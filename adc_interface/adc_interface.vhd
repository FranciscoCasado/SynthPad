----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:49:27 05/19/2016 
-- Design Name: 
-- Module Name:    adc_interface - Behavioral 
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

entity adc_interface is
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
    ch7_output : out std_logic_vector(9 downto 0)
  );
end adc_interface;

architecture Behavioral of adc_interface is

  -- ADC requires new clock domain
  signal clk_div : std_logic;
  signal clk_counter : unsigned(6 downto 0);
  
  signal addr : unsigned(2 downto 0) := (others => '0');
  
  type state_type is (s_idle, s_conf, s_addr, s_dontcare, s_data, s_stop);
  signal state, state_next: state_type;
  
  signal addr_counter : unsigned(1 downto 0);
  signal data_counter : unsigned(4 downto 0);
  signal conf_counter : unsigned(1 downto 0);
  
  signal data_out_b : std_logic_vector(9 downto 0);
  signal data_out   : std_logic_vector(9 downto 0);
  
  signal ch0_output_b : std_logic_vector(9 downto 0);
  signal ch1_output_b : std_logic_vector(9 downto 0);
  signal ch2_output_b : std_logic_vector(9 downto 0);
  signal ch3_output_b : std_logic_vector(9 downto 0);
  signal ch4_output_b : std_logic_vector(9 downto 0);
  signal ch5_output_b : std_logic_vector(9 downto 0);
  signal ch6_output_b : std_logic_vector(9 downto 0);
  signal ch7_output_b : std_logic_vector(9 downto 0);

begin
  spi_sck <= clk_div;
  --ch0_output <= data_out(9 downto 2);
  ch0_output <= ch0_output_b;
  ch1_output <= ch1_output_b;
  ch2_output <= ch2_output_b;
  ch3_output <= ch3_output_b;
  ch4_output <= ch4_output_b;
  ch5_output <= ch5_output_b;
  ch6_output <= ch6_output_b;
  ch7_output <= ch7_output_b;
  
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
      if(data_counter = 11) then
        state_next <= s_stop;
      else
        state_next <= s_data;
      end if;
    elsif(state = s_stop) then
      state_next <= s_idle;
    end if;
  end process;
  
  process(clk_div)
  begin
    if(clk_div'event and clk_div = '1') then
      if(state = s_data) then
        data_out_b <= data_out_b(8 downto 0)& spi_miso;
      end if;
    end if;
  end process;
  
  process(clk_div, reset)
  begin
    if(reset = '1') then
      state  <= s_stop;
      spi_cs <= '0';
    elsif(clk_div'event and clk_div = '0') then
      state <= state_next;
      addr_counter <= (others => '0');
      conf_counter <= (others => '0');
      data_counter <= (others => '0');
      spi_cs <= '0';
      
      if(state = s_conf) then
        conf_counter <= conf_counter + 1;
        if(conf_counter = 0) then
          spi_mosi <= '1';
          addr <= addr + 1;
        else
          spi_mosi <= '1';
        end if;
      elsif(state = s_addr) then
        addr_counter <= addr_counter + 1;
        spi_mosi <= addr(to_integer(addr_counter)); --
      elsif(state = s_dontcare) then
        spi_mosi <= '0';
      elsif(state = s_data) then
        data_counter <= data_counter + 1;
      else
        data_out <= data_out_b;
        spi_cs <= '1';
        --ch0_output_b <= "10101010";
        --ch0_output <= data_out_b(9 downto 2);
        if(addr = 0) then
          ch0_output_b <= data_out_b;
        end if;
--        elsif(addr = 1) then
--          ch1_output_b <= data_out_b(9 downto 2);
--        elsif(addr = 2) then
--          ch2_output_b <= data_out_b(9 downto 2);
--        elsif(addr = 3) then
--          ch3_output_b <= data_out_b(9 downto 2);
--        elsif(addr = 4) then
--          ch4_output_b <= data_out_b(9 downto 2);
--        elsif(addr = 5) then
--          ch5_output_b <= data_out_b(9 downto 2);
--        elsif(addr = 6) then
--          ch6_output_b <= data_out_b(9 downto 2);
--        elsif(addr = 7) then
--          ch7_output_b <= data_out_b(9 downto 2);
--        else
--          ch0_output_b <= "10101010";
--        end if;

      end if;
    end if;
  end process;


end Behavioral;

