----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:41:24 08/16/2016 
-- Design Name: 
-- Module Name:    vibrato_generator - Behavioral 
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

entity vibrato_generator is
  port(
    clk             : in  std_logic;
    reset           : in  std_logic;
    note_counter    : in  std_logic_vector(15 downto 0);
    time_pot        : in  std_logic_vector(7 downto 0);
    frec_pot        : in  std_logic_vector(7 downto 0);
    vibrato_counter : out std_logic_vector(15 downto 0);
    counter_1_debug : out std_logic_vector(15 downto 0);
    counter_2_debug : out std_logic_vector(15 downto 0);
    vibrato_status  : out std_logic
  );
end vibrato_generator;

architecture Behavioral of vibrato_generator is

  signal min_counter : unsigned(15 downto 0); -- Min & Max Counter are OK
  signal max_counter : unsigned(15 downto 0);
  signal counter     : unsigned(15 downto 0); -- keeps at 1111111111111111
  
  signal internal_max_counter : std_logic_vector(15 downto 0);
  signal internal_counter     : unsigned(17 downto 0) := (others => '0');
  
  signal counter_range : unsigned(15 downto 0);
  signal state : std_logic; -- 0 baja - 1 sube

  signal CLOCKS_PER_INCR : unsigned(17 downto 0);

begin

  vibrato_status <= state;

  min_counter <= SHIFT_RIGHT(UNSIGNED(note_counter), 1);
  
  max_counter <= "1111111111111111" when note_counter(15) = '1' else 
     SHIFT_LEFT(UNSIGNED(note_counter), 1);

  counter_range <= max_counter - min_counter;
  
  --CLOCKS_PER_INCR <= unsigned(time_pot)*counter_range&"0000000000000000000";
  CLOCKS_PER_INCR <= "111111111111111111";--SHIFT_LEFT(unsigned(time_pot), 19)/counter_range;--&"0000000000000000000";

  -- setear CLOCK_PER_INCR = (pot/256)/(time(usually 2)*f_clk)/(f_range(usually 0.5f and 2*f))

  -- dividir por precuencia equals multiplicar por tiempo !

  -- multiplicar por (time(usually 2)*f_clk) es similar a multiplicat por 2^27

  vibrato_counter <= std_logic_vector(counter);

  counter_1_debug <= std_logic_vector(note_counter);
  counter_2_debug <= std_logic_vector(max_counter);

  process(clk, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
      internal_counter <= (others => '0');
      state <= '1';
    elsif(clk'event and clk = '1') then
      internal_counter <= internal_counter + 1;
      
      -- para poder cambiar pot en tiempo real asegurar que el internal counter esta dentro del rango
      
      if(internal_counter >= CLOCKS_PER_INCR) then
        --counter <= counter + 1;
        internal_counter <= (others => '0');
        
        if(state = '0') then
          counter <= counter - 1;
        else
          counter <= counter + 1;
        end if;
        
        if(counter <= min_counter) then
          counter <= min_counter+1;
          state <= '1';
        elsif(counter >= max_counter) then -- logica tri_wave, luego de subir baja xd
          counter <= max_counter-1;
          state <= '0'; 
        end if;
      end if;
    end if;
  end process;

end Behavioral;

