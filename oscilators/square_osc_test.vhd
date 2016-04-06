--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:47:34 04/06/2016
-- Design Name:   
-- Module Name:   C:/Users/Kenzo/Dropbox/SynthLaunchpad/MIDI-FPGA/Codigo/oscilators/square_osc_test.vhd
-- Project Name:  oscilators
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: square_osc
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
 
entity square_osc_test is
end square_osc_test;
 
architecture behavior of square_osc_test is 
   
  -- Component Declaration for the Unit Under Test (UUT)
 
  component square_osc
    port(
      clk      : in  std_logic;
      reset    : in  std_logic;
      tick     : in  std_logic;
      data_out : out  std_logic_vector(7 downto 0)
    );
  end component;
    

  --Inputs
  signal clk : std_logic := '0';
  signal reset : std_logic;
  signal tick : std_logic;

 	--Outputs
  signal data_out : std_logic_vector(7 downto 0);

  -- Clock period definitions
  constant clk_period : time := 10 ns;
 
begin
 
  -- Instantiate the Unit Under Test (UUT)
  uut: square_osc 
  port map(
    clk      => clk,
    reset    => reset,
    tick     => tick,
    data_out => data_out
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
    tick  <= '0';
    wait for clk_period*10;
    reset <= '0';
    tick  <= '1';
    -- insert stimulus here 
    wait for clk_period*100;
    wait;
  end process;

end;
