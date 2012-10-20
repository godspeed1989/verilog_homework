`timescale 1ns / 1ns
/*
 * test bench
 */
//`define DEBUG
module multi3_tb();
	reg [2:0] p1;
	reg [2:0] p2;
	wire [5:0] result;
initial begin
`ifdef DEBUG
	$dumpfile("multi3.vcd");
	$dumpvars();
`endif
	p1 <= 0;
	p2 <= 0;
end
	multi3 mult(p1, p2, result);

`ifdef DEBUG
initial begin
	#0 p1 = 3'b111; p2 = 3'b000;
	#2 p1 = 3'b001; p2 = 3'b001;
	#2 p1 = 3'b010; p2 = 3'b010;
	#2 p1 = 3'b100; p2 = 3'b011;
	#2 p1 = 3'b110; p2 = 3'b100;
	#2 $finish();
end
`endif

endmodule
/*
 * 3 bit multiplier
 */
module multi3(p1, p2, result);
	input [2:0] p1;
	input [2:0] p2;
	output reg [5:0] result;
	reg [5:0] ret;
	reg [5:0] pb;
	integer i;
always @ (*)
begin
	ret = 6'b0;
	pb = {3'b000, p2};
	for(i=0; i<3; i=i+1)
	begin
		if (p1[i] == 1'b1)
			ret = ret + pb;
		pb = pb << 1;
	end
	result = ret;
end

endmodule
