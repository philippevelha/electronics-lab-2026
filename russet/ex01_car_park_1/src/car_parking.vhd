library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Car_Parking_System_VHDL is
    port(
        clk : in std_logic;
        reset_n : in std_logic; -- active low, asynchronous
        front_sensor: in std_logic;
        back_sensor : in std_logic;
        password_1 : in std_logic_vector(1 downto 0);
        password_2 : in std_logic_vector(1 downto 0);
        GREEN_LED : out std_logic;
        RED_LED : out std_logic;
        HEX_1 : out std_logic_vector(6 downto 0); -- segments gfedcba
        HEX_2 : out std_logic_vector(6 downto 0)
    );
end Car_Parking_System_VHDL;

architecture rtl of Car_Parking_System_VHDL is
    type state_type is (IDLE, WAIT_PASSWORD, WRONG_PASSWORD, RIGHT_PASSWORD, STOP);
    signal State : state_type;
    signal blink_on : std_logic := '0';
    signal wait_count : natural range 0 to 9 := 0;

begin
    clock : process(clk, reset_n) is
    begin
        if reset_n = '0' then
            State <= IDLE;
            HEX_1 <= "1111111"; -- off
            HEX_2 <= "1111111"; -- off
            blink_on <= '0';
            wait_count <= 0;
        elsif rising_edge(clk) then
            blink_on <= not blink_on;
                    
            case State is
                when IDLE =>
                    if front_sensor = '1' then
                        State <= WAIT_PASSWORD;
                        wait_count <= 0;
                    end if;
                when WAIT_PASSWORD =>
                    HEX_1 <= "0000110"; -- E
                    HEX_2 <= "0101011"; -- n
                    if wait_count < 9 then
                        wait_count <= wait_count + 1;
                    else
                        wait_count <= 0;
                        if password_1 = "01" and password_2 = "10" then 
                            State <= RIGHT_PASSWORD;
                        else
                            State <= WRONG_PASSWORD;
                        end if;
                    end if;
                when WRONG_PASSWORD =>
                    HEX_1 <= "0000110"; -- E 
                    HEX_2 <= "0000110"; -- E
                    if front_sensor = '0' and back_sensor = '0' then
                        State <= IDLE;
                        HEX_1 <= "1111111"; -- off
                        HEX_2 <= "1111111"; -- off
                    end if;
                when RIGHT_PASSWORD =>
                    HEX_1 <= "0000010"; -- 6
                    HEX_2 <= "1000000"; -- 0
                    if front_sensor = '1' and back_sensor = '1' then
                        State <= STOP;
                    end if;
                when STOP =>
                    HEX_1 <= "0100100"; -- S
                    HEX_2 <= "0001100"; -- P
                    if front_sensor = '0' and back_sensor = '0' then
                        State <= IDLE;
                        HEX_1 <= "1111111"; -- off
                        HEX_2 <= "1111111"; -- off
                    end if;
            end case;
        end if;
    end process;

    RED_LED <= '1' when State = WAIT_PASSWORD else
           blink_on when State = WRONG_PASSWORD or State = STOP else
           '0';

    GREEN_LED <= blink_on when State = RIGHT_PASSWORD else '0';
end architecture;
