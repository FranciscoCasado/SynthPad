----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:15:06 05/24/2016 
-- Design Name: 
-- Module Name:    adsr_generator - Behavioral 
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

entity adsr_generator is
  port( 
    clk           : in  std_logic;
    reset         : in  std_logic;
    note_on_tick  : in  std_logic;
    note_off_tick : in  std_logic;
    attack        : in  std_logic_vector(7 downto 0);
    decay         : in  std_logic_vector(7 downto 0);
    sustain       : in  std_logic_vector(7 downto 0);
    release       : in  std_logic_vector(7 downto 0);
    envelope      : out std_logic_vector(9 downto 0);
    led_status    : out std_logic_vector(2 downto 0);
    parameter     : out std_logic_vector(7 downto 0);
    tick          : out std_logic
  );
end adsr_generator;

architecture Behavioral of adsr_generator is

  type env_state is (
    state_idle, state_attack, state_decay, state_sustain, state_release
  );
  
  signal state, state_next : env_state;
  signal envelope_b : unsigned(9 downto 0);
  
  signal attack_b  : std_logic_vector(7 downto 0);
  signal decay_b   : std_logic_vector(7 downto 0);
  signal release_b : std_logic_vector(7 downto 0);
  signal sustain_b : std_logic_vector(9 downto 0);
  
  signal attack_u  : unsigned(7 downto 0);
  signal decay_u   : unsigned(7 downto 0);
  signal release_u : unsigned(7 downto 0);
  signal sustain_u : unsigned(9 downto 0);
  
  signal counter         : unsigned(17 downto 0);
  signal counter_limit   : std_logic_vector(17 downto 0);
  signal counter_limit_u : unsigned(17 downto 0);
  signal counter_tick : std_logic;

begin
  tick <= counter_tick;

  envelope  <= std_logic_vector(envelope_b);
  attack_u  <= unsigned(attack_b);
  decay_u   <= unsigned(decay_b);
  release_u <= unsigned(release_b);
  sustain_u <= unsigned(sustain_b);

  with state select led_status <= 
    "000" when state_attack,
    "001" when state_decay,
    "010" when state_sustain,
    "011" when state_release,
    "111" when others;
  
  parameter <= counter_limit(17 downto 10);
  --with state select parameter <= 
   -- attack_b   when state_attack,
  --  decay_b    when state_decay,
  --  sustain_b(9 downto 2)  when state_sustain,
  --  release_b  when state_release,
  --  "11001100" when others;
    
  with state select counter_limit <= 
    attack_b&"0000000000"   when state_attack,
    decay_b&"0000000000"    when state_decay,
    sustain_b(9 downto 2)&"0000000000"  when state_sustain,
    release_b&"0000000000"  when state_release,
    "111111111111111111" when others;
  
  -- Next State Sequential Logic
  process(clk, reset)
  begin
    if(reset = '1') then
      state <= state_idle;
    elsif(clk'event and clk = '1') then
      if(note_on_tick = '1') then
        state <= state_attack;
        attack_b  <= attack;
        decay_b   <= decay;
        release_b <= release;
        sustain_b <= sustain&"00";
      elsif(note_off_tick = '1') then
        state <= state_release;
      else
        state <= state_next;
      end if;
    end if;
  end process;

  -- Next State Combinatorial Logic
  process(state, envelope_b)
  begin
    if(state = state_idle) then
      state_next <= state_idle;
    elsif(state = state_attack) then
      if(envelope_b = "1111111111") then
        state_next <= state_decay;
      else
        state_next <= state_attack;
      end if;
    elsif(state = state_decay) then
      if(envelope_b = sustain_u) then
        state_next <= state_sustain;
      else
        state_next <= state_decay;
      end if;
    elsif(state = state_sustain) then
      state_next <= state_sustain;
    elsif(state = state_release) then
      if(envelope_b = "0000000000") then
        state_next <= state_idle;
      else
        state_next <= state_release;
      end if;
    end if;
  end process;

  -- Counter Loop Process
  process(clk, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
    elsif(clk'event and clk = '1') then
      counter <= counter + 1;
      counter_tick <= '0';
      if(counter = unsigned(counter_limit)) then --100
        counter <= (others => '0');
        counter_tick <= '1';
      end if;
    end if;
  end process;

  -- Envelope Generation
  process(clk, reset)
  begin
    if(reset = '1') then
      envelope_b <= (others => '0');
    elsif(clk'event and clk = '1') then
        if(state = state_attack) then
          if(counter_tick = '1') then
            envelope_b <= envelope_b + 1;
          end if;
        elsif(state = state_decay) then
          if(counter_tick = '1') then
            envelope_b <= envelope_b - 1;
          end if;
        elsif(state = state_release) then
          if(counter_tick = '1') then
            envelope_b <= envelope_b - 1; --
          end if;
        elsif(state = state_idle) then
          envelope_b <= "0000000000";
        end if;
    end if;
  end process;

end Behavioral;

