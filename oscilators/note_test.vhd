--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:13:50 04/05/2016
-- Design Name:   
-- Module Name:   C:/Users/K n z o/Dropbox/SynthLaunchpad/MIDI-FPGA/Codigo/oscilators/note_test.vhd
-- Project Name:  oscilators
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity note_test is
end note_test;
 
architecture behavior of note_test is 
 
  -- Component Declaration for the Unit Under Test (UUT)
 
  component note_generator
    port(
      clk       : in  std_logic;
      reset     : in  std_logic;
      sw        : in  std_logic;
      note_tick : out  std_logic
    );
  end component;
    

   --Inputs
   signal clk   : std_logic := '0';
   signal reset : std_logic := '0';
   signal sw    : std_logic := '0';

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
    sw        => sw,
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
    -- hold reset state for 100 ns.
    wait for 100 ns;	
    reset <= '1';
    wait for clk_period*10;
    reset <= '0';
    -- insert stimulus here 

    wait;
  end process;

end;
