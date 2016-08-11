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

entity custom_osc is
  port ( 
    clk      : in  std_logic;
    reset    : in  std_logic;
    tick     : in  std_logic;
    wave_out : out std_logic_vector(9 downto 0));
end custom_osc;

architecture Behavioral of custom_osc is

component custom_wave
  port(
    clka  : in  std_logic;
    wea   : in  std_logic_vector(0 downto 0);
    addra : in  std_logic_vector(6 downto 0);
    dina  : in  std_logic_vector(9 downto 0);
    douta : out std_logic_vector(9 downto 0)
  );  
end component;

  signal counter       : unsigned(6 downto 0);
  signal counter_next  : unsigned(6 downto 0);
  signal counter2      : unsigned(6 downto 0);
  signal counter2_next : unsigned(6 downto 0);
  signal addr          : std_logic_vector(6 downto 0);
  signal counter_tick : std_logic;

begin

  addr <= std_logic_vector(counter2);

  process(clk, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
    elsif(clk'event and clk = '1' and tick = '1') then
      counter_tick <= '0';
      
      if(counter = "000000") then
        counter_tick <= '1';
      end if;
      
      counter <= counter_next;
    end if;
  end process;
  
  process(clk, reset)
  begin
    if(reset = '1') then
      counter2 <= (others => '0');
    elsif(clk'event and clk = '1' and counter_tick = '1') then
      counter2 <= counter2 + 1;
    end if;
  end process;
  
  counter_next <= 
    (others => '0') when counter = 99 else 
    counter + 1;

  Instance_custom_wave : custom_wave
  port map(
    clka  => clk,
    wea   => "0",
    addra => addr,
    dina  => "0000000000",
    douta => wave_out
  );


end Behavioral;

