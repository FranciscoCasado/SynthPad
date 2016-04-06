----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:36:57 04/06/2016 
-- Design Name: 
-- Module Name:    square_osc - Behavioral 
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

entity square_osc is
  port ( 
    clk      : in  std_logic;
    reset    : in  std_logic;
    tick     : in  std_logic;
    data_out : out  std_logic_vector(7 downto 0));
end square_osc;

architecture Behavioral of square_osc is

  signal counter : unsigned(5 downto 0);
  signal state : std_logic;
begin
  
  data_out <= "11111111" when state = '1' else 
     "00000000" when state = '0';
  
  process(clk, tick, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
      state   <= '0';
    elsif(clk'event and clk = '1' and tick = '1') then
      if(counter = 49) then
        counter <= (others => '0');
        state   <= not state;
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;

end Behavioral;

