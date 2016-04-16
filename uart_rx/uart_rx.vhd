
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
generic(
  DBIT    : integer := 8;  -- data bits
  Sbyte_TICK : integer := 16  -- ticks for stop bits
);
port(
  clk,reset    : in std_logic;
  rx           : in std_logic;  -- data line signal
  sample_tick  : in std_logic;  -- over-sampling tick (16 times faster)
  rx_done_tick : out std_logic;  -- 
  dout         : out std_logic_vector(7 downto 0)
);
end uart_rx;

architecture Behavioural of uart_rx is

  -- Signals declaration
  signal sample_reg, sample_next : unsigned(3 downto 0);  -- samples signal
  signal n_reg, n_next : unsigned(2 downto 0);  -- number of bits sampled
  signal byte_reg, byte_next : std_logic_vector(7 downto 0);  -- bytes signal
  signal rx_done : std_logic;

  -- States declaration
  type state_type is(idle, start, data, stop);
  signal state_reg, state_next : state_type;

begin

-- reset logic
process(clk, reset)
begin
  if(reset = '1') then
      state_reg <= idle;
      sample_reg <= (others => '0');
      n_reg <= (others => '0');
      byte_reg <= (others => '0');
  elsif(clk'event and clk = '1') then
      state_reg <= state_next;
      sample_reg <= sample_next;
      n_reg <= n_next;
      byte_reg <= byte_next;
  end if;
end process;

-- Next state logic
process(state_reg, sample_reg, n_reg, byte_reg, sample_tick)
begin
  state_next <= state_reg;
  sample_next <= sample_reg;
  n_next <= n_reg;
  byte_next <= byte_reg;
  rx_done <= '0';
  
  case state_reg is
  
    -- idle : waiting for rx = '0'
    when idle=>
	   if(sample_tick = '1')then
        if rx = '0' then
          state_next <= start;
          sample_next <= (others => '0');
        end if;
		end if;
		
    -- start 
    when start =>
	   if(sample_tick = '1')then
		  if sample_reg = 15 then
		    state_next <= data;
			 sample_next <= (others => '0');
			 n_next <= (others => '0');
		  else
			 sample_next <= sample_reg + 1;
		  end if;
	   end if;
		
    -- data
    when data =>
	   -- sample at every tick
	   if(sample_tick = '1') then
		  if sample_reg = 15 then -- next state condition
			 sample_next <= (others => '0');
			 byte_next <= rx & byte_reg(7 downto 1); -- Rotate right
			 if n_reg = (DBIT - 1) then
			   state_next <= stop;
			 else
			   n_next <= n_reg + 1;
			 end if;
		  else
		    sample_next <= sample_reg + 1;
		  end if;
		end if;
		
	 -- stop	
    when stop =>
	   if(sample_tick = '1') then
		  if sample_reg = (Sbyte_TICK - 1 ) then
			 state_next <= idle;
			 rx_done <= '1';
		  else
			 sample_next <= sample_reg + 1;
		  end if;
		end if;
  end case;
end process;

process(rx_done)
begin
  if (rx_done'event and rx_done = '1') then
    dout <= byte_reg;
  end if;
end process;

rx_done_tick <= rx_done;

end Behavioural;