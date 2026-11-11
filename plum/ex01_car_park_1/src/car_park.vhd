library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Car_Parking_System_VHDL is 

    port ( 
        clk : in std_logic; 
        reset_n : in std_logic;   -- active low, asynchronou
        front_sensor: in std_logic; 
        back_sensor : in std_logic; 
        password_1 : in std_logic_vector(1 downto 0); 
        password_2 : in std_logic_vector(1 downto 0); 
        GREEN_LED : out std_logic; 
        RED_LED : out std_logic; 
        HEX_1 : out std_logic_vector(6 downto 0);-- segments gfedcba 
        HEX_2 : out std_logic_vector(6 downto 0); 

    );
end Car_Parking_System_VHDL;

architecture CPS of Car_Parking_System_VHDL is
    type t_State is (
        IDLE,
        WAIT_PASS,
        WRONG_PASS,
        RIGHT_PASS,
        STOP
    );

    signal current_state : t_State;
    signal next_state : t_State;

    signal Counter : integer range
        0 to 10;
    
    signal  red_temp : std_logic;
    signal  green_temp : std_logic;

begin 
    clock   : process(reset_n,next_state)
    begin
        if  reset_n = '1' then
            current_state  <= Idle;

            GREEN_LED <= '0';
            RED_LED <= '0';
            HEX_1 <='1111111';
            HEX_2 <='1111111';

        else
            current_state <= next_state;
        end if;
    end process clock;

    ---------FSM STATE------------
    FSM : process (current_state,front_sensor,back_sensor,clk)
    begin
        next <= state ;
            GREEN_LED <= '0';
            RED_LED <= '0';
            HEX_1 <='1111111';
            HEX_2 <='1111111';

        ---default output
            case State is
            when IDLE =>
                if front_sensor = '1';
                next_state  <= wait_pass;
            end if;

            if front_sensor = '0'


 IDLE,
        WAIT_PASS,
        WRONG_PASS,
        RIGHT_PASS,
        STOP