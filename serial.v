`timescale 1ns / 1ns
/*
 * test bench
 */
module serial_tb();
	reg clk, istream;
	reg [16:0] in;
	wire ostream;
	integer i;
	parameter len = 16;
initial begin
	$dumpfile("serial.vcd");
	$dumpvars();
	clk = 0;
	in = 16'b1101111110101110;
	istream = 0;
	i = 0;
end
always #2 clk = ~clk;
	serial Serial(istream, ostream, clk);
always @ (posedge clk or negedge clk)
begin
	if(i<len)
	begin
		istream <= in[i];
		i = i+1;
	end else
		#2 $finish();
end
endmodule
/*
 * serial detector
 */
module serial(istream, ostream, clk);
	input istream, clk;
	output reg ostream;
	reg [2:0] cnt;
initial begin
	cnt <= 0;
	ostream <= 0;
end
always @ (posedge clk or negedge clk)
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
	$display("%d %b", cnt, ostream);
end
endmodule
