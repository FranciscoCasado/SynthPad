--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:42:21 06/14/2016
-- Design Name:   
-- Module Name:   C:/Users/K n z o/Dropbox/SynthPad/synth_integration/voice_test.vhd
-- Project Name:  synth_integration
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: voice_unit
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
 
ENTITY voice_test IS
END voice_test;
 
ARCHITECTURE behavior OF voice_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT voice_unit
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         data_1 : IN  std_logic_vector(6 downto 0);
         data_2 : IN  std_logic_vector(6 downto 0);
         adsr_attack : IN  std_logic_vector(7 downto 0);
         adsr_decay : IN  std_logic_vector(7 downto 0);
         adsr_sustain : IN  std_logic_vector(7 downto 0);
         adsr_release : IN  std_logic_vector(7 downto 0);
         voice_on_tick : IN  std_logic;
         voice_off_tick : IN  std_logic;
         wave_sel_tick : IN  std_logic;
         ctrl_sel_tick : IN  std_logic;
         wave_out : OUT  std_logic_vector(9 downto 0);
         voice_status : OUT  std_logic;
         wave_debug_1 : OUT  std_logic_vector(15 downto 0);
         wave_debug_2 : OUT  std_logic_vector(15 downto 0);
         status_debug : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal data_1 : std_logic_vector(6 downto 0) := "0100000";
   signal data_2 : std_logic_vector(6 downto 0) := "0100000";
   signal adsr_attack : std_logic_vector(7 downto 0) := "10000100";
   signal adsr_decay : std_logic_vector(7 downto 0) := "00000100";
   signal adsr_sustain : std_logic_vector(7 downto 0) := "00000100";
   signal adsr_release : std_logic_vector(7 downto 0) := "00000100";
   signal voice_on_tick : std_logic := '0';
   signal voice_off_tick : std_logic := '0';
   signal wave_sel_tick : std_logic := '0';
   signal ctrl_sel_tick : std_logic := '0';

 	--Outputs
   signal wave_out : std_logic_vector(9 downto 0);
   signal voice_status : std_logic;
   signal wave_debug_1 : std_logic_vector(15 downto 0);
   signal wave_debug_2 : std_logic_vector(15 downto 0);
   signal status_debug : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: voice_unit PORT MAP (
          clk => clk,
          reset => reset,
          data_1 => data_1,
          data_2 => data_2,
          adsr_attack => adsr_attack,
          adsr_decay => adsr_decay,
          adsr_sustain => adsr_sustain,
          adsr_release => adsr_release,
          voice_on_tick => voice_on_tick,
          voice_off_tick => voice_off_tick,
          wave_sel_tick => wave_sel_tick,
          ctrl_sel_tick => ctrl_sel_tick,
          wave_out => wave_out,
          voice_status => voice_status,
          wave_debug_1 => wave_debug_1,
          wave_debug_2 => wave_debug_2,
          status_debug => status_debug
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
      wait for clk_period;
      reset <= '0';
      wait for clk_period;      
      voice_on_tick <= '1';
      wait for clk_period;
      voice_on_tick <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
