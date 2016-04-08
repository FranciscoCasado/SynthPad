----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:35:13 04/07/2016 
-- Design Name: 
-- Module Name:    rotatory_encoder - Behavioral 
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

entity rotatory_encoder is
  port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    A         : in  std_logic;
    B         : in  std_logic;
    direction : out std_logic;
    count     : out std_logic := '0'
  );
end rotatory_encoder;

architecture behavioral of rotatory_encoder is
  type state_type is (
    CW_A, CW_B, CW_C, CW_D,
    CCW_A, CCW_B, CCW_C, CCW_D
  );

  signal state, state_next : state_type := CW_A;

  constant CCW : std_logic := '0';
  constant CW  : std_logic  := '1';

begin

  -- State Machine logic
  process(clk, reset)
  begin
    if(reset = '1') then
      state <= CW_A;
    elsif(clk'event and clk = '1') then
      state <= state_next;
    end if;
  end process;

  -- Next State logic
  process (A, B, state)
    begin
      case state is
       when CW_A =>
        if(A = '0' and B = '1') then
          state_next <= CW_B;
        elsif(A = '1' and B = '0') then
          state_next <= CCW_D;
        else
          state_next <= state;
        end if;
      when CW_B =>
        if(A = '0' and B = '0')then
          state_next <= CW_C;
        elsif(A = '1' and B = '1') then
          state_next <= CCW_A;
        else
          state_next <= state;
        end if;
      when CW_C =>
        if(A = '1' and B = '0') then
          state_next <= CW_D;
        elsif(A = '0' and B = '1') then
          state_next <= CCW_B;
        else
          state_next <= state;
        end if;
      when CW_D =>
        if(A = '1' and B = '1') then
          state_next <= CW_A;
        elsif(A = '0' and B = '0') then
          state_next <= CCW_C;
        else
          state_next <= state;
        end if;
      when CCW_A =>
        if(A = '0' and B = '1') then
          state_next <= CW_B;
        elsif(A = '1' and B = '0') then
          state_next <= CCW_D;
        else
          state_next <= state;
        end if;
      when CCW_B =>
        if(A = '0' and B = '0') then
          state_next <= CW_C;
        elsif(A = '1' and B = '1') then
          state_next <= CCW_A;
        else
          state_next <= state;
        end if;
      when CCW_C =>
        if(A = '1' and B = '0') then
          state_next <= CW_D;
        elsif(A = '0' and B = '1') then
          state_next <= CCW_B;
        else
          state_next <= state;
        end if;
      when CCW_D =>
        if(A = '1' and B = '1') then
          state_next <= CW_A;
        elsif(A = '0' and B = '0') then
          state_next <= CCW_C;
        else
          state_next <= state;
        end if;
       when others =>
         state_next <= CW_A;
    end case;
  end process;

  direction <= '1' when state = CW_A or
    state = CW_B or state = CW_C or
    state = CW_D else '0';
  count <= '1' when state = CW_B or
    state = CW_C or state = CCW_B or
    state = CCW_C else '0';
    
end Behavioral;