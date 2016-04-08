----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:25:16 04/07/2016 
-- Design Name: 
-- Module Name:    synth_controller - Behavioral 
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

entity synth_controller is
  port ( 
    clk          : in  std_logic;
    reset        : in  std_logic;
    sw           : in  std_logic_vector(3 downto 0);
    button_north : in  std_logic;
    button_east  : in  std_logic;
    rot_enc_a    : in  std_logic;
    rot_enc_b    : in  std_logic;
    wave_out     : out std_logic_vector(11 downto 0)
  );
end synth_controller;

architecture Behavioral of synth_controller is

  component voice_unit
  port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    note_sel : in  std_logic_vector(2 downto 0);
    wave_sel : in  std_logic_vector(1 downto 0);          
    wave_out : out std_logic_vector(9 downto 0)
  );
  end component;
  
  component wave_mixer
	port(
    ctrl     : in std_logic_vector(3 downto 0);
    wave_1   : in std_logic_vector(9 downto 0);
    wave_2   : in std_logic_vector(9 downto 0);
    wave_3   : in std_logic_vector(9 downto 0);
    wave_4   : in std_logic_vector(9 downto 0);          
    wave_out : out std_logic_vector(11 downto 0)
    );
	end component;
  
  component rotatory_encoder
  port(
    clk       : in std_logic;
    reset     : in std_logic;
    A         : in std_logic;
    B         : in std_logic;          
    direction : out std_logic;
    count     : out std_logic
  );
  end component;
  
  signal wave_1 : std_logic_vector(9 downto 0);
  signal wave_2 : std_logic_vector(9 downto 0);
  signal wave_3 : std_logic_vector(9 downto 0);
  signal wave_4 : std_logic_vector(9 downto 0); 
  
  signal rot_enc_direction : std_logic;
  signal rot_enc_count     : std_logic;
  
  type active_voice_state is (
    voice_1, voice_2, voice_3, voice_4
  );
  
  signal state, state_next : active_voice_state;
  
  signal button_north_prev : std_logic;
  signal button_east_prev  : std_logic;
  
  signal note_sel  : unsigned(2 downto 0);
  signal note_sel1 : unsigned(2 downto 0);
  signal note_sel2 : unsigned(2 downto 0);
  signal note_sel3 : unsigned(2 downto 0);
  signal note_sel4 : unsigned(2 downto 0);
  
  signal wave_sel      : unsigned(1 downto 0);
  signal wave_sel_next : unsigned(1 downto 0);
  signal wave_sel1     : unsigned(1 downto 0);
  signal wave_sel2     : unsigned(1 downto 0);
  signal wave_sel3     : unsigned(1 downto 0);
  signal wave_sel4     : unsigned(1 downto 0);

begin

  -- State machine logic
  process(clk, reset)
  begin
    if(reset = '1') then
      state <= voice_1;
    elsif(clk'event and clk='1') then
        button_north_prev <= button_north;
        if(button_north = '1' and button_north_prev = '0') then
          state <= state_next;
        end if;
    end if;
  end process;

  -- Next State logic
  process(state)
  begin
    if(state = voice_1) then
      state_next <= voice_2;
    elsif(state = voice_2) then
      state_next <= voice_3;
    elsif(state = voice_3) then
      state_next <= voice_4;
    elsif(state = voice_4) then
      state_next <= voice_1;
    end if;
  end process;
  
  -- Wave Selection Next State
  process(wave_sel)
  begin
    wave_sel_next <= wave_sel + 1;
  end process;
  
  -- Wave selection for actual voice
  process(clk, reset)
  begin
    if(reset = '1') then
      wave_sel <= (others => '0'); 
    elsif(clk'event and clk='1') then
      if(button_east = '1' and button_east_prev ='0') then
        wave_sel <= wave_sel_next;
      end if;
    end if;
  end process;
  
  -- Note selection for actual voice
  process(clk, reset)
  begin
    if(reset = '1') then
      note_sel <= (others => '0'); 
    elsif(clk'event and clk='1') then
      button_east_prev <= button_east;
    
      if(button_east = '1' and button_east_prev ='0') then
        
        if(rot_enc_count = '1' and rot_enc_direction = '1') then
          note_sel <= note_sel + 1;
        elsif(rot_enc_count = '1' and rot_enc_direction = '0') then
          note_sel <= note_sel - 1;
        end if; 
      
      end if;
      
    end if;
  end process;  

  process(state, note_sel, wave_sel,
    note_sel1, note_sel2, note_sel3, note_sel4,
    wave_sel1, wave_sel2, wave_sel3, wave_sel4)
  begin
    case state is
      when voice_1 =>
      
        note_sel1 <= note_sel;
        note_sel2 <= note_sel2;
        note_sel3 <= note_sel3;
        note_sel4 <= note_sel4;
        
        wave_sel1 <= wave_sel;
        wave_sel2 <= wave_sel2;
        wave_sel3 <= wave_sel3;
        wave_sel4 <= wave_sel4;
        
      when voice_2 =>
      
        note_sel1 <= note_sel1;
        note_sel2 <= note_sel;
        note_sel3 <= note_sel3;
        note_sel4 <= note_sel4;
        
        wave_sel1 <= wave_sel1;
        wave_sel2 <= wave_sel;
        wave_sel3 <= wave_sel3;
        wave_sel4 <= wave_sel4;
        
      when voice_3 =>
      
        note_sel1 <= note_sel1;
        note_sel2 <= note_sel2;
        note_sel3 <= note_sel;
        note_sel4 <= note_sel4;
        
        wave_sel1 <= wave_sel1;
        wave_sel2 <= wave_sel2;
        wave_sel3 <= wave_sel;
        wave_sel4 <= wave_sel4;
      
      when voice_4 =>
      
        note_sel1 <= note_sel1;
        note_sel2 <= note_sel2;
        note_sel3 <= note_sel3;
        note_sel4 <= note_sel;
        
        wave_sel1 <= wave_sel1;
        wave_sel2 <= wave_sel2;
        wave_sel3 <= wave_sel3;
        wave_sel4 <= wave_sel;
      
      when others =>
      
        note_sel1 <= note_sel1;
        note_sel2 <= note_sel2;
        note_sel3 <= note_sel3;
        note_sel4 <= note_sel4;
        
        wave_sel1 <= wave_sel1;
        wave_sel2 <= wave_sel2;
        wave_sel3 <= wave_sel3;
        wave_sel4 <= wave_sel4;
        
    end case;
  end process;
  
  Inst_voice_unit_1 : voice_unit
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => std_logic_vector(note_sel1),
    wave_sel => std_logic_vector(wave_sel1), 
    wave_out => wave_1
  );
  
  Inst_voice_unit_2 : voice_unit
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => std_logic_vector(note_sel2),
    wave_sel => std_logic_vector(wave_sel2), 
    wave_out => wave_2
  );
  
  Inst_voice_unit_3 : voice_unit
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => std_logic_vector(note_sel3),
    wave_sel => std_logic_vector(wave_sel3), 
    wave_out => wave_3
  );
  
  Inst_voice_unit_4 : voice_unit 
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => std_logic_vector(note_sel4),
    wave_sel => std_logic_vector(wave_sel4), 
    wave_out => wave_4
  );
  
  Inst_wave_mixer: wave_mixer 
  port map(
    ctrl     => sw,
    wave_1   => wave_1,
    wave_2   => wave_2,
    wave_3   => wave_3,
    wave_4   => wave_4,
    wave_out => wave_out 
	);
  
  Inst_rotatory_encoder: rotatory_encoder 
  port map(
    clk       => clk,
    reset     => reset,
    A         => rot_enc_a,
    B         => rot_enc_b,
    direction => rot_enc_direction,
    count     => rot_enc_count
	);

  
end Behavioral;

