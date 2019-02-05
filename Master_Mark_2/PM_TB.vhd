--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:42:11 05/27/2016
-- Design Name:   
-- Module Name:   C:/Users/Stefano/Desktop/Master_Mark_2/PM_TB.vhd
-- Project Name:  Master_Mark_2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Players
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
 
ENTITY PM_TB IS
END PM_TB;
 
ARCHITECTURE behavior OF PM_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Players
    PORT(
         i_Players_Clk : IN  std_logic;
         i_Players_Reset : IN  std_logic;
         i_Players_Hit : IN  std_logic;
         o_Players_Vram_Sel : OUT  std_logic_vector(1 downto 0);
         o_Players_Vram_Data : OUT  std_logic_vector(2 downto 0);
         o_Players_Vram_Address : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_Players_Clk : std_logic := '0';
   signal i_Players_Reset : std_logic := '0';
   signal i_Players_Hit : std_logic := '0';

 	--Outputs
   signal o_Players_Vram_Sel : std_logic_vector(1 downto 0);
   signal o_Players_Vram_Data : std_logic_vector(2 downto 0);
   signal o_Players_Vram_Address : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant i_Players_Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Players PORT MAP (
          i_Players_Clk => i_Players_Clk,
          i_Players_Reset => i_Players_Reset,
          i_Players_Hit => i_Players_Hit,
          o_Players_Vram_Sel => o_Players_Vram_Sel,
          o_Players_Vram_Data => o_Players_Vram_Data,
          o_Players_Vram_Address => o_Players_Vram_Address
        );

   -- Clock process definitions
   i_Players_Clk_process :process
   begin
		i_Players_Clk <= '0';
		wait for i_Players_Clk_period/2;
		i_Players_Clk <= '1';
		wait for i_Players_Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      i_Players_Reset <= '1';
      wait for 100 ns;	
      i_Players_Reset <= '0';
      wait for i_Players_Clk_period*10;
		
		for index in 0 to 55 loop
			i_Players_Hit <= '1';
			wait for 1 ms;
			i_Players_Hit <= '0';
			wait for 600 us;
		end loop;
      -- insert stimulus here 

      wait;
   end process;

END;
