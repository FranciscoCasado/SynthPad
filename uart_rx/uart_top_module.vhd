----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:30:42 04/04/2016 
-- Design Name: 
-- Module Name:    uart_top_module - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_top_module is
  port(
    clk   : in  std_logic;
    reset : in  std_logic;
    rx    : in  std_logic;
    LED   : out std_logic_vector(7 downto 0)
  );
end uart_top_module;

architecture Behavioral of uart_top_module is

 component uart_rx
  port(
    clk          : in   std_logic;
    reset        : in   std_logic;
    rx           : in   std_logic;
    s_tick       : in   std_logic;
    rx_done_tick : out  std_logic;
    dout         : out  std_logic_vector(7 downto 0);
    debug_state  : out  std_logic_vector(7 downto 0)
  );
  end component;
    
  component baudrate_generator
	port(
    clk  : in  std_logic;
    rst  : in  std_logic;          
    tick : out std_logic
    );
  end component;
  
  signal s_tick : std_logic;
  signal rx_done_tick : std_logic;
  
  signal uart_out : std_logic_vector(7 downto 0);
  
  signal state : std_logic;
  signal counter : unsigned(26 downto 0);
begin

  process(clk,reset)
  begin
    if(reset = '1') then
      LED <= "11111111";
    else
      if(clk'event and clk = '1') then
        if(state = '1') then
          counter <= counter + 1;
        end if;
        
        if(counter = 0 and state = '1') then
          state <= '0';
        elsif(state = '0' and rx = '0') then
          state <= '1';
        end if;
      
        LED <= rx&s_tick&rx_done_tick&uart_out(4 downto 0);
      end if;
      
    end if;
  end process;

  Inst_baudrate_generator: baudrate_generator 
  PORT MAP(
    clk  => clk,
    rst  => reset, 
    tick => s_tick
	);
  
  Inst_uart_rx : uart_rx 
  port map (
    clk          => clk,
    reset        => reset,
    rx           => rx,
    s_tick       => s_tick,
    rx_done_tick => rx_done_tick,
    dout         => uart_out,
    debug_state  => 
  );

end Behavioral;

