--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:39:18 05/31/2016
-- Design Name:   
-- Module Name:   D:/Develop/Xlinx/PROJECT/Master_Mark_2/TB.vhd
-- Project Name:  Master_Mark_2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Master_Module
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB IS
END TB;
 
ARCHITECTURE behavior OF TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Master_Module
    PORT(
         i_Master_Clk : IN  std_logic;
         i_Master_On : IN  std_logic;
         i_Master_Btn_1 : IN  std_logic;
         i_Master_Btn_2 : IN  std_logic;
         i_Master_Switch_2 : IN  std_logic;
         i_Master_Switch_Combo_1 : IN  std_logic;
         i_Master_Switch_Combo_2 : IN  std_logic;
         o_Master_Led : OUT  std_logic_vector(3 downto 0);
         o_Master_R : OUT  std_logic_vector(4 downto 0);
         o_Master_G : OUT  std_logic_vector(5 downto 0);
         o_Master_B : OUT  std_logic_vector(4 downto 0);
         o_Master_HSync : OUT  std_logic;
         o_Master_VSync : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_Master_Clk : std_logic := '0';
   signal i_Master_On : std_logic := '0';
   signal i_Master_Btn_1 : std_logic := '0';
   signal i_Master_Btn_2 : std_logic := '0';
   signal i_Master_Switch_2 : std_logic := '0';
   signal i_Master_Switch_Combo_1 : std_logic := '0';
   signal i_Master_Switch_Combo_2 : std_logic := '0';

 	--Outputs
   signal o_Master_Led : std_logic_vector(3 downto 0);
   signal o_Master_R : std_logic_vector(4 downto 0);
   signal o_Master_G : std_logic_vector(5 downto 0);
   signal o_Master_B : std_logic_vector(4 downto 0);
   signal o_Master_HSync : std_logic;
   signal o_Master_VSync : std_logic;

   -- Clock period definitions
   constant i_Master_Clk_period : time := 8 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Master_Module PORT MAP (
          i_Master_Clk => i_Master_Clk,
          i_Master_On => i_Master_On,
          i_Master_Btn_1 => i_Master_Btn_1,
          i_Master_Btn_2 => i_Master_Btn_2,
          i_Master_Switch_2 => i_Master_Switch_2,
          i_Master_Switch_Combo_1 => i_Master_Switch_Combo_1,
          i_Master_Switch_Combo_2 => i_Master_Switch_Combo_2,
          o_Master_Led => o_Master_Led,
          o_Master_R => o_Master_R,
          o_Master_G => o_Master_G,
          o_Master_B => o_Master_B,
          o_Master_HSync => o_Master_HSync,
          o_Master_VSync => o_Master_VSync
        );

   -- Clock process definitions
   i_Master_Clk_process :process
   begin
		i_Master_Clk <= '0';
		wait for i_Master_Clk_period/2;
		i_Master_Clk <= '1';
		wait for i_Master_Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      i_Master_On <= '0';
      wait for 100 ns;	
		
      i_Master_On <= '1';
      wait for 100 ns;	
		i_Master_On <= '0';
      wait for 100 ns;	
		i_Master_On <= '1';
      wait for 100 ns;	
      -- insert stimulus here 

      wait;
   end process;

END;
