--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:03:01 05/03/2016
-- Design Name:   
-- Module Name:   C:/Users/K n z o/Documents/SynthPad/decoder/midi_decoder_test.vhd
-- Project Name:  decoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: midi_decoder
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
 
entity midi_decoder_test is
end midi_decoder_test;
 
architecture behavior of midi_decoder_test is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
  component midi_decoder
  port(
    clk       : in  std_logic;
    reset     : in  std_logic;
    byte_in   : in  std_logic_vector(7 downto 0);
    tick      : in  std_logic;
    wave_ctrl : out std_logic_vector(3 downto 0);
    note_sel1 : out std_logic_vector(6 downto 0);
    wave_sel1 : out std_logic_vector(1 downto 0);
    note_sel2 : out std_logic_vector(6 downto 0);
    wave_sel2 : out std_logic_vector(1 downto 0);
    note_sel3 : out std_logic_vector(6 downto 0);
    wave_sel3 : out std_logic_vector(1 downto 0);
    note_sel4 : out std_logic_vector(6 downto 0);
    wave_sel4 : out std_logic_vector(1 downto 0);
    status_out : out std_logic_vector(7 downto 0)
  );
  end component;
    

   --Inputs
   signal clk     : std_logic := '0';
   signal reset   : std_logic := '0';
   signal byte_in : std_logic_vector(7 downto 0) := (others => '0');
   signal tick    : std_logic := '0';

 	--Outputs
   signal wave_ctrl : std_logic_vector(3 downto 0);
   signal note_sel1 : std_logic_vector(6 downto 0);
   signal wave_sel1 : std_logic_vector(1 downto 0);
   signal note_sel2 : std_logic_vector(6 downto 0);
   signal wave_sel2 : std_logic_vector(1 downto 0);
   signal note_sel3 : std_logic_vector(6 downto 0);
   signal wave_sel3 : std_logic_vector(1 downto 0);
   signal note_sel4 : std_logic_vector(6 downto 0);
   signal wave_sel4 : std_logic_vector(1 downto 0);
   
   signal status_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
  uut: midi_decoder 
  port map(
    clk => clk,
    reset => reset,
    byte_in => byte_in,
    tick => tick,
    wave_ctrl => wave_ctrl,
    note_sel1 => note_sel1,
    wave_sel1 => wave_sel1,
    note_sel2 => note_sel2,
    wave_sel2 => wave_sel2,
    note_sel3 => note_sel3,
    wave_sel3 => wave_sel3,
    note_sel4 => note_sel4,
    wave_sel4 => wave_sel4,
    status_out => status_out
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
    wait for clk_period/2;
    
    -- Fist Message - 3 bytes
    tick <= '1';
    byte_in <= "10010000";
    wait for clk_period;
    
    tick <= '0';
    wait for clk_period;
    
    tick <= '1';
    byte_in <= "01111111";
    wait for clk_period;
    
    tick <= '0';
    wait for clk_period;
    
    tick <= '1';
    byte_in <= "01010101";
    wait for clk_period;
    
    tick <= '0';
    wait for clk_period*10;
    
    
    -- Second Message - 2 bytes
    tick <= '1';
    byte_in <= "10010000";
    wait for clk_period;
    
    tick <= '0';
    wait for clk_period;
    
    tick <= '1';
    byte_in <= "01110000";
    wait for clk_period;
    
    tick <= '0';
    wait for clk_period;
    
    tick <= '1';
    byte_in <= "00101010";
    wait for clk_period;
    
    tick <= '0';
    wait for clk_period*10;
    

    --wait for clk_period;
    --tick <= '1';
    --byte_in <= "01010101";

    tick <= '0';
    wait for clk_period*10;
    
    
    -- Fist Message - 3 bytes
    tick <= '1';
    byte_in <= "10000000";
    wait for clk_period;
    
    tick <= '0';
    wait for clk_period;
    
    tick <= '1';
    byte_in <= "01111111";
    wait for clk_period;
    
    tick <= '0';
    wait for clk_period;
    
    tick <= '1';
    byte_in <= "00000000";
    wait for clk_period;
    
    tick <= '0';
    wait for clk_period;
    

    wait;
  end process;

end;
