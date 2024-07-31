//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	96;
parameter	H_SYNC_BACK	=	45+3;
parameter	H_SYNC_ACT	=	640;	//	646
parameter	H_SYNC_FRONT=	13+3;
parameter	H_SYNC_TOTAL=	800;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	2;
parameter	V_SYNC_BACK	=	30+2;
parameter	V_SYNC_ACT	=	480;	//	484
parameter	V_SYNC_FRONT=	9+2;
parameter	V_SYNC_TOTAL=	525;
//	Start Offset
parameter	X_START		=	H_SYNC_CYC+H_SYNC_BACK;
parameter	Y_START		=	V_SYNC_CYC+V_SYNC_BACK;
