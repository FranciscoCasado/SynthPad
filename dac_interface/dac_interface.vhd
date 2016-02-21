----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kenzo Lobos Tsunekawa
-- 
-- Create Date:    14:00:48 02/19/2016 
-- Design Name: 
-- Module Name:    dac_interface - Behavioral 
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


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dac_interface is
  port ( 
    SPI_MISO : in  std_logic;
    data_in :  in  std_logic_vector(11 downto 0);
    comm :     in  std_logic_vector(3 downto 0);
    addr :     in  std_logic_vector(3 downto 0);
    reset :    in  std_logic;
    CLK :      in  std_logic;
    SPI_MOSI : out std_logic;
    SPI_SCK :  out std_logic;
    DAC_CS :   out std_logic;
    DAC_CLR :  out std_logic;
    shift_in : out std_logic_vector(23 downto 0);
    shift_out : out std_logic_vector(23 downto 0);
    state_v : out std_logic_vector(7 downto 0)
    );
end dac_interface;

architecture Behavioral of dac_interface is

signal clk25 : std_logic := '0';
signal state : unsigned(4 downto 0);
signal next_state : unsigned(4 downto 0);
signal init : std_logic;
signal dac_cs_tmp : std_logic;
signal shift_register : std_logic_vector(23 downto 0);
signal shift_register2 : std_logic_vector(23 downto 0);

begin

  shift_in <= shift_register;
  shift_out <= shift_register2;
  state_v <= "111"&std_logic_vector(state);

  clk25_gen : process(CLK)
  begin
    if CLK'EVENT and CLK = '1' then
      clk25 <= not clk25;   
    end if;
  end process clk25_gen;
  
  state_handler : process(CLK, reset)
  begin
    if reset = '1' then -- reset is active low
      state <= B"00000";
    elsif CLK'EVENT and CLK = '1' then
      if clk25 = '1' then
        state <= next_state;
      end if;
    end if;
  end process state_handler;
  
  state_machine : process(state)
  begin
    case state is
      when "00000" =>   
        next_state <= state + 1;
        init <= '0';
        dac_cs_tmp <= '1';
      when "11000" =>   
        next_state <= (others => '0');
        init <= '1';
        dac_cs_tmp <= '0';
      when others => 
        next_state <= state + 1;
        init <= '1';
        dac_cs_tmp <= '0';
    end case;
  end process state_machine;

  shift_register_proc : process(CLK)
  begin
    if CLK'EVENT and CLK = '1' then
      if init = '1' then
        if clk25 = '1' then
          shift_register <= shift_register(22 downto 0)&shift_register(23);
          shift_register2 <= shift_register2(22 downto 0)&SPI_MISO;
        end if;
      else
        shift_register <= comm & addr & data_in & "0000";
      end if;
    end if;
  end process shift_register_proc;
  
  outputs : process(CLK)
  begin
    if CLK'EVENT and CLK = '1' then
      SPI_MOSI <= shift_register(23);
      DAC_CS <= dac_cs_tmp;
      DAC_CLR <= not reset; -- DAC reset is active low
      SPI_SCK <= clk25 and init;
    end if;
  end process outputs;
  
end Behavioral;

