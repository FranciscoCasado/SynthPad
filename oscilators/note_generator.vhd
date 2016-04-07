----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:16:15 04/05/2016 
-- Design Name: 
-- Module Name:    note_generator - Behavioral 
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

entity note_generator is
  port ( 
    clk       : in  std_logic;
    reset     : in  std_logic;
    note_sel  : in  std_logic_vector(2 downto 0);
    note_tick : out std_logic);
end note_generator;

architecture Behavioral of note_generator is

  -- Note constants
  signal C1 : unsigned(10 downto 0) := TO_UNSIGNED(1912, 11);
  signal D1 : unsigned(10 downto 0) := TO_UNSIGNED(1702, 11);
  signal E1 : unsigned(10 downto 0) := TO_UNSIGNED(1517, 11);
  signal F1 : unsigned(10 downto 0) := TO_UNSIGNED(1432, 11);
  signal G1 : unsigned(10 downto 0) := TO_UNSIGNED(1276, 11);
  signal A1 : unsigned(10 downto 0) := TO_UNSIGNED(1135, 11);
  signal B1 : unsigned(10 downto 0) := TO_UNSIGNED(1011, 11);
  signal C2 : unsigned(10 downto 0) := TO_UNSIGNED(955, 11);
  
 -- Wave generation
  signal counter : unsigned(10 downto 0);
  signal max_counter : unsigned(10 downto 0);
  
begin
 -- 100 samples per note
 
 -- Wave generation
  process(clk, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
    elsif(clk'event and clk = '1') then
      note_tick <= '0';
      
      if(counter = max_counter) then
        note_tick <= '1';
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
        
    end if;
  end process;
  
  -- Note selection
  max_counter <= 
    C1 when note_sel = "000" else 
    D1 when note_sel = "001" else
    E1 when note_sel = "010" else
    F1 when note_sel = "011" else
    G1 when note_sel = "100" else
    A1 when note_sel = "101" else
    B1 when note_sel = "110" else
    C2 when note_sel = "111";

end Behavioral;

