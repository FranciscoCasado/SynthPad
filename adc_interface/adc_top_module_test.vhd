--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:12:51 06/02/2016
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY adc_top_module_test IS
END adc_top_module_test;
 
ARCHITECTURE behavior OF adc_top_module_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adc_top_module
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         spi_miso : IN  std_logic;
         spi_mosi : OUT  std_logic;
         spi_sck : OUT  std_logic;
         spi_cs : OUT  std_logic;
         LED : OUT  std_logic_vector(7 downto 0);
         SF_D : OUT  std_logic_vector(11 downto 8);
         LCD_E : OUT  std_logic;
         LCD_RS : OUT  std_logic;
         LCD_RW : OUT  std_logic;
         SF_CE0 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal spi_miso : std_logic := '0';

 	--Outputs
   signal spi_mosi : std_logic;
   signal spi_sck : std_logic;
   signal spi_cs : std_logic;
   signal LED : std_logic_vector(7 downto 0);
   signal SF_D : std_logic_vector(11 downto 8);
   signal LCD_E : std_logic;
   signal LCD_RS : std_logic;
   signal LCD_RW : std_logic;
   signal SF_CE0 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: adc_top_module PORT MAP (
          clk => clk,
          reset => reset,
          spi_miso => spi_miso,
          spi_mosi => spi_mosi,
          spi_sck => spi_sck,
          spi_cs => spi_cs,
          LED => LED,
          SF_D => SF_D,
          LCD_E => LCD_E,
          LCD_RS => LCD_RS,
          LCD_RW => LCD_RW,
          SF_CE0 => SF_CE0
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
      reset <= '1';
      wait for 100 ns;	
      reset <= '0';
      wait for clk_period*100000000;

      -- insert stimulus here 

      wait;
   end process;

END;
