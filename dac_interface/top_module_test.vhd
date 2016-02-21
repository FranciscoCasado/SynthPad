--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:03:01 02/19/2016
-- Design Name:   
-- Module Name:   C:/Users/K n z o/Dropbox/MIDI-FPGA/Codigo/dac_interface/top_module_test.vhd
-- Project Name:  dac_interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_module
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
 
ENTITY top_module_test IS
END top_module_test;
 
ARCHITECTURE behavior OF top_module_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_module
    PORT(
      SPI_MISO : in std_logic;
      SW       : in std_logic;
      CLK      : in std_logic;          
      SPI_MOSI : out std_logic;
      SPI_SCK  : out std_logic;
      DAC_CS   : out std_logic;
      DAC_CLR  : out std_logic;
      LED      : out std_logic_vector(7 downto 0);
      LCD_E    : out std_logic;
      LCD_RS   : out std_logic;
      LCD_RW   : out std_logic;
      SF_D     : out std_logic_vector(11 downto 8);
      SF_CE0   : out std_logic;
      SPI_SS_B : out std_logic;
      AMP_CS   : out std_logic;
      AD_CONV  : out std_logic;
      FPGA_INIT_B : out std_logic
        );
    END COMPONENT;
    

  --Inputs
  signal SW : std_logic := '0';
  signal CLK : std_logic := '0';

  --Outputs
  signal SPI_MISO : std_logic;        
  signal SPI_MOSI : std_logic;
  signal SPI_SCK  : std_logic;
  signal DAC_CS   : std_logic;
  signal DAC_CLR  : std_logic;
  signal LED      : std_logic_vector(7 downto 0);
  signal LCD_E    : std_logic;
  signal LCD_RS   : std_logic;
  signal LCD_RW   : std_logic;
  signal SF_D     : std_logic_vector(11 downto 8);
  signal SF_CE0   : std_logic;
  signal SPI_SS_B : std_logic;
  signal AMP_CS   : std_logic;
  signal AD_CONV  : std_logic;
  signal FPGA_INIT_B : std_logic;


   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_module PORT MAP (
		SPI_MISO => SPI_MISO,
		SW => SW,
		CLK => CLK,
		SPI_MOSI => SPI_MOSI,
		SPI_SCK => SPI_SCK,
		DAC_CS => DAC_CS,
		DAC_CLR => DAC_CLR,
		LED => LED ,
		LCD_E => LCD_E,
		LCD_RS => LCD_RS,
		LCD_RW => LCD_RW,
		SF_D => SF_D,
		SF_CE0 => SF_CE0,
		SPI_SS_B => SPI_SS_B,
		AMP_CS => AMP_CS,
		AD_CONV => AD_CONV,
		FPGA_INIT_B => FPGA_INIT_B
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      SW <= '1';
      wait for CLK_period*10;
      SW <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
