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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity synth_top_module is
  port( 
    clk         : in  std_logic;
    reset       : in  std_logic;
    rx          : in  std_logic;
    SPI_MISO    : in  std_logic;     
    SPI_MOSI    : out std_logic;
		SPI_SCK     : out std_logic;
		DAC_CS      : out std_logic;
		DAC_CLR     : out std_logic;
    SPI_SS_B    : out std_logic;
    AMP_CS      : out std_logic;
    AD_CONV     : out std_logic;
    FPGA_INIT_B : out std_logic;
    LED         : out std_logic_vector(7 downto 0)
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
		SPI_MISO  : in std_logic;
		data_in   : in std_logic_vector(11 downto 0);
		comm      : in std_logic_vector(3 downto 0);
		addr      : in std_logic_vector(3 downto 0);
		reset     : in std_logic;
		CLK       : in std_logic;          
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
    clk       : in std_logic;
    reset     : in std_logic;
    byte_in   : in std_logic_vector(7 downto 0);
    tick      : in std_logic;          
    wave_ctrl : out std_logic_vector(3 downto 0);
    note_sel1 : out std_logic_vector(6 downto 0);
    wave_sel1 : out std_logic_vector(1 downto 0);
    note_sel2 : out std_logic_vector(6 downto 0);
    wave_sel2 : out std_logic_vector(1 downto 0);
    note_sel3 : out std_logic_vector(6 downto 0);
    wave_sel3 : out std_logic_vector(1 downto 0);
    note_sel4 : out std_logic_vector(6 downto 0);
    wave_sel4 : out std_logic_vector(1 downto 0);
    status_out : out std_logic_vector(7 downto 0)
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

begin
  LED <= wave_out(7 downto 0);

  -- SPI Config
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
    ctrl     => decoder_wave_ctrl,
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
    clk       => clk,
    reset     => reset,
    byte_in   => uart_byte,
    tick      => uart_done,
    wave_ctrl => decoder_wave_ctrl,
    note_sel1 => note_sel1,
    wave_sel1 => wave_sel1,
    note_sel2 => note_sel2,
    wave_sel2 => wave_sel2,
    note_sel3 => note_sel3,
    wave_sel3 => wave_sel3,
    note_sel4 => note_sel4,
    wave_sel4 => wave_sel4,
    status_out => status_out 
  );

end Behavioral;

