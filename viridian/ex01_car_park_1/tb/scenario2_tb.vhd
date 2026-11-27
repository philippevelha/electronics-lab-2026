library ieee;
use ieee.std_logic_1164.all;


entity CPS_tb is
end CPS_tb;

architecture first of CPS_tb is

    constant clk_hz     : integer := 100;
    constant clk_period : time    := 1000 ms / clk_hz;

    signal clk          : std_logic := '0';
    signal reset_n      : std_logic := '1';
    signal front_sensor : std_logic := '0';
    signal back_sensor  : std_logic := '0';
    signal password_1   : std_logic_vector(1 downto 0) := "00";
    signal password_2   : std_logic_vector(1 downto 0) := "00";
    signal GREEN_LED    : std_logic;
    signal RED_LED      : std_logic;
    signal HEX_1        : std_logic_vector(6 downto 0);
    signal HEX_2        : std_logic_vector(6 downto 0);

begin

    DUT: entity work.Car_Parking_System_VHDL
    port map(
        clk          => clk,
        reset_n      => reset_n,
        front_sensor => front_sensor,
        back_sensor  => back_sensor,
        password_1   => password_1,
        password_2   => password_2,
        GREEN_LED    => GREEN_LED,
        RED_LED      => RED_LED,
        HEX_1        => HEX_1,
        HEX_2        => HEX_2
    );

    clk <= not clk after clk_period / 2;

    SEQUENCER_PROC : process is
    begin

        --reset the state to IDLE. Put counter to 0. leds are off
        reset_n <= '0';
        wait for 2 * clk_period;
        reset_n <= '1';
        wait until falling_edge(clk);

        -- 
        password_1   <= "00";
        password_2   <= "00";
        front_sensor <= '1';


        std.env.finish;
    end process;

end architecture;