--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:00:05 05/31/2016
-- Design Name:   
-- Module Name:   C:/Users/K n z o/Dropbox/SynthPad/synth_integration/adsr_generator_test.vhd
-- Project Name:  synth_integration
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adsr_generator
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

entity adsr_generator_test is
end adsr_generator_test;
 
architecture behavior of adsr_generator_test is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
  component adsr_generator
  port(
    clk           : in  std_logic;
    reset         : in  std_logic;
    note_on_tick  : in  std_logic;
    note_off_tick : in  std_logic;
    attack        : in  std_logic_vector(7 downto 0);
    decay         : in  std_logic_vector(7 downto 0);
    sustain       : in  std_logic_vector(7 downto 0);
    release       : in  std_logic_vector(7 downto 0);
    envelope      : out  std_logic_vector(9 downto 0);
    led_status    : out  std_logic_vector(2 downto 0);
    parameter     : out  std_logic_vector(7 downto 0);
    tick          : out  std_logic
  );
  end component;
    

   --Inputs
   signal clk           : std_logic := '0';
   signal reset         : std_logic := '0';
   signal note_on_tick  : std_logic := '0';
   signal note_off_tick : std_logic := '0';
   signal attack        : std_logic_vector(7 downto 0) := (others => '0');
   signal decay         : std_logic_vector(7 downto 0) := (others => '0');
   signal sustain       : std_logic_vector(7 downto 0) := (others => '0');
   signal release       : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal envelope   : std_logic_vector(9 downto 0);
   signal led_status : std_logic_vector(2 downto 0);
   signal parameter  : std_logic_vector(7 downto 0);
   signal tick       : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
  uut: adsr_generator 
  port map(
    clk           => clk,
    reset         => reset,
    note_on_tick  => note_on_tick,
    note_off_tick => note_off_tick,
    attack        => attack,
    decay         => decay,
    sustain       => sustain,
    release       => release,
    envelope      => envelope,
    led_status    => led_status,
    parameter     => parameter,
    tick          => tick
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
      sustain <= "10000000";
      wait for clk_period*10;
      note_on_tick <= '1';
      wait for clk_period*1;
      note_on_tick <= '0';
      wait for clk_period*300000;
      note_off_tick <= '1';
      wait for clk_period*1;
      note_off_tick <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
