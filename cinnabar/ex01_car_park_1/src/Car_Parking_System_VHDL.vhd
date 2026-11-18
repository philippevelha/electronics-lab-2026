USE -

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

architecture Behavioral of Car_Parking_System_VHDL is

    -- all FSM states
    type state_type is (
        IDLE,
        WAIT_PASSWORD,
        WRONG_PASS,
        RIGHT_PASS,
        STOP
    );

    signal current_state : state_type := IDLE;

    signal counter : integer range 0 to 9 := 0; -- Counts 10 clock cycles

    
    signal blink : std_logic := '0'; -- Controls LED blinking

    
    signal stop_lock : std_logic := '0';-- Prevents STOP from immediately triggering again after 2nd car authorization
    
--clock 
begin

    process(clk, reset_n)
    begin

        if reset_n = '0' then

            current_state <= IDLE;
            counter <= 0;
            blink <= '0';
            stop_lock <= '0';

        elsif rising_edge(clk) then

            
            blink <= not blink; --every clock cycle->blink signal

            case current_state is

                when IDLE =>
              
              
              
              
              
              
              ;

                when WAIT_PASSWORD =>

                     ;

                when WRONG_PASS =>

                     
                  
                  ;

                when RIGHT_PASS =>

                    counter <= 0;

                     ;

                when STOP =>

                    counter <= 0;

                    ;

            end case;

        end if;

    end process;


  --LEDS

    process(current_state, blink)
    begin

        
        GREEN_LED <= '0'; -- Default output 1 (off)
        RED_LED <= '0';   -- default output 2 (off)

        HEX_1 <= "1111111"; -- all segments off 
        HEX_2 <= "1111111";

        case current_state is

            when IDLE =>

                
                GREEN_LED <= '0'; --off
                RED_LED <= '0';   --off

            when WAIT_PASSWORD =>

                
                RED_LED <= '1';  -- on, steady

                HEX_1 <= "0000110"; -- E
                HEX_2 <= "0101011"; -- n

            when WRONG_PASS =>

                RED_LED <= blink; -- on, blinking 

                HEX_1 <= "0000110"; -- E
                HEX_2 <= "0000110"; -- E

            when RIGHT_PASS =>

                GREEN_LED <= blink; -- on, blinking

                HEX_1 <= "0000010"; -- G
                HEX_2 <= "1000000"; -- O

            when STOP =>

                RED_LED <= blink; -- on, blinking

                HEX_1 <= "0100100"; -- S
                HEX_2 <= "0001100"; -- P

        end case;

    end process;

end Behavioral;


