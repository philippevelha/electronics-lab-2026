library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Car_Parking_System_VHDL is 
    port(
        clk : in std_logic;
        reset_n : in std_logic;
        front_sensor : in std_logic;
        back_sensor : in std_logic;
        password_1 : in std_logic_vector(1 downto 0);
        password_2 : in std_logic_vector(1 downto 0);
        GREEN_LED : out std_logic;
        RED_LED : out std_logic;
        HEX_1 : out std_logic_vector(6 downto 0);
        HEX_2 : out std_logic_vector(6 downto 0)
    );
end Car_Parking_System_VHDL;

architecture rtl of Car_Parking_System_VHDL is
    type FSM_States is (IDLE, WAIT_PASSWORD, WRONG_PASS, RIGHT_PASS, STOP);
    signal current_state, next_state : FSM_States;
    signal counter_wait : integer range 0 to 10;
    signal red_tmp, green_tmp : std_logic := '0';
begin
    clkandreset : process (clk,reset_n)
    begin
        if reset_n = '0' then
            current_state <= IDLE; -- reset to the initial state
            counter_wait <= 0;
        elsif rising_edge(clk) then
            current_state <= next_state;
            
            if current_state /= next_state then
                counter_wait <= 0;
            elsif counter_wait < 10 then
                counter_wait <= counter_wait + 1;
            end if;
        end if;
    end process clkandreset;

    state_logic : process (current_state, front_sensor, password_1, password_2, back_sensor, counter_wait)
    begin
        next_state <= current_state;
        -- default outputs
        GREEN_LED <= '0';
        RED_LED <= '0';
        HEX_1 <= (others => '1');
        HEX_2 <= (others => '1');

        case current_state is
        when IDLE =>
            if front_sensor = '1' then
                next_state <= WAIT_PASSWORD;
            end if;
        when WAIT_PASSWORD =>
            RED_LED <= '1';
            HEX_1 <= "0000110"; -- E
            HEX_2 <= "0101011"; -- n

            if counter_wait >= 10 then
                if password_1 = "01" and password_2 = "10" then
                    next_state <= RIGHT_PASS;
                else
                    next_state <= WRONG_PASS;
                end if;
            end if;
        when WRONG_PASS =>
            RED_LED <= red_tmp;
            HEX_1 <= "0000110"; -- E
            HEX_2 <= "0000110"; -- E

            if counter_wait >= 10 then
                next_state <= WAIT_PASSWORD;
            end if;
        when RIGHT_PASS => 
            GREEN_LED <= green_tmp;
            HEX_1 <= "0000010"; -- G
            HEX_2 <= "1000000"; -- O

            if front_sensor = '1' and back_sensor = '1' then
                next_state <= STOP;
            end if;
        when STOP => 
            RED_LED <= red_tmp;
            HEX_1 <= "0100100"; -- S
            HEX_2 <= "0001100"; -- P

            if back_sensor = '0' then
                next_state <= IDLE;
            end if;
        end case;

        -- if suddenly the car in front leaves, then return to idle state
        if front_sensor = '0' and current_state /= STOP then
            next_state <= IDLE;
        end if;

    end process state_logic;

    blink : process (clk, reset_n)
    begin
        if reset_n = '0' then
            red_tmp   <= '0';
            green_tmp <= '0';
        elsif rising_edge(clk) then
            if current_state = WRONG_PASS or current_state = STOP then        -- event trigger
                red_tmp <= not red_tmp;
            end if;
            if current_state = RIGHT_PASS then
                green_tmp <= not green_tmp;
            end if;
        end if;
    end process blink;
end architecture rtl;