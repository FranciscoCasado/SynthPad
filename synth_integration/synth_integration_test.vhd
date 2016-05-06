--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:42:54 05/06/2016
-- Design Name:   
-- Module Name:   C:/Users/Kenzo/Dropbox/SynthPad/synth_integration/synth_integration_test.vhd
-- Project Name:  synth_integration
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: synth_top_module
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
 
ENTITY synth_integration_test IS
END synth_integration_test;
 
ARCHITECTURE behavior OF synth_integration_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT synth_top_module
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rx : IN  std_logic;
         SPI_MISO : IN  std_logic;
         SPI_MOSI : OUT  std_logic;
         SPI_SCK : OUT  std_logic;
         DAC_CS : OUT  std_logic;
         DAC_CLR : OUT  std_logic;
         SPI_SS_B : OUT  std_logic;
         AMP_CS : OUT  std_logic;
         AD_CONV : OUT  std_logic;
         FPGA_INIT_B : OUT  std_logic;
         LED : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rx : std_logic := '0';
   signal SPI_MISO : std_logic := '0';

 	--Outputs
   signal SPI_MOSI : std_logic;
   signal SPI_SCK : std_logic;
   signal DAC_CS : std_logic;
   signal DAC_CLR : std_logic;
   signal SPI_SS_B : std_logic;
   signal AMP_CS : std_logic;
   signal AD_CONV : std_logic;
   signal FPGA_INIT_B : std_logic;
   signal LED : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: synth_top_module PORT MAP (
          clk => clk,
          reset => reset,
          rx => rx,
          SPI_MISO => SPI_MISO,
          SPI_MOSI => SPI_MOSI,
          SPI_SCK => SPI_SCK,
          DAC_CS => DAC_CS,
          DAC_CLR => DAC_CLR,
          SPI_SS_B => SPI_SS_B,
          AMP_CS => AMP_CS,
          AD_CONV => AD_CONV,
          FPGA_INIT_B => FPGA_INIT_B,
          LED => LED
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

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
