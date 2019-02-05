
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package Constants is
	---- 1280 x 1024
	--constant c_H_VisibleArea 	: integer :=1280;
	--constant c_H_FrontPorch		: integer :=48;
	--constant c_H_SyncPulse 		: integer :=112;
	--constant c_H_BackPorch 		: integer :=248;
	--constant c_H_Whole 			: integer :=1688;

	--constant c_V_VisibleArea 	: integer :=1024;
	--constant c_V_FrontPorch 	: integer :=1;
	--constant c_V_SyncPulse 		: integer :=4; --3
	--constant c_V_BackPorch 		: integer :=38;
	--constant c_V_Whole 			: integer :=1066;

	--constant c_VRam_Limit 				: integer :=65536;
	
	--constant c_VRam_Player_Width 		: integer :=512;
	--constant c_VRam_Player_Height 		: integer :=128;

	--constant c_VRam_Offset_X_Dealer 	: integer :=0;
	--constant c_VRam_Offset_Y_Dealer		: integer :=0;
	
	--constant c_VRam_Offset_X_Common		: integer :=0;
	--constant c_VRam_Offset_Y_Common 	: integer :=0;
	
	--constant c_VRam_Offset_X_Player_1 	: integer :=0;
	--constant c_VRam_Offset_Y_Player_1 	: integer :=400;

	--constant c_VRam_Offset_X_Player_2 	: integer :=0;
	--constant c_VRam_Offset_Y_Player_2 	: integer :=600;



	--800 x 600
	constant c_H_VisibleArea 	: integer :=800;
	constant c_H_FrontPorch		: integer :=40;
	constant c_H_SyncPulse 		: integer :=128;
	constant c_H_BackPorch 		: integer :=88;
	constant c_H_Whole 			: integer :=1056;

	constant c_V_VisibleArea 	: integer :=600;
	constant c_V_FrontPorch 	: integer :=1;
	constant c_V_SyncPulse 		: integer :=5; --3
	constant c_V_BackPorch 		: integer :=23;
	constant c_V_Whole 			: integer :=628;

	constant c_VRam_Limit 				: integer := 65535;
	
	constant c_VRam_Dealer_Width 		: integer := 512;
	constant c_VRam_Dealer_Height 		: integer := 128;
	constant c_VRam_Offset_X_Dealer 	: integer := 5;--144;
	constant c_VRam_Offset_Y_Dealer		: integer := 1;--50;
	
	constant c_VRam_Player_Width 		: integer := 256;
	constant c_VRam_Player_Height 		: integer := 256;
	constant c_VRam_Offset_X_Player_1 	: integer := 96;
	constant c_VRam_Offset_Y_Player_1 	: integer := 320;

	constant c_VRam_Offset_X_Player_2 	: integer :=448;
	constant c_VRam_Offset_Y_Player_2 	: integer :=320;

	--constant c_VRam_Offset_X_Common		: integer :=0;
	--constant c_VRam_Offset_Y_Common 	: integer :=0;

	----640 x 480
	--constant c_H_VisibleArea 	: integer :=640;
	--constant c_H_FrontPorch		: integer :=16;
	--constant c_H_SyncPulse 		: integer :=96;
	--constant c_H_BackPorch 		: integer :=48;
	--constant c_H_Whole 			: integer :=800;

	--constant c_V_VisibleArea 	: integer :=480;
	--constant c_V_FrontPorch 	: integer :=10;
	--constant c_V_SyncPulse 		: integer :=3; --3
	--constant c_V_BackPorch 		: integer :=33;
	--constant c_V_Whole 			: integer :=525;

	--constant c_VRam_Limit 				: integer :=65536;
	
	--constant c_VRam_Player_Width 		: integer :=512;
	--constant c_VRam_Player_Height 		: integer :=128;

	--constant c_VRam_Offset_X_Dealer 	: integer :=0;
	--constant c_VRam_Offset_Y_Dealer		: integer :=0;
	
	--constant c_VRam_Offset_X_Common		: integer :=0;
	--constant c_VRam_Offset_Y_Common 	: integer :=0;
	
	--constant c_VRam_Offset_X_Player_1 	: integer :=0;
	--constant c_VRam_Offset_Y_Player_1 	: integer :=200;

	--constant c_VRam_Offset_X_Player_2 	: integer :=0;
	--constant c_VRam_Offset_Y_Player_2 	: integer :=400;


	


end Constants;

package body Constants is
 
end Constants;
