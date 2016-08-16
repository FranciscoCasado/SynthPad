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
    clk            : in  std_logic;
    reset          : in  std_logic;
    data_1         : in  std_logic_vector(6 downto 0);
    data_2         : in  std_logic_vector(6 downto 0);
    adsr_attack    : in  std_logic_vector(7 downto 0);
    adsr_decay     : in  std_logic_vector(7 downto 0);
    adsr_sustain   : in  std_logic_vector(7 downto 0);
    adsr_release   : in  std_logic_vector(7 downto 0);
    voice_on_tick  : in  std_logic;
    voice_off_tick : in  std_logic;
    wave_sel_tick  : in  std_logic;
    ctrl_sel_tick  : in  std_logic;
    wave_out       : out std_logic_vector(9 downto 0);
    voice_status   : out std_logic;
    wave_debug_1   : out std_logic_vector(15 downto 0);
    wave_debug_2   : out std_logic_vector(15 downto 0);
    status_debug   : out std_logic_vector(2 downto 0); 
    note_tick_debug : out std_logic
  );
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
  
  component custom_osc
	port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    tick     : in  std_logic;          
    wave_out : out std_logic_vector(9 downto 0)
  );
	end component;
  
  component multiplier
  port(
    clk : in std_logic;
    a   : in std_logic_vector(17 downto  0);
    b   : in std_logic_vector(17 downto  0);
    p   : out std_logic_vector(35 downto  0)
  );
  end component;

  component adsr_generator
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
    status        : out std_logic_vector(2 downto 0);
    parameter     : out std_logic_vector(7 downto 0);
    tick          : out std_logic
  );
  end component;

  -- Internal signal declarations
  signal note_tick   : std_logic;
  signal wave_square : std_logic_vector(9 downto 0);
  signal wave_tri    : std_logic_vector(9 downto 0);
  signal wave_saw    : std_logic_vector(9 downto 0);
  signal wave_sine   : std_logic_vector(9 downto 0);
  signal wave_custom : std_logic_vector(9 downto 0);
  signal wave        : std_logic_vector(9 downto 0);
  
  -- MIDI Decoder Signals
  signal note     : std_logic_vector(6 downto 0);
  signal vel      : std_logic_vector(6 downto 0);
  signal wave_sel : std_logic_vector(6 downto 0);
  signal control  : std_logic_vector(6 downto 0);
  
  -- Note Velocity Signals
  signal wave_extended   : std_logic_vector(17 downto 0);
  signal vel_extended    : std_logic_vector(17 downto 0);
  signal mult_vel_output : std_logic_vector(35 downto 0);
  signal mult_vel_output_normalized : std_logic_vector(9 downto 0);

  -- ADSR Signals
  signal adst_input_extended    : std_logic_vector(17 downto 0);
  signal adsr_envelope          : std_logic_vector(9 downto 0);
  signal adsr_envelope_extended : std_logic_vector(17 downto 0);
  signal mult_adsr_output       : std_logic_vector(35 downto 0);
  signal adsr_status            : std_logic_vector(2 downto 0);
  
begin

  wave_out <= mult_adsr_output(19 downto 10);
  
  --byte_debug <= adsr_envelope(9 downto 2);
  note_tick_debug <= note_tick;
  status_debug <= adsr_status;

  wave_debug_1 <= wave_sel&"00"&wave_sel;--mult_vel_output(15 downto 0);
  wave_debug_2 <= "000000"&adsr_envelope;--mult_adsr_output(15 downto 0);

  -- Multiplier length compliance
  wave_extended              <= "00000000"&wave;
  vel_extended               <= "00000000"&vel&"000";
  adsr_envelope_extended     <= "00000000"&adsr_envelope;
  mult_vel_output_normalized <= mult_vel_output(19 downto 10);
  adst_input_extended        <= "00000000"&mult_vel_output_normalized;

  -- Wave selection
  wave <= 
    wave_square when wave_sel(2 downto 0) = "000" else 
    wave_tri    when wave_sel(2 downto 0) = "001" else
    wave_saw    when wave_sel(2 downto 0) = "010" else
    wave_sine   when wave_sel(2 downto 0) = "011" else
    wave_custom;

  -- Voice Status
  voice_status <= 
    '0' when adsr_status = "111" else 
    '1';
    
  process(clk, reset)
  begin
    if(reset = '1') then
      note     <= "0000000";
      vel      <= "0000000";
      wave_sel <= "0000000";
    elsif(clk'event and  clk = '1') then
      if(voice_on_tick = '1') then
        note <= data_1;
        vel  <= data_2;
      elsif(wave_sel_tick = '1') then
        wave_sel <= data_1;
      end if;
    end if;
  end process;

  -- Instantiation
  Inst_note_generator: note_generator 
  port map(
    clk       => clk,
    reset     => reset,
    note_sel  => note,
    note_tick => note_tick
  );
  
  Inst_multiplier_vel : multiplier
  port map(
    clk => clk,
    a   => wave_extended,
    b   => vel_extended,
    p   => mult_vel_output
  );
  
  Inst_adsr_generator: adsr_generator 
  port map(
    clk           => clk,
    reset         => reset,
    note_on_tick  => voice_on_tick,
    note_off_tick => voice_off_tick,
    attack        => adsr_attack,
    decay         => adsr_decay,
    sustain       => adsr_sustain,
    release       => adsr_release,
    envelope      => adsr_envelope,
    status        => adsr_status
	);
  
  Inst_multiplier_adsr : multiplier
  port map(
    clk => clk,
    a   => adst_input_extended,
    b   => adsr_envelope_extended,
    p   => mult_adsr_output
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
  
  Inst_custom_osc: custom_osc 
  port map(
    clk      => clk,
    reset    => reset,
    tick     => note_tick,
    wave_out => wave_custom
  );
  
end Behavioral;

