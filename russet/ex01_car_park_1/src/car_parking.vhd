-- Car Parking System - FSM

-- States : IDLE, WAIT_PASSWORD, WRONG_PASSWORD, RIGHT_PASSWORD, STOP

-- Transitions
--   IDLE           -> WAIT_PASSWORD  front_sensor = '1'
--   WAIT_PASSWORD  -> RIGHT_PASSWORD after 10 clock cycles, password correct
--                  -> WRONG_PASSWORD after 10 clock cycles, password wrong
--   WRONG_PASSWORD -> RIGHT_PASSWORD password correct
--   RIGHT_PASSWORD -> STOP           front_sensor = '1' and back_sensor = '1'
--                  -> IDLE           back_sensor = '1' (front_sensor = '0')
--   STOP           -> RIGHT_PASSWORD password correct (second car)

-- Outputs depend on the state only:
--   IDLE            LEDs off,          displays off
--   WAIT_PASSWORD   red steady,        "En"
--   WRONG_PASSWORD  red blinking,      "EE"
--   RIGHT_PASSWORD  green blinking,    "GO"
--   STOP            red blinking,      "SP"

-- Assumptions:
--   - the 10-cycle wait runs to completion even if front_sensor drops
--   - password inputs are stable while they are being checked
--   - the sensors reflect the real car positions: front_sensor is released once the car has passed it
--   - blinking is at clock frequency: the blink signal toggles every cycle

library ieee;
    use ieee.std_logic_1164.all;

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
    signal State : state_type := IDLE;
    signal blink_on : std_logic := '0';
    signal wait_count : natural range 0 to 9 := 0;
    signal password_ok : boolean;

    -- correct password
    constant CORRECT_1 : std_logic_vector(1 downto 0) := "01";
    constant CORRECT_2 : std_logic_vector(1 downto 0) := "10";

    -- 7-segment codes (gfedcba)
    constant SEG_E   : std_logic_vector(6 downto 0) := "0000110"; -- E
    constant SEG_N   : std_logic_vector(6 downto 0) := "0101011"; -- n
    constant SEG_G   : std_logic_vector(6 downto 0) := "0000010"; -- G
    constant SEG_O   : std_logic_vector(6 downto 0) := "1000000"; -- O
    constant SEG_S   : std_logic_vector(6 downto 0) := "0100100"; -- S
    constant SEG_P   : std_logic_vector(6 downto 0) := "0001100"; -- P
    constant SEG_OFF : std_logic_vector(6 downto 0) := "1111111"; -- all off

begin

    password_ok <= (password_1 = CORRECT_1) and (password_2 = CORRECT_2);

    -- state register, wait counter, blink generator
    fsm : process(clk, reset_n) is
    begin
        if reset_n = '0' then
            State <= IDLE;
            blink_on <= '0';
            wait_count <= 0;
        elsif rising_edge(clk) then
            blink_on <= not blink_on;
                    
            case State is
                when IDLE =>
                    wait_count <= 0;
                    if front_sensor = '1' then
                        State <= WAIT_PASSWORD;
                    end if;

                when WAIT_PASSWORD =>
                    if wait_count < 9 then
                        wait_count <= wait_count + 1;
                    else
                        wait_count <= 0;
                        if password_ok then
                            State <= RIGHT_PASSWORD;
                        else
                            State <= WRONG_PASSWORD;
                        end if;
                    end if;

                when WRONG_PASSWORD | STOP=>
                    if password_ok then
                        State <= RIGHT_PASSWORD;
                    end if;
                    
                when RIGHT_PASSWORD =>
                    if front_sensor = '1' and back_sensor = '1' then
                        State <= STOP;
                    elsif back_sensor = '1' then
                        State <= IDLE;
                    end if;
            end case;
        end if;
    end process fsm;

-- outputs (depend on the state only)
    with State select
        HEX_1 <= SEG_E   when WAIT_PASSWORD | WRONG_PASSWORD,
                 SEG_G   when RIGHT_PASSWORD,
                 SEG_S   when STOP,
                 SEG_OFF when IDLE;

    with State select
        HEX_2 <= SEG_N   when WAIT_PASSWORD,
                 SEG_E   when WRONG_PASSWORD,
                 SEG_O   when RIGHT_PASSWORD,
                 SEG_P   when STOP,
                 SEG_OFF when IDLE;

    RED_LED <= '1'      when State = WAIT_PASSWORD else
               blink_on when State = WRONG_PASSWORD or State = STOP else
               '0';

    GREEN_LED <= blink_on when State = RIGHT_PASSWORD else '0';

end architecture rtl;
