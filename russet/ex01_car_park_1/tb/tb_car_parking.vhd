library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Car_Parking_System_VHDL is
end Car_Parking_System_VHDL;

architecture sim of Car_Parking_System_VHDL is

    constant clk_hz : integer := 10; --! Clock at 10Hz
    constant clk_period : time := 1000 ms / clk_hz; --! Clock period

    signal clk          : std_logic := '1'; -- create the signal for the clock, initial value is 1
    signal rst          : std_logic := '1'; -- create the signal for the reset, initial value is 1 meaning system is in reset
    signal NorthRed     : std_logic;
    signal NorthYellow  : std_logic;
    signal NorthGreen   : std_logic;
    signal WestRed      : std_logic;
    signal WestYellow   : std_logic;
    signal WestGreen    : std_logic;