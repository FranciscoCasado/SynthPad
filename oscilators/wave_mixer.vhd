----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:37:08 04/07/2016 
-- Design Name: 
-- Module Name:    wave_mixer - Behavioral 
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

entity wave_mixer is
  port( 
    ctrl     : in  std_logic_vector(3 downto 0);
    wave_1   : in  std_logic_vector(9 downto 0);
    wave_2   : in  std_logic_vector(9 downto 0);
    wave_3   : in  std_logic_vector(9 downto 0);
    wave_4   : in  std_logic_vector(9 downto 0);
    wave_out : out std_logic_vector(11 downto 0));
end wave_mixer;

architecture Behavioral of wave_mixer is

  signal e1 : std_logic_vector(9 downto 0);
  signal e2 : std_logic_vector(9 downto 0);
  signal e3 : std_logic_vector(9 downto 0);
  signal e4 : std_logic_vector(9 downto 0);
  
  signal sum : unsigned(11 downto 0);
  
  signal u1 : unsigned(11 downto 0);
  signal u2 : unsigned(11 downto 0);
  signal u3 : unsigned(11 downto 0);
  signal u4 : unsigned(11 downto 0);
  
begin

  wave_out <= std_logic_vector(sum);
  
  e1 <= wave_1 when ctrl(0) = '1' else
    "0000000000";

  e2 <= wave_2 when ctrl(1) = '1' else
    "0000000000";
    
  e3 <= wave_3 when ctrl(2) = '1' else
    "0000000000";
    
  e4 <= wave_4 when ctrl(3) = '1' else
    "0000000000";
  
  u1 <= "00"&unsigned(e1);
  u2 <= "00"&unsigned(e2);
  u3 <= "00"&unsigned(e3);
  u4 <= "00"&unsigned(e4);
	 
  sum <= u1 + u2 + u3 + u4;
end Behavioral;

