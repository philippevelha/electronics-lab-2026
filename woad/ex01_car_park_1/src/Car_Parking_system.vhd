library ieee;
use ieee.std_logic_1164.all;

entity Car_Parking_System_VHDL is
    port(
        clk : in std_logic;
        reset_n : in std_logic := '1'; -- active low, asynchronous
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

architecture FSM of Car_Parking_System_VHDL is 
  -- "open" is a VHDL reserved word, hence the S_ prefix
  type state_t is (S_IDLE, S_WAIT_PASS, S_WRONG_PASS, S_RIGHT_PASS, S_STOP);
  signal state, next_state : state_t;
  signal counter : integer range 0 to 10 := 0;
  signal tmr : std_logic := '0';
  signal RED_BLK : std_logic := '0';
  signal GREEN_BLK : std_logic := '0';

begin

  -- state register
  reg : process (reset_n, next_state)
  begin
    if reset_n = '0' then
      state <= S_IDLE; -- reset to the initial state
    else
      state <= next_state;
    end if;
  end process reg;

  blink : process (clk, RED_BLK, GREEN_BLK)
  begin 
    if RED_BLK = '1' then 
        RED_LED <= clk;
    end if;
    if GREEN_BLK = '1' then
        GREEN_LED <= clk;
    end if;
  end process blink;


  -- clock process
timer : process(clk, reset_n)
    begin
        if reset_n = '0' then
            counter <= 0;

        elsif rising_edge(clk) then
            if state /= next_state then
                counter <= 0;

            elsif tmr = '1' then
                if counter < 10 then
                    counter <= counter + 1;
                end if;

            else
                counter <= 0;
            end if;
        end if;
end process timer;

  -- next-state and output logic (outputs default to 0, as on the diagram)
  FSM : process(state, reset_n, front_sensor, back_sensor, password_1, password_2, counter) --- add the relevant signal to the sensitivity list

  begin
        RED_LED <= '0';
        GREEN_LED <= '0';
        RED_BLK <= '0';
        GREEN_BLK <= '0';
        HEX_1 <= "1111111";
        HEX_2 <= "1111111";
        tmr <= '0';

        next_state <= state;

        case state is
        when S_IDLE => 
            if front_sensor = '1' then
                next_state <= S_WAIT_PASS;
            else
                next_state <= S_IDLE;
            end if;
        when S_WAIT_PASS =>
            tmr <= '1';
            RED_LED <= '1';
            HEX_1 <= "0000110";
            HEX_2 <= "0101011";
            if reset_n = '0' then next_state <= S_IDLE;
            elsif counter = 10 and (password_1 = "10" and password_2 = "01") then
                next_state <= S_RIGHT_PASS;
            elsif counter = 10 and not (password_1 = "10" and password_2 = "01") then 
                next_state <= S_WRONG_PASS;
            elsif front_sensor = '1' and counter < 10 then
                next_state <= S_WAIT_PASS;
            end if;
        when S_WRONG_PASS =>
            tmr <= '1';
            RED_BLK <= '1';
            HEX_1 <= "0000110";
            HEX_2 <= "0000110";
            if reset_n = '0' then next_state <= S_IDLE;
            elsif counter > 5 then
                next_state <= S_WAIT_PASS;
            else 
                next_state <= S_WRONG_PASS;
            end if;
        when S_RIGHT_PASS =>
            tmr <= '1';
            GREEN_BLK <= '1';
            HEX_1 <= "0000010";
            HEX_2 <= "1000000";
            if reset_n = '0' then next_state <= S_IDLE;
            elsif front_sensor = '0' and back_sensor = '0' and counter > 5 then 
                next_state <= S_IDLE;
            elsif front_sensor = '1' and back_sensor = '1' and counter < 5 then
                next_state <= S_STOP;
            else
                next_state <= S_RIGHT_PASS;
            end if;
        when S_STOP =>
            RED_BLK <= '1';
            HEX_1 <= "0100100";
            HEX_2 <= "0001100";
            if reset_n = '0' then next_state <= S_IDLE;
            --the car is behind so we stop it and make it enter the password again
            elsif back_sensor = '0' then
                next_state <= S_WAIT_PASS;
            else
                next_state <= S_STOP;
            end if;        
        end case;
  end process FSM;
end;