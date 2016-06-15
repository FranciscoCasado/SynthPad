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
    clk                : in std_logic;
    reset              : in std_logic;
    byte_in            : in std_logic_vector(7 downto 0);
    tick               : in std_logic;
    voice_status       : in std_logic_vector(3 downto 0);
    voice_1_ctrl_ticks : out std_logic_vector(3 downto 0);
    voice_2_ctrl_ticks : out std_logic_vector(3 downto 0);
    voice_3_ctrl_ticks : out std_logic_vector(3 downto 0);
    voice_4_ctrl_ticks : out std_logic_vector(3 downto 0);
    data_1             : out std_logic_vector(6 downto 0);
    data_2             : out std_logic_vector(6 downto 0)
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
  
  signal instruction_tick : std_logic;
  signal CHANNEL_MESSAGE  : std_logic;
  
  signal device_channel : std_logic_vector(3 downto 0) := "0000"; -- Our Device is set to listen to channel 0 !
  signal note     : std_logic_vector(6 downto 0);
  --signal vel      : std_logic_vector(6 downto 0);
  
  -- Voice Notes (neccesary for NOTE_OFF logic)
  signal voice_1_note : std_logic_vector(6 downto 0);
  signal voice_2_note : std_logic_vector(6 downto 0);
  signal voice_3_note : std_logic_vector(6 downto 0);
  signal voice_4_note : std_logic_vector(6 downto 0);
  
  -- Implemented Instruction Set
  signal NOTE_ON        : std_logic;
  signal NOTE_OFF       : std_logic;
  signal PROGRAM_CHANGE : std_logic;
  signal CONTROL_CHANGE : std_logic;
  --signal ALL_VOICES_OFF : std_logic;
  --signal ALL_SOUNDS_OFF : std_logic;
  
  --signal debug : std_logic;
  signal done : std_logic;
  signal prev_intruction_tick : std_logic;
  signal update_tick : std_logic;
begin

  -- Decoding
  status_msb4 <= status_byte(6 downto 4);
  note <= data1_byte(6 downto 0);
  --vel  <= data2_byte(6 downto 0);
  data_1  <= data1_byte(6 downto 0);
  data_2  <= data2_byte(6 downto 0);
  
  --status_out <= note_on&note_off&"00"&wave_ctrl_b;
  
  with status_msb4 select	is_byte_2 <= 
    '0' when "101",
    '0' when "100",
    '1' when others;
  
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
    CHANNEL_MESSAGE <= 
      '0' when "111",
      '1' when others;
      
  with status_byte(6 downto 4) select
    NOTE_ON <=
      '1' when "001",
      '0' when others;
      
  with status_byte(6 downto 4) select
    NOTE_OFF <=
      '1' when "000",
      '0' when others;
  
  with status_byte(6 downto 4) select
    CONTROL_CHANGE <=
      '1' when "011",
      '0' when others;
  
  with status_byte(6 downto 4) select
    PROGRAM_CHANGE <=
      '1' when "100",
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
      voice_1_note <= "0000000";
      voice_2_note <= "0000000";
      voice_3_note <= "0000000";
      voice_4_note <= "0000000";
      voice_1_ctrl_ticks <= "0000";
      voice_2_ctrl_ticks <= "0000";
      voice_3_ctrl_ticks <= "0000";
      voice_4_ctrl_ticks <= "0000";
      
      done <= '0';
      
    elsif(clk'event and clk = '1') then --signal debug : std_logic;
      voice_1_ctrl_ticks <= "0000";
      voice_2_ctrl_ticks <= "0000";
      voice_3_ctrl_ticks <= "0000";
      voice_4_ctrl_ticks <= "0000";
      
      if(update_tick = '1') then
        if(done = '0') then
        
          done <= '1';
    
          if(CHANNEL_MESSAGE = '1') then
            if(NOTE_ON = '1') then
              if(voice_status(0) = '0') then
                voice_1_ctrl_ticks(3) <= '1'; -- 3 is NOTE_ON
                voice_1_note <= note;
              elsif(voice_status(1) = '0') then
                voice_2_ctrl_ticks(3) <= '1'; -- 3 is NOTE_ON
                voice_2_note <= note;
              elsif(voice_status(2) = '0') then
                voice_3_ctrl_ticks(3) <= '1'; -- 3 is NOTE_ON
                voice_3_note <= note;
              elsif(voice_status(3) = '0') then
                voice_4_ctrl_ticks(3) <= '1'; -- 3 is NOTE_ON
                voice_4_note <= note;
              end if;            
            elsif(NOTE_OFF = '1') then
              --debug <= '1';
              if(voice_1_note = note) then
                voice_1_ctrl_ticks(2) <= '1'; -- 2 is NOTE_OFF
              end if;
              if(voice_2_note = note) then
                voice_2_ctrl_ticks(2) <= '1'; -- 2 is NOTE_OFF
              end if;
              if(voice_3_note = note) then
                voice_3_ctrl_ticks(2) <= '1'; -- 2 is NOTE_OFF
              end if;
              if(voice_4_note = note) then
                voice_4_ctrl_ticks(2) <= '1'; -- 2 is NOTE_OFF
              end if;
            elsif(CONTROL_CHANGE = '1') then
              if(data1_byte(6 downto 0) = "1111000" and data2_byte(6 downto 0) = "00000000") then
                voice_1_ctrl_ticks(2) <= '1';
                voice_2_ctrl_ticks(2) <= '1';
                voice_3_ctrl_ticks(2) <= '1';
                voice_4_ctrl_ticks(2) <= '1';
              else  
                voice_1_ctrl_ticks(1) <= '1'; -- 1 is CONTROL_CHANGE
                voice_2_ctrl_ticks(1) <= '1';
                voice_3_ctrl_ticks(1) <= '1';
                voice_4_ctrl_ticks(1) <= '1';
              end if;
            elsif(PROGRAM_CHANGE = '1') then
              voice_1_ctrl_ticks(0) <= '1'; -- 0 is PROGRAM_CHANGE
              voice_2_ctrl_ticks(0) <= '1';
              voice_3_ctrl_ticks(0) <= '1';
              voice_4_ctrl_ticks(0) <= '1';      
            else
              --debug <= '0';
            end if;
          end if;
        end if;
      else
        done <= '0';
      end if;
    end if;
  end process;
  



      
end Behavioral;

