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
    note_sel1 : out std_logic_vector(6 downto 0);
    wave_sel1 : out std_logic_vector(1 downto 0);
    note_sel2 : out std_logic_vector(6 downto 0);
    wave_sel2 : out std_logic_vector(1 downto 0);
    note_sel3 : out std_logic_vector(6 downto 0);
    wave_sel3 : out std_logic_vector(1 downto 0);
    note_sel4 : out std_logic_vector(6 downto 0);
    wave_sel4 : out std_logic_vector(1 downto 0);
    status_out : out std_logic_vector(7 downto 0)
  );
end midi_decoder;

architecture Behavioral of midi_decoder is

type byte_state is (
    idle, status, data1, data2 -- Meaning NEXT byte should be ...
  );
  
  signal prev_state, state, state_next : byte_state;

  signal status_byte : std_logic_vector(6 downto 0);
  signal data1_byte  : std_logic_vector(6 downto 0);
  signal data2_byte  : std_logic_vector(6 downto 0);
  
  signal is_byte_2 : std_logic;
  
  signal status_msb4 : std_logic_vector(2 downto 0);
  
  signal wave_ctrl_b : std_logic_vector(3 downto 0);
  signal note_sel1_b : std_logic_vector(6 downto 0);
  signal wave_sel1_b : std_logic_vector(1 downto 0);
  signal note_sel2_b : std_logic_vector(6 downto 0);
  signal wave_sel2_b : std_logic_vector(1 downto 0);
  signal note_sel3_b : std_logic_vector(6 downto 0);
  signal wave_sel3_b : std_logic_vector(1 downto 0);
  signal note_sel4_b : std_logic_vector(6 downto 0);
  signal wave_sel4_b : std_logic_vector(1 downto 0);
  
  signal instruction_tick : std_logic;
  signal channel_message : std_logic;
  
  signal device_channel : std_logic_vector(3 downto 0) := "0000"; -- Our Device is set to listen to channel 0 !
  signal note     : std_logic_vector(6 downto 0);
  signal note_on  : std_logic;
  signal note_off : std_logic;
  
  -- Para los multiplicadores de la fpga.
  -- usar shift a la izq, multiplicar y tomar solo los MSB
  
  signal debug : std_logic;
  signal done : std_logic;
  signal prev_intruction_tick : std_logic;
  signal update_tick : std_logic;
begin

  -- Decoding

  status_msb4 <= status_byte(6 downto 4);
  note <= data1_byte(6 downto 0);
  
  status_out <= note_on&note_off&"00"&wave_ctrl_b;
  
  
  with status_msb4 select	is_byte_2 <= 
    '0' when "101",
    '0' when "100",
    '1' when others;

  -- Estas deben ser modificadas
  wave_ctrl <= wave_ctrl_b;
  note_sel1 <= note_sel1_b;
  wave_sel1 <= wave_sel1_b;
  note_sel2 <= note_sel2_b;
  wave_sel2 <= wave_sel2_b;
  note_sel3 <= note_sel3_b;
  wave_sel3 <= wave_sel3_b;
  note_sel4 <= note_sel4_b;
  wave_sel4 <= wave_sel4_b;
  
  process(state, tick)
  begin
    if(state = status and tick = '1') then
      instruction_tick <= '1';
    else
      instruction_tick <= '0';
    end if;
  end process;
  
  process(clk)
  begin
    if(clk'event and clk = '1') then
      prev_intruction_tick <= instruction_tick;
    end if;
  end process;
  
  process(state, prev_state)
  begin
    if(state = status and prev_state = data2) then
      update_tick <= '1';
    else
      update_tick <= '0';
    end if;
  end process;
  
  with status_byte(6 downto 4) select	
    channel_message <= 
      '0' when "111",
      '1' when others;
      
  with status_byte(6 downto 4) select
    note_on <=
      '1' when "001",
      '0' when others;
      
  with status_byte(6 downto 4) select
    note_off <=
      '1' when "000",
      '0' when others;
      
  

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
            prev_state <= state;
          end if;  
        end if;
    end if;
  end process;

  -- Byte Position
  process(clk, reset) -- Poner tambien condiciones de next state
  begin
    if(reset = '1') then
      status_byte <= "0000000";
      data1_byte  <= "0000000";
      data2_byte  <= "0000000";
    elsif(clk'event and clk='1') then
      if(tick = '1') then
          if(byte_in(7) = '1') then -- Recover from errors... if MSB is 1 then is a STATUS byte !
            status_byte <= byte_in(6 downto 0);
          elsif(state = status) then
            status_byte <= byte_in(6 downto 0);
          elsif(state = data1) then
            data1_byte <= byte_in(6 downto 0);
          elsif(state = data2) then
            data2_byte <= byte_in(6 downto 0);
          else
            status_byte <= byte_in(6 downto 0);
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
      
  -- Sequential Output
  process(clk, reset, instruction_tick)
  begin
    if(reset = '1') then
      wave_ctrl_b <= "0000";
      note_sel1_b <= "0000000";
      wave_sel1_b <= "00";
      note_sel2_b <= "0000000";
      wave_sel2_b <= "00";
      note_sel3_b <= "0000000";
      wave_sel3_b <= "00";
      note_sel4_b <= "0000000";
      wave_sel4_b <= "00";
      done <= '0';
    elsif(clk'event and clk = '1') then --signal debug : std_logic;
    
      if(update_tick = '1') then
        if(done = '0') then
        
          done <= '1';
    
          if(channel_message = '1') then
            if(note_on = '1') then
              if(wave_ctrl_b(0) = '0') then
                wave_ctrl_b(0) <= '1';
                note_sel1_b    <= note;
              elsif(wave_ctrl_b(1) = '0') then
                wave_ctrl_b(1) <= '1';
                note_sel2_b    <= note;
              elsif(wave_ctrl_b(2) = '0') then
                wave_ctrl_b(2) <= '1';
                note_sel3_b    <= note;
              elsif(wave_ctrl_b(3) = '0') then
                  wave_ctrl_b(3) <= '1';
                  note_sel4_b    <= note;
              end if;            
            elsif(note_off = '1') then
              debug <= '1';
              if(note_sel1_b = note) then
                wave_ctrl_b(0) <= '0';
              end if;
              if(note_sel2_b = note) then
                wave_ctrl_b(1) <= '0';
              end if;
              if(note_sel3_b = note) then
                wave_ctrl_b(2) <= '0';
              end if;
              if(note_sel4_b = note) then
                wave_ctrl_b(3) <= '0';
              end if;  
            else
              debug <= '0';
            end if;
          end if;
        end if;
      else
        done <= '0';
      end if;
    end if;
  end process;
  



      
end Behavioral;

