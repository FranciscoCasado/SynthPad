----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:51:46 04/06/2016 
-- Design Name: 
-- Module Name:    osc_square - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity osc_square is
    Port ( tick : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           wave_square : out  STD_LOGIC_VECTOR (9 downto 0));
end osc_square;

architecture Behavioral of osc_square is

 -- Wave generation
  signal counter : unsigned(5 downto 0);
  signal max_counter : unsigned(5 downto 0) := TO_UNSIGNED(50,6); -- 100 samples per note: count up to 100/2
  signal wave : STD_LOGIC_VECTOR(9 downto 0);
  

begin

  wave_square <= wave;

  process(tick, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
    elsif(tick'event and tick = '1') then      
      if(counter = max_counter) then
         wave <= not wave;
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
        
    end if;
  end process;

end Behavioral;

