module CCD_Capture(	oDATA,
					oDVAL,
					oFrame_Cont,
					iDATA,
					iFVAL,
					iLVAL,
					iSTART,
					iEND,
					iCLK,
					iRST	);
					
input	[9:0]	iDATA;
input			iFVAL;
input			iLVAL;
input			iSTART;
input			iEND;
input			iCLK;
input			iRST;
output	[9:0]	oDATA;
output	[31:0]	oFrame_Cont;
output			oDVAL;
reg				Pre_FVAL;
reg				mCCD_FVAL;
reg				mCCD_LVAL;
reg		[9:0]	mCCD_DATA;
reg		[31:0]	Frame_Cont;
reg				mSTART;


assign	oFrame_Cont	=	Frame_Cont;
assign	oDATA		=	mCCD_DATA;
assign	oDVAL		=	mCCD_FVAL&mCCD_LVAL;

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	mSTART	<=	0;
	else
	begin
		if(iSTART)
		mSTART	<=	1;
		if(iEND)
		mSTART	<=	0;		
	end
end

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		Pre_FVAL	<=	0;
		mCCD_FVAL	<=	0;
		mCCD_LVAL	<=	0;
		mCCD_DATA	<=	0;
	end
	else
	begin
		Pre_FVAL	<=	iFVAL;
		if( ({Pre_FVAL,iFVAL}==2'b01) && mSTART )//上升沿监测，延迟一个周期
			mCCD_FVAL	<=	1;
		else if({Pre_FVAL,iFVAL}==2'b10)
			mCCD_FVAL	<=	0;
		mCCD_LVAL	<=	iLVAL;
		mCCD_DATA	<=	iDATA;
	end
end

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	Frame_Cont	<=	0;
	else
	begin
		if( ({Pre_FVAL,iFVAL}==2'b01) && mSTART )
			Frame_Cont	<=	Frame_Cont+1;
	end
end

endmodule
