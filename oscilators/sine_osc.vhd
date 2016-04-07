----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:54:20 04/06/2016 
-- Design Name: 
-- Module Name:    sine_osc - Behavioral 
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

entity sine_osc is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tic : in  STD_LOGIC;
           wave_out : out  STD_LOGIC_VECTOR (9 downto 0));
end sine_osc;

architecture Behavioral of sine_osc is

begin


end Behavioral;

