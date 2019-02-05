library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Constants.ALL;

entity Synchronizer is
PORT (
	i_Sync_Clk 			: in  std_logic;
	i_Sync_Reset		: in std_logic;
	o_Sync_HSync 		: out  std_logic;
    o_Sync_VSync 		: out  std_logic;
    
    o_Sync_ActiveVRam 	: out std_logic_vector(2 downto 0);
    o_Sync_VideoOn 		: out std_logic
    --o_Sync_VideoOnRam_1 : out std_logic

);
end Synchronizer;

architecture Main of Synchronizer is

	signal HPOS: integer range 0 to c_H_Whole:=c_H_Whole-1;
	signal VPOS: integer range 0 to c_V_Whole:=c_V_Whole;

    signal r_H_Sync, r_V_Sync, r_VideoOn, r_VideoOnRam_1 : std_logic;

    signal r_MemorySyncro_HPOS_4, r_MemorySyncro_HPOS_1 : integer range 0 to c_H_Whole:=0;
	signal r_MemorySyncro_VPOS_4 : integer range 0 to c_V_Whole:=0;


begin

	syncro: process (i_Sync_Clk, i_Sync_Reset)
	begin

		if(i_Sync_Reset = '1') then
			HPOS <= c_H_Whole-3;
			VPOS <= c_V_Whole;
			--o_Sync_ActiveVRam <= "000";
			--o_Sync_VideoOn <= '0';
			r_VideoOn <= '0';
		elsif  i_Sync_Reset = '0' and rising_edge(i_Sync_Clk) then

			--Scan
			if (HPOS < c_H_Whole) then
				HPOS <= HPOS +1;
			else
				HPOS <= 0;
				if(VPOS < c_V_Whole) then
					VPOS <= VPOS +1;
				else
					VPOS <= 0;
				end if;
			end if; 
			-- end Scan

			if (HPOS >= c_H_VisibleArea + c_H_FrontPorch and HPOS < c_H_VisibleArea + c_H_FrontPorch + c_H_SyncPulse) then
				r_H_Sync <= '0';
			else
				r_H_Sync <= '1';
			end if;

			if (VPOS > c_V_VisibleArea + c_V_FrontPorch and (VPOS < c_V_VisibleArea + c_V_FrontPorch + c_V_SyncPulse )) then
				r_V_Sync <= '0';
			else
				r_V_Sync <= '1';
			end if;

			if( (HPOS >= c_H_VisibleArea and HPOS < c_H_Whole) or (VPOS >= c_V_VisibleArea and VPOS <c_V_Whole) ) then
				r_VideoOn <= '0';
			else
				r_VideoOn <= '1';
			end if;
		end if;
	end process;

	
	memorySyncro : process (i_Sync_Clk, i_Sync_Reset)
	begin

		if (i_Sync_Clk'event and i_Sync_Clk = '1') then

			if(i_Sync_Reset = '1') then
				o_Sync_ActiveVRam <= "000";
				--r_VideoOn <= '0';
				--r_VideoOnRam_1 <= '0';
			elsif i_Sync_Reset = '0' then
				
				if (HPOS < c_H_Whole - 3) then
					r_MemorySyncro_HPOS_4 <= HPOS + 4;
					r_MemorySyncro_VPOS_4 <= VPOS;
				else
					r_MemorySyncro_HPOS_4 <= HPOS + 3 - c_H_Whole;
					if (VPOS = c_V_Whole) then
						r_MemorySyncro_VPOS_4 <= 0;
					else
						r_MemorySyncro_VPOS_4 <= VPOS + 1;
					end if;
				end if;
				
				--r_MemorySyncro_HPOS_1 <= r_MemorySyncro_HPOS_4;


				if(r_MemorySyncro_HPOS_4 >= c_VRam_Offset_X_Dealer and r_MemorySyncro_HPOS_4 < c_VRam_Dealer_Width + c_VRam_Offset_X_Dealer)
					and (r_MemorySyncro_VPOS_4 >= c_VRam_Offset_Y_Dealer and r_MemorySyncro_VPOS_4 < c_VRam_Dealer_Height + c_VRam_Offset_Y_Dealer) then
					
					o_Sync_ActiveVRam <= "001";
					
				--qui manca 10, per la zona comune
				elsif (r_MemorySyncro_HPOS_4 >= c_VRam_Offset_X_Player_1 and r_MemorySyncro_HPOS_4 < c_VRam_Player_Width + c_VRam_Offset_X_Player_1)
					and (r_MemorySyncro_VPOS_4 >= c_VRam_Offset_Y_Player_1 and r_MemorySyncro_VPOS_4 < c_VRam_Player_Height + c_VRam_Offset_Y_Player_1) then
					
					o_Sync_ActiveVRam <= "011";

				elsif (r_MemorySyncro_HPOS_4 >= c_VRam_Offset_X_Player_2 and r_MemorySyncro_HPOS_4 < c_VRam_Player_Width + c_VRam_Offset_X_Player_2)
					and (r_MemorySyncro_VPOS_4 >= c_VRam_Offset_Y_Player_2 and r_MemorySyncro_VPOS_4 < c_VRam_Player_Height + c_VRam_Offset_Y_Player_2) then
					
					o_Sync_ActiveVRam <= "100";
				
				else
					o_Sync_ActiveVRam <= "000";
				end if;








				--if(r_MemorySyncro_HPOS_1 >= c_VRam_Offset_X_Dealer and r_MemorySyncro_HPOS_1 < c_VRam_Player_Width + c_VRam_Offset_X_Dealer)
				--	and (r_MemorySyncro_VPOS_4 >= c_VRam_Offset_Y_Dealer and r_MemorySyncro_VPOS_4 < c_VRam_Player_Height + c_VRam_Offset_Y_Dealer) then
				--	r_VideoOnRam_1 <= '1';
				--else
				--	r_VideoOnRam_1 <= '0';
				--end if;

				--if( (r_MemorySyncro_HPOS_1 >= c_H_VisibleArea and r_MemorySyncro_HPOS_1 < c_H_Whole) or (r_MemorySyncro_VPOS_4 >= c_V_VisibleArea and r_MemorySyncro_VPOS_4 <c_V_Whole) ) then
				--	r_VideoOn <= '0';
				--else
				--	r_VideoOn <= '1';
				--end if;
				
			end if;
		end if;


	end process;

	o_Sync_HSync <= r_H_Sync;
	o_Sync_VSync <= r_V_Sync;
	o_Sync_VideoOn <= r_VideoOn;
	--o_Sync_VideoOnRam_1 <= r_VideoOnRam_1;

 

end Main;

