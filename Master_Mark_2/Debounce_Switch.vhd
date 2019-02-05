----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:03:58 04/13/2016 
-- Design Name: 
-- Module Name:    Debounce_Switch - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Debounce_Switch is
    Port ( i_DebounceS_Clk : in  STD_LOGIC;
           i_DebounceS_Btn : in  STD_LOGIC;
           o_DebounceS_Btn : out  STD_LOGIC);
end Debounce_Switch;

architecture Behavioral of Debounce_Switch is

	constant c_DEBOUNCE_LIMIT : integer :=1250000;
	signal r_State : STD_LOGIC := '0';
	signal r_Count : integer range 0 to c_DEBOUNCE_LIMIT := 0;
	
begin

	p_Debounce: process (i_DebounceS_Clk) is
	begin
		if rising_edge(i_DebounceS_Clk) then
			if (i_DebounceS_Btn /= r_State and r_Count < c_DEBOUNCE_LIMIT) then
				r_Count <= r_Count +1;
			elsif r_Count = c_DEBOUNCE_LIMIT then
				r_State <= i_DebounceS_Btn;
				r_COunt <= 0;
			else
				r_Count <= 0;
			end if;
		end if;
	end process p_Debounce;

	o_DebounceS_Btn <= r_State;
	
end architecture Behavioral;

