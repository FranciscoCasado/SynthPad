----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:54:20 04/06/2016 
-- Design Name: 
-- Module Name:    sine_osc - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sine_osc is
  port ( 
    clk      : in  std_logic;
    reset    : in  std_logic;
    tick      : in  std_logic;
    wave_out : out std_logic_vector(9 downto 0));
end sine_osc;

architecture Behavioral of sine_osc is

component sine_mem
  port(
    clka  : in  std_logic;
    wea   : in  std_logic_vector(0 downto 0);
    addra : in  std_logic_vector(6 downto 0);
    dina  : in  std_logic_vector(9 downto 0);
    douta : out std_logic_vector(9 downto 0)
  );  
end component;

  signal counter      : unsigned(6 downto 0);
  signal counter_next : unsigned(6 downto 0);
  signal addr         : std_logic_vector(6 downto 0);

begin


  addr <= std_logic_vector(counter);

  process(clk, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
    elsif(clk'event and clk = '1' and tick = '1') then
      counter <= counter_next;
    end if;
  end process;
  
  counter_next <= 
    (others => '0') when counter = 98 else 
    counter + 1;

  Instance_sine_mem : sine_mem
  port map(
    clka  => clk,
    wea   => "0",
    addra => addr,
    dina  => "0000000000",
    douta => wave_out
  );


end Behavioral;

