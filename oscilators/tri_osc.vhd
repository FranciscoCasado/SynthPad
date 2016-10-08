----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:36:57 04/06/2016 
-- Design Name: 
-- Module Name:    tri_osc - Behavioral 
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

entity tri_osc is
  port ( 
    clk      : in  std_logic;
    reset    : in  std_logic;
    tick     : in  std_logic;
    wave_out : out std_logic_vector(9 downto 0));
end tri_osc;

architecture Behavioral of tri_osc is

  signal next_counter : unsigned(5 downto 0);
  signal counter : unsigned(5 downto 0);
  signal wave    : unsigned(9 downto 0);
  signal state   : std_logic;
  signal next_state : std_logic;
  
begin
  
  wave_out <= STD_LOGIC_VECTOR(wave);
  
  wave     <= (counter & "0000") + ("00" & counter & "00");

  process(clk, tick, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
      state   <= '0';
    elsif(clk'event and clk = '1' and tick = '1') then
      counter <= next_counter;
      state   <= next_state;
    end if;
  end process;

  -- next state logic
  process(counter, state)
  begin
    if(counter = 1) then
      next_state <= '0';
    elsif(counter = 49) then
      next_state <= '1';
    else
      next_state <= state;
    end if;
  end process;

  -- next counter logic
  process(state, counter)
  begin
    if(state = '0') then
      next_counter <= counter + 1;
    elsif(state = '1') then
      next_counter <= counter - 1;
    else
      next_counter <= counter;
    end if;
  end process;
end Behavioral;
