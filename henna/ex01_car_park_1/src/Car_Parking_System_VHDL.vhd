-------------------------------------------------------------------------------
-- Car Parking System FSM
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Car_Parking_System_VHDL is
    port(
        clk             : in std_logic;
        reset_n         : in std_logic;     -- active low (0 is active, asynchronous)
        front_sensor    : in std_logic;     -- 1 = car at the gate
        back_sensor     : in std_logic;     -- 1 = car passed the gate 
        password_1      : in std_logic_vector(1 downto 0);
        password_2      : in std_logic_vector(1 downto 0);
        GREEN_LED       : out std_logic;
        RED_LED         : out std_logic;
        HEX_1           : out std_logic_vector(6 downto 0); -- segments gfedcba
        HEX_2           : out std_logic_vector(6 downto 0)
    );
end Car_Parking_System_VHDL;

architecture rtl of Car_Parking_System_VHDL is

    type state_t is (IDLE, WAIT_PASSWORD, WRONG_PASS, RIGHT_PASS, STOP);

    signal current_state, next_state : state_t;

    signal counter : unsigned(3 downto 0); --clock cycles counter 

    signal blink : std_logic;

    constant CORRECT_PASS_1 : std_logic_vector (1 downto 0) := "01";  --correct password: 0110
    constant CORRECT_PASS_2 : std_logic_vector (1 downto 0) := "10";

begin

    -- 2 processes: one clocked (memory: state, counter, blink), one combinational (next state + outputs)

    reg : process (clk, reset_n) --behavior with clock cycles, "memory" of current state, counter, blink
    begin
        if reset_n = '0' then     --if reset is active sets state to IDLE, and resets counter and blink. 
        current_state <= IDLE;
        counter       <= (others => '0');
        blink         <= '0';

    elsif rising_edge(clk) then
      current_state <= next_state;    --at rising clock edge changes to the next state (from FSM)

      if next_state = WAIT_PASSWORD then    -- check next state because like this the first cycle is 1, second cycle is 2, ...
        if counter < 10 then                -- otherwise it would be 0 at the first cycle and so on so WAIT_PASSWORD would last 11 cycles
          counter <= counter + 1;
        end if;

      else
        counter <= (others => '0');
      end if;

      blink <= not blink;  --opposite of last value of blink so it alternates.
    end if;
  end process reg;

  FSM : process (current_state, front_sensor, back_sensor, password_1, password_2, counter, blink) --when any of these signals changes the process starts.
  -- FSM gives next state and outputs (only based on the current state -> Moore machine)
  begin
    next_state <= current_state;

    GREEN_LED <= '0';           --defined "default" values to not repeat them in every state.
    RED_LED   <= '0';           --if some outputs are not changed in a state they will just be these defaults.
    HEX_1     <= "1111111";
    HEX_2     <= "1111111";

    case current_state is               -- all possible states and outputs

      when IDLE =>                      --if no car is at the gate the system is in IDLE.
        if front_sensor = '1' then      --if someone approaches the gate they have to insert the password so the system has to be in WAIT_PASSWORD.
          next_state <= WAIT_PASSWORD;
        end if;

      when WAIT_PASSWORD =>     -- a car just approached the gate and was detected by the front sensor. The system is waiting for the password.
        RED_LED <= '1';         --red led steady
        HEX_1   <= "0000110";   -- E
        HEX_2   <= "0101011";   -- n

        if counter = 10 then      --waiting on the password input until the counter reaches 10 cycles, then it depends it the password was right or wrong.
          if password_1 = CORRECT_PASS_1 and password_2 = CORRECT_PASS_2 then
            next_state <= RIGHT_PASS;
          else
            next_state <= WRONG_PASS;
          end if;
        end if;

      when WRONG_PASS =>        --Wait is over and the password is wrong
        RED_LED <= blink;
        HEX_1   <= "0000110";   -- E
        HEX_2   <= "0000110";   -- E

        if password_1 = CORRECT_PASS_1 and password_2 = CORRECT_PASS_2 then  --after a wrong password was inserted the only way out
          next_state <= RIGHT_PASS;                                          --is to insert the correct password
        end if;                                                              

      when RIGHT_PASS =>  --Wait is over and the password is right
        GREEN_LED <= blink;
        HEX_1     <= "0000010"; -- G
        HEX_2     <= "1000000"; -- O

        if front_sensor = '1' and back_sensor = '1' then    --if a second car approaches the gate while the first is still passing
          next_state <= STOP;         
        elsif back_sensor = '1' then --if no other car is approaching then it can return to idle.
          next_state <= IDLE;
        end if;                       --PDF says that both front_sensor and back_sensor must be on to get to STOP
                                      --but so if the front sensor sees a new car and the first one still didn't pass (back_sensor off) it wouldn't go into STOP.
      when STOP =>
        RED_LED <= blink;
        HEX_1   <= "0100100"; -- S [the task said it is drawn like a 5]
        HEX_2   <= "0001100"; -- P

        if back_sensor = '0' then   --back sensor sees car 1 passing so the gate is now free
          next_state <= WAIT_PASSWORD;
        end if;

    end case;
  end process FSM;

end architecture rtl;



