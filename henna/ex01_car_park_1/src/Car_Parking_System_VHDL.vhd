-------------------------------------------------------------------------------
-- Car Parking System FSM
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Car_Parking_System_VHDL is
    port(
        clk             : in std_logic;
        reset_n         : in std_logic;
        front_sensor    : in std_logic;
        back_sensor     : in std_logic;
        password_1      : in std_logic_vector(1 downto 0);
        password_2      : in std_logic_vector(1 downto 0);
        GREEN_LED       : out std_logic;
        RED_LED         : out std_logic;
        HEX_1           : out std_logic_vector(6 downto 0);
        HEX_2           : out std_logic_vector(6 downto 0)
    );
end Car_Parking_System_VHDL;

architecture rtl of Car_Parking_System_VHDL is

  type state_type is (IDLE, WAIT_PASSWORD, WRONG_PASS, RIGHT_PASS, STOP);
  signal next_state, current_state : state_type;
  --signal counter : integer range 0 to clock_frequency + 60;     -- 1 min counter 

begin

    -- working on the clock process (needs to be completed)
    clock_process : process(clk, reset_n, current_state, front_sensor, back_sensor, password_1, password_2) is
    begin
        if rising_edge(clk) then
            if reset_n = '1' then
            current_state <= IDLE;
            wait_counter <= 0;
            else
                wait_counter <= wait_counter + 1;
            end if;
        end if;

        next_state <= current_state;
        case current_state is
            when IDLE =>
                if front_sensor = '0' then
                    next_state <= IDLE;
                elsif front_sensor = '1' and wait_counter < 10 then
                    next_state <= WAIT_PASSWORD;
                end if;
    end process clock_process;


end rtl;



