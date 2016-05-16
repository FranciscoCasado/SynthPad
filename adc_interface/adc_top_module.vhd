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

  component lcd
  port(
    clk         : in std_logic;
    rst         : in std_logic;
    test_lcd    : in std_logic_vector(13 downto 0);
    test_lcd_wr : in std_logic_vector(7 downto 0);          
    SF_D        : out std_logic_vector(11 downto 8);
    LCD_E       : out std_logic;
    LCD_RS      : out std_logic;
    LCD_RW      : out std_logic;
    SF_CE0      : out std_logic
  );
  end component;

  -- ADC requires new clock domain
  signal clk_div : std_logic;
  signal clk_counter : unsigned(6 downto 0);
  
  signal addr : std_logic_vector(2 downto 0) := "000";
  
  type state_type is (s_idle, s_conf, s_addr, s_dontcare, s_data, s_stop);
  signal state, state_next: state_type;
  
  signal addr_counter : unsigned(1 downto 0);
  signal data_counter : unsigned(3 downto 0);
  signal conf_counter : unsigned(1 downto 0);
  
  signal data_out_b : std_logic_vector(9 downto 0);
  signal data_out   : std_logic_vector(9 downto 0);
  
  signal reset_lcd : std_logic;
  signal data_in_led : std_logic_vector(13 downto 0);

begin

  spi_sck <= clk_div;
  LED <= data_out(9 downto 2);
  reset_lcd <= not reset;
  data_in_led <= data_out(9 downto 0)&"0000";

  -- clock counter process
  process(clk, reset)
  begin
    if(reset = '1') then
      clk_counter <= (others => '0');
    elsif(clk'event and clk = '1') then
      clk_counter <= clk_counter + 1;
    end if;
  end process;

  -- clock div process
  process(clk, reset)
  begin
    if(reset = '1') then
      clk_div <= '0';
    elsif(clk'event and clk = '1') then
      if(to_integer(clk_counter) = 0) then
        clk_div <= not clk_div;
      end if;
    end if;
  end process;
  
  process(state, conf_counter, addr_counter, data_counter)
  begin
    if(state = s_idle) then
      state_next <= s_conf;
    elsif(state = s_conf) then
      if(conf_counter = 1) then
        state_next <= s_addr;
      else
        state_next <= s_conf;
      end if;
    elsif(state = s_addr) then
      if(addr_counter = 2) then
        state_next <= s_dontcare;
      else
        state_next <= s_addr;
      end if;
    elsif(state = s_dontcare) then
      state_next <= s_data;
    elsif(state = s_data) then
      if(data_counter = 9) then
        state_next <= s_stop;
      else
        state_next <= s_data;
      end if;
    elsif(state = s_stop) then
      state_next <= s_idle;
    end if;
  end process;
  
  process(clk_div, reset)
  begin
    if(reset = '1') then
      state  <= s_stop;
      spi_cs <= '0';
    elsif(clk_div'event and clk_div = '1') then
      state <= state_next;
      addr_counter <= (others => '0');
      conf_counter <= (others => '0');
      data_counter <= (others => '0');
      spi_cs <= '0';
      
      if(state = s_conf) then
        conf_counter <= conf_counter + 1;
        if(conf_counter = 0) then
          spi_mosi <= '1';
        else
          spi_mosi <= '1';
        end if;
      elsif(state = s_addr) then
        addr_counter <= addr_counter + 1;
        spi_mosi <= addr(to_integer(addr_counter));
      elsif(state = s_dontcare) then
        spi_mosi <= '0';
      elsif(state = s_data) then
        data_counter <= data_counter + 1;
        data_out_b <= data_out_b(8 downto 0)& spi_miso;
      else
        data_out <= data_out_b;
        spi_cs <= '1';
      end if;
    end if;
  end process;
  
  Inst_lcd: lcd 
  port map(
    clk => clk,
    rst => reset_lcd,
    test_lcd => data_in_led,
    test_lcd_wr => data_out(9 downto 2),
    SF_D => SF_D,
    LCD_E => LCD_E,
    LCD_RS => LCD_RS,
    LCD_RW => LCD_RW,
    SF_CE0 => SF_CE0 
	);

end Behavioral;

