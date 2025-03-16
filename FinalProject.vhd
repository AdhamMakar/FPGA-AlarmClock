-- Farhin Zaman 301581517, Tiffany Vu 301587894, Adham Makar 301584092
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity FinalProject is
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
	 alarm_enable: in std_logic := '0';
	 alarm_signal: out std_logic := '0'
 );
end FinalProject;

architecture Behavioral of FinalProject is
	component SegDecoder
	port (
	 D: in std_logic_vector(3 downto 0);
	 Y: out std_logic_vector(6 downto 0)
	);
	end component;

	component PreScale
	port (
	 CLOCK: in std_logic;
	 CLOCK1S: out std_logic
	);
	end component;

	signal S1CLOCK: std_logic; 
	signal counter_hour, counter_minute, counter_second: integer:= 0;
	signal H1out: std_logic_vector(3 downto 0); 
	signal H0out: std_logic_vector(3 downto 0);
	signal M1out: std_logic_vector(3 downto 0);
	signal M0out: std_logic_vector(3 downto 0);
	signal S1out: std_logic_vector(3 downto 0);
	signal S0out: std_logic_vector(3 downto 0);
	signal alarm_hour: integer;
	signal alarm_minute: integer;
	signal alarm_active: std_logic := '0';
	
begin
	create_1s_clock: PreScale port map (CLOCK => clk, CLOCK1S => S1CLOCK); 
	
	process(S1CLOCK)
begin
    if rst_n = '0' then
        counter_hour <= 0;
        alarm_hour <= 0;
        counter_minute <= 0;
        alarm_minute <= 0;
        counter_second <= 0;
        alarm_active <= '0';
    elsif rising_edge(S1CLOCK) then
        case mode is
            when "001" =>
                if H_in1 = "00" and H_in0 = "0000" then
                    counter_hour <= 0;
                else
                    counter_hour <= to_integer(unsigned(H_in1)) * 10 + to_integer(unsigned(H_in0));
                end if;

                if M_in1 = "000" and M_in0 = "0000" then
                    counter_minute <= 0;
                else
                    counter_minute <= to_integer(unsigned(M_in1)) * 10 + to_integer(unsigned(M_in0));
                end if;

                counter_second <= 0;

            when "100" =>
                if counter_second < 59 then
                    counter_second <= counter_second + 1;
                else
                    counter_second <= 0;
                    if counter_minute < 59 then
                        counter_minute <= counter_minute + 1;
                    else
                        counter_minute <= 0;
                        if counter_hour < 23 then
                            counter_hour <= counter_hour + 1;
                        else
                            counter_hour <= 0;
                        end if;
                    end if;
                end if;

					if ((alarm_enable = '1') and (counter_hour = alarm_hour) and (counter_minute = alarm_minute)) then
						 if alarm_active = '0' then
							  alarm_active <= '1';
						 end if;
					else
						 alarm_active <= '0';
					end if;

            when "010" =>
                           
                if A_in_H1 = "00" and A_in_H0 = "0000" then
                    alarm_hour <= 0;
                else
                    alarm_hour <= to_integer(unsigned(A_in_H1)) * 10 + to_integer(unsigned(A_in_H0));
                end if;

                if A_in_M1 = "000" and A_in_M0 = "0000" then
                    alarm_minute <= 0;
                else
                    alarm_minute <= to_integer(unsigned(A_in_M1)) * 10 + to_integer(unsigned(A_in_M0));
                end if;

                alarm_active <= '0';
            when others =>
                alarm_active <= '0';
        end case;
    end if;
end process;
		
	
	 H1out <= x"2" when counter_hour >=20 else
	 x"1" when counter_hour >=10 else x"0";
	 convert_hex_H_out1: SegDecoder port map (D => H1out, Y => H_out1); 
	 
	 H0out <= std_logic_vector(to_unsigned((counter_hour - to_integer(unsigned(H1out))*10),4));
	 convert_hex_H_out0: SegDecoder port map (D => H0out, Y => H_out0); 
	 
	 S1out <= x"5" when counter_second >=50 else
	 x"4" when counter_second >=40 else
	 x"3" when counter_second >=30 else
	 x"2" when counter_second >=20 else
	 x"1" when counter_second >=10 else x"0";
	 convert_hex_S_out1: SegDecoder port map (D => S1out, Y => S_out1); 
	 
	 S0out <= std_logic_vector(to_unsigned((counter_second - to_integer(unsigned(S1out))*10),4));
	convert_hex_S_out0: SegDecoder port map (D => S0out, Y => S_out0);
	 
	 M1out <= x"5" when counter_minute >=50 else
	 x"4" when counter_minute >=40 else
	 x"3" when counter_minute >=30 else
	 x"2" when counter_minute >=20 else
	 x"1" when counter_minute >=10 else x"0";
	 convert_hex_M_out1: SegDecoder port map (D => M1out, Y => M_out1); 
	 
	 M0out <= std_logic_vector(to_unsigned((counter_minute - to_integer(unsigned(M1out))*10),4));
	convert_hex_M_out0: SegDecoder port map (D => M0out, Y => M_out0); 
	
	alarm_signal <= alarm_active;
end Behavioral;
	