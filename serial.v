module serial_tb();
	reg clk, istream;
	reg [16:0] in;
	wire ostream;
	integer i;
initial begin
	$dumpfile("serial.vcd");
	$dumpvars();
	clk = 0;
	in = 17'b11011111101011110;
	istream = 0;
	i = 16;
end
always #2 clk = ~clk;
	serial Serial(istream, ostream, clk);
always @ (posedge clk or negedge clk)
begin
	if(i>=0) begin
		istream <= in[i];
		i <= i - 1;
	end else
		#2 $finish();
end
endmodule

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
	if(istream == 1'b0) begin
		cnt <= 0;
		ostream <= 1'b0;
	end
	else begin
		cnt = cnt + 1;
		if(cnt == 3'b100) begin
			cnt <= 3'b11;
			ostream <= 1'b1;
		end
	end
	$display("%b", ostream);
end
endmodule
