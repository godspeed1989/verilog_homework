module add4c_tb();
	reg [3:0] p1;
	reg [3:0] p2;
	reg type;
	wire [3:0] result;
	wire carry;
initial begin
	$dumpfile("add4c.vcd");
	$dumpvars();
	p1 = 0; p2 = 0; type = 0;
end
	addmin4c addmin(p1, p2, result, carry, type);
initial begin
	#3 p1 = 4'd1; p2 = 4'd2; type=1;
	#3 p1 = 4'd9; p2 = 4'd8; type=0;
	#3 p1 = 4'd5; p2 = 4'd7; type=1;
	#3 p1 = 4'd5; p2 = 4'd7; type=0;
	#3 p1 = 4'd15; p2 = 4'd6; type=1;
	#10 $finish();
end
endmodule

module addmin4c(p1, p2, result, c, type);
	input [3:0] p1;
	input [3:0] p2;
	input type;
	output [3:0] result;
	output c;

	reg [4:0] sum;
	assign result[3:0] = sum[3:0];
	assign c = sum[4];

always @ (*)
begin
	if(type == 1'b1)
		sum = p1 + p2;
	else
		if(p1 >= p2)
			sum = p1 - p2;
		else begin
			sum = p2 - p1;
			sum = sum | 5'b10000;
		end
end
	
endmodule
