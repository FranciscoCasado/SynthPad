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
    clk           : in  std_logic;
    reset         : in  std_logic;
    note_sel      : in  std_logic_vector(6 downto 0);
    vibrato_time  : in  std_logic_vector(7 downto 0);
    vibrato_depth : in  std_logic_vector(7 downto 0);
    note_tick     : out std_logic;
    counter_1_debug : out std_logic_vector(15 downto 0);
    counter_2_debug : out std_logic_vector(15 downto 0);
    vibrato_status : out std_logic
  );
end note_generator;

architecture Behavioral of note_generator is

  -- Note constants
  constant C1 : unsigned(10 downto 0) := TO_UNSIGNED(1912, 11);
  constant D1 : unsigned(10 downto 0) := TO_UNSIGNED(1702, 11);
  constant E1 : unsigned(10 downto 0) := TO_UNSIGNED(1517, 11);
  constant F1 : unsigned(10 downto 0) := TO_UNSIGNED(1432, 11);
  constant G1 : unsigned(10 downto 0) := TO_UNSIGNED(1276, 11);
  constant A1 : unsigned(10 downto 0) := TO_UNSIGNED(1135, 11);
  constant B1 : unsigned(10 downto 0) := TO_UNSIGNED(1011, 11);
  constant C2 : unsigned(10 downto 0) := TO_UNSIGNED(955, 11);
  
  --type MEM is array (127 downto 0) of unsigned(10 downto 0);
  
  
 -- Wave generation
  signal counter         : unsigned(15 downto 0) := (others => '0');
  signal max_counter     : unsigned(15 downto 0);
  signal map_out         : std_logic_vector(15 downto 0);
  signal vibrato_counter : std_logic_vector(15 downto 0);
  signal counter_raw     : std_logic_vector(15 downto 0);
  
  component note_map
    port(
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(6 downto 0);
      dina  : in  std_logic_vector(15 downto 0);
      douta : out std_logic_vector(15 downto 0)
    );
  end component;
  
  component vibrato_generator
	port(
    clk             : in  std_logic;
    reset           : in  std_logic;
    note_counter    : in  std_logic_vector(15 downto 0);
    time_pot        : in  std_logic_vector(7 downto 0);
    frec_pot        : in  std_logic_vector(7 downto 0);          
    vibrato_counter : out std_logic_vector(15 downto 0);
    counter_1_debug : out std_logic_vector(15 downto 0);
    counter_2_debug : out std_logic_vector(15 downto 0);
    vibrato_status : out std_logic
  );
  end component;

  
begin
 -- 100 samples per note
 
 -- Wave generation
  process(clk, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
    elsif(clk'event and clk = '1') then
      note_tick <= '0';
      
      if(counter >= max_counter) then
        note_tick <= '1';
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
        
    end if;
  end process;

  counter_raw <= map_out;
  --max_counter <= UNSIGNED(map_out); 
  max_counter <= UNSIGNED(vibrato_counter);
  --counter_1_debug <= std_logic_vector(vibrato_counter);
  --counter_2_debug <= std_logic_vector(counter);
  
  -- Note selection
  --max_counter <= note_map(_note_sel);
  
  Instance_note_map : note_map
  port map(
    clka  => clk,
    wea   => "0",
    addra => note_sel,
    dina  => "0000000000000000",
    douta => map_out
  );
  
  Inst_vibrato_generator: vibrato_generator 
  port map(
    clk             => clk,
    reset           => reset,
    note_counter    => counter_raw,
    time_pot        => "11111111",
    frec_pot        => "00000001",
    vibrato_counter => vibrato_counter,
    counter_1_debug => counter_1_debug,
    counter_2_debug => counter_2_debug,
    vibrato_status => vibrato_status
	);

end Behavioral;

