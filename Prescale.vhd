-- Farhin Zaman 301581517, Tiffany Vu 301587894, Adham Makar 301584092
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PreScale is
    port (
        CLOCK : in std_logic;
        CLOCK1S : out std_logic
    );
end PreScale;

architecture Behavioral of PreScale is
    signal counter : unsigned(25 DOWNTO 0) := (others => '0');
begin
    process(CLOCK)
    begin
        if rising_edge(CLOCK) then
            counter <= counter + 1;
				if counter = to_unsigned(50000000, 26) then
					counter <= (others => '0');
				end if;					 
        end if;
    end process;

    CLOCK1S <= '1' when counter = to_unsigned(49999999, 26) else '0';

end Behavioral;

