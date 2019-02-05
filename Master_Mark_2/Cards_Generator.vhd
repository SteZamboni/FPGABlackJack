library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Cards_Constants.All;

entity Cards_Generator is
port(
	i_CG_Clk 		: in std_logic;
	i_CG_Reset 		: in std_logic;

	i_CG_Card_Request	: in std_logic;
	i_CG_Card_Number	: in std_logic_vector(5 downto 0);
	o_CG_Card_ACK		: out std_logic;
	o_CG_Card_Data 		: out std_logic_vector(2 downto 0)

	);
end Cards_Generator;

architecture Behavioral of Cards_Generator is

	Component Numbers_Rom is
	  port (
	    clka : in std_logic;
	    addra : in std_logic_vector(12 downto 0);
	    douta : out std_logic_vector(2 downto 0)
	  );
	end Component Numbers_Rom;

	Component Seeds_Rom is
	  port (
	    clka : in std_logic;
	    addra : in std_logic_vector(11 downto 0);
	    douta : out std_logic_vector(2 downto 0)
	  );
	end Component Seeds_Rom;

	signal r_HPOS : integer range 0 to Card_X + 1 := Card_X + 1;
	signal r_VPOS : integer range 0 to Card_Y + 1 := Card_Y + 1;

	signal r_Card_Number_Counter: integer range 0 to Numbers_Block_Size_0 := 0;
	signal r_Card_Seed_Counter	: integer range 0 to Seeds_Block_Size_0 :=0;

	signal r_Requested_Number	: std_logic_vector(3 downto 0);	 
	signal r_Requested_Seed		: std_logic_vector(1 downto 0);
	signal r_Requested_Color	: std_logic;
	

	signal r_Card_Number_Data, r_Card_Seed_Data	: std_logic_vector(2 downto 0);
	signal r_Card_Number_Address 				: std_logic_vector(12 downto 0);
	signal r_Card_Seed_Address	 				: std_logic_vector(11 downto 0);

	signal r_Card_ACK : std_logic;
	signal r_Output_Card_Data 					: std_logic_vector(2 downto 0);

begin
	
	Num_Rom : Numbers_Rom port map(i_CG_Clk, r_Card_Number_Address, r_Card_Number_Data);
	Seed_Rom : Seeds_Rom  port map(i_CG_Clk, r_Card_Seed_Address, r_Card_Seed_Data);

	process (i_CG_Clk, i_CG_Card_Request, i_CG_Reset)
	begin
		if i_CG_Reset = '1' then
			--r_Card_Number_Data 		<= (others => '0');
			r_Card_Number_Address 	<= (others => '0');
			--r_Card_Seed_Data 		<= (others => '0');
			r_Card_Seed_Address 	<= (others => '0');
			r_Requested_Number 		<= (others => '0');
			r_Requested_Seed 		<= (others => '0');
			r_Card_Number_Counter 	<= 0;
			r_Card_Seed_Counter 	<= 0;
			r_Card_ACK <= '0';
		elsif rising_edge(i_CG_Clk) and i_CG_Reset = '0' then

			if i_CG_Card_Request = '1' and r_Card_ACK = '0' then	
					r_Requested_Seed 	<= i_CG_Card_Number(5 downto 4);	
					r_Requested_Number 	<= i_CG_Card_Number(3 downto 0);
					r_Requested_Color	<= i_CG_Card_Number(5);
					r_Card_ACK <= '1';

					r_HPOS <= Card_X + 1;
					r_VPOS <= Card_Y + 1;
			end if;

			if r_Card_ACK = '1' then
				if r_HPOS = Card_X -1 and r_VPOS = Card_Y then
						r_Card_ACK <= '0';
				end if;
				if r_HPOS < Card_X then
					r_HPOS <= r_HPOS + 1;
					else
					r_HPOS <= 0;
					if r_VPOS < Card_Y then
						r_VPOS <= r_VPOS + 1;
					else
						r_VPOS <= 0;
					end if ;
				end if ;

				if (r_HPOS < 3 - 1) or (r_HPOS > 63 - 1) or (r_VPOS < 3) or (r_VPOS > 97) then --cornice rossa
					r_Output_Card_Data <= "100";
				elsif (r_HPOS > 5 - 1 and r_HPOS <= 5 - 1 + Numbers_Block_X) and (r_VPOS > 5 and r_VPOS <= 5 + Numbers_Block_Y) then --numero alto_sx
					r_Output_Card_Data <= r_Card_Number_Data;
					if r_Card_Number_Counter < Numbers_Block_Size_0 then
						r_Card_Number_Counter <= r_Card_Number_Counter +1;
					else
						r_Card_Number_Counter <= 0;
					end if;

				--elsif (r_HPOS > 43 and r_HPOS < 43+c_numb) and (r_VPOS > 5 and r_VPOS < 5+c_numb) then --numero alto_dx [disabilitato]
				--	r_Output_Card_Data <= r_Card_Number_Data;
				--elsif (r_HPOS > 5 and r_HPOS < 5+c_numb) and (r_VPOS > 77 and r_VPOS < 77+c_numb) then --numero basso_sx [disabilitato]
				--	r_Output_Card_Data <= r_Card_Number_Data;
				
				elsif (r_HPOS > 43 - 1 and r_HPOS <= 43 - 1 + Numbers_Block_X) and (r_VPOS > 77 and r_VPOS <= 77 + Numbers_Block_Y) then --numero basso_dx
					r_Output_Card_Data <= r_Card_Number_Data;
					if r_Card_Number_Counter < Numbers_Block_Size_0 then
						r_Card_Number_Counter <= r_Card_Number_Counter +1;
					else
						r_Card_Number_Counter <= 0;
					end if;


				elsif (r_HPOS > 16 - 1 and r_HPOS <= 16 - 1 + Seeds_Block_X) and (r_VPOS > 33 and r_VPOS <= 33 + Seeds_Block_Y) then --seme centrale
					r_Output_Card_Data <= r_Card_Seed_Data;

					if r_Card_Seed_Counter <= Seeds_Block_Size_0 then
						r_Card_Seed_Counter <= r_Card_Seed_Counter +1;
					else
						r_Card_Seed_Counter <= 0;
					end if;


				else --sfondo bianco
					r_Output_Card_Data <= "111";
				end if;


				if(r_Requested_Color = '0') then
					r_Card_Number_Address <= std_logic_vector(to_unsigned( (r_Card_Number_Counter + (256 * to_integer(unsigned(r_Requested_Number)  ) ) + 3328 + 1 -256) , 13));
				else
					r_Card_Number_Address <= std_logic_vector(to_unsigned(  (r_Card_Number_Counter + (256 * to_integer(unsigned(r_Requested_Number) ) )  +1 -256) , 13));

				end if;
				r_Card_Seed_Address <= std_logic_vector(to_unsigned(  (r_Card_Seed_Counter + (1024 * to_integer(unsigned(r_Requested_Seed) ) )  +1), 12));


			end if;
				


		end if;
	end process;

	o_CG_Card_ACK <= r_Card_ACK;
	o_CG_Card_Data <= r_Output_Card_Data;


end Behavioral;

