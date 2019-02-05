library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Constants.ALL;

entity Drawer is
PORT (
	i_Draw_VgaClk 			: in std_logic;
	i_Draw_Reset 			: in std_logic;
	
	i_Draw_VRam_Data_Dealer 	: in std_logic_vector(2 downto 0);
	o_Draw_VRam_Address_Dealer	: out std_logic_vector(15 downto 0);

	i_Draw_VRam_Data_1 			: in std_logic_vector(2 downto 0);
	o_Draw_VRam_Address_1		: out std_logic_vector(15 downto 0);

	i_Draw_VRam_Data_2 			: in std_logic_vector(2 downto 0);
	o_Draw_VRam_Address_2		: out std_logic_vector(15 downto 0);

	i_Draw_ActiveVRam 			: in std_logic_vector(2 downto 0);
	i_Draw_VideoOn 				: in std_logic;
	
	o_Draw_RGB 					: out std_logic_vector(2 downto 0)
	--o_Draw_RGB				: out std_logic_vector(15 downto 0) 
	);

end Drawer;

architecture Behavioral of Drawer is
	
	signal r_Vram_Counter_Dealer, r_Vram_Counter_1, r_Vram_Counter_2 : integer range 0 to c_VRam_Limit :=0 ;
	signal r_Vram_Address_Dealer, r_Vram_Address_1, r_Vram_Address_2 : std_logic_vector(15 DOWNTO 0);
	--signal r_Vram_Data_Dealer, r_Vram_Data_1, r_Vram_Data_2  : std_logic_vector(2 DOWNTO 0);

begin

	Draw : process(i_Draw_VgaClk, i_Draw_Reset, i_Draw_VideoOn, i_Draw_ActiveVRam)
	begin

		if rising_edge(i_Draw_VgaClk) then
			if i_Draw_Reset = '1' then
				o_Draw_RGB<= (others => '0');
				r_Vram_Counter_Dealer <= 0;
				r_Vram_Address_Dealer <= (others => '0');
				--r_Vram_Data_Dealer 	 <= (others => '0');

				r_Vram_Counter_1 <= 0;
				r_Vram_Address_1 <= (others => '0');
				--r_Vram_Data_1 	 <= (others => '0');

				r_Vram_Counter_2 <= 0;
				r_Vram_Address_2 <= (others => '0');
				--r_Vram_Data_2 	 <= (others => '0');
			else
				
				if(i_Draw_VideoOn = '1') then

					case i_Draw_ActiveVRam is
						when "001" =>
							
							if(r_Vram_Counter_Dealer < c_VRam_Limit) then
								r_Vram_Counter_Dealer <= r_Vram_Counter_Dealer +1;
							else
								r_Vram_Counter_Dealer <= 0;
							end if;
							--r_Vram_Data_Dealer <= i_Draw_VRam_Data_Dealer;
							--o_Draw_RGB <= r_Vram_Data_Dealer;

							r_Vram_Address_Dealer <= std_logic_vector(to_unsigned(r_Vram_Counter_Dealer, 16));

							o_Draw_RGB	<= i_Draw_VRam_Data_Dealer;

						when "011" =>
							
							if(r_Vram_Counter_1 < c_VRam_Limit) then
								r_Vram_Counter_1 <= r_Vram_Counter_1 +1;
							else
								r_Vram_Counter_1 <= 0;
							end if;
							--r_Vram_Data_1 <= i_Draw_VRam_Data_1;
							--o_Draw_RGB <= r_Vram_Data_1;
							
							r_Vram_Address_1 <= std_logic_vector(to_unsigned(r_Vram_Counter_1, 16));
							
							o_Draw_RGB	<= i_Draw_VRam_Data_1;

						when "100" =>
							
							if(r_Vram_Counter_2 < c_VRam_Limit) then
								r_Vram_Counter_2 <= r_Vram_Counter_2 +1;
							else
								r_Vram_Counter_2 <= 0;
							end if;
							--r_Vram_Data_2 <= i_Draw_VRam_Data_2;
							--o_Draw_RGB <= r_Vram_Data_2;

							r_Vram_Address_2 <= std_logic_vector(to_unsigned(r_Vram_Counter_2, 16));
							
							o_Draw_RGB	<= i_Draw_VRam_Data_2;
							
						
						when others => o_Draw_RGB <=  (others => '1');
					
					end case;
				else
					o_Draw_RGB <=  (others => '0');
				end if;
			


			end if;




		end if;

	end process;
	o_Draw_VRam_Address_Dealer <= r_Vram_Address_Dealer;
	o_Draw_VRam_Address_1 <= r_Vram_Address_1;
	o_Draw_VRam_Address_2 <= r_Vram_Address_2;


end Behavioral;

