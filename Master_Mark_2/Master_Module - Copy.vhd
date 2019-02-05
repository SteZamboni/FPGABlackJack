library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Master_Module is
port(
	i_Master_Clk : in std_logic;
	i_Master_Reset : in std_logic;
	i_Master_Switch	: in std_logic;
	i_Master_Switch_2	: in std_logic;
	o_Master_Led	: out std_logic;
	o_Master_R 		: out std_logic_vector(4 downto 0);
	o_Master_G 		: out std_logic_vector(5 downto 0);
	o_Master_B 		: out std_logic_vector(4 downto 0);
	
	o_Master_HSync 	: out std_logic;
	o_Master_VSync 	: out std_logic

	);
end Master_Module;

architecture Behavioral of Master_Module is

	Component Clock_Regulator is
	port (
	  	i_CR_Clk           : in     std_logic;
		o_CR_Clk_125          : out    std_logic;
		o_CR_Clk_40          : out    std_logic;
		i_CR_Reset             : in     std_logic
	 );
	end Component Clock_Regulator;

	Component Vga is
	PORT (
		i_Vga_Clk_125 		: in  STD_LOGIC;
		i_Vga_Clk_40		: in  STD_LOGIC;

		i_Vga_Reset 	: in std_logic;

		i_Vga_Vram_Select 	: in std_logic_vector(1 downto 0);
		i_Vga_Vram_Data 	: in std_logic_vector(2 downto 0);
		i_Vga_Vram_Address 	: in std_logic_vector(15 downto 0);
		
		o_Vga_R 		: out std_logic_vector(4 downto 0);
		o_Vga_G 		: out std_logic_vector(5 downto 0);
		o_Vga_B 		: out std_logic_vector(4 downto 0);
		
		o_Vga_HSync 	: out std_logic;
		o_Vga_VSync 	: out std_logic
	);
	end Component Vga;

	Component Players_Manager is
	port(
		i_Players_Clk 		: in  STD_LOGIC;
		i_Players_Reset 	: in std_logic;

		i_Players_Hit		: in std_logic;
		i_Players_Turn	: in std_logic;
		i_Players_EndGame	: in std_logic;


		o_Players_Vram_Sel		: out std_logic_vector(1 downto 0);
		o_Players_Vram_Data 	: out std_logic_vector(2 downto 0);
		o_Players_Vram_Address 	: out std_logic_vector(15 downto 0)

		);
	end Component Players_Manager;

	Component Debounce_Switch is
    Port ( i_DebounceS_Clk : in  STD_LOGIC;
           i_DebounceS_Btn : in  STD_LOGIC;
           o_DebounceS_Btn : out  STD_LOGIC);
	end Component Debounce_Switch;

	TYPE State_type IS (Init, Reset, Game, EndGame);  -- Define the states
	SIGNAL Current_State, Next_State : State_Type;


  	signal r_Clock_125, r_Clock_40, r_Btn_Debounced : std_logic;

	signal r_Players_Vram_Sel		: std_logic_vector(1 downto 0);
	signal r_Players_Vram_Data		: std_logic_vector(2 downto 0);
	signal r_Players_Vram_Address 	: std_logic_vector(15 downto 0);


begin
	o_Master_Led <= r_Btn_Debounced;

	CR : Clock_Regulator port map (i_Master_Clk, r_Clock_125, r_Clock_40, i_Master_Reset);

	Deb_Mod : Debounce_Switch port map(r_Clock_125, i_Master_Switch, r_Btn_Debounced);

	Vga_Mod : Vga port map (r_Clock_125, r_Clock_40, i_Master_Reset, r_Players_Vram_Sel, r_Players_Vram_Data, r_Players_Vram_Address, o_Master_R, o_Master_G, o_Master_B, o_Master_HSync, o_Master_VSync);

	Players_Mod : Players_Manager port map (r_Clock_125, i_Master_Reset, r_Btn_Debounced, '1', i_Master_Switch_2, r_Players_Vram_Sel, r_Players_Vram_Data, r_Players_Vram_Address);


end Behavioral;

