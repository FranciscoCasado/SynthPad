----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:14:06 04/06/2016 
-- Design Name: 
-- Module Name:    voice_oscillator - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity voice_oscillator is
    Port ( clk : in  STD_LOGIC;
           note_freq : in  STD_LOGIC_VECTOR (2 downto 0);
           wave_select : in  STD_LOGIC_VECTOR (1 downto 0);
           wave_out : out  STD_LOGIC_VECTOR (9 downto 0));
end voice_oscillator;

architecture Behavioral of voice_oscillator is

-- Component declarations
  component note_generator
  port(
    clk       : in   std_logic;
    reset     : in   std_logic;
    sw        : in   std_logic;
    note_tick : out  std_logic
    );
  end component;
  
  component osc_square
  port(
    tick : in  STD_LOGIC;
    reset : in  STD_LOGIC;
    wave_square : out  STD_LOGIC_VECTOR (9 downto 0)
    );
  end component;

-- Internal signal declarations

  signal note_tick : std_logic;
  signal sw : std_logic;
  signal reset : std_logic;
  
  signal shift_in : std_logic_vector(23 downto 0);
  signal shift_out : std_logic_vector(23 downto 0);
  signal state : std_logic_vector(7 downto 0);


begin

-- Instantiation
  Inst_note_generator: note_generator port map(
    clk => clk,
    reset => reset,
    sw => '0',
    note_tick => note_tick
  );
  
  
  Inst_osc_square: osc_square port map(
    tick => note_tick,
    reset => reset,
    wave_square => wave_out
  );
end Behavioral;

