----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kenzo Lobos Tsunekawa
-- 
-- Create Date:    19:54:37 02/18/2016 
-- Design Name: 
-- Module Name:    lcd_interface - Behavioral 
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lcd_interface is
    port( 
        clk    		: in std_logic;
        rst    		: in std_logic;
        test_lcd    : in std_logic_vector(13 downto 0);
        test_lcd_wr	: in std_logic_vector(7 downto 0);
        SF_D   		: out std_logic_vector(11 downto 8);
        LCD_E  		: out std_logic; 
        LCD_RS 		: out std_logic; 
        LCD_RW 		: out std_logic;
        SF_CE0 		: out std_logic);
end lcd_interface;

architecture rtl of lcd_interface is

type istate_t is (istep_one, istep_two, istep_three, istep_four, istep_five,
                  istep_six, istep_seven, istep_eight, istep_nine, 
                  function_set, entry_mode, control_display, clear_display, 
                  init_done);

type dstate_t is (didle, set_start_address, write_data_13, write_data_12,
						write_data_11, write_data_10, write_data_9, write_data_8,
						write_data_7, write_data_6, write_data_5, write_data_4,
						write_data_3, write_data_2, write_data_1, write_data_0, 
						address_digit,
						write_digit_wr_7, write_digit_wr_6, write_digit_wr_5,
						write_digit_wr_4, write_digit_wr_3, write_digit_wr_2, 
						write_digit_wr_1, write_digit_wr_0
						); 

signal istate, next_istate   : istate_t;--state and next state of the init. sm
signal dstate, next_dstate   : dstate_t;--state and next state of the display sm
signal idone, next_idone     : std_logic;--initialization done
signal count, next_count     : integer range 0 to 750000;
signal nibble                : std_logic_vector(3 downto 0); 
signal enable, next_enable   : std_logic;--register enable signal put out to LCD_E
signal regsel, next_regsel   : std_logic;--register select signal put out to LCD_RS
signal byte                  : std_logic_vector(7 downto 0); --data to pass to SF_D
signal timer_15ms            : std_logic;
signal timer_4100us          : std_logic;
signal timer_100us           : std_logic;
signal timer_40us            : std_logic; 
signal timer_1640us          : std_logic;
signal txdone, next_txdone   : std_logic;
signal txcount, next_txcount : integer range 0 to 2068;
signal selnibble             : std_logic; 
signal next_selnibble        : std_logic;
signal digit, next_digit     : std_logic_vector(3 downto 0);
signal cnt, next_cnt         : integer range 0 to 50000000;

begin

  -- 
  -- concurrent assignments (LCD interface)
  --
  SF_CE0 <= '1'; --disable intel strataflash memory.
                 --FPGA has full read/write access to LCD.
  LCD_RW <= '0'; --write LCD (LCD accepts data). 
                 --putting LCD_RW=0 also prevent the LCD screen 
                 --from presenting undesired data.
  SF_D   <= nibble;
  LCD_E  <= enable;
  LCD_RS <= regsel;
  
  --
  -- the data_selector choose what data to pass to the LCD
  -- depending on the operation's state of the system
  --
  data_selector: process(istate, dstate, digit)
  begin
    -- the following section of the code is for the
    -- LCD's initialization process so it is always
    -- the same
    case istate is 
      when istep_two | istep_four | istep_six =>
        byte <= X"30"; 
      when istep_eight =>
        byte <= X"20";
      when function_set =>
        byte <= X"28";
      when entry_mode =>
        byte <= X"06";
      when control_display =>
        byte <= X"0C";
      when clear_display =>
        byte <= X"01";
      when others =>
        byte <= (others => '0');
    end case;
    
    -- the following section of code 
    -- needs to be modified depending on what
    -- the user want to display on the screen
    if istate = init_done then
      case dstate is
        when set_start_address =>
          byte <= X"80"; -- first char of first line
        when write_data_13 =>
		    if(test_lcd(13) = '0') then
				byte <= X"30";
			 elsif(test_lcd(13) = '1') then
				byte <= X"31";
			 end if;
        when write_data_12 =>
          if(test_lcd(12) = '0') then
				byte <= X"30";
			 elsif(test_lcd(12) = '1') then
				byte <= X"31";
			 end if;
        when write_data_11 =>
          if(test_lcd(11) = '0') then
				byte <= X"30";
			 elsif(test_lcd(11) = '1') then
				byte <= X"31";
			 end if;
        when write_data_10 =>
          if(test_lcd(10) = '0') then
				byte <= X"30";
			 elsif(test_lcd(10) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_9 =>
          if(test_lcd(9) = '0') then
				byte <= X"30";
			 elsif(test_lcd(9) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_8 =>
          if(test_lcd(8) = '0') then
				byte <= X"30";
			 elsif(test_lcd(8) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_7 =>
          if(test_lcd(7) = '0') then
				byte <= X"30";
			 elsif(test_lcd(7) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_6 =>
          if(test_lcd(6) = '0') then
				byte <= X"30";
			 elsif(test_lcd(6) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_5 =>
          if(test_lcd(5) = '0') then
				byte <= X"30";
			 elsif(test_lcd(5) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_4 =>
          if(test_lcd(4) = '0') then
				byte <= X"30";
			 elsif(test_lcd(4) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_3 =>
          if(test_lcd(3) = '0') then
				byte <= X"30";
			 elsif(test_lcd(3) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_2 =>
          if(test_lcd(2) = '0') then
				byte <= X"30";
			 elsif(test_lcd(2) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_1 =>
          if(test_lcd(1) = '0') then
				byte <= X"30";
			 elsif(test_lcd(1) = '1') then
				byte <= X"31";
			 end if;
		  when write_data_0 =>
          if(test_lcd(0) = '0') then
				byte <= X"30";
			 elsif(test_lcd(0) = '1') then
				byte <= X"31";
			 end if;
        when address_digit =>
          byte <= X"C0"; -- last char of the second line
        when write_digit_wr_7 =>
          if(test_lcd_wr(7) = '0') then
				byte <= X"30";
			 elsif(test_lcd_wr(7) = '1') then
				byte <= X"31";
			 end if;
		  when write_digit_wr_6 =>
          if(test_lcd_wr(6) = '0') then
				byte <= X"30";
			 elsif(test_lcd_wr(6) = '1') then
				byte <= X"31";
			 end if;
		  when write_digit_wr_5 =>
          if(test_lcd_wr(5) = '0') then
				byte <= X"30";
			 elsif(test_lcd_wr(5) = '1') then
				byte <= X"31";
			 end if;
		  when write_digit_wr_4 =>
          if(test_lcd_wr(4) = '0') then
				byte <= X"30";
			 elsif(test_lcd_wr(4) = '1') then
				byte <= X"31";
			 end if;
		  when write_digit_wr_3 =>
          if(test_lcd_wr(3) = '0') then
				byte <= X"30";
			 elsif(test_lcd_wr(3) = '1') then
				byte <= X"31";
			 end if;
		  when write_digit_wr_2 =>
          if(test_lcd_wr(2) = '0') then
				byte <= X"30";
			 elsif(test_lcd_wr(2) = '1') then
				byte <= X"31";
			 end if;
		  when write_digit_wr_1 =>
          if(test_lcd_wr(1) = '0') then
				byte <= X"30";
			 elsif(test_lcd_wr(1) = '1') then
				byte <= X"31";
			 end if;
		  when write_digit_wr_0 =>
          if(test_lcd_wr(0) = '0') then
				byte <= X"30";
			 elsif(test_lcd_wr(0) = '1') then
				byte <= X"31";
			 end if;
        when others => 
          byte <= (others => '0');      
      end case;
    end if;   
   
  end process data_selector;
  
  --
  -- generate a 0 to 9 "running digit" 
  -- the following block increments the digit once every sec. 
  -- at the end of the trasmission of the address of the 
  -- desired display location
  --  
  digit_incr: process (dstate, txdone, digit, cnt)
  begin
    -- by defaukt hold
    next_digit <= digit; -- hold the value
    next_cnt   <= cnt;
   
    if (cnt = 50000000) then
      if (dstate = address_digit and txdone = '1') then
        if digit = X"9" then
          next_digit <= (others => '0');
        else
          next_digit <= digit + 1;
        end if;
        next_cnt <= 0;
      end if;
    else
      next_cnt <= cnt + 1;
    end if;  
    
  end process digit_incr; 
   
 
  --
  -- select what nibble goes to the LCD's  
  -- data interface
  --
  nibble_select: process (selnibble, byte)
  begin
    case selnibble is
      when '0' => -- pass lower nibble
        nibble <= byte(3 downto 0);   
      when '1' => -- pass upper nibble
        nibble <= byte(7 downto 4);
      when others => -- nothing to do  
    end case;
  end process nibble_select;
  
  
  --
  -- After power-on, the display must be initialized to 
  -- a) establish the required communication protocol, and 
  -- b) configure the diplay operation
  --
  -- a) Configuration of the Fout-bit Interface Protocol
  -- The initialization sequence establishes that the FPGA application wishes to use
  -- the four-bit data interface to the LCD as follows:
  --   s1. Wait 15ms or longer, although the display is generally ready when the FPGA 
  --       finishes configuration. The 15ms interval is 750,000 clock cycles at 50 MHz.
  --   s2. Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles.
  --   s3. Wait 4.1 ms or longer, which is 205,000 clock cycles at 50 MHz.
  --   s4. Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles.
  --   s5. Wait 100 ?s or longer, which is 5,000 clock cycles at 50 MHz.
  --   s6. Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles.
  --   s7. Wait 40 ?s or longer, which is 2,000 clock cycles at 50 MHz.
  --   s8. Write SF_D<11:8> = 0x2, pulse LCD_E High for 12 clock cycles.
  --   s9. Wait 40 ?s or longer, which is 2,000 clock cycles at 50 MHz.
  --
  -- b) Display Configuration
  -- The four-bit interface is now established. The next part of the sequence 
  -- configures the display:
  --   s10. Issue a Function Set command, 0x28, to configure the display for operation 
  --        on the Spartan-3E Starter Kit board.
  --   s11. Issue an Entry Mode Set command, 0x06, to set the display to automatically
  --        increment the address pointer.
  --   s12. Issue a Display On/Off command, 0x0C, to turn the display on and disables 
  --        the cursor and blinking.
  --   s13. Issue a Clear Display command, 0x01. 
  --   s14. Allow at least 1.64 ms (82,000 clock cycles) after issuing a clear
  --        display command.
  -- 
  
  --
  -- The design is "partitioned" into 4 blocks:
  -- 1) init_sm
  -- 2) time_m 
  -- 3) display_sm 
  -- 4) tx_m
  --
  
  --
  -- Once power comes on, the init_sm makes sure we go through all the 
  -- necessary steps of the LCD initialization process.
  -- The only purpose of the sm is to control that the system evolve 
  -- properly through the various initialization steps. Besides this task 
  -- the sm doesn't do much. The "real work" is done behind the scenes 
  -- by tx_m and time_m 
  --
  
  init_sm: process (istate, idone, timer_15ms, timer_4100us, timer_100us,
                    timer_40us, timer_1640us, txdone )
  begin
    -- default assignments
    next_istate     <= istate;
    next_idone      <= idone;

    case istate is
      
      when istep_one => -- wait here for 15 ms
        
        if (timer_15ms = '1') then
          next_istate    <= istep_two;
        end if;
        
      when istep_two => -- write nibble (0x3) 

        if (txdone = '1') then 
          next_istate <= istep_three;
        end if;
       
      when istep_three => -- wait here for 4100 us
      
        if (timer_4100us = '1') then
          next_istate    <= istep_four;
        end if;
        
      when istep_four => -- write nibble (0x3) 

        if (txdone = '1') then 
          next_istate  <= istep_five;
        end if;
  
      when istep_five => -- wait here for 100 us
      
        if (timer_100us = '1') then
          next_istate   <= istep_six;
        end if;  
           
      when istep_six => -- write nibble (0x3) 

        if (txdone = '1') then 
          next_istate <= istep_seven;
        end if;  
  
      when istep_seven => -- wait here for 40 us
       
        if (timer_40us = '1') then
          next_istate   <= istep_eight;
        end if;  
            
      when istep_eight => -- write nibble (0x2) 

        if (txdone = '1') then 
          next_istate  <= istep_nine;
        end if;             
      
      when istep_nine => -- wait here for 40 us
       
        if (timer_40us = '1') then
          next_istate   <= function_set;
        end if;     
        
      when function_set => -- istep 10: 
                           -- write data (0x28)  

       if (txdone = '1') then 
         next_istate <= entry_mode;
       end if;
    
      when entry_mode => -- istep 11
                         -- write data 0x06
      
        if (txdone = '1') then 
          next_istate <= control_display;
        end if;
  
      when control_display => -- istep 12 
                              -- enable display, disable cursor, disable blinking
                              -- write data 0x0C
      
        if (txdone = '1') then 
          next_istate <= clear_display;
        end if;
          
      when clear_display => -- istep 13
                            -- write data 0x01
      
        if (txdone = '1') then 
          next_istate <= init_done; -- init. done
        end if;      
      
      when init_done => -- istep 14 
    
        -- the state machine will remain in init_done for good  
      
        -- must wait 1.64 ms after issuing a clear display command 
        if (timer_1640us = '1') then
          next_idone     <= '1';
        end if;
                
      when others => -- nothing to do  
    
    end case;
    
  end process init_sm;
  
  
  -- 
  -- time_m provides all signals needed to correctly "time" the various
  -- LCD's operations
  --
  
  time_m: process(istate, count, idone)
  begin
    --
    -- by default hold the state, keep the counter at rest, and 
    -- hold the timer's outputs low
    --
    next_count   <= count;
    timer_15ms   <= '0'; -- combinational output
    timer_4100us <= '0'; -- combinational output
    timer_100us  <= '0'; -- combinational output
    timer_40us   <= '0'; -- combinational output
    timer_1640us <= '0'; -- combinational output
         
    case istate is
      when istep_one   =>
        next_count <= count + 1;
        if (count = 750000) then
          next_count  <= 0;
          timer_15ms  <= '1';
        end if;  
      when istep_three =>
        next_count <= count + 1;
        if (count = 205000) then
          next_count   <= 0;
          timer_4100us <= '1';
        end if;  
      when istep_five  =>
        next_count <= count + 1;
        if (count = 5000) then
          next_count  <= 0;
          timer_100us <= '1';
        end if;        
      when istep_seven | istep_nine =>
        next_count <= count + 1;
        if (count = 2000) then
          next_count  <= 0;
          timer_40us  <= '1';
        end if;
      when init_done =>
        if (idone = '0') then
          next_count <= count + 1;
        end if;  
        if (count = 82000) then
          next_count   <= 0;
          timer_1640us <= '1';
        end if;          
      when others => -- nothing to do
    end case;
          
  end process time_m;
  
  
  -- 
  -- tx_m generate the control (LCD_E, LCD_RS, LCD_RW, SF_CE0) and data (SF_D) 
  -- signals needed to drive the LCD according to the 4-bit interface protocol 
  -- used by the Spartan 3E starter kit board.
  --
    
  tx_m: process(istate, txcount, byte, selnibble, enable, txdone, 
                idone, dstate)
  begin
    next_selnibble <= selnibble;
    next_txdone    <= txdone;
    next_txcount   <= txcount;
    next_enable    <= enable;
      
    --
    -- the following section of the state machine allow 
    -- to transmit the data necessary for the LCD's
    -- initialization  (which is pretty much the same
    -- no matter what the user what to write on the
    -- display), as well as transmitting the bytes 
    -- needed to display the text the user want to put 
    -- on the screen (which is user specific so it 
    -- will require cutomization) 
    --
    case istate is
      when istep_one | istep_three | istep_seven | istep_nine =>
        next_selnibble <= '1'; -- pass hign nibble
        -- transmit a nibble
      when istep_two | istep_four | istep_six | istep_eight =>
         next_txcount <= txcount + 1;
         if (txcount = 1) then
           next_enable <= '1';
         end if;
         if (txcount = 10) then
           next_enable <= '0';
           next_txdone <= '1';
         end if;
         if (txcount = 11) then
           next_txcount    <= 0;
           next_txdone     <= '0';
           --next we could pass zeros on the SF_D bus
         end if;
       -- transmit a byte  
       when function_set | entry_mode | control_display | 
            clear_display | init_done =>

         -- if we are in init_done the LCD's initialization 
         -- phase is completed so we only need to transmit 
         -- the bytes needed to display the text the user 
         -- want to put on the screen 
         --
         -- the following condition makes sure we can transmit
         -- the bytes needed for initializing the LCD as well        
         -- as the bytes the user need to display the desired 
         -- text on the LCD.
         -- The condition must be customized according
         -- to the user needs
         --  
        
         if (istate /= init_done or 
            (istate = init_done and 
            (dstate = set_start_address or 
             dstate = write_data_13 or 
             dstate = write_data_12 or
             dstate = write_data_11 or 
             dstate = write_data_10 or
				 dstate = write_data_9 or
				 dstate = write_data_8 or
				 dstate = write_data_7 or
				 dstate = write_data_6 or
				 dstate = write_data_5 or
				 dstate = write_data_4 or
				 dstate = write_data_3 or
				 dstate = write_data_2 or
				 dstate = write_data_1 or
				 dstate = write_data_0 or
             dstate = address_digit or
             dstate = write_digit_wr_7 or
				 dstate = write_digit_wr_6 or
				 dstate = write_digit_wr_5 or
				 dstate = write_digit_wr_4 or
				 dstate = write_digit_wr_3 or
				 dstate = write_digit_wr_2 or
				 dstate = write_digit_wr_1 or
				 dstate = write_digit_wr_0
            ))) then
          
           next_txcount <= txcount + 1;
           if (txcount = 1) then
             next_enable <= '1';             
           end if;
           if (txcount = 10) then
             next_enable <= '0';
           end if;
           if (txcount = 11) then
             -- next we could pass zeros on the SF_D bus
           end if;
           -- the timing between the falling edge of the upper nibble's enable 
           -- and the rising edge of the lower nibble's rising edge of an 
           -- operation is 1us (50 clock cycles)
           if (txcount = 58) then    -- 10 + 1 + 50 - 2 = 58
             next_selnibble <= '0'; -- pass lower nibble
           end if;
           if (txcount = 60) then 
             next_enable <= '1';           
           end if;  
           if (txcount = 69) then
             next_enable <= '0';
           end if;
           if(txcount = 70) then -- done with the lower nibble data
             -- next we could pass zeros on the SF_D bus
           end if;
           -- the timing between the falling edge of the lower nibble's enable 
           -- and the rising edge of the upper nibble's rising edge 
           -- of two adjacent operations is 40us (2000 clock cycles)
           if (txcount = 2067) then
             next_txdone <= '1';
           end if;
           if (txcount = 2068) then -- 69 + 1 + 2000 - 2 = 
             next_txcount   <= 0;
             next_txdone    <= '0';
             next_selnibble <= '1'; -- pass upper nibble
           end if;  
         end if;               
       when others => --nothing to do
    end case;         
      
  end process tx_m;
  
  
  --
  -- display state machine
  --
  -- Once the LCD has been properly initialized finally the display sm kicks in and 
  -- it makes possible to display characters on the screen.

  -- The character code to be displayed on the screen are first stored in the Display 
  -- Data RAM (DDRAM).
  -- There are 32 character locations on the display. The upper line of characters 
  -- is stored between addresses 0x00 and 0x0F of the DDRAM. The second line of 
  -- characters is stored between addresses 0x40 and 0x4F of the DDRAM.
  -- The character code stored in a DDRAM location "references" a specific character 
  -- bitmap stored in the predefined Character Generator ROM (CGROM) character set. 
  -- The CGROM contains the font bitmap for each of the predefined characters that 
  -- the LCD screen can display.
  -- The sequence of commands to display characters to the screen is as follows:
  -- 1. Set DDRAM Address command
  --    It sets the initial DDRAM address by initializing an internal address counter. 
  --    The DDRAM address counter either remains constant or auto-increments or 
  --    auto-decrements by one location, as defined by the I/D set bit of the 
  --    entry mode set command.
  -- 2. Write Data to DDRAM command
  --    Write data into DDRAM if the command follows a previous Set DDRAM Address.
  -- 3. Return Cursor Home command
  --    Return the cursor to the home position, the top-left corner. DDRAM contents are
  --    unaffected.
  --  
  -- The specific sequence of commands executed in the state machine depend on the text 
  -- the user want to display on the LCD
  --
  -- the logic to activate the register select signal is placed in this block
  --  
  display_sm: process(dstate, txdone, idone, regsel, txcount)
  begin
   
    -- by default hold state
    next_dstate <= dstate;
    next_regsel <= regsel;
   
    if txcount = 11 then
      next_regsel <= '0';
    end if;  
    if txcount = 58 then
      next_regsel <= idone; --high for active write dstates, low for istates
    end if;
    if txcount = 70 then
      next_regsel <= '0';
    end if;   
   
    case dstate is 
   
      when didle =>
        next_regsel <= '0'; -- must be low for active istates
        if (idone = '1') then
          next_dstate  <= set_start_address;
          next_regsel  <= '0'; -- must be low for address commands
        end if;
      
      when set_start_address => -- start the text at the first
                                -- location of the first line
                                -- of the LCD (0x80)  
        next_regsel <= '0';
        if (txdone = '1') then 
          next_dstate <= write_data_13;
          next_regsel <= '1'; --must be high for write commands
        end if;      

      when write_data_13 => -- V = 0x56       
        if (txdone = '1') then 
          next_dstate <= write_data_12;
          next_regsel <= '1';
        end if;

      when write_data_12 => -- H = 0x48
        if (txdone = '1') then 
          next_dstate <= write_data_11;
          next_regsel <= '1';
        end if;
    
      when write_data_11 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_10;
          next_regsel <= '1';
        end if;
		
		when write_data_10 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_9;
          next_regsel <= '1';
        end if;
		  
		when write_data_9 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_8;
          next_regsel <= '1';
        end if;
		  
		when write_data_8 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_7;
          next_regsel <= '1';
        end if;
		
		when write_data_7 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_6;
          next_regsel <= '1';
        end if;
		  
		when write_data_6 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_5;
          next_regsel <= '1';
        end if;
		  
		when write_data_5 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_4;
          next_regsel <= '1';
        end if;
		  
		when write_data_4 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_3;
          next_regsel <= '1';
        end if;
		  
		when write_data_3 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_2;
          next_regsel <= '1';
        end if;
		
		when write_data_2 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_1;
          next_regsel <= '1';
        end if;
		  
	   when write_data_1 => -- D = 0x44
        if (txdone = '1') then 
          next_dstate <= write_data_0;
          next_regsel <= '1';
        end if;
      
      when write_data_0 => -- L = 0x4C
        if (txdone = '1') then 
          next_dstate <= address_digit;
          next_regsel <= '0';
        end if;
      
      when address_digit => -- 0x80
        next_regsel <= '0';
        if (txdone = '1') then 
          next_dstate <= write_digit_wr_7;
          next_regsel <= '1';
        end if;
      
      when write_digit_wr_7 =>
        if (txdone = '1') then 
          next_dstate <= write_digit_wr_6; --return_home;
          next_regsel <= '1';
        end if;
      
      when write_digit_wr_6 =>
        if (txdone = '1') then 
          next_dstate <= write_digit_wr_5; --return_home;
          next_regsel <= '1';
        end if;
      
      when write_digit_wr_5 =>
        if (txdone = '1') then 
          next_dstate <= write_digit_wr_4; --return_home;
          next_regsel <= '1';
        end if;
      
      when write_digit_wr_4 =>
        if (txdone = '1') then 
          next_dstate <= write_digit_wr_3; --return_home;
          next_regsel <= '1';
        end if;
      
      when write_digit_wr_3 =>
        if (txdone = '1') then 
          next_dstate <= write_digit_wr_2; --return_home;
          next_regsel <= '1';
        end if;
      
      when write_digit_wr_2 =>
        if (txdone = '1') then 
          next_dstate <= write_digit_wr_1; --return_home;
          next_regsel <= '1';
        end if;
      
      when write_digit_wr_1 =>
        if (txdone = '1') then 
          next_dstate <= write_digit_wr_0; --return_home;
          next_regsel <= '1';
        end if;
      
      when write_digit_wr_0 =>
        if (txdone = '1') then 
          next_dstate <= set_start_address; --return_home;
          next_regsel <= '0';
        end if;
		
      
      --when return_home =>
        -- by default the state machine will remain in the 
        -- return_home state for good
        -- NOTE: this is not a "real" return_home command
        --       (see the Spartan 3E starter kit user guide). 
        --       If we know that once we reach this state we 
        --       are not sending anything new to the display 
        --       we can simply stall the sm in this state
      
      when others => -- nothing to do;

    end case;      

  end process display_sm;
  

  registers: process(rst, clk)
  begin
    if rst = '0' then
      istate    <= istep_one;
      dstate    <= didle;
      idone     <= '0';
      count     <=  0;
      txcount   <=  0;
      selnibble <= '1'; -- upper nibble
      enable    <= '0';
      txdone    <= '0';
      regsel    <= '0';
      digit     <= (others => '0');
      cnt       <= 0;
    elsif clk = '1' and clk'event then
      istate    <= next_istate;
      dstate    <= next_dstate;
      idone     <= next_idone;
      count     <= next_count;
      txcount   <= next_txcount;
      selnibble <= next_selnibble;
      enable    <= next_enable;
      txdone    <= next_txdone;
      regsel    <= next_regsel;
      digit     <= next_digit;
      cnt       <= next_cnt;
    end if;
  end process registers;
  

end rtl;

