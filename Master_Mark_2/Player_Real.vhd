library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Cards_Constants.All;

entity Player is

port (
	i_Player_Clk	: in std_logic;
	i_Player_Hit	: in std_logic;
	i_Player_Reset	: in std_logic;
	i_Player_Found	: in std_logic;
	i_Player_Card	: in std_logic_vector (5 downto 0);
	i_Player_Turn	: in std_logic;
	i_Player_EndGame: in std_logic;
	i_Player_Stand	: in std_logic;

	i_Player_TempSelect : in std_logic_vector(1 downto 0);

	i_Player_CG_Data	: in std_logic_vector (2 downto 0);
	i_Player_CG_Ack		: in std_logic;
	o_Player_CG_Request	: out std_logic;
	o_Player_CG_Card	: out std_logic_vector (5 downto 0);

	i_Player_CBR_Data	: in std_logic_vector (2 downto 0);
	o_Player_CBR_Address : out std_logic_vector (12 downto 0);

	o_Player_VRam_Select	: out std_logic_vector(1 downto 0);
	o_Player_VRam_Address	: out std_logic_vector (15 downto 0);
	o_Player_VRam_Data 		: out std_logic_vector (2 downto 0)
	);
end Player;

architecture Behavioral of Player is

type MEM is array (0 to 4) of std_logic_vector (5 downto 0);

signal r_Card_Received, r_Player_CG_Card : std_logic_vector (5 downto 0);
signal r_HPOS, r_VPOS : integer range 0 to 512;
signal r_Number_Card : integer range 0 to 5;
signal r_Number : integer range 0 to 5;
signal r_CG_Printing, r_CBR_Printing, r_Flag, r_Player_CG_Request, r_StopPrinting	: std_logic;
signal r_Offset_X, r_Offset_Y : integer range 0 to 512;
signal r_Select : std_logic_vector ( 1 downto 0);
signal r_Player_Enabled_Code : std_logic_vector ( 1 downto 0);
signal r_Memory_Card : MEM;
signal r_Player_VRam_Address : std_logic_vector (15 downto 0);
signal r_Player_VRam_Data	: std_logic_vector (2 downto 0);
signal r_Player_CBR_Address : std_logic_vector (12 downto 0);
signal r_CBR_Counter		: integer range 0 to 6700;
signal r_Player_Stand 		: std_logic;


begin
	
	process(i_Player_Clk, i_Player_Reset)
	begin
		if rising_edge(i_Player_Clk) then
			if (i_Player_Reset = '1') then
				--segnali da azzerare
				r_Card_Received <= "000000";
				r_CG_Printing <= '0';
				r_CBR_Printing <= '0';
				r_StopPrinting <= '0';
				r_Number_Card <= 0;
				r_Number<= 0;
				r_StopPrinting <= '0';
				r_Offset_X <= 0;
				r_Offset_Y <= 0;
				r_Flag <= '0';
				r_Player_CG_Request <= '0';
				r_Select <= "11";				
				r_Memory_Card(0) <= "000000";
				r_Memory_Card(1) <= "000000";				
				r_Memory_Card(2) <= "000000";
				r_Memory_Card(3) <= "000000";
				r_Memory_Card(4) <= "000000";
				r_Player_VRam_Data <= (others => '0');
				r_Player_VRam_Address <= (others => '0');
				r_Player_CG_Card <= (others => '0');
				r_Player_CBR_Address <= (others => '0');
				r_CBR_Counter <= 0;
				r_Player_Stand <= '0';
			elsif i_Player_Turn = '1' then			--turno passato diversamente ai diversi player (and, not, xor ecc. vd VRam)
				if i_Player_EndGame = '0' and r_Player_Stand = '0' then
					if i_Player_Stand = '1' then
						r_Player_Stand <= '1';
					end if;
					if (i_Player_Found = '1' and r_Flag = '0') then
						r_Card_Received <= i_Player_Card;
						r_Number_Card <= r_Number_Card + 1;
						if r_Number_Card >= 2 and r_Number_Card <= 4 then		--stampo scoperta solo se sono dopo le prime due
							r_Player_CG_Card <= i_Player_Card;
							r_HPOS <= 1;
							r_Player_CG_Request <= '1';
						elsif r_Number_Card < 2 then
							r_Player_CBR_Address <= (others => '0');
							r_HPOS <= 0;
							r_CBR_Printing <= '1';
						else r_Player_Stand <= '1';
						end if;	
						r_Flag <= '1';
						r_VPOS <= 0;
						r_CBR_Counter <= 1;
						case( r_Number_Card ) is
							when 0 =>
								r_Offset_Y <= Card_1_Y;										
								r_Offset_X <= Card_1_X;
							when 1 =>
								r_Offset_Y <= Card_2_Y;										
								r_Offset_X <= Card_2_X;
							when 2 =>
								r_Offset_Y <= Card_3_Y;										
								r_Offset_X <= Card_3_X;
							when 3 =>
								r_Offset_Y <= Card_4_Y;										
								r_Offset_X <= Card_4_X;
							when 4 =>
								r_Offset_Y <= Card_5_Y;										
								r_Offset_X <= Card_5_X;										
							when others => 
								r_Offset_X <= 256;
								r_Offset_Y <= 256;
						end case ;
					end if ;

					if (i_Player_CG_Ack = '1') then
						r_CG_Printing <= '1';
						r_Select <= r_Player_Enabled_Code;
						r_Player_VRam_Address <= std_logic_vector(to_unsigned((r_Offset_Y), 8)) & std_logic_vector(to_unsigned((r_Offset_X), 8));		
					end if;
					if (r_CG_Printing = '1') then
						r_Player_CG_Request <= '0';	
						r_Memory_Card(r_Number_Card - 1) <= r_Card_Received;
						if r_HPOS < Card_X then
							r_HPOS <= r_HPOS + 1;
							else
							r_HPOS <= 0;
							if r_VPOS < Card_Y then
								r_VPOS <= r_VPOS + 1;
							else
								r_VPOS <= 0;
								r_CG_Printing <= '0';
								r_Flag <= '0';
								r_Select <= "11";
							end if ;
						end if ;
						r_Player_VRam_Address <= std_logic_vector(to_unsigned((r_Offset_Y+r_VPOS), 8)) & std_logic_vector(to_unsigned((r_Offset_X+r_HPOS), 8));		
						r_Player_VRam_Data <= i_Player_CG_Data;
					elsif (r_CBR_Printing = '1') then
						r_Memory_Card(r_Number_Card - 1) <= r_Card_Received;
						r_Select <= r_Player_Enabled_Code;
						if r_HPOS < Card_X then
							r_HPOS <= r_HPOS + 1;
							else
							r_HPOS <= 0;
							if r_VPOS < Card_Y then
								r_VPOS <= r_VPOS + 1;
							else
								r_VPOS <= 0;
								r_CBR_Printing <= '0';
								r_Flag <= '0';
								r_Select <= "11";
							end if ;
						end if ;
						if r_CBR_Counter < 6699 then
							r_CBR_Counter <= r_CBR_Counter + 1;
						else 
							r_CBR_Counter <= 0;
						end if;
						r_Player_CBR_Address <= std_logic_vector(to_unsigned(r_CBR_Counter, 13));
						r_Player_VRam_Address <= std_logic_vector(to_unsigned((r_Offset_Y+r_VPOS), 8)) & std_logic_vector(to_unsigned((r_Offset_X+r_HPOS), 8));		
						r_Player_VRam_Data <= i_Player_CBR_Data;
					end if;
				elsif (i_Player_EndGame = '1' and r_StopPrinting = '0') then
					if r_Number >= 2 then 
						r_StopPrinting <= '1';
						r_Select <= "11";
					elsif (r_CBR_Printing = '0') then
						case( r_Number ) is
						when 0 =>
							r_Offset_Y <= Card_1_Y;										
							r_Offset_X <= Card_1_X;
						when 1 =>
							r_Offset_Y <= Card_2_Y;										
							r_Offset_X <= Card_2_X;
						when 2 =>
							r_Offset_Y <= Card_3_Y;										
							r_Offset_X <= Card_3_X;
						when 3 =>
							r_Offset_Y <= Card_4_Y;										
							r_Offset_X <= Card_4_X;
						when 4 =>
							r_Offset_Y <= Card_5_Y;										
							r_Offset_X <= Card_5_X;										
						when others => 
							r_Offset_X <= 256;
							r_Offset_Y <= 256;
						end case ;
						r_Flag <= '1';
						if (r_Player_CG_Request = '0') then
							r_Player_CG_Card <= r_Memory_Card(r_Number);
							r_Player_CG_Request <= '1';
						end if;

						if (i_Player_CG_Ack = '1') then
							r_CG_Printing <= '1';
							r_Select <= r_Player_Enabled_Code;
							r_Player_VRam_Address <= std_logic_vector(to_unsigned((r_Offset_Y), 8)) & std_logic_vector(to_unsigned((r_Offset_X), 8));
						end if;		
					
						if (r_CG_Printing = '1') then
							r_Player_CG_Request <= '0';	

							if r_HPOS < Card_X then
								r_HPOS <= r_HPOS + 1;
								else
								r_HPOS <= 0;
								if r_VPOS < Card_Y then
									r_VPOS <= r_VPOS + 1;
								else
									r_VPOS <= 0;
									r_CG_Printing <= '0';
									r_Flag <= '0';
									r_Number <= r_Number + 1;
								end if ;
							end if ;
							r_Player_VRam_Address <= std_logic_vector(to_unsigned((r_Offset_Y+r_VPOS), 8)) & std_logic_vector(to_unsigned((r_Offset_X+r_HPOS), 8));		
							r_Player_VRam_Data <= i_Player_CG_Data;
						end if;
					end if;
				end if;
			end if;	--turn & reset end if
		end if;	--risingedge
	end process;

	r_Player_Enabled_Code <= i_Player_TempSelect;
	o_Player_CBR_Address <= r_Player_CBR_Address;
	o_Player_CG_Card <= r_Player_CG_Card;
	o_Player_VRam_Address <= r_Player_VRam_Address;
	o_Player_VRam_Data <= r_Player_VRam_Data;
	o_Player_CG_Request <= r_Player_CG_Request;
	o_Player_Vram_Select <= r_Select;

end Behavioral;