--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:40:30 04/04/2016
-- Design Name:   
-- Module Name:   C:/Users/Kenzo/Dropbox/SynthLaunchpad/MIDI-FPGA/Codigo/uart_rx/uart_test.vhd
-- Project Name:  uart_rx
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_rx
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
 
entity uart_test is
end uart_test;
 
architecture behavior of uart_test is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
  component uart_rx
  port(
    clk          : in  std_logic;
    reset        : in  std_logic;
    rx           : in  std_logic;
    sample_tick       : in  std_logic;
    rx_done_tick : out  std_logic;
    dout         : out  std_logic_vector(7 downto 0)
  );
  end component;
    
  component baudrate_generator
	port(
    clk : in std_logic;
    rst : in std_logic;          
    tick : out std_logic
    );
  end component;

   --Inputs
   signal clk    : std_logic := '0';
   signal reset  : std_logic := '0';
   signal rx     : std_logic := '0';
   signal sample_tick : std_logic := '0';

 	--Outputs
   signal rx_done_tick : std_logic;
   signal dout         : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
  
  Inst_baudrate_generator: baudrate_generator 
  PORT MAP(
    clk  => clk,
    rst  => reset, 
    tick => sample_tick
	);
  
  uut: uart_rx 
  port map (
    clk          => clk,
    reset        => reset,
    rx           => rx,
    sample_tick  => sample_tick,
    rx_done_tick => rx_done_tick,
    dout         => dout
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
    rx <= '1';
    wait for 10 us;	
    wait for clk_period*10;
    reset <= '0';
	 wait for clk_period*500;
    -- insert stimulus here 
    wait for clk_period*1600; rx <= '0'; -- start
    wait for clk_period*1600; rx <= '1'; -- LSB
    wait for clk_period*1600; rx <= '0';
    wait for clk_period*1600; rx <= '1';
    wait for clk_period*1600; rx <= '0';
    wait for clk_period*1600; rx <= '1';
    wait for clk_period*1600; rx <= '0';
    wait for clk_period*1600; rx <= '1';
    wait for clk_period*1600; rx <= '0'; -- MSB
    wait for clk_period*1600; rx <= '1'; -- stop
    
	 wait for clk_period*2050;
    -- insert stimulus here 
    wait for clk_period*1600; rx <= '0'; -- start
    wait for clk_period*1600; rx <= '1'; -- LSB
    wait for clk_period*1600; rx <= '0';
    wait for clk_period*1600; rx <= '1';
    wait for clk_period*1600; rx <= '0';
    wait for clk_period*1600; rx <= '1';
    wait for clk_period*1600; rx <= '0';
    wait for clk_period*1600; rx <= '1';
    wait for clk_period*1600; rx <= '0'; -- MSB
    wait for clk_period*1600; rx <= '1'; -- stop
    wait;
  end process;

end;
