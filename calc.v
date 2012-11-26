module calc_tb (/*input [2:0] SW_op1,
				input [2:0] SW_op2,
				input SW_type,*/
				output [6:0] SEG7_0,
				output [6:0] SEG7_1);
reg [2:0] SW_op1;
reg [2:0] SW_op2;
reg SW_type;

wire [5:0] result;
wire [3:0] res_l = result % 10;
wire [3:0] res_h = result / 10;
CALC cal(
		.op1(SW_op1),
		.op2(SW_op2),
		.type(SW_type),
		.result(result)
		);

SEG7_LUT seg7_0(.oSEG(SEG7_0), .iDIG(res_l));
SEG7_LUT seg7_1(.oSEG(SEG7_1), .iDIG(res_h));

initial begin
	$dumpfile("calc.vcd");
	$dumpvars();
	#0	SW_op1 = 1; SW_op2 = 3; SW_type = 0;
	#1	SW_op1 = 2; SW_op2 = 5; SW_type = 0;
	#1	SW_op1 = 5; SW_op2 = 7; SW_type = 0;
	#1	SW_op1 = 7; SW_op2 = 7; SW_type = 0;
	#1	SW_op1 = 2; SW_op2 = 3; SW_type = 1;
	#1	SW_op1 = 5; SW_op2 = 4; SW_type = 1;
	#1	SW_op1 = 6; SW_op2 = 5; SW_type = 1;
	#1	SW_op1 = 7; SW_op2 = 7; SW_type = 1;
	#1 $finish();
end

endmodule

module CALC(input [2:0] op1,
			input [2:0] op2,
			input type,
			output reg [5:0] result);

always @ (*)
begin
	if(type == 1'b1)
		result <= op1 * op2;
	else
		result <= op1 + op2;
end
endmodule

module SEG7_LUT(input [3:0] iDIG,
				output reg [6:0] oSEG);

always @(iDIG)
begin
		case(iDIG)
			4'h1: oSEG = 7'b1111001;	// ---t----
			4'h2: oSEG = 7'b0100100; 	// |	  |
			4'h3: oSEG = 7'b0110000; 	// lt	 rt
			4'h4: oSEG = 7'b0011001; 	// |	  |
			4'h5: oSEG = 7'b0010010; 	// ---m----
			4'h6: oSEG = 7'b0000010; 	// |	  |
			4'h7: oSEG = 7'b1111000; 	// lb	 rb
			4'h8: oSEG = 7'b0000000; 	// |	  |
			4'h9: oSEG = 7'b0011000; 	// ---b----
			4'ha: oSEG = 7'b0001000;
			4'hb: oSEG = 7'b0000011;
			4'hc: oSEG = 7'b1000110;
			4'hd: oSEG = 7'b0100001;
			4'he: oSEG = 7'b0000110;
			4'hf: oSEG = 7'b0001110;
			4'h0: oSEG = 7'b1000000;
		endcase
end

endmodule
