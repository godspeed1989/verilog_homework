`timescale 1ns / 1ns
/*
 * test bench
 */
`define DEBUG
module serial_tb();
	reg clk, istream;
	reg [16:0] in;
	wire ostream;
	integer i;
	parameter len = 16;
initial begin
`ifdef DEBUG
	$dumpfile("serial.vcd");
	$dumpvars();
`endif
	clk = 0;
	in = 16'b1101111110101110;
	istream = 0;
	i = 0;
end

	serial Serial(istream, ostream, clk);

`ifdef DEBUG
always #2 clk = ~clk;
always @ (clk)
begin
	if(i<len)
	begin
		istream <= in[i];
		i = i+1;
	end else
		#2 $finish();
end
`endif
endmodule
/*
 * serial detector
 */
module serial(istream, ostream, clk);
	input istream, clk;
	output reg ostream;
	reg [2:0] cnt;
initial begin
	ostream = 0;
end
always @ (clk)
begin
	if(istream == 1'b0)
		cnt = 0;	
	else
		cnt = cnt + 1;

	if(cnt == 3'b100)
	begin
		ostream = 1'b1;
		cnt = 3'b011;
	end else
		ostream = 1'b0;
	$display("%b %d %b", istream, cnt, ostream);
end
endmodule
