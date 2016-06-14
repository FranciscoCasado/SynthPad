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
    clk      : in  std_logic;
    reset    : in  std_logic;
    note_sel : in  std_logic_vector(6 downto 0);
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
    clk           : in std_logic;
    reset         : in std_logic;
    byte_in       : in std_logic_vector(7 downto 0);
    tick          : in std_logic;          
    wave_ctrl     : out std_logic_vector(3 downto 0);
    note_sel1     : out std_logic_vector(6 downto 0);
    wave_sel1     : out std_logic_vector(1 downto 0);
    note_sel2     : out std_logic_vector(6 downto 0);
    wave_sel2     : out std_logic_vector(1 downto 0);
    note_sel3     : out std_logic_vector(6 downto 0);
    wave_sel3     : out std_logic_vector(1 downto 0);
    note_sel4     : out std_logic_vector(6 downto 0);
    wave_sel4     : out std_logic_vector(1 downto 0);
    status_out    : out std_logic_vector(7 downto 0);
    note_vel1     : out std_logic_vector(6 downto 0);
    note_vel2     : out std_logic_vector(6 downto 0);
    note_vel3     : out std_logic_vector(6 downto 0);
    note_vel4     : out std_logic_vector(6 downto 0);
    note_on_tick  : out std_logic_vector(3 downto 0);
    note_off_tick : out std_logic_vector(3 downto 0)
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
    led_status    : out std_logic_vector(2 downto 0);
    parameter     : out std_logic_vector(7 downto 0);
    tick          : out std_logic
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
  
  signal status_out : std_logic_vector(7 downto 0);
  
  -- DAC Signals
  signal shift_in  : std_logic_vector(23 downto 0);
  signal shift_out : std_logic_vector(23 downto 0);
  
  -- Vel Multiplier Signals
  signal wave_1_extended : std_logic_vector(17 downto 0);
  signal wave_2_extended : std_logic_vector(17 downto 0);
  signal wave_3_extended : std_logic_vector(17 downto 0);
  signal wave_4_extended : std_logic_vector(17 downto 0);
  
  signal vel1_extended : std_logic_vector(17 downto 0);
  signal vel2_extended : std_logic_vector(17 downto 0);
  signal vel3_extended : std_logic_vector(17 downto 0);
  signal vel4_extended : std_logic_vector(17 downto 0);
  
  signal mult_vel_1_output : std_logic_vector(35 downto 0);
  signal mult_vel_2_output : std_logic_vector(35 downto 0);
  signal mult_vel_3_output : std_logic_vector(35 downto 0);
  signal mult_vel_4_output : std_logic_vector(35 downto 0);
  
  -- ADC - ADSR Signals
  signal adsr_attack  : std_logic_vector(7 downto 0);
  signal adsr_decay   : std_logic_vector(7 downto 0);
  signal adsr_sustain : std_logic_vector(7 downto 0);
  signal adsr_release : std_logic_vector(7 downto 0);
  
  -- MIDI Decoder - ADSR Control Signals
  signal note_on_tick : std_logic_vector(3 downto 0);
  signal note_off_tick : std_logic_vector(3 downto 0);
  
  -- ADSR Generator - Output Signals
  signal adsr_envelope_1 : std_logic_vector(9 downto 0);
  signal adsr_envelope_2 : std_logic_vector(9 downto 0);
  signal adsr_envelope_3 : std_logic_vector(9 downto 0);
  signal adsr_envelope_4 : std_logic_vector(9 downto 0);
  
  signal adsr_envelope_1_extended : std_logic_vector(17 downto 0);
  signal adsr_envelope_2_extended : std_logic_vector(17 downto 0);
  signal adsr_envelope_3_extended : std_logic_vector(17 downto 0);
  signal adsr_envelope_4_extended : std_logic_vector(17 downto 0);
  
  signal adsr_led_status : std_logic_vector(2 downto 0);
  signal adsr_parameter : std_logic_vector(7 downto 0);
  
  -- ADSR Multiplier Signals
  signal mult_adsr_1_output : std_logic_vector(35 downto 0);
  signal mult_adsr_2_output : std_logic_vector(35 downto 0);
  signal mult_adsr_3_output : std_logic_vector(35 downto 0);
  signal mult_adsr_4_output : std_logic_vector(35 downto 0);
  
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
  
begin
  
  adsr_attack  <= ch0_output(9 downto 2);
  adsr_decay   <= ch1_output(9 downto 2);
  adsr_sustain <= ch2_output(9 downto 2);
  adsr_release <= ch3_output(9 downto 2);
  
  LED <= mult_adsr_1_output(35 downto 28);--SW&"11000";--"00000"&adsr_led_status;
    
  lcd_upper <= mult_vel_1_output(35 downto 20);--adsr_attack&adsr_decay;
  lcd_lower <= adsr_envelope_1&"000000";--adsr_sustain&adsr_release;
  
  
  -- Multiplier length compliance
  wave_1_extended <= wave_1&"00000000";
  wave_2_extended <= wave_2&"00000000";
  wave_3_extended <= wave_3&"00000000";
  wave_4_extended <= wave_4&"00000000";

  vel1_extended <= note_vel1&"00000000000";
  vel2_extended <= note_vel2&"00000000000";
  vel3_extended <= note_vel3&"00000000000";
  vel4_extended <= note_vel4&"00000000000";
  
  adsr_envelope_1_extended <= adsr_envelope_1&"00000000";
  adsr_envelope_2_extended <= adsr_envelope_2&"00000000";
  adsr_envelope_3_extended <= adsr_envelope_3&"00000000";
  adsr_envelope_4_extended <= adsr_envelope_4&"00000000";

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
    clk      => clk,
    reset    => reset,
    note_sel => note_sel1,
    wave_sel => wave_sel1, 
    wave_out => wave_1
  );
  
  Inst_voice_unit_2 : voice_unit
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => note_sel2,
    wave_sel => wave_sel2, 
    wave_out => wave_2
  );
  
  Inst_voice_unit_3 : voice_unit
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => note_sel3,
    wave_sel => wave_sel3, 
    wave_out => wave_3
  );
  
  Inst_voice_unit_4 : voice_unit 
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => note_sel4,
    wave_sel => wave_sel4, 
    wave_out => wave_4
  );
  
  Inst_wave_mixer: wave_mixer 
  port map(
    ctrl     => "1111", --decoder_wave_ctrl
    wave_1   => mult_adsr_1_output(35 downto 26),--mult_adsr_1_output(35 downto 26),
    wave_2   => mult_adsr_2_output(35 downto 26),--mult_adsr_2_output(35 downto 26),
    wave_3   => mult_adsr_3_output(35 downto 26),--mult_adsr_3_output(35 downto 26),
    wave_4   => mult_adsr_4_output(35 downto 26),--mult_adsr_4_output(35 downto 26),
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
    clk           => clk,
    reset         => reset,
    byte_in       => uart_byte,
    tick          => uart_done,
    wave_ctrl     => decoder_wave_ctrl,
    note_sel1     => note_sel1,
    wave_sel1     => wave_sel1,
    note_sel2     => note_sel2,
    wave_sel2     => wave_sel2,
    note_sel3     => note_sel3,
    wave_sel3     => wave_sel3,
    note_sel4     => note_sel4,
    wave_sel4     => wave_sel4,
    status_out    => status_out,
    note_vel1     => note_vel1,
    note_vel2     => note_vel2,
    note_vel3     => note_vel3,
    note_vel4     => note_vel4,
    note_on_tick  => note_on_tick,
    note_off_tick => note_off_tick    
  );
  
  Inst_multiplier_vel_1 : multiplier_wave
  port map(
    clk => clk,
    a   => wave_1_extended,
    b   => vel1_extended,
    p   => mult_vel_1_output
  );
  
  Inst_multiplier_vel_2 : multiplier_wave
  port map(
    clk => clk,
    a   => wave_2_extended,
    b   => vel2_extended,
    p   => mult_vel_2_output
  );
  
  Inst_multiplier_vel_3 : multiplier_wave
  port map(
    clk => clk,
    a   => wave_3_extended,
    b   => vel3_extended,
    p   => mult_vel_3_output
  );
  
  Inst_multiplier_vel_4 : multiplier_wave
  port map(
    clk => clk,
    a   => wave_4_extended,
    b   => vel4_extended,
    p   => mult_vel_4_output
  );
  
  Inst_multiplier_adsr_1 : multiplier_wave
  port map(
    clk => clk,
    a   => mult_vel_1_output(35 downto 18),--mult_vel_1_output(35 downto 18),
    b   => adsr_envelope_1_extended,--adsr_envelope_extended_1,
    p   => mult_adsr_1_output
  );
  
  Inst_multiplier_adsr_2 : multiplier_wave
  port map(
    clk => clk,
    a   => mult_vel_2_output(35 downto 18),
    b   => adsr_envelope_2_extended,
    p   => mult_adsr_2_output
  );
  
  Inst_multiplier_adsr_3 : multiplier_wave
  port map(
    clk => clk,
    a   => mult_vel_3_output(35 downto 18),
    b   => adsr_envelope_3_extended,
    p   => mult_adsr_3_output
  );
  
  Inst_multiplier_adsr_4 : multiplier_wave
  port map(
    clk => clk,
    a   => mult_vel_4_output(35 downto 18),
    b   => adsr_envelope_4_extended,
    p   => mult_adsr_4_output
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
  
  Inst_adsr_generator_1: adsr_generator 
  port map(
    clk           => clk,
    reset         => reset,
    note_on_tick  => note_on_tick(0),
    note_off_tick => note_off_tick(0),
    attack        => adsr_attack,
    decay         => adsr_decay,
    sustain       => adsr_sustain,
    release       => adsr_release,
    envelope      => adsr_envelope_1,
    led_status    => adsr_led_status,
    parameter     => adsr_parameter,
    tick => tick
	);
  
  Inst_adsr_generator_2: adsr_generator 
  port map(
    clk           => clk,
    reset         => reset,
    note_on_tick  => note_on_tick(1),
    note_off_tick => note_off_tick(1),
    attack        => adsr_attack,
    decay         => adsr_decay,
    sustain       => adsr_sustain,
    release       => adsr_release,
    envelope      => adsr_envelope_2
	);
  
  Inst_adsr_generator_3: adsr_generator 
  port map(
    clk           => clk,
    reset         => reset,
    note_on_tick  => note_on_tick(2),
    note_off_tick => note_off_tick(2),
    attack        => adsr_attack,
    decay         => adsr_decay,
    sustain       => adsr_sustain,
    release       => adsr_release,
    envelope      => adsr_envelope_3
	);
  
  Inst_adsr_generator_4: adsr_generator 
  port map(
    clk           => clk,
    reset         => reset,
    note_on_tick  => note_on_tick(3),
    note_off_tick => note_off_tick(3),
    attack        => adsr_attack,
    decay         => adsr_decay,
    sustain       => adsr_sustain,
    release       => adsr_release,
    envelope      => adsr_envelope_4
	);

end Behavioral;

