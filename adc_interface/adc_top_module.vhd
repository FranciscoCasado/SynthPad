----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:56:54 05/16/2016 
-- Design Name: 
-- Module Name:    adc_top_module - Behavioral 
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

entity adc_top_module is
  port( 
    clk      : in  std_logic;
    reset    : in  std_logic;
    SW       : in  std_logic_vector(2 downto 0);
    spi_miso : in  std_logic;
    spi_mosi : out std_logic;
    spi_sck  : out std_logic;
    spi_cs   : out std_logic;
    LED      : out std_logic_vector(7 downto 0);
    SF_D     : out std_logic_vector(11 downto 8);
    LCD_E    : out std_logic;
    LCD_RS   : out std_logic;
    LCD_RW   : out std_logic;
    SF_CE0   : out std_logic
  );
end adc_top_module;

architecture Behavioral of adc_top_module is

component adc_interface
  port(
    clk        : in  std_logic;
    reset      : in  std_logic;
    spi_miso   : in  std_logic;          
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
    shift_in   : out std_logic_vector(9 downto 0)
  );
end component;

component lcd
  port(
    clk         : in  std_logic;
    rst         : in  std_logic;
    test_lcd    : in  std_logic_vector(15 downto 0);
    test_lcd_wr : in  std_logic_vector(15 downto 0);          
    SF_D        : out std_logic_vector(11 downto 8);
    LCD_E       : out std_logic;
    LCD_RS      : out std_logic;
    LCD_RW      : out std_logic;
    SF_CE0      : out std_logic
  );
end component;
  
  signal reset_lcd   : std_logic;
  signal lcd_instr   : std_logic_vector(15 downto 0);
  signal lcd_wr      : std_logic_vector(15 downto 0);
  
  signal ch0_output : std_logic_vector(9 downto 0);
  signal ch1_output : std_logic_vector(9 downto 0);
  signal ch2_output : std_logic_vector(9 downto 0);
  signal ch3_output : std_logic_vector(9 downto 0);
  signal ch4_output : std_logic_vector(9 downto 0);
  signal ch5_output : std_logic_vector(9 downto 0);
  signal ch6_output : std_logic_vector(9 downto 0);
  signal ch7_output : std_logic_vector(9 downto 0);
  signal shift_in   : std_logic_vector(9 downto 0);
  
  signal spi_mosi_b : std_logic;
  signal spi_sck_b  : std_logic;

begin

  spi_mosi <= spi_mosi_b;
  spi_sck  <= spi_sck_b;
  LED         <= SW&"00001"; --ch0_output(7 downto 0);
  reset_lcd   <= not reset; -- LCD has active low reset
  --data_in_led <= ch0_output&"000000";

--  with SW select data_in_led <=
--    ch0_output&"000000" when "000",
--    ch1_output&"000000" when "001",
--    ch2_output&"000000" when "010",
--   ch3_output&"000000" when "011",
--    ch4_output&"000000" when "100",
--    ch5_output&"000000" when "101",
--    ch6_output&"000000" when "110",
--    ch7_output&"000000" when "111";
    
--  lcd_instr <= ch0_output&"0000" when SW = "000" else 
--     ch1_output&"000001" when SW = "001" else 
--     ch2_output&"000010" when SW = "010" else 
--     ch3_output&"000011" when SW = "011" else
--     ch4_output&"000100" when SW = "100" else
--     ch5_output&"000101" when SW = "101" else
--     ch6_output&"000110" when SW = "110" else
--     ch7_output&"000111" when SW = "111";
     
  lcd_wr <= "1010101010101010";
  lcd_wr <= "1010101010101010";--spi_mosi_b&spi_sck_b&shift_in(9 downto 4);


  Inst_lcd: lcd 
  port map(
    clk         => clk,
    rst         => reset_lcd,
    test_lcd    => lcd_instr,
    test_lcd_wr => lcd_wr,
    SF_D        => SF_D,
    LCD_E       => LCD_E,
    LCD_RS      => LCD_RS,
    LCD_RW      => LCD_RW,
    SF_CE0      => SF_CE0 
	);
  
  Inst_adc_interface: adc_interface 
  port map(
		clk        => clk,
		reset      => reset,
		spi_miso   => spi_miso,
		spi_mosi   => spi_mosi_b,
		spi_sck    => spi_sck_b,
		spi_cs     => spi_cs,
		ch0_output => ch0_output,
		ch1_output => ch1_output,
		ch2_output => ch2_output,
		ch3_output => ch3_output,
		ch4_output => ch4_output,
		ch5_output => ch5_output,
		ch6_output => ch6_output,
		ch7_output => ch7_output,
    shift_in   => shift_in
  );

end Behavioral;

