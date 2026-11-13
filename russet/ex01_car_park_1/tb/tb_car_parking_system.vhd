
-- Self-checking testbench for Car_Parking_System_VHDL

--   Scenario 1: normal entry
--   Scenario 2: wrong password, then correct password
--   Scenario 3: multiple cars (-> STOP state)
--   Scenario 4: asynchronous reset from every state

-- Conventions
--  - Stimulus is applied 1 ns after a rising clock edge, checks are done 1 ns after a rising clock edge, so there are no races with the DUT.
--  - "E1" is the clock edge on which front_sensor = '1' is sampled in IDLE. WAIT_PASSWORD then lasts 10 edges (E2..E11); the decision is taken on E11, so the new state is visible right after E11.
--  - Passwords are cleared once they have been used (keypad released).
--  - front_sensor is released once the car has passed it.

library ieee;
  use ieee.std_logic_1164.all;

entity tb_car_parking_system is
end entity;

architecture sim of tb_car_parking_system is

  -- INPUTS
  signal clk          : std_logic                    := '0';  --initial values
  signal reset_n      : std_logic                    := '0';  -- asynchronous, active low
  signal front_sensor : std_logic                    := '0';  --initial values
  signal back_sensor  : std_logic                    := '0';  --initial values
  signal password_1   : std_logic_vector(1 downto 0) := "00"; --initial values
  signal password_2   : std_logic_vector(1 downto 0) := "00"; --initial values

  -- OUTPUTS
  signal GREEN_LED : std_logic;
  signal RED_LED   : std_logic;
  signal HEX_1     : std_logic_vector(6 downto 0); --
  signal HEX_2     : std_logic_vector(6 downto 0); --

  signal done       : boolean := false;

  constant PASS_1 : std_logic_vector(1 downto 0) := "01";
  constant PASS_2 : std_logic_vector(1 downto 0) := "10";

  constant SEG_E   : std_logic_vector(6 downto 0) := "0000110";
  constant SEG_N   : std_logic_vector(6 downto 0) := "0101011";
  constant SEG_G   : std_logic_vector(6 downto 0) := "0000010";
  constant SEG_O   : std_logic_vector(6 downto 0) := "1000000";
  constant SEG_S   : std_logic_vector(6 downto 0) := "0100100";
  constant SEG_P   : std_logic_vector(6 downto 0) := "0001100";
  constant SEG_OFF : std_logic_vector(6 downto 0) := "1111111";

begin
  -- 100 MHz clock, stops when the test is finished so the simulation ends
  clk <= not clk after 5 ns when not done; 
  -- DUT
  dut: entity work.Car_Parking_System_VHDL(rtl)
    port map (
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
  -- stimulus
  stim: process
    variable errors : natural := 0;

    procedure check(cond : boolean; msg : string) is
    begin
      if not cond then
        report msg severity error;
        errors := errors + 1;
      end if;
    end procedure;
    
    -- wait n rising edges, then 1 ns
    procedure cycles(n : natural) is
    begin
      for i in 1 to n loop
        wait until rising_edge(clk);
      end loop;
      wait for 1 ns;
    end procedure;
    
    -- blinking at clock frequency
    -- takes 4 clock cycles
    procedure check_blink(signal led : in std_logic; msg : string) is
      variable prev : std_logic;
    begin
      for i in 1 to 4 loop
        prev := led;
        wait until rising_edge(clk);
        wait for 1 ns;
        check(led /= prev, msg);
      end loop;
    end procedure;

    -- expected output per state
    procedure expect_idle(ctx : string) is
    begin
      check(RED_LED = '0',   ctx & ": IDLE: red LED should be off");
      check(GREEN_LED = '0', ctx & ": IDLE: green LED should be off");
      check(HEX_1 = SEG_OFF and HEX_2 = SEG_OFF,
            ctx & ": IDLE: displays should be off");
    end procedure;

    procedure expect_wait(ctx : string) is
    begin
      check(RED_LED = '1',   ctx & ": WAIT_PASSWORD: red LED should be steady on");
      check(GREEN_LED = '0', ctx & ": WAIT_PASSWORD: green LED should be off");
      check(HEX_1 = SEG_E and HEX_2 = SEG_N,
            ctx & ": WAIT_PASSWORD: displays should show En");
    end procedure;

        procedure expect_wrong(ctx : string) is
    begin
      check(GREEN_LED = '0', ctx & ": WRONG_PASSWORD: green LED should be off");
      check(HEX_1 = SEG_E and HEX_2 = SEG_E,
            ctx & ": WRONG_PASSWORD: displays should show EE");
      check_blink(RED_LED, ctx & ": WRONG_PASSWORD: red LED should blink");
    end procedure;

    procedure expect_right(ctx : string) is
    begin
      check(RED_LED = '0',   ctx & ": RIGHT_PASSWORD: red LED should be off");
      check(HEX_1 = SEG_G and HEX_2 = SEG_O,
            ctx & ": RIGHT_PASSWORD: displays should show GO");
      check_blink(GREEN_LED, ctx & ": RIGHT_PASSWORD: green LED should blink");
    end procedure;

    procedure expect_stop(ctx : string) is
    begin
      check(GREEN_LED = '0', ctx & ": STOP: green LED should be off");
      check(HEX_1 = SEG_S and HEX_2 = SEG_P,
            ctx & ": STOP: displays should show SP");
      check_blink(RED_LED, ctx & ": STOP: red LED should blink");
    end procedure;

    -- helpers
    procedure correct_password is
    begin
      password_1 <= PASS_1;
      password_2 <= PASS_2;
    end procedure;

    procedure clear_password is
    begin
      password_1 <= "00";
      password_2 <= "00";
    end procedure;

    -- synchronous-looking reset: all inputs cleared, reset held for 2 edges
    procedure do_reset(ctx : string) is
    begin
      front_sensor <= '0';
      back_sensor  <= '0';
      clear_password;
      reset_n <= '0';
      cycles(2);
      expect_idle(ctx & " (in reset)");
      reset_n <= '1';
      cycles(2);
      expect_idle(ctx & " (after reset release)");
    end procedure;

    -- reset asserted between two clock edges: the outputs must go to IDLE
    -- without waiting for a clock edge
    procedure async_reset(ctx : string) is
    begin
      reset_n <= '0';
      wait for 2 ns;                        -- still before the next edge
      expect_idle(ctx & " (asynchronous, before next clock edge)");
      cycles(1);
      expect_idle(ctx & " (reset still asserted)");
      front_sensor <= '0';
      back_sensor  <= '0';
      clear_password;
      reset_n <= '1';
      cycles(2);
      expect_idle(ctx & " (after reset release)");
    end procedure;

  begin
    -- Scenario 1
    report "Scenario 1: normal entry";
    do_reset("S1");

    correct_password;                       -- stable during the whole wait
    front_sensor <= '1';
    cycles(1);                              -- E1: IDLE -> WAIT_PASSWORD
    expect_wait("S1 car detected");
    cycles(9);                              -- E10: still in WAIT_PASSWORD
    expect_wait("S1 10th wait cycle");
    cycles(1);                              -- E11: password checked
    expect_right("S1 correct password");

    clear_password;
    front_sensor <= '0';                    -- car has passed the front sensor
    cycles(2);
    expect_right("S1 car between sensors");

    back_sensor <= '1';                     -- car reaches the back sensor
    cycles(1);
    expect_idle("S1 back sensor");
    back_sensor <= '0';
    cycles(2);
    expect_idle("S1 end");

  end process;

end architecture;
