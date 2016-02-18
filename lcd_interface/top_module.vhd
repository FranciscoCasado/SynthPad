----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:57:24 02/18/2016 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
    port( 
        clk    		: in std_logic;
        rst    		: in std_logic;
        SF_D   		: out std_logic_vector(11 downto 8);
        LCD_E  		: out std_logic; 
        LCD_RS 		: out std_logic; 
        LCD_RW 		: out std_logic;
        SF_CE0 		: out std_logic);
end top_module;

architecture Behavioral of top_module is

	component lcd_interface
	port(
        clk         : in std_logic;
        rst         : in std_logic;
        test_lcd    : in std_logic_vector(13 downto 0);
        test_lcd_wr : in std_logic_vector(7 downto 0);          
        SF_D        : out std_logic_vector(11 downto 8);
        LCD_E       : out std_logic;
        LCD_RS      : out std_logic;
        LCD_RW      : out std_logic;
        SF_CE0      : out std_logic);
    end component;

begin

    Inst_lcd_interface: lcd_interface 
    port map(
        clk         => clk ,
        rst         => rst,
        test_lcd    => "11111111111111",
        test_lcd_wr => "00000000",
        SF_D        => SF_D,
        LCD_E       => LCD_E,
        LCD_RS      => LCD_RS,
        LCD_RW      => LCD_RW,
        SF_CE0      => SF_CE0);

end Behavioral;

