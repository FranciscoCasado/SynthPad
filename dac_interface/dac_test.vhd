--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:16:36 02/19/2016
-- Design Name:   
-- Module Name:   C:/Users/K n z o/Dropbox/MIDI-FPGA/Codigo/dac_interface/dac_test.vhd
-- Project Name:  dac_interface
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dac_interface
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
 
ENTITY dac_test IS
END dac_test;
 
ARCHITECTURE behavior OF dac_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dac_interface
    PORT(
         SPI_MISO : IN  std_logic;
         data_in : IN  std_logic_vector(11 downto 0);
         comm : IN  std_logic_vector(3 downto 0);
         addr : IN  std_logic_vector(3 downto 0);
         reset : IN  std_logic;
         CLK : IN  std_logic;
         SPI_MOSI : OUT  std_logic;
         SPI_SCK : OUT  std_logic;
         DAC_CS : OUT  std_logic;
         DAC_CLR : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SPI_MISO : std_logic := '0';
   signal data_in : std_logic_vector(11 downto 0) := (others => '0');
   signal comm : std_logic_vector(3 downto 0) := (others => '0');
   signal addr : std_logic_vector(3 downto 0) := (others => '0');
   signal reset : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal SPI_MOSI : std_logic;
   signal SPI_SCK : std_logic;
   signal DAC_CS : std_logic;
   signal DAC_CLR : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dac_interface PORT MAP (
          SPI_MISO => SPI_MISO,
          data_in => data_in,
          comm => comm,
          addr => addr,
          reset => reset,
          CLK => CLK,
          SPI_MOSI => SPI_MOSI,
          SPI_SCK => SPI_SCK,
          DAC_CS => DAC_CS,
          DAC_CLR => DAC_CLR
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

      data_in <= "000000000000";
      comm <= "0000";
      addr <= "0000";
      reset <= '1';

      wait for CLK_period*10;

      -- insert stimulus here 
      data_in <= "101010101010";
      comm <= "1111";
      addr <= "0000";
      reset <= '0';
      wait;
   end process;

END;
