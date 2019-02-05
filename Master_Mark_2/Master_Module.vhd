library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Master_Module is
port(
	i_Master_Clk : in std_logic;
	i_Master_On : in std_logic;
	i_Master_Btn_1	: in std_logic;
	i_Master_Btn_2	: in std_logic;

	i_Master_Switch_2	: in std_logic;
	
	i_Master_Switch_Combo_1	: in std_logic;
	i_Master_Switch_Combo_2	: in std_logic;

	o_Master_Led	: out std_logic_vector(3 downto 0);
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
		i_Players_Turn		: in std_logic_vector(1 downto 0);
		i_Players_EndGame	: in std_logic;
		i_Players_Stand		: in std_logic;

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

	TYPE State_type IS (Reset, Game);  -- Define the states
	SIGNAL Current_State, Next_State : State_Type;


  	signal r_Clock_125, r_Clock_40, r_Btn_Debounced_1, r_Btn_Debounced_2 : std_logic;

	signal r_Players_Vram_Sel		: std_logic_vector(1 downto 0);
	signal r_Players_Vram_Data		: std_logic_vector(2 downto 0);
	signal r_Players_Vram_Address 	: std_logic_vector(15 downto 0);

	constant c_Reset_Limit 	: integer := 625000000;
	signal r_Master_Reset : std_logic;
	signal r_Reset_Completed : std_logic;

	signal r_Delay_Counter 	: integer :=0;
	signal r_DelayOK : std_logic;

	signal r_Players_Enabled	: std_logic_vector(1 downto 0);


begin
	o_Master_Led(0) <= r_Btn_Debounced_1;
	r_Master_Reset <= not i_Master_On;
	r_Players_Enabled <= i_Master_Switch_Combo_1 & i_Master_Switch_Combo_2;

	CR : Clock_Regulator port map (i_Master_Clk, r_Clock_125, r_Clock_40, r_Master_Reset);

	Deb_Mod 	: Debounce_Switch port map(r_Clock_125, i_Master_Btn_1, r_Btn_Debounced_1);
	Deb_Mod_2 	: Debounce_Switch port map(r_Clock_125, i_Master_Btn_2, r_Btn_Debounced_2);


	Vga_Mod : Vga port map (r_Clock_125, r_Clock_40, r_Master_Reset, r_Players_Vram_Sel, r_Players_Vram_Data, r_Players_Vram_Address, o_Master_R, o_Master_G, o_Master_B, o_Master_HSync, o_Master_VSync);

	Players_Mod : Players_Manager port map (r_Clock_125, r_Master_Reset, r_Btn_Debounced_1, r_Players_Enabled, i_Master_Switch_2, r_Btn_Debounced_2, r_Players_Vram_Sel, r_Players_Vram_Data, r_Players_Vram_Address);

-- edited section, copy below

	--r_DelayOK <= '1' ;--when (Current_State = Reset and r_Delay_Counter >= c_Reset_Limit) else '0';
	
	--

	--Current : process (r_Clock_125, i_Master_On)
	--begin
	--	--if r_Clock_125 = '1' and r_Clock_125'Event then
	--		if i_Master_On = '1' then
	--			Current_State <= Next_State;
	--		else
	--			Current_State <= Reset;				
	--		end if;
	--	--end if;
	--end process;

	--nextP : process (r_Clock_125, r_DelayOK, i_Master_On)
	--begin
	--	if (r_Clock_125 = '1' and r_Clock_125'event) then
	--		case Current_State is
	--			when Reset =>
	--				if r_DelayOK = '1' and i_Master_On = '1' then
	--					Next_State <= Game;
	--				elsif r_DelayOK = '1' and i_Master_On = '0' then
	--					Next_State <= Reset;

	--				elsif r_DelayOK = '0' and i_Master_On = '1' then
	--					Next_State <= Reset;

	--				elsif r_DelayOK = '0' and i_Master_On = '0' then
	--					Next_State <= Reset;

	--				end if;					
	--			when Game =>
	--				if i_Master_On = '1' then
	--					Next_State <= Game;
	--				else
	--					Next_State <= Reset;
	--				end if;

	--		end case;

	--	end if;
	--end process;

	--output : process (Current_State)
	--	begin   
	--		case Current_State is
	--			when Reset =>
	--				r_Master_Reset <= '1';
	--				o_Master_Led(3) <= '1';
	--				o_Master_Led(2) <= '0';
					
	--			when Game =>
	--				r_Master_Reset <= '0';
	--				o_Master_Led(3) <= '0';
	--				o_Master_Led(2) <= '1';
	--		end case;	
	--	end process;	




end Behavioral;



--r_DelayOK <= '1' ;--when (Current_State = Reset and r_Delay_Counter >= c_Reset_Limit) else '0';
	
--	r_Players_Enabled <= i_Master_Switch_Combo_1 & i_Master_Switch_Combo_2;

--	Current : process (r_Clock_125, i_Master_On)
--	begin
--		--if r_Clock_125 = '1' and r_Clock_125'Event then
--			if i_Master_On = '1' then
--				Current_State <= Next_State;
--			else
--				Current_State <= Reset;				
--			end if;
--		--end if;
--	end process;

--	nextP : process (r_Clock_125, r_DelayOK, i_Master_On)
--	begin
--		if (r_Clock_125 = '1' and r_Clock_125'event) then
--			case Current_State is
--				when Reset =>
--					if r_DelayOK = '1' and i_Master_On = '1' then
--						Next_State <= Game;
--					elsif r_DelayOK = '1' and i_Master_On = '0' then
--						Next_State <= Reset;

--					elsif r_DelayOK = '0' and i_Master_On = '1' then
--						Next_State <= Reset;

--					elsif r_DelayOK = '0' and i_Master_On = '0' then
--						Next_State <= Reset;

--					end if;					
--				when others =>
--					if i_Master_On = '1' then
--						Next_State <= Game;
--					else
--						Next_State <= Reset;
--					end if;

--			end case;

--		end if;
--	end process;

--	output : process (Current_State)
--		begin   
--			case Current_State is
--				when Reset =>
--					r_Master_Reset <= '1';
--					o_Master_Led(3) <= '1';
--					o_Master_Led(2) <= '0';
					
--				when others =>
--					r_Master_Reset <= '0';
--					o_Master_Led(3) <= '0';
--					o_Master_Led(2) <= '1';
--			end case;	
--		end process;	
