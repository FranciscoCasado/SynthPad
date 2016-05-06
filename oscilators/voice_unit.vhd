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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity voice_unit is
  port( 
    clk      : in  std_logic;
    reset    : in  std_logic;
    note_sel : in  std_logic_vector(6 downto 0);
    wave_sel : in  std_logic_vector(1 downto 0);
    wave_out : out std_logic_vector(9 downto 0));
end voice_unit;

architecture Behavioral of voice_unit is

-- Component declarations
  component note_generator
  port(
    clk       : in  std_logic;
    reset     : in  std_logic;
    note_sel  : in  std_logic_vector(6 downto 0);
    note_tick : out std_logic
  );
  end component;
  
  component square_osc
  port(
    clk         : in  std_logic;
    tick        : in  std_logic;
    reset       : in  std_logic;
    wave_out    : out std_logic_vector(9 downto 0)
  );
  end component;
  
  component tri_osc
	port(
		clk      : in  std_logic;
		reset    : in  std_logic;
		tick     : in  std_logic;          
		wave_out : out std_logic_vector(9 downto 0)
		);
	end component;
  
  component saw_osc
	port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    tick     : in  std_logic;          
    wave_out : out std_logic_vector(9 downto 0)
  );
	end component;
    
  component sine_osc
	port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    tick     : in  std_logic;          
    wave_out : out std_logic_vector(9 downto 0)
  );
	end component;

  -- Internal signal declarations
  signal note_tick   : std_logic;
  signal wave_square : std_logic_vector(9 downto 0);
  signal wave_tri    : std_logic_vector(9 downto 0);
  signal wave_saw    : std_logic_vector(9 downto 0);
  signal wave_sine   : std_logic_vector(9 downto 0);

begin

  -- Wave selection
  wave_out <= 
  wave_square when wave_sel = "00" else 
  wave_tri    when wave_sel = "01" else
  wave_saw    when wave_sel = "10" else
  wave_sine   when wave_sel = "11";

  -- Instantiation
  Inst_note_generator: note_generator 
  port map(
    clk       => clk,
    reset     => reset,
    note_sel  => note_sel,
    note_tick => note_tick
  );
  
  Inst_square_osc: square_osc 
  port map(
    clk         => clk,
    tick        => note_tick,
    reset       => reset,
    wave_out    => wave_square
  );

  Inst_tri_osc: tri_osc 
  port map(
    clk      => clk,
    reset    => reset,
    tick     => note_tick,
    wave_out => wave_tri
  );
  
  Inst_saw_osc: saw_osc 
  port map(
		clk      => clk,
		reset    => reset,
		tick     => note_tick,
		wave_out => wave_saw
	);
  
  Inst_sine_osc: sine_osc 
  port map(
    clk      => clk,
    reset    => reset,
    tick     => note_tick,
    wave_out => wave_sine
  );
  
end Behavioral;

