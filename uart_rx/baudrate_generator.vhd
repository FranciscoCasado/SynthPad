----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:28:55 04/01/2016 
-- Design Name: 
-- Module Name:    badrate_generator - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity baudrate_generator is
  generic(
    N : integer := 8;
    M : integer := 163
  );
  port(
    clk : in std_logic;
    rst : in std_logic;
    tick : out std_logic
  );
end baudrate_generator;

architecture Behavioral of baudrate_generator is

signal r_reg : unsigned (N-1 downto 0);
signal r_next : unsigned (N-1 downto 0);

begin

  process(clk, rst)
  begin
    if(rst = '1') then
      r_reg <= (others => '0');
    elsif(clk'event and clk = '1') then
      r_reg <= r_next;
    end if;
  end process;

  --r_next <= (others => '0') when r_reg = (M-1) else (r_reg + '1');
  
  process(r_reg)
  begin
    if(r_reg = M-1) then
      r_next <= (others => '0');
    else
      r_next <= r_reg + 1;
    end if;
  end process;
  
  tick <= '1' when r_reg = (M-1) else '0';

end Behavioral;

