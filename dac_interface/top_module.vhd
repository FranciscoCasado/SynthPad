----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:38:16 02/19/2016 
-- Design Name: 
-- Module Name:    top_module - Behavioral 
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
use IEEE.numeric_std.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
  port(
    SPI_MISO : in std_logic;
		SW       : in std_logic;
		CLK      : in std_logic;          
		SPI_MOSI : out std_logic;
		SPI_SCK  : out std_logic;
		DAC_CS   : out std_logic;
		DAC_CLR  : out std_logic;
    LED      : out std_logic_vector(7 downto 0);
    LCD_E    : out std_logic;
    LCD_RS   : out std_logic;
    LCD_RW   : out std_logic;
    SF_D     : out std_logic_vector(11 downto 8);
    SF_CE0   : out std_logic;
    SPI_SS_B : out std_logic;
    AMP_CS   : out std_logic;
    AD_CONV  : out std_logic;
    FPGA_INIT_B : out std_logic
    );
end top_module;

architecture Behavioral of top_module is

	component dac_interface
	port(
    SPI_MISO : in std_logic;
		data_in  : in std_logic_vector(11 downto 0);
		comm     : in std_logic_vector(3 downto 0);
		addr     : in std_logic_vector(3 downto 0);
		reset    : in std_logic;
		CLK      : in std_logic;          
		SPI_MOSI : out std_logic;
		SPI_SCK  : out std_logic;
		DAC_CS   : out std_logic;
		DAC_CLR  : out std_logic;
    shift_in : out std_logic_vector(23 downto 0);
    shift_out : out std_logic_vector(23 downto 0);
    state_v    : out std_logic_vector(7 downto 0)
		);
	end component;
  
  component lcd_interface
	port(
		clk         : in std_logic;
		rst         : in std_logic;
		upper_screen : in std_logic_vector(15 downto 0);
		lower_screen : in std_logic_vector(15 downto 0);          
		SF_D        : out std_logic_vector(11 downto 8);
		LCD_E       : out std_logic;
		LCD_RS      : out std_logic;
		LCD_RW      : out std_logic;
		SF_CE0      : out std_logic
		);
	end component;

  signal prescaler : unsigned(23 downto 0);
  signal clk_div : std_logic;
  
  signal shift_in : std_logic_vector(23 downto 0);
  signal shift_out : std_logic_vector(23 downto 0);
  signal state : std_logic_vector(7 downto 0);

begin

  LED <= state;

  -- SPI Config
  SPI_SS_B    <= '1';
  AMP_CS      <= '1';
  AD_CONV     <= '0';
  FPGA_INIT_B <= '0';


  process(CLK,SW)
  begin
    if(SW = '1') then
      clk_div <= '0';
    elsif(CLK'EVENT and CLK = '1') then
      if prescaler = X"A00000" then -- default X"03BC20" -- for testing B"000010"
        prescaler   <= (others => '0');
        clk_div   <= not clk_div;
      else
        prescaler <= prescaler + "1";
      end if;
    end if;
  end process;

  Inst_dac_interface: dac_interface port map(
    data_in => "010101010101",
    comm => "0011",
    addr => "0000",
    reset => SW,
    CLK => CLK,
    SPI_MOSI => SPI_MOSI,
    SPI_SCK => SPI_SCK,
    DAC_CS => DAC_CS,
    DAC_CLR => DAC_CLR,
    SPI_MISO => SPI_MISO,
    shift_in => shift_in,
    shift_out => shift_out,
    state_v => state
  );
  
  Inst_lcd_interface: lcd_interface PORT MAP(
    clk => CLK,
    rst => SW,
    upper_screen => shift_in(23 downto 8),
    lower_screen => shift_out(23 downto 8),
    SF_D => SF_D,
    LCD_E => LCD_E,
    LCD_RS => LCD_RS,
    LCD_RW => LCD_RW,
    SF_CE0 => SF_CE0
  );
  


end Behavioral;

