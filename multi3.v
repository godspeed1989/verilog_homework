
module multi3_tb();
	reg [2:0] p1;
	reg [2:0] p2;
	wire [4:0] result;
initial begin
	$dumpfile("multi3.vcd");
	$dumpvars();
	p1 <= 0;
	p2 <= 0;
end
	multi3 mult(p1, p2, result);
initial begin
	#2 p1= 3'b11;	p2= 3'b10;
	#2 p1=-3'b01;	p2= 3'b10;
	#2 p1= 3'b10;	p2=-3'b10;
	#2 p1=-3'b11;	p2= 3'b11;
	#2 p1=-3'b11;	p2= 3'b00;
	#5 $finish();
end
endmodule

module multi3(p1, p2, result);
	input [2:0] p1; //最高位是符号位
	input [2:0] p2;
	output reg [4:0] result;

always @ (*)
begin
	result = p1[1:0] * p2[1:0];
	result[4] = p1[2] ^ p2[2];
end
endmodule
