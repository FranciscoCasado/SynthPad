----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:20:25 05/06/2016 
-- Design Name: 
-- Module Name:    synth_top_module - Behavioral 
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

entity synth_top_module is
  port( 
    clk          : in  std_logic;
    reset        : in  std_logic;
    SW           : in  std_logic_vector(2 downto 0);
    rx           : in  std_logic;
    SPI_MISO     : in  std_logic;
    adc_spi_miso : in  std_logic;     
    -- Spartan 3-E DAC
    SPI_MOSI     : out std_logic;
    SPI_SCK      : out std_logic;
    DAC_CS       : out std_logic;
    DAC_CLR      : out std_logic;
    SPI_SS_B     : out std_logic;
    AMP_CS       : out std_logic;
    AD_CONV      : out std_logic;
    FPGA_INIT_B  : out std_logic;
    LED          : out std_logic_vector(7 downto 0);
    -- ADC
    adc_spi_sck  : out std_logic;
    adc_spi_mosi : out std_logic;
    adc_spi_cs   : out std_logic;
    -- LCD
    SF_D         : out std_logic_vector(11 downto 8);
    LCD_E        : out std_logic;
    LCD_RS       : out std_logic;
    LCD_RW       : out std_logic;
    SF_CE0       : out std_logic;
    tick         : out std_logic
  );
end synth_top_module;

architecture Behavioral of synth_top_module is

  component uart_module
  port(
    clk     : in  std_logic;
    reset   : in  std_logic;
    rx      : in  std_logic;          
    data    : out std_logic_vector(7 downto 0);
    tick    : out std_logic;
    rx_done : out std_logic
  );
  end component;
  
  component voice_unit
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
    status_debug   : out std_logic_vector(2 downto 0);
    wave_debug_1   : out std_logic_vector(15 downto 0);
    wave_debug_2   : out std_logic_vector(15 downto 0);
    note_tick_debug : out std_logic
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
  
  component dac_interface
  port(
		SPI_MISO  : in  std_logic;
		data_in   : in  std_logic_vector(11 downto 0);
		comm      : in  std_logic_vector(3 downto 0);
		addr      : in  std_logic_vector(3 downto 0);
		reset     : in  std_logic;
		CLK       : in  std_logic;          
		SPI_MOSI  : out std_logic;
		SPI_SCK   : out std_logic;
		DAC_CS    : out std_logic;
		DAC_CLR   : out std_logic;
		shift_in  : out std_logic_vector(23 downto 0);
		shift_out : out std_logic_vector(23 downto 0);
		state_v   : out std_logic_vector(7 downto 0)
  );
	end component;
  
  component midi_decoder
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
    data_2             : out std_logic_vector(6 downto 0);
    debug              : out std_logic
  );
  end component;
  
  component multiplier_wave
  port(
    clk : in  std_logic;
    a   : in  std_logic_vector(17 downto 0);
    b   : in  std_logic_vector(17 downto 0);
    p   : out std_logic_vector(35 downto 0)
  );
  end component;

  component adc_interface
  port(
    clk        : in std_logic;
    reset      : in std_logic;
    spi_miso   : in std_logic;          
    spi_mosi   : out std_logic;
    spi_sck    : out std_logic;
    spi_cs     : out std_logic;
    ch0_output : out std_logic_vector(9 downto 0);
    ch1_output : out std_logic_vector(9 downto 0);
    ch2_output : out std_logic_vector(9 downto 0);
    ch3_output : out std_logic_vector(9 downto 0);
    ch4_output : out std_logic_vector(9 downto 0);
    ch5_output : out std_logic_vector(9 downto 0);
    ch6_output : out std_logic_vector(9 downto 0);
    ch7_output : out std_logic_vector(9 downto 0);
    shift_in  : out std_logic_vector(9 downto 0)
  );
  end component;
  
  component lcd_interface
  port(
    clk          : in  std_logic;
    rst          : in  std_logic;
    upper_screen : in  std_logic_vector(15 downto 0);
    lower_screen : in  std_logic_vector(15 downto 0);          
    SF_D         : out std_logic_vector(11 downto 8);
    LCD_E        : out std_logic;
    LCD_RS       : out std_logic;
    LCD_RW       : out std_logic;
    SF_CE0       : out std_logic
  );
  end component;
  
  -- UART Signals
  signal uart_byte : std_logic_vector(7 downto 0);
  signal baud_tick : std_logic;
  signal uart_done : std_logic;
  
  -- Voices Signals
  signal note_sel1 : std_logic_vector(6 downto 0);
  signal note_sel2 : std_logic_vector(6 downto 0);
  signal note_sel3 : std_logic_vector(6 downto 0);
  signal note_sel4 : std_logic_vector(6 downto 0);
  
  signal note_vel1 : std_logic_vector(6 downto 0);
  signal note_vel2 : std_logic_vector(6 downto 0);
  signal note_vel3 : std_logic_vector(6 downto 0);
  signal note_vel4 : std_logic_vector(6 downto 0);
  
  signal wave_sel1 : std_logic_vector(1 downto 0);
  signal wave_sel2 : std_logic_vector(1 downto 0);
  signal wave_sel3 : std_logic_vector(1 downto 0);
  signal wave_sel4 : std_logic_vector(1 downto 0);
  
  signal wave_1 : std_logic_vector(9 downto 0);
  signal wave_2 : std_logic_vector(9 downto 0);
  signal wave_3 : std_logic_vector(9 downto 0);
  signal wave_4 : std_logic_vector(9 downto 0);
  
  signal wave_out : std_logic_vector(11 downto 0);
  
  signal decoder_wave_ctrl : std_logic_vector(3 downto 0);
  
  signal voice_status : std_logic_vector(3 downto 0);
  
  -- DAC Signals
  signal shift_in  : std_logic_vector(23 downto 0);
  signal shift_out : std_logic_vector(23 downto 0);
  
  -- ADC - ADSR Signals
  signal adsr_attack  : std_logic_vector(7 downto 0);
  signal adsr_decay   : std_logic_vector(7 downto 0);
  signal adsr_sustain : std_logic_vector(7 downto 0);
  signal adsr_release : std_logic_vector(7 downto 0);
  
  -- MIDI Decoder - ADSR Control Signals
  signal midi_voice_1_ctrl_ticks : std_logic_vector(3 downto 0);
  signal midi_voice_2_ctrl_ticks : std_logic_vector(3 downto 0);
  signal midi_voice_3_ctrl_ticks : std_logic_vector(3 downto 0);
  signal midi_voice_4_ctrl_ticks : std_logic_vector(3 downto 0);
  signal midi_data_1             : std_logic_vector(6 downto 0);
  signal midi_data_2             : std_logic_vector(6 downto 0);
  signal midi_debug : std_logic;


  
  -- ADC 
  signal ch0_output : std_logic_vector(9 downto 0);
  signal ch1_output : std_logic_vector(9 downto 0);
  signal ch2_output : std_logic_vector(9 downto 0);
  signal ch3_output : std_logic_vector(9 downto 0);
  signal ch4_output : std_logic_vector(9 downto 0);
  signal ch5_output : std_logic_vector(9 downto 0);
  signal ch6_output : std_logic_vector(9 downto 0);
  signal ch7_output : std_logic_vector(9 downto 0);
  signal adc_shift_in  : std_logic_vector(9 downto 0);
  
  -- LCD Signals
  signal lcd_upper : std_logic_vector(15 downto 0);
  signal lcd_lower : std_logic_vector(15 downto 0);
  
  signal voice_1_status_debug : std_logic_vector(2 downto 0);
  
  signal wave_debug_1 : std_logic_vector(15 downto 0);
  signal wave_debug_2 : std_logic_vector(15 downto 0);
begin
  
  adsr_attack  <= ch0_output(9 downto 2);
  adsr_decay   <= ch1_output(9 downto 2);
  adsr_sustain <= ch2_output(9 downto 2);
  adsr_release <= ch3_output(9 downto 2);
  
  LED <= midi_debug&midi_data_1;
    
  lcd_upper <= voice_status&"00000"&midi_data_1;
  lcd_lower <= voice_1_status_debug&"000000"&midi_data_2;--uart_byte&byte_debug;--adsr_sustain&adsr_release;

  -- Spartan 3-E DAC SPI Config
  SPI_SS_B    <= '1';
  AMP_CS      <= '1';
  AD_CONV     <= '0';
  FPGA_INIT_B <= '0';


  Inst_uart_module: uart_module 
  port map(
    clk     => clk,
    reset   => reset,
    rx      => rx,
    data    => uart_byte,
    tick    => baud_tick,
    rx_done => uart_done
  );
  
  Inst_voice_unit_1 : voice_unit
  port map(
    clk            => clk,
    reset          => reset,
    data_1         => midi_data_1,
    data_2         => midi_data_2,
    adsr_attack    => adsr_attack,
    adsr_decay     => adsr_decay,
    adsr_sustain   => adsr_sustain,
    adsr_release   => adsr_release,
    voice_on_tick  => midi_voice_1_ctrl_ticks(3),
    voice_off_tick => midi_voice_1_ctrl_ticks(2),
    wave_sel_tick  => midi_voice_1_ctrl_ticks(0),
    ctrl_sel_tick  => midi_voice_1_ctrl_ticks(1), 
    wave_out       => wave_1,
    voice_status   => voice_status(0),
    status_debug   => voice_1_status_debug,
    wave_debug_1     => wave_debug_1,
    wave_debug_2     => wave_debug_2,
    note_tick_debug  => tick
  );
  
    
  
  Inst_voice_unit_2 : voice_unit
  port map(
    clk            => clk,
    reset          => reset,
    data_1         => midi_data_1,
    data_2         => midi_data_2,
    adsr_attack    => adsr_attack,
    adsr_decay     => adsr_decay,
    adsr_sustain   => adsr_sustain,
    adsr_release   => adsr_release,
    voice_on_tick  => midi_voice_2_ctrl_ticks(3),
    voice_off_tick => midi_voice_2_ctrl_ticks(2),
    wave_sel_tick  => midi_voice_2_ctrl_ticks(0),
    ctrl_sel_tick  => midi_voice_2_ctrl_ticks(1), 
    wave_out       => wave_2,
    voice_status   => voice_status(1)
  );
  
  Inst_voice_unit_3 : voice_unit
  port map(
    clk            => clk,
    reset          => reset,
    data_1         => midi_data_1,
    data_2         => midi_data_2,
    adsr_attack    => adsr_attack,
    adsr_decay     => adsr_decay,
    adsr_sustain   => adsr_sustain,
    adsr_release   => adsr_release,
    voice_on_tick  => midi_voice_3_ctrl_ticks(3),
    voice_off_tick => midi_voice_3_ctrl_ticks(2),
    wave_sel_tick  => midi_voice_3_ctrl_ticks(0),
    ctrl_sel_tick  => midi_voice_3_ctrl_ticks(1), 
    wave_out       => wave_3,
    voice_status   => voice_status(2)
  );
  
  Inst_voice_unit_4 : voice_unit 
  port map(
    clk            => clk,
    reset          => reset,
    data_1         => midi_data_1,
    data_2         => midi_data_2,
    adsr_attack    => adsr_attack,
    adsr_decay     => adsr_decay,
    adsr_sustain   => adsr_sustain,
    adsr_release   => adsr_release,
    voice_on_tick  => midi_voice_4_ctrl_ticks(3),
    voice_off_tick => midi_voice_4_ctrl_ticks(2),
    wave_sel_tick  => midi_voice_4_ctrl_ticks(0),
    ctrl_sel_tick  => midi_voice_4_ctrl_ticks(1), 
    wave_out       => wave_4,
    voice_status   => voice_status(3)
  );
  
  Inst_wave_mixer: wave_mixer 
  port map(
    ctrl     => "1111", --decoder_wave_ctrl
    wave_1   => wave_1,
    wave_2   => wave_2,
    wave_3   => wave_3,
    wave_4   => wave_4,
    wave_out => wave_out 
	);
  
  Inst_dac_interface: dac_interface 
  port map(
    data_in   => wave_out,
    comm      => "0011",
    addr      => "1111",
    reset     => reset,
    CLK       => clk,
    SPI_MOSI  => SPI_MOSI,
    SPI_SCK   => SPI_SCK,
    DAC_CS    => DAC_CS,
    DAC_CLR   => DAC_CLR,
    SPI_MISO  => SPI_MISO,
    shift_in  => shift_in,
    shift_out => shift_out
  );
  
  Inst_midi_decoder: midi_decoder 
  port map(
    clk                => clk,
    reset              => reset,
    byte_in            => uart_byte,
    tick               => uart_done,
    voice_status       => voice_status,
    voice_1_ctrl_ticks => midi_voice_1_ctrl_ticks,
    voice_2_ctrl_ticks => midi_voice_2_ctrl_ticks,
    voice_3_ctrl_ticks => midi_voice_3_ctrl_ticks,
    voice_4_ctrl_ticks => midi_voice_4_ctrl_ticks,
    data_1             => midi_data_1,
    data_2             => midi_data_2,
    debug              => midi_debug
  );
    
  Inst_adc_interface: adc_interface 
  port map(
    clk        => clk,
    reset      => reset,
    spi_miso   => adc_spi_miso,
    spi_mosi   => adc_spi_mosi,
    spi_sck    => adc_spi_sck,
    spi_cs     => adc_spi_cs,
    ch0_output => ch0_output,
    ch1_output => ch1_output,
    ch2_output => ch2_output,
    ch3_output => ch3_output,
    shift_in  => adc_shift_in 
  );
    
  Inst_lcd: lcd_interface 
  port map(
    clk          => clk,
    rst          => reset,
    upper_screen => lcd_upper,
    lower_screen => lcd_lower,
    SF_D         => SF_D,
    LCD_E        => LCD_E,
    LCD_RS       => LCD_RS,
    LCD_RW       => LCD_RW,
    SF_CE0       => SF_CE0 
	);
  

end Behavioral;

