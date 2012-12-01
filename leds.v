module leds(leds, clk50);

	output [9:0] leds;
	input clk50;
	reg [9:0] data;
	integer count;

	assign leds = data;
initial begin
	data = 9'b1;
	count = 0;
end

always @ (posedge clk50)
begin
	count = count + 1;
	if(count >= 150_000_000)
	begin
		count = 0;
		data = data<<1;
		if(data == 0)
			data = 9'b1;
	end
end

endmodule
