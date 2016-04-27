----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:49:04 04/27/2016 
-- Design Name: 
-- Module Name:    dout_reg - Behavioral 
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

entity dout_reg is
    Port ( dout : in  STD_LOGIC_VECTOR (7 downto 0);
           rx_done : in  STD_LOGIC;
           data : out  STD_LOGIC_VECTOR (7 downto 0);
			  reset : in std_logic
			  );
end dout_reg;

architecture Behavioral of dout_reg is

begin

process(rx_done, reset)
begin
  if(reset = '1') then
    data <= (others => '0');
  elsif(rx_done'event and rx_done = '1') then
    data <= dout;
  end if;
end process;

end Behavioral;

