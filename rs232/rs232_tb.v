module rs232_tb (
					input CLK_50M,
					input RX,
					output TX,
					output [9:0] LEDG
				);

wire rx_vld;
wire [7:0] rx_data;

assign LEDG[7:0] = rx_data[7:0];
assign LEDG[9] = rx_vld;

RS232_RX #(.baud(9600), .mhz(50)) rx_232
(
	.clock(CLK_50M),
	.reset(0),
	.RS232_DCE_RXD(RX),
	.rx_vld(rx_vld),
	.receive_data(rx_data)
);

reg tx_vld;
wire [7:0] tx_data;
//assign tx_vld = rx_vld;
assign tx_data = rx_data;

RS232_TX #(.baud(9600), .mhz(50)) tx_232
(
	.clock(CLK_50M),
	.reset(0),
	.RS232_DCE_TXD(TX),
	.tx_vld(tx_vld),
	.transmit_data(8'b10010110),
	.tx_rdy(LEDG[8])
);

integer cnt;
always @ (posedge CLK_50M)
begin
	cnt <= cnt + 1;
	if(cnt >= 50_000_000)
	begin
		cnt <= 0;
		tx_vld <= 1;
	end
	else
		tx_vld <= 0;
end

/*
rs232  
RS232	(
			.clk(CLK_50M),
			.rst(0),
			.rx(RX),			//input
			.tx(TX),			//output
			.rx_vld(rx_vld),	//output
			.rx_data(rx_data),	//output
			.tx_vld(tx_vld),	//input
			.tx_data(tx_data)	//input
		);*/

endmodule
