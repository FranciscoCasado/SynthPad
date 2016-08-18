--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:44:50 08/17/2016
-- Design Name:   
-- Module Name:   C:/Users/K n z o/Desktop/SynthPad/synth_integration/vibrato_test.vhd
-- Project Name:  synth_integration
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: note_generator
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity vibrato_test is
end vibrato_test;
 
architecture behavior of vibrato_test is 
 
  -- Component Declaration for the Unit Under Test (UUT)
 
  component note_generator
  port(
    clk       : in  std_logic;
    reset     : in  std_logic;
    note_sel  : in  std_logic_vector(6 downto 0);
    note_tick : out std_logic
  );
  end component;
    
  --Inputs
  signal clk      : std_logic := '0';
  signal reset    : std_logic := '0';
  signal note_sel : std_logic_vector(6 downto 0) := "1111110";

  --Outputs
  signal note_tick : std_logic;

  -- Clock period definitions
  constant clk_period : time := 20 ns;
 
begin
 
  -- Instantiate the Unit Under Test (UUT)
  uut: note_generator 
  port map(
    clk       => clk,
    reset     => reset,
    note_sel  => note_sel,
    note_tick => note_tick
  );

  -- Clock process definitions
  clk_process :process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
 
  -- Stimulus process
  stim_proc: process
  begin		
  reset <= '1';
  -- hold reset state for 100 ns.
  wait for 100 ns;	
  reset <= '0';

  wait for clk_period*10;

    -- insert stimulus here 

    wait;
  end process;

end;
