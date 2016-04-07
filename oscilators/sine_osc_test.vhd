--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:42:45 04/07/2016
-- Design Name:   
-- Module Name:   C:/Users/Kenzo/Desktop/Synthpad/oscilators/sine_osc_test.vhd
-- Project Name:  oscilators
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sine_osc
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
use ieee.numeric_std.all;
 
entity sine_osc_test is
end sine_osc_test;
 
architecture behavior of sine_osc_test is 
 
  -- Component Declaration for the Unit Under Test (UUT)
 
  component sine_osc
  port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    tick      : in  std_logic;
    wave_out : out  std_logic_vector(9 downto 0)
  );
  end component;
    
  --Inputs
  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal tick   : std_logic := '0';

 	--Outputs
  signal wave_out : std_logic_vector(9 downto 0);

  -- Clock period definitions
  constant clk_period : time := 10 ns;
 
begin
 
  -- Instantiate the Unit Under Test (UUT)
  uut: sine_osc 
  port map(
    clk      => clk,
    reset    => reset,
    tick      => tick,
    wave_out => wave_out
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
    tick  <= '1';
    reset <= '0';
    -- insert stimulus here 

    wait;
  end process;

end;
