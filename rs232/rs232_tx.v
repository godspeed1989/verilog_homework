module RS232_TX
#(
	parameter baud = 9600, mhz = 50
 )
(
	input clock,
	input reset,
	output reg RS232_DCE_TXD,
	input [7:0] transmit_data,
	input tx_vld,
	output reg tx_rdy
);

parameter txd_bit_per = (mhz*1_000_000)/baud;

//--State Definitions--
parameter st_ready = 2'b00;
parameter st_start_bit = 2'b01;
parameter st_data_bits = 2'b10;
parameter st_stop_bit = 2'b11;

reg [1:0] state = st_ready;
reg [1:0] n_state = st_ready;
reg [31:0] counter;
reg [31:0] n_counter;
reg [2:0] data_bit_count;
reg [2:0] n_data_bit_count;
reg [7:0] tx_data;

//transmit proc
always @ (*)
begin
	n_state <= state;
	n_counter <= counter;
	n_data_bit_count <= data_bit_count;
	if(reset == 1'b1)
		RS232_DCE_TXD <= 1'b0;
	else
	case(state)
	st_ready:
		begin	
			if(tx_vld == 1'b1) begin
				tx_rdy <= 1'b0;
				tx_data <= transmit_data;
				n_state <= st_start_bit;
			end
			else begin
				RS232_DCE_TXD <= 1'b0;
				tx_rdy <= 1'b1;
				n_state <= st_ready;
				n_counter <= 0;
				n_data_bit_count <= 0;
			end
		end
	st_start_bit:
		begin
			if(counter == txd_bit_per) begin
				n_counter <= 0;
				n_state <= st_data_bits;
				n_data_bit_count <= 0;
			end
			else begin
				RS232_DCE_TXD <= 1'b1;
				n_state <= st_start_bit;
				n_counter <= counter + 1;
			end
		end
	st_data_bits:
		begin
			if(counter == txd_bit_per) begin	
				n_counter <= 0;
				n_data_bit_count <= data_bit_count + 1;
				if(data_bit_count == 7) begin
					n_state <= st_stop_bit;
				end else
					n_state <= st_data_bits;
			end
			else begin
				n_counter <= counter + 1;
				RS232_DCE_TXD <= tx_data[data_bit_count];
				n_state <= st_data_bits;
			end
		end
	st_stop_bit:
		begin
			if(counter == txd_bit_per)
				n_state <= st_ready;
			else begin
				RS232_DCE_TXD <= 1'b0;
				n_state <= st_stop_bit;
				n_counter <= counter + 1;
			end
		end
	endcase
end

//clock proc
always @(posedge clock or posedge reset) begin
	if(reset == 1) begin
		state <= st_ready; 
		counter <= 0;
		data_bit_count <= 0;
	end
	else begin
		state <= n_state;
		counter <= n_counter;
		data_bit_count <= n_data_bit_count;
	end
end

endmodule
