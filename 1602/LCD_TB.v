module LCD_TB
(
		input CLOCK_50,				//	50 MHz
		//////////	LCD Module 16X2	///////////
		output LCD_BLON,		//	LCD Back Light ON/OFF
		output LCD_RW,			//	LCD Read/Write Select, 0 = Write, 1 = Read
		output LCD_EN,			//	LCD Enable
		output LCD_RS,			//	LCD Command/Data Select, 0 = Command, 1 = Data
		inout [7:0] LCD_DATA	//	LCD Data bus 8 bits
);

//	All inout port turn to tri-state
assign	LCD_DATA	=	8'hzz;
assign	LCD_BLON	=	1'b1;

wire	DLY_RST;
Reset_Delay			r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST));

wire [255:0] Frame_Buffer;
//  Line 1 
assign Frame_Buffer[7:0]	= 8'h20;
assign Frame_Buffer[15:8]	= 8'h59; // Y
assign Frame_Buffer[23:16]	= 8'h41; // A
assign Frame_Buffer[31:24]	= 8'h4E; // N
assign Frame_Buffer[39:32]	= 8'h20; //
assign Frame_Buffer[47:40]	= 8'h4C; // L
assign Frame_Buffer[55:48]	= 8'h49; // I
assign Frame_Buffer[63:56]	= 8'h4E; // N
assign Frame_Buffer[71:64]	= 8'h20; //
assign Frame_Buffer[79:72]	= 8'h2B; // +
assign Frame_Buffer[87:80]	= 8'h2D; // -
assign Frame_Buffer[95:88]	= 8'h2A; // *
assign Frame_Buffer[103:96]	= 8'h2F; // /
assign Frame_Buffer[111:104]= 8'h21; // !
assign Frame_Buffer[119:112]= 8'h20; //
assign Frame_Buffer[127:120]= 8'h20; //
//	Line 2 
assign Frame_Buffer[128+7:128+0]	= 8'h30; //0
assign Frame_Buffer[128+15:128+8]	= 8'h31; //1
assign Frame_Buffer[128+23:128+16]	= 8'h32; //2
assign Frame_Buffer[128+31:128+24]	= 8'h33; //3
assign Frame_Buffer[128+39:128+32]	= 8'h34; //4
assign Frame_Buffer[128+47:128+40]	= 8'h35; //5
assign Frame_Buffer[128+55:128+48]	= 8'h36; //6
assign Frame_Buffer[128+63:128+56]	= 8'h37; //7
assign Frame_Buffer[128+71:128+64]	= 8'h38; //8
assign Frame_Buffer[128+79:128+72]	= 8'h39; //9
assign Frame_Buffer[128+87:128+80]	= 8'h41; //A
assign Frame_Buffer[128+95:128+88]	= 8'h42; //B
assign Frame_Buffer[128+103:128+96]	= 8'h43; //C
assign Frame_Buffer[128+111:128+104]= 8'h44; //D
assign Frame_Buffer[128+119:128+112]= 8'h45; //E
assign Frame_Buffer[128+127:128+120]= 8'h46; //F

LCD_MODULE lcd_test
(		//	Host Side
		.iCLK(CLOCK_50),
		.iRST_N(DLY_RST),
		.iFB(Frame_Buffer),
		//	LCD Side
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS)
);

endmodule

/**
 * 20ms Reset Delay for LCD
 */
module Reset_Delay (input iCLK, output reg oRESET);

reg	[19:0] Cont;

always @ (posedge iCLK)
begin
	if(Cont!=20'hFFFFF) //1/50s, 20ms
	begin
		Cont	<=	Cont+1;
		oRESET	<=	1'b0;
	end
	else
		oRESET	<=	1'b1;
end
endmodule
