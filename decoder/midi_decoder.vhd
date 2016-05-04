----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:21:47 05/03/2016 
-- Design Name: 
-- Module Name:    midi_decoder - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity midi_decoder is
  port( 
    clk       : in  std_logic;
    reset     : in  std_logic;
    byte_in   : in  std_logic_vector(7 downto 0);
    tick      : in  std_logic;
    wave_ctrl : out std_logic_vector(3 downto 0);
    note_sel1 : out std_logic_vector(2 downto 0);
    wave_sel1 : out std_logic_vector(1 downto 0);
    note_sel2 : out std_logic_vector(2 downto 0);
    wave_sel2 : out std_logic_vector(1 downto 0);
    note_sel3 : out std_logic_vector(2 downto 0);
    wave_sel3 : out std_logic_vector(1 downto 0);
    note_sel4 : out std_logic_vector(2 downto 0);
    wave_sel4 : out std_logic_vector(1 downto 0);
    status_out : out std_logic_vector(7 downto 0)
  );
end midi_decoder;

architecture Behavioral of midi_decoder is

type byte_state is (
    idle, status, data1, data2 -- Meaning NEXT byte should be ...
  );
  
  signal state, state_next : byte_state;

  signal status_byte : std_logic_vector(7 downto 0);
  signal data1_byte  : std_logic_vector(7 downto 0);
  signal data2_byte  : std_logic_vector(7 downto 0);
  
  signal is_byte_2 : std_logic;
  
  signal status_msb4 : std_logic_vector(3 downto 0);
  
  signal wave_ctrl_b : std_logic_vector(3 downto 0);
  signal note_sel1_b : std_logic_vector(2 downto 0);
  signal wave_sel1_b : std_logic_vector(1 downto 0);
  signal note_sel2_b : std_logic_vector(2 downto 0);
  signal wave_sel2_b : std_logic_vector(1 downto 0);
  signal note_sel3_b : std_logic_vector(2 downto 0);
  signal wave_sel3_b : std_logic_vector(1 downto 0);
  signal note_sel4_b : std_logic_vector(2 downto 0);
  signal wave_sel4_b : std_logic_vector(1 downto 0);
  
  signal instruction_tick : std_logic;
  
  -- Para los multiplicadores de la fpga.
  -- usar shift a la izq, multiplicar y tomar solo los MSB
  
begin

  status_msb4 <= status_byte(7 downto 4);

  -- State machine logic
  process(clk, reset)
  begin
    if(reset = '1') then
      state <= status;
    elsif(clk'event and clk='1') then
        if(tick = '1') then
          if(byte_in(7) = '1') then
            state <= data1;
          else
            state <= state_next;
          end if;  
        end if;
    end if;
  end process;

  -- Byte Position
  process(clk, reset) -- Poner tambien condiciones de next state
  begin
    if(reset = '1') then
      status_byte <= "00000000";
      data1_byte <= "00000000";
      data2_byte <= "00000000";
    elsif(clk'event and clk='1') then
      if(tick = '1') then
          if(byte_in(7) = '1') then -- Recover from errors... if MSB is 1 then is a STATUS byte !
            status_byte <= byte_in;
          elsif(state = status) then
            status_byte <= byte_in;
          elsif(state = data1) then
            data1_byte <= byte_in;
          elsif(state = data2) then
            data2_byte <= byte_in;
          else
            status_byte <= byte_in;
          end if;
      end if;
    end if;
  end process;
  
  -- Permitir Que cuando llegue un byte con el MSB en 1 sea reconocido como status !!!
  -- Next State Logic
  process(state, is_byte_2)
  begin
    if(state = idle) then
      state_next <= status;
    elsif(state = status) then
      state_next <= data1;
    elsif(state = data1) then
      if(is_byte_2 = '1') then
        state_next <= data2;
      else
        state_next <= status;
      end if;
    else
      state_next <= status;
    end if;
  end process;
  
  -- Decoding

  
  with status_msb4 select	is_byte_2 <= 
    '0' when "1101",
    '0' when "1100",
    '1' when others;
      
  -- Sequential Output
  process(clk, reset)
  begin
    if(reset = '1') then
      wave_ctrl <= "0000";
      note_sel1 <= "000";
      wave_sel1 <= "00";
      note_sel2 <= "000";
      wave_sel2 <= "00";
      note_sel3 <= "000";
      wave_sel3 <= "00";
      note_sel4 <= "000";
      wave_sel4 <= "00";
    elsif(clk'event and clk = '1' and instruction_tick = '1') then
      status_out <= data1_byte;
      wave_ctrl <= wave_ctrl_b;
      note_sel1 <= note_sel1_b;
      wave_sel1 <= wave_sel1_b;
      note_sel2 <= note_sel2_b;
      wave_sel2 <= wave_sel2_b;
      note_sel3 <= note_sel3_b;
      wave_sel3 <= wave_sel3_b;
      note_sel4 <= note_sel4_b;
      wave_sel4 <= wave_sel4_b;
    end if;
  end process;
  
--  process(clk, reset)
--  begin
--    if(reset = '1') then
--      
--  
--  end process;

  process(state, tick)
  begin
    if(state = status and tick = '1') then
      instruction_tick <= '1';
    else
      instruction_tick <= '0';
    end if;
  end process;
  
  wave_ctrl_b <= status_byte(3 downto 0);
  note_sel1_b <= status_byte(2 downto 0);
  wave_sel1_b <= status_byte(1 downto 0);
  note_sel2_b <= status_byte(2 downto 0);
  wave_sel2_b <= status_byte(1 downto 0);
  note_sel3_b <= status_byte(2 downto 0);
  wave_sel3_b <= status_byte(1 downto 0);
  note_sel4_b <= status_byte(2 downto 0);
  wave_sel4_b <= status_byte(1 downto 0);
 
      
end Behavioral;

