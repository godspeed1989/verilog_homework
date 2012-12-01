`timescale 1ns / 1ns
/*
 * test bench
 */
`define DEBUG
module add4c_tb();
	reg [3:0] p1;
	reg [3:0] p2;
	reg type;
	wire [3:0] result;
	wire carry;
initial begin
`ifdef DEBUG
	$dumpfile("add4c.vcd");
	$dumpvars();
`endif
	p1 = 0; p2 = 0; type = 0;
end
	addmin4c addmin(p1, p2, result, carry, type);
initial begin
`ifdef DEBUG
	#0 p1 = 4'b0001; p2 = 4'b0001; type=1;
	#3 p1 = 4'b0010; p2 = 4'b0011; type=1;
	#3 p1 = 4'b1000; p2 = 4'b1111; type=1;
	#3 p1 = 4'b1111; p2 = 4'b1111; type=1;
	#3 p1 = 4'b0101; p2 = 4'b1010; type=1;
	#3 p1 = 4'b0001; p2 = 4'b0001; type=0;
	#3 p1 = 4'b0010; p2 = 4'b0011; type=0;
	#3 p1 = 4'b1000; p2 = 4'b1111; type=0;
	#3 p1 = 4'b1111; p2 = 4'b1111; type=0;
	#3 p1 = 4'b0101; p2 = 4'b1010; type=0;
	#3 $finish();
`endif
end
endmodule
/*
 * 4 bit width adder/minus
 */
module addmin4c(p1, p2, result, carry, type);
	input [3:0] p1;
	input [3:0] p2;
	input type;
	output [3:0] result;
	output carry;

	wire c1, c2, c3;
	add1bit a1(p1[0], p2[0],  0, result[0], c1, type);
	add1bit a2(p1[1], p2[1], c1, result[1], c2, type);
	add1bit a3(p1[2], p2[2], c2, result[2], c3, type);
	add1bit a4(p1[3], p2[3], c3, result[3], carry, type);

endmodule
/*
 * 1 bit width adder/minus, selected by 'type'
 */
module add1bit(o1, o2, carryb, out, carryf, type);
	output carryf, out;
	input o1, o2, carryb, type;
	reg carryf, out;

always @ (*)
begin
	if(type == 1'b1)
	begin
		out		<=	(o1 ^ o2) ^ carryb;
		carryf	<=	(o1 & o2) | (o1 & carryb) | (o2 & carryb);
	end else begin
		out		<=	o1 ^ o2 ^ carryb;
		carryf	<=	(~o1 & o2) | (carryb & o2) | (carryb & ~o1);
	end
end

endmodule
