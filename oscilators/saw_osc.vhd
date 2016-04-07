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
  signal counter2 : unsigned(2 downto 0);

begin
  
  wave_out <= STD_LOGIC_VECTOR(counter)&"000";
  
  -- aqui falta separation of concerns.
  -- counter siempre cuenta 100 para volver a 0
  -- waveout debe hacer la pega, a dormir
  
  process(clk, tick, reset)
  begin
    if(reset = '1') then
      counter  <= (others => '0');
      counter2 <= (others => '0');
    elsif(clk'event and clk = '1' and tick = '1') then
      
      if(counter2 = 5) then
        counter2 <= (others => '0');
      else
        counter2 <= counter2 + 1;
      end if;
    
      if(counter = 99) then
        counter <= (others => '0');
      else
        if(counter2 = 5) then
          counter <= counter + 2;
        else
          counter <= counter + 1;
        end if;
      end if;
    end if;
  end process;

end Behavioral;

