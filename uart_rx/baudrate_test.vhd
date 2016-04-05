--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:08:22 04/04/2016
-- Design Name:   
-- Module Name:   C:/Users/Kenzo/Dropbox/SynthLaunchpad/MIDI-FPGA/Codigo/uart_rx/baudrate_test.vhd
-- Project Name:  uart_rx
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: baudrate_generator
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
 
ENTITY baudrate_test IS
END baudrate_test;
 
ARCHITECTURE behavior OF baudrate_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT baudrate_generator
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         tick : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal tick : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: baudrate_generator PORT MAP (
          clk => clk,
          rst => rst,
          tick => tick
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
      rst <= '1';
      wait for clk_period*10;
      rst <= '0';
      -- insert stimulus here
      wait for clk_period*3200;

      wait;
   end process;

END;
