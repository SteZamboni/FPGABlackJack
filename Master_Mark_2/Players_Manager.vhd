library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use work.Cards_Constants.All;

entity Players_Manager is
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
end Players_Manager;


architecture Behavioral of Players_Manager is

	Component CardBack IS
  PORT (
	 clka : IN STD_LOGIC;
	 addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
	 douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
	END Component CardBack;

	Component Cards_Generator is
	port(
		i_CG_Clk 		: in std_logic;
		i_CG_Reset 		: in std_logic;

		i_CG_Card_Request	: in std_logic;
		i_CG_Card_Number	: in std_logic_vector(5 downto 0);
		o_CG_Card_ACK		: out std_logic;
		o_CG_Card_Data 		: out std_logic_vector(2 downto 0)

		);
	end Component Cards_Generator;

	Component Dealer is
		port (
		i_Dealer_Clk	: in std_logic;
		i_Dealer_Reset	: in std_logic;
		i_Dealer_Found	: in std_logic;
		i_Dealer_Card	: in std_logic_vector (5 downto 0);
		i_Dealer_Turn	: in std_logic;
		i_Dealer_EndGame: in std_logic;

		o_Dealer_DM_Hit	: out std_logic;

		i_Dealer_CG_Data	: in std_logic_vector (2 downto 0);
		i_Dealer_CG_Ack		: in std_logic;
		o_Dealer_CG_Request	: out std_logic;
		o_Dealer_CG_Card	: out std_logic_vector (5 downto 0);

		i_Dealer_CBR_Data	: in std_logic_vector (2 downto 0);
		o_Dealer_CBR_Address : out std_logic_vector (12 downto 0);

		o_Dealer_VRam_Select	: out std_logic_vector(1 downto 0);
		o_Dealer_VRam_Address	: out std_logic_vector (15 downto 0);
		o_Dealer_VRam_Data 		: out std_logic_vector (2 downto 0)
		);
	end Component;

	Component Player is
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
	end Component Player;

	Component Deck_Manager is
	Port (
		i_clk : in std_logic;
	 	i_reset : in std_logic;
	 	i_new_game : in std_logic;
	 	i_hit : in std_logic;
	 	o_found : out std_logic;
	 	o_card : out std_logic_vector (5 downto 0));
	end Component Deck_Manager;

	--signal	r_Card_Request	: std_logic;
	--signal	r_Card_Number	: std_logic_vector(5 downto 0);
	signal r_Player_CBR_Data : std_logic_vector (2 downto 0);
	signal r_Player_CBR_Address : std_logic_vector (12 downto 0);
	signal	r_Card_ACK, r_Found, r_Player_req	: std_logic;
	signal	r_Card_Data 		: std_logic_vector(2 downto 0);
	signal r_Card_DM, r_Player_Num	: std_logic_vector (5 downto 0);

	signal r_Vram_Select_D, r_Vram_Select_1, r_Vram_Select_2 	: std_logic_vector(1 downto 0);
	signal r_Vram_Data_D, r_Vram_Data_1, r_Vram_Data_2 			: std_logic_vector(2 downto 0);
	signal r_Vram_Address_D, r_Vram_Address_1, r_Vram_Address_2 : std_logic_vector(15 downto 0);

	signal r_DeckManager_Hit, r_Dealer_Hit : std_logic;

	signal r_Card_Request_D, r_Card_Request_1, r_Card_Request_2 : std_logic;
	signal r_Card_Code_D, r_Card_Code_1, r_Card_Code_2 : std_logic_vector (5 downto 0);
	
	signal r_CBR_Address_D, r_CBR_Address_1, r_CBR_Address_2 : std_logic_vector (12 downto 0);

	signal r_Player_Enabled : std_logic_vector(2 downto 0);

	

begin
	r_Player_Enabled(0) <= (not i_Players_Turn(1)) 	and (not i_Players_Turn(0));
	r_Player_Enabled(1) <= (not i_Players_Turn(1))	and (i_Players_Turn(0));
	r_Player_Enabled(2) <= (i_Players_Turn(1)) 		and (not i_Players_Turn(0));

	--i_Players_Turn --> select

	with i_Players_Turn select o_Players_Vram_Data <=
		r_Vram_Data_D when "00",
		r_Vram_Data_1 when "01",
		r_Vram_Data_2 when "10";

	with i_Players_Turn select o_Players_Vram_Address <=
		r_Vram_Address_D when "00",
		r_Vram_Address_1 when "01",
		r_Vram_Address_2 when "10";

	with i_Players_Turn select o_Players_Vram_Sel <=
		r_Vram_Select_D when "00",
		r_Vram_Select_1 when "01",
		r_Vram_Select_2 when "10";

	with i_Players_Turn select r_DeckManager_Hit <=
		r_Dealer_Hit when "00",
		i_Players_Hit when "01",
		i_Players_Hit when "10";

	with i_Players_Turn select r_Player_req <=
		r_Card_Request_D when "00",
		r_Card_Request_1 when "01",
		r_Card_Request_2 when "10";

	with i_Players_Turn select r_Player_Num <=
		r_Card_Code_D when "00",
		r_Card_Code_1 when "01",
		r_Card_Code_2 when "10";

	with i_Players_Turn select r_Player_CBR_Address <=
		r_CBR_Address_D when "00",
		r_CBR_Address_1 when "01",
		r_CBR_Address_2 when "10";

	CB : CardBack port map( 
		i_Players_Clk,
		r_Player_CBR_Address,
		r_Player_CBR_Data);

	CG : Cards_Generator port map(
		i_Players_Clk,
		i_Players_Reset,
		r_Player_req,
		r_Player_Num,
		r_Card_ACK,
		r_Card_Data);

	--Dealer_Module
	Dealer_Fantastic_Component_Ultra_Mega_Wow_Lol_Wtf_JhonCeena_ROTFL : Dealer port map( 
		i_Players_Clk,
		i_Players_Reset,
		r_Found,
		r_Card_DM,
		r_Player_Enabled(0),
		i_Players_EndGame,

		r_Dealer_Hit,

		r_Card_Data,
		r_Card_ACK,
		r_Card_Request_D,
		r_Card_Code_D,

		r_Player_CBR_Data,
		r_CBR_Address_D,

		r_Vram_Select_D,
		r_Vram_Address_D,
		r_Vram_Data_D
		);

	P1 : Player port map(
		i_Players_Clk,
		i_Players_Hit,
		i_Players_Reset,
		r_Found,
		r_Card_DM,
		r_Player_Enabled(1),
		i_Players_EndGame,
		i_Players_Stand,
		"01",	
		r_Card_Data,
		r_Card_ACK,
		r_Card_Request_1,
		r_Card_Code_1,
		r_Player_CBR_Data,
		r_CBR_Address_1,
		r_Vram_Select_1,
		r_Vram_Address_1,
		r_Vram_Data_1
		
		);

	P2 : Player port map(
		i_Players_Clk,
		i_Players_Hit,
		i_Players_Reset,
		r_Found,
		r_Card_DM,
		r_Player_Enabled(2),
		i_Players_EndGame,
		i_Players_Stand,		
		"10",
		r_Card_Data,
		r_Card_ACK,
		r_Card_Request_2,
		r_Card_Code_2,
		r_Player_CBR_Data,
		r_CBR_Address_2,
		r_Vram_Select_2,
		r_Vram_Address_2,
		r_Vram_Data_2
		);

	DM : Deck_Manager port map(
		i_Players_Clk,
		i_Players_Reset,
		'0',
		r_DeckManager_Hit,
		r_Found,
		r_Card_DM		
		);
	
end Behavioral;

