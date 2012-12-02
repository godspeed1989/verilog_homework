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

wire tx_vld;
wire [7:0] tx_data;
assign tx_vld = rx_vld;
assign tx_data = rx_data;

RS232_TX #(.baud(9600), .mhz(50)) tx_232
(
	.clock(CLK_50M),
	.reset(0),
	.RS232_DCE_TXD(TX),
	.tx_vld(tx_vld),
	.transmit_data(tx_data),
	.tx_rdy(LEDG[8])
);

/*
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
*/

endmodule
