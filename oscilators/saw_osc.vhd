----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:36:57 04/06/2016 
-- Design Name: 
-- Module Name:    square_osc - Behavioral 
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

entity saw_osc is
  port ( 
    clk      : in  std_logic;
    reset    : in  std_logic;
    tick     : in  std_logic;
    wave_out : out std_logic_vector(9 downto 0));
end saw_osc;

architecture Behavioral of saw_osc is

  signal counter : unsigned(6 downto 0);
  signal wave    : unsigned(9 downto 0);
  
begin
  
  wave_out <= STD_LOGIC_VECTOR(wave);
  wave     <= (counter & "000") + ("00" & counter & "0");
  
  process(clk, tick, reset)
  begin
    if(reset = '1') then
      counter  <= (others => '0');
    elsif(clk'event and clk = '1' and tick = '1') then
     
      if(counter = 99) then
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;

end Behavioral;

