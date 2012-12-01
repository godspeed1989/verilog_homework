module RS232_RX
#(
	parameter baud = 9600, mhz = 50
 )
(
	input clock,
	input reset,
	input RS232_DCE_RXD,
	output [7:0] receive_data,
	output reg rx_vld
);
 
parameter rcv_bit_per = (mhz*1_000_000)/baud;
parameter half_rcv_bit_per = rcv_bit_per/2;
//--State Definitions--
parameter st_ready = 2'b00;
parameter st_start_bit = 2'b01;
parameter st_data_bits = 2'b10;
parameter st_stop_bit = 2'b11;
 
reg [31:0] counter;
reg [31:0] n_counter;
reg [2:0] data_bit_count;
reg [2:0] n_data_bit_count;
reg [7:0] rcv_sr;
reg [7:0] n_rcv_sr;
reg [1:0] state;
reg [1:0] n_state;

assign receive_data = rcv_sr;

//receive proc
always @(*)
begin
	n_rcv_sr <= rcv_sr;
	n_state <= state;
	n_counter <= counter;
	n_data_bit_count <= data_bit_count;
	rx_vld <= 0;
	if(reset == 1)
		n_rcv_sr <= 0;
	else
	case (state)
	st_ready:
		begin
			n_counter <= 0;
			n_data_bit_count <= 0;
			if(RS232_DCE_RXD == 1)
				n_state <= st_start_bit;
		end
	st_start_bit:
		begin
			if(counter == half_rcv_bit_per) begin
				n_counter <= 0;
				n_state <= st_data_bits;
				n_data_bit_count <= 0;
			end
			else begin
				n_counter <= counter + 1;
			end
		end
	st_data_bits:
		begin
			if(counter == rcv_bit_per) begin
				n_counter <= 0;
				n_rcv_sr <= {RS232_DCE_RXD, rcv_sr[7:1]};
				n_data_bit_count <= data_bit_count + 1;
				if(data_bit_count == 7) begin
					rx_vld <= 1'b1;
					n_state <= st_stop_bit;
				end
			end
			else
				n_counter <= counter + 1;
		end
	st_stop_bit:
		begin
			if(counter == rcv_bit_per) //should be 1/2 stop_bit period
				n_state <= st_ready;
			else
				n_counter <= counter + 1;
		end
	endcase
end
 
//clock proc
always @(posedge clock or posedge reset) begin
	if(reset == 1) begin
		state <= st_ready; 
		rcv_sr <= 0;
		counter <= 0;
		data_bit_count <= 0;
	end
	else begin
		state <= n_state;
		rcv_sr <= n_rcv_sr;
		counter <= n_counter;
		data_bit_count <= n_data_bit_count;
	end
end
 
 
endmodule
