`timescale 1 ns / 1 ns
`define DEBUG
`ifdef DEBUG
module clock_tb();
reg CLK50M;
`else
module clock_tb(input CLK50M);
`endif

wire [4:0] hours;
wire [7:0] minutes;
wire [7:0] seconds;

initial begin
`ifdef DEBUG
	$dumpfile("clock.vcd");
	$dumpvars();
	CLK50M = 0;
	#50000 $finish();
`endif
end

clock clk(.CLK50M(CLK50M), .hours(hours),
			.minutes(minutes), .seconds(seconds));

always #1 CLK50M = ~CLK50M;


endmodule
/*
 * clock module
 */
module clock(input CLK50M,
			 output reg [4:0] hours,
			 output reg [7:0] minutes,
			 output reg [7:0] seconds);
integer count;
parameter HZ = 5;//0_000_000;
initial begin
	hours <= 0;
	minutes <= 0;
	seconds <= 0;
	count <= 0;
end

always @ (CLK50M)
begin
	count = count + 1;
	if(count >= HZ) begin
		count = 0;
		seconds = seconds + 1;
		if(seconds >= 8'd60) begin
			seconds = 0;
			minutes = minutes + 1;
			if(minutes >= 8'd60) begin
				minutes = 0;
				hours = hours + 1;
				if(hours >= 5'd24)
					hours = 0;
			end
		end
	end
end

endmodule
