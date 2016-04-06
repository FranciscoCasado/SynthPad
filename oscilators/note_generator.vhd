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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity note_generator is
  port ( 
    clk       : in   std_logic;
    reset     : in   std_logic;
    sw        : in   std_logic;
    note_tick : out  std_logic);
end note_generator;

architecture Behavioral of note_generator is

-- Note constants
  signal C1 : unsigned(10 downto 0) := TO_UNSIGNED(1912,11);
  signal D1 : unsigned(10 downto 0) := TO_UNSIGNED(1702,11);
  signal E1 : unsigned(10 downto 0) := TO_UNSIGNED(1517,11);
  signal F1 : unsigned(10 downto 0) := TO_UNSIGNED(1432,11);
  signal G1 : unsigned(10 downto 0) := TO_UNSIGNED(1276,11);
  signal A1 : unsigned(10 downto 0) := TO_UNSIGNED(1135,11);
  signal B1 : unsigned(10 downto 0) := TO_UNSIGNED(1011,11);
  signal C2 : unsigned(10 downto 0) := TO_UNSIGNED(955,11);
  
 -- Wave generation
  signal counter : unsigned(10 downto 0);
  signal max_counter : unsigned(10 downto 0);
  
 -- External input control
  signal sw_prev : std_logic;
  
 -- States for the state machine
  type state_type is(state_c1, state_d1, state_e1, state_f1, state_g1, state_a1, state_b1, state_c2);
  signal state_reg, state_next : state_type;

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
  
  -- State machine declaration
  process(clk, reset)
  begin
    if(reset = '1') then
      state_reg <= state_a1;
    elsif(clk'event and clk = '1') then
      
      if(sw = '1' and sw_prev = '0') then
        state_reg <= state_next;
      end if;
      
       sw_prev <= sw;
        
    end if;
  end process;
  
  -- Note changes depending on current state
  process(state_reg)
  begin
    if(state_reg = state_c1) then
      state_next <= state_d1;
      max_counter <= C1;
    elsif(state_reg = state_d1) then
      state_next <= state_e1;
      max_counter <= D1;
    elsif(state_reg = state_e1) then
      state_next <= state_f1;
      max_counter <= E1;
    elsif(state_reg = state_f1) then
      state_next <= state_g1;
      max_counter <= F1;
    elsif(state_reg = state_g1) then
      state_next <= state_a1;
      max_counter <= G1;
    elsif(state_reg = state_a1) then
      state_next <= state_b1;
      max_counter <= A1;
    elsif(state_reg = state_b1) then
      state_next <= state_c2;
      max_counter <= B1;
    elsif(state_reg = state_c2) then
      state_next <= state_c1;
      max_counter <= C2;
    end if;
  end process; 
  

end Behavioral;

