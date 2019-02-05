library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Deck_Manager is
	Port (
		i_clk : in std_logic;
	 	i_reset : in std_logic;
	 	i_new_game : in std_logic;
	 	i_hit : in std_logic;
	 	o_found : out std_logic;
	 	o_card : out std_logic_vector (5 downto 0));
end Deck_Manager;

architecture Behavioral of Deck_Manager is

	signal r_LSFR : std_logic_vector (5 downto 0);
	signal r_deck : std_logic_vector (0 to 63);
	signal r_hit_got : std_logic;
	signal r_found, r_found_output: std_logic;
	signal r_LSFR_rec : std_logic_vector (5 downto 0);
	signal i_resetn: std_logic;

	COMPONENT Lsfr is
	port (
		clock: in std_logic;
		resetn: in std_logic;	-- active low reset
		load: in std_logic;		-- active high load
		seed: in std_logic_vector(5 downto 0);	-- parallel seed input
		parallel_out: out std_logic_vector(5 downto 0); -- parallel data out
		serial_out: out std_logic	-- serial data out (From last shift register)
		);
	end COMPONENT;

	begin
		i_resetn <= not i_reset;
		lsfr_1 : Lsfr PORT MAP (i_clk, i_resetn, '0', "000000", r_LSFR, open);

	DM :process(i_reset, i_clk)
		begin
		
			if (i_reset = '1') then
				r_deck <= (others => '1');
				r_deck(0) <= '0';
				r_deck(14) <= '0';
				r_deck(15) <= '0';
				r_deck(16) <= '0';
				r_deck(30) <= '0';
				r_deck(31) <= '0';
				r_deck(32) <= '0';
				r_deck(46) <= '0';
				r_deck(47) <= '0';
				r_deck(48) <= '0';
				r_deck(62) <= '0';
				r_deck(63) <= '0';
				r_found <= '0';
				r_found_output <= '0';
				r_hit_got <= '0';
			elsif (rising_edge(i_clk))then
				if (i_hit = '1' and r_hit_got = '0') then
					if (r_found = '1') then
						r_hit_got <= '1';
						--L1 : while v_found = '0' loop
						--	if (r_deck(to_integer(unsigned(r_LSFR))) = '1') then
						--		r_deck(to_integer(unsigned(r_LSFR))) <= '0';
						--		v_found := '1';
						--	end if;
						--end loop L1;
						r_found <= '0';
						r_found_output <= '1';
						o_card <= r_LSFR_rec;
					else 		--found = 0
						if (r_deck(to_integer(unsigned(r_LSFR))) = '1') then
							r_deck(to_integer(unsigned(r_LSFR))) <= '0';
							r_found <= '1';
							r_LSFR_rec <= r_LSFR;
						end if; --rdecktointeger
					end if; --rfound=1
				elsif (i_hit = '0' and r_hit_got = '1') then
					r_hit_got <= '0';
				else 
						r_found_output <= '0';
				end if; --hit=1andrhit
					
			end if; --reset/risingedge
		end process DM;
	o_found <= r_found_output;
end Behavioral;

