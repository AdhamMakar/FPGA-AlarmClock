-- Farhin Zaman 301581517, Tiffany Vu 301587894, Adham Makar 301584092

library ieee;
use ieee.std_logic_1164.all;


entity AlarmSystem is
    Port (
			CLOCK_50 : in std_logic; 
			SW : in std_logic_vector(9 downto 0);
			KEY : in std_logic_vector(3 downto 0):= (others => '0');
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0);
			Aalarm_signal: buffer std_logic;
			LEDR : buffer STD_LOGIC_VECTOR(0 DOWNTO 0) := "0"
    );
end AlarmSystem;

architecture Behavioral of AlarmSystem is

	Signal	AH_in1: std_logic_vector(1 downto 0):= "00";
	Signal	AH_in0: std_logic_vector(3 downto 0):= "0000";  
	Signal	AM_in1: std_logic_vector(2 downto 0):= "000";  
	Signal	AM_in0: std_logic_vector(3 downto 0):= "0000";
	Signal	AA_in_H1: std_logic_vector(1 downto 0):= "00";
	Signal	AA_in_H0: std_logic_vector(3 downto 0):= "0000";
	Signal	AA_in_M1: std_logic_vector(2 downto 0):= "000";
	Signal	AA_in_M0: std_logic_vector(3 downto 0):= "0000";
	Signal   AlarmON: std_logic := '0';
	Signal   Decision: std_logic := '0';
	Signal   Decision2: std_logic := '0';
	Signal 	W: std_logic_vector(9 downto 0) := (others => '0');
	
	Component FinalProject is
	port ( 
		 clk: in std_logic; 
		 mode: in std_logic_vector(2 downto 0);
		 rst_n: in std_logic; 
		 H_in1: in std_logic_vector(1 downto 0);
		 H_in0: in std_logic_vector(3 downto 0);  
		 M_in1: in std_logic_vector(2 downto 0);  
		 M_in0: in std_logic_vector(3 downto 0); 
		 H_out1: out std_logic_vector(6 downto 0);
		 H_out0: out std_logic_vector(6 downto 0);
		 M_out1: out std_logic_vector(6 downto 0);
		 M_out0: out std_logic_vector(6 downto 0);
		 S_out1: out std_logic_vector(6 downto 0);
		 S_out0: out std_logic_vector(6 downto 0);
		 A_in_H1: in std_logic_vector(1 downto 0);
		 A_in_H0: in std_logic_vector(3 downto 0);
		 A_in_M1: in std_logic_vector(2 downto 0);
		 A_in_M0: in std_logic_vector(3 downto 0);
		 alarm_enable: in std_logic;
		 alarm_signal: out std_logic
 );
 end component;
Begin	
CLOCK	: FinalProject port map(
		clk => CLOCK_50,
		rst_n => KEY(3),
		mode => W(9 downto 7),
		H_in1 => AH_in1,
		H_in0 => AH_in0,
		M_in1 => AM_in1,
		M_in0 => AM_in0,
		H_out1 => HEX5,
		H_out0 => HEX4,
		M_out1 => HEX3,
		M_out0 => HEX2,
		S_out1 => HEX1,
		S_out0 => HEX0,
		A_in_H1 => AA_in_H1,
		A_in_H0 => AA_in_H0,
		A_in_M1 => AA_in_M1,
		A_in_M0 => AA_in_M0,
		alarm_enable => W(9),
		alarm_signal => Aalarm_signal
	);
	W <= SW;
	Process(W, CLOCK_50)
	Begin
		if KEY(1) = '0' THEN
			AH_in1 <= W(5 downto 4);
			AH_in0 <= W(3 downto 0);
			AA_in_H1 <= W(5 DOWNTO 4);
			AA_in_H0 <= W(3 DOWNTO 0);
		elsif (SW(9 DOWNTO 7) = "000" OR KEY(3) = '0') then
   		AH_in1 <= "00";
			AH_in0 <= "0000";
			AA_in_H1 <= "00";
			AA_in_H0 <= "0000";
		END if;
		if KEY(0) = '0' THEN
			AM_in1 <= W(6 DOWNTO 4);
			AM_in0 <= W(3 DOWNTO 0);
			AA_in_M1 <= W(6 DOWNTO 4);
			AA_in_M0 <= W(3 DOWNTO 0);
		elsif (SW(9 DOWNTO 7) = "000" OR KEY(3) = '0') then
			AM_in1 <= "000";
			AM_in0 <= "0000";
			AA_in_M1 <= "000";
			AA_in_M0 <= "0000";
		END if;
	end process;	
	process(CLOCK_50, KEY(3))
	begin
    if (KEY(3) = '0') then
        AlarmON <= '0';
        LEDR(0) <= '0';
    elsif rising_edge(CLOCK_50) then
        if (KEY(2) = '0') then
            AlarmON <= '1';
            LEDR(0) <= '0';
        elsif (Aalarm_signal = '1' and AlarmON = '0') then
            LEDR(0) <= '1';
        elsif (Aalarm_signal = '0' and AlarmON = '1') then
            AlarmON <= '0';
            LEDR(0) <= '0';
        end if;
    end if;
end process;
END Behavioral;
	
