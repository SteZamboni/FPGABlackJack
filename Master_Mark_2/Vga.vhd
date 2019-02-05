library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity Vga is
PORT (
	i_Vga_Clk_125 		: in  STD_LOGIC;
	i_Vga_Clk_40 		: in  STD_LOGIC;

	i_Vga_Reset 	: in std_logic;

	i_Vga_Vram_Select	: in std_logic_vector(1 downto 0);
	i_Vga_Vram_Data 	: in std_logic_vector(2 downto 0);
	i_Vga_Vram_Address 	: in std_logic_vector(15 downto 0);

	o_Vga_R 		: out std_logic_vector(4 downto 0);
	o_Vga_G 		: out std_logic_vector(5 downto 0);
	o_Vga_B 		: out std_logic_vector(4 downto 0);
	
	o_Vga_HSync 	: out std_logic;
	o_Vga_VSync 	: out std_logic
);
end Vga;

architecture Behavioral of Vga is

Component Synchronizer is
PORT (
	i_Sync_Clk 			: in  std_logic;
	i_Sync_Reset		: in std_logic;
	o_Sync_HSync 		: out  std_logic;
    o_Sync_VSync 		: out  std_logic;
    
    o_Sync_ActiveVRam 	: out std_logic_vector(2 downto 0);
    o_Sync_VideoOn 		: out std_logic -- tocheck
);
end Component Synchronizer;

Component Drawer is
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
	);

end Component Drawer;

Component VRam_3Bit IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
end Component VRam_3Bit;

signal r_Clk_125, r_Clk_40, r_VideoOn : std_logic; 
signal r_ActiveRam, r_Vram_Data_D, r_Vram_Data_1, r_Vram_Data_2, r_RGB : std_logic_vector(2 downto 0);

signal r_Vram_Address_D, r_Vram_Address_1, r_Vram_Address_2 : std_logic_vector(15 downto 0);


signal r_Vram_Write_Address : std_logic_vector(15 downto 0);
signal r_Vram_Write_Data : std_logic_vector(2 downto 0);

signal r_Write_Enabled : std_logic_vector(2 downto 0);

signal r_Write_Enabled_1 : std_logic_vector(0 downto 0);
signal r_Write_Enabled_2 : std_logic_vector(0 downto 0);
signal r_Write_Enabled_3 : std_logic_vector(0 downto 0);


begin

r_Vram_Write_Data <= i_Vga_Vram_Data;
r_Vram_Write_Address <= i_Vga_Vram_Address;

r_Write_Enabled(0) <= (not i_Vga_Vram_Select(1)) 	and (not i_Vga_Vram_Select(0));
r_Write_Enabled(1) <= (not i_Vga_Vram_Select(1))	and (i_Vga_Vram_Select(0));
r_Write_Enabled(2) <= (i_Vga_Vram_Select(1)) 		and (not i_Vga_Vram_Select(0));

r_Write_Enabled_1(0) <= r_Write_Enabled(0);
r_Write_Enabled_2(0) <= r_Write_Enabled(1);
r_Write_Enabled_3(0) <= r_Write_Enabled(2);

Syncro 	: Synchronizer port map(i_Vga_Clk_40, i_Vga_Reset, o_Vga_HSync, o_Vga_VSync, r_ActiveRam, r_VideoOn);

Vram_D 		: VRam_3Bit port map(i_Vga_Clk_125, r_Write_Enabled_1, r_Vram_Write_Address, r_Vram_Write_Data, i_Vga_Clk_40, r_Vram_Address_D, r_Vram_Data_D);

Vram_P1 	: VRam_3Bit port map(i_Vga_Clk_125, r_Write_Enabled_2, r_Vram_Write_Address, r_Vram_Write_Data, i_Vga_Clk_40, r_Vram_Address_1, r_Vram_Data_1);

Vram_P2 	: VRam_3Bit port map(i_Vga_Clk_125, r_Write_Enabled_3, r_Vram_Write_Address, r_Vram_Write_Data, i_Vga_Clk_40, r_Vram_Address_2, r_Vram_Data_2);

Draw 	: Drawer port map
(
	i_Vga_Clk_40,
	i_Vga_Reset,
	r_Vram_Data_D,
	r_Vram_Address_D,
	r_Vram_Data_1,
	r_Vram_Address_1,
	r_Vram_Data_2,
	r_Vram_Address_2,
	r_ActiveRam,
	r_VideoOn,
	r_RGB

	);

o_Vga_R 	<= ( others => r_RGB(2) );
o_Vga_G 	<= ( others => r_RGB(1) );
o_Vga_B 	<= ( others => r_RGB(0) );

end Behavioral;

