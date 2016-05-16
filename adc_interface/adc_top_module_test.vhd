--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:21:29 05/16/2016
-- Design Name:   
-- Module Name:   C:/Users/K n z o/Dropbox/SynthPad/adc_interface/adc_top_module_test.vhd
-- Project Name:  adc_interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adc_top_module
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
 
entity adc_top_module_test is
end adc_top_module_test;
 
architecture behavior of adc_top_module_test is 
 
  -- Component Declaration for the Unit Under Test (UUT)
  component  adc_top_module
    port(
      clk      : in  std_logic;
      reset    : in  std_logic;
      spi_miso : in  std_logic;
      spi_mosi : out std_logic;
      spi_sck  : out std_logic;
      spi_cs   : out std_logic;
      data_out : out std_logic_vector(9 downto 0)
    );
  end component;
    
  --Inputs
  signal clk      : std_logic := '0';
  signal reset    : std_logic := '0';
  signal spi_miso : std_logic := '0';

  --Outputs
  signal spi_mosi : std_logic;
  signal spi_sck  : std_logic;
  signal spi_cs   : std_logic;
  signal data_out : std_logic_vector(9 downto 0);

  -- Clock period definitions
  constant clk_period : time := 20 ns;
 
begin
 
  -- Instantiate the Unit Under Test (UUT)
  uut: adc_top_module 
  port map(
          clk => clk,
          reset => reset,
          spi_miso => spi_miso,
          spi_mosi => spi_mosi,
          spi_sck  => spi_sck,
          spi_cs   => spi_cs,
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
      reset <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      reset <= '0';
      spi_mosi <= '1';
      wait for clk_period*100;

      -- insert stimulus here 

      wait;
   end process;

end;
