module	LCD_MODULE (	//	Host Side
						input iCLK,
						input iRST_N,
						input [255:0] iFB,
						//	LCD Side
						output [7:0] LCD_DATA,
						output LCD_RW,
						output LCD_EN,
						output LCD_RS	);

//	Internal Wires/Registers
reg	[5:0]	LUT_INDEX;
reg	[8:0]	LUT_DATA;
reg	[5:0]	mLCD_ST;
reg	[17:0]	mDLY;
reg			mLCD_Start;
reg	[7:0]	mLCD_DATA;
reg			mLCD_RS;
wire		mLCD_Done;

parameter	LCD_INTIAL	=	0;
parameter	LCD_LINE1	=	5;
parameter	LCD_CH_LINE	=	LCD_LINE1+16;
parameter	LCD_LINE2	=	LCD_LINE1+16+1;
parameter	LUT_SIZE	=	LCD_LINE1+32+1;

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LUT_INDEX	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
	end
	else
	begin
		if(LUT_INDEX<LUT_SIZE)
		begin
			case(mLCD_ST)
			0:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;					
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
						mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	3;
					end
				end
			3:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mLCD_ST		<=	0;
				end
			endcase
		end
	end
end

always
begin
	case(LUT_INDEX)
		//	Initial the LCD
		LCD_INTIAL+0:	LUT_DATA	<=	9'h038;
		LCD_INTIAL+1:	LUT_DATA	<=	9'h00C;
		LCD_INTIAL+2:	LUT_DATA	<=	9'h001;
		LCD_INTIAL+3:	LUT_DATA	<=	9'h006;
		LCD_INTIAL+4:	LUT_DATA	<=	9'h080;
		//	Line 1 Start
		LCD_LINE1+0:	LUT_DATA	<=	{1'b1, iFB[7:0]};
		LCD_LINE1+1:	LUT_DATA	<=	{1'b1, iFB[15:8]};
		LCD_LINE1+2:	LUT_DATA	<=	{1'b1, iFB[23:16]};
		LCD_LINE1+3:	LUT_DATA	<=	{1'b1, iFB[31:24]};
		LCD_LINE1+4:	LUT_DATA	<=	{1'b1, iFB[39:32]};
		LCD_LINE1+5:	LUT_DATA	<=	{1'b1, iFB[47:40]};
		LCD_LINE1+6:	LUT_DATA	<=	{1'b1, iFB[55:48]};
		LCD_LINE1+7:	LUT_DATA	<=	{1'b1, iFB[63:56]};
		LCD_LINE1+8:	LUT_DATA	<=	{1'b1, iFB[71:64]};
		LCD_LINE1+9:	LUT_DATA	<=	{1'b1, iFB[79:72]};
		LCD_LINE1+10:	LUT_DATA	<=	{1'b1, iFB[87:80]};
		LCD_LINE1+11:	LUT_DATA	<=	{1'b1, iFB[95:88]};
		LCD_LINE1+12:	LUT_DATA	<=	{1'b1, iFB[103:96]};
		LCD_LINE1+13:	LUT_DATA	<=	{1'b1, iFB[111:104]};
		LCD_LINE1+14:	LUT_DATA	<=	{1'b1, iFB[119:112]};
		LCD_LINE1+15:	LUT_DATA	<=	{1'b1, iFB[127:120]};
		//	Change Line
		LCD_CH_LINE:	LUT_DATA	<=	9'h0C0;
		//	Line 2 Start
		LCD_LINE2+0:	LUT_DATA	<=	{1'b1, iFB[128+7:128+0]};
		LCD_LINE2+1:	LUT_DATA	<=	{1'b1, iFB[128+15:128+8]};
		LCD_LINE2+2:	LUT_DATA	<=	{1'b1, iFB[128+23:128+16]};
		LCD_LINE2+3:	LUT_DATA	<=	{1'b1, iFB[128+31:128+24]};
		LCD_LINE2+4:	LUT_DATA	<=	{1'b1, iFB[128+39:128+32]};
		LCD_LINE2+5:	LUT_DATA	<=	{1'b1, iFB[128+47:128+40]};
		LCD_LINE2+6:	LUT_DATA	<=	{1'b1, iFB[128+55:128+48]};
		LCD_LINE2+7:	LUT_DATA	<=	{1'b1, iFB[128+63:128+56]};
		LCD_LINE2+8:	LUT_DATA	<=	{1'b1, iFB[128+71:128+64]};
		LCD_LINE2+9:	LUT_DATA	<=	{1'b1, iFB[128+79:128+72]};
		LCD_LINE2+10:	LUT_DATA	<=	{1'b1, iFB[128+87:128+80]};
		LCD_LINE2+11:	LUT_DATA	<=	{1'b1, iFB[128+95:128+88]};
		LCD_LINE2+12:	LUT_DATA	<=	{1'b1, iFB[128+103:128+96]};
		LCD_LINE2+13:	LUT_DATA	<=	{1'b1, iFB[128+111:128+104]};
		LCD_LINE2+14:	LUT_DATA	<=	{1'b1, iFB[128+119:128+112]};
		LCD_LINE2+15:	LUT_DATA	<=	{1'b1, iFB[128+127:128+120]};
		default:		LUT_DATA	<=	9'h000;
	endcase
end

LCD_Controller 	controler
(	//	Host Side
	.iDATA(mLCD_DATA),
	.iRS(mLCD_RS),
	.iStart(mLCD_Start),
	.oDone(mLCD_Done),
	.iCLK(iCLK),
	.iRST_N(iRST_N),
	//	LCD Interface
	.LCD_DATA(LCD_DATA),
	.LCD_RW(LCD_RW),
	.LCD_EN(LCD_EN),
	.LCD_RS(LCD_RS)
);

endmodule
