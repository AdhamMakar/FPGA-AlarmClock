-- TIFFANY VU 301587894, FARHIN ZAMAN 301581517, ADHAM MAKAR 301584092
library IEEE;
use IEEE.std_logic_1164.all;

ENTITY SegDecoder is
	Port (D : in std_logic_vector( 3 downto 0 );
			Y : out std_logic_vector( 6 downto 0 )
			);
END SegDecoder;

ARCHITECTURE LogicFunction of SegDecoder is
BEGIN
	with D select
		Y <=
			"1000000" when "0000", -- 0
			"1111001" when "0001", -- 1
			"0100100" when "0010", -- 2
			"0110000" when "0011", -- 3
			"0011001" when "0100", -- 4
			"0010010" when "0101", -- 5
			"0000010" when "0110", -- 6
			"1111000" when "0111", -- 7
			"0000000" when "1000", -- 8
			"0010000" when "1001", -- 9
			"0001000" when "1010", -- A
			"0000011" when "1011",
			"0100111" when "1100",
			"0100001" when "1101",
			"0000110" when "1110",
			"0001110" when "1111", -- F
			"1111111" when others;
END LogicFunction;