module counter_tb();
	reg clk, reset;
	reg [1:0] mode;
	wire [3:0] out;
initial begin
	$dumpfile("counter.vcd");
	$dumpvars();
	clk = 0;
	mode = 0;
end
always #1 clk = ~clk;
	counter Counter(clk, mode, out, reset);
initial begin
	#1 reset = 1'b1;
	#1 reset = 1'b0;
	#10 mode = 2'b10;
	#20 mode = 2'b01;
	#5 $finish();
end
	
endmodule
/*
 * changable mode counter
 */
module counter(clk, mode, out, reset);
	input clk, reset;
	input [1:0] mode;
	output reg [3:0] out;
	reg [3:0] max;
initial out = 0;
always @(*)
begin
case (mode)
		2'b00: max = 4'd9;
		2'b01: max = 4'd11;
		2'b10: max = 4'd13;
		2'b11: max = 4'd15;
		default:;
	endcase
end
always @ (posedge clk or negedge clk)
begin
	if(reset)
		out = 0;
	else
	begin
		out = out + 1;
		if(out == max)
			out = 0;
	end
end
endmodule
