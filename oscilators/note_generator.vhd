----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:16:15 04/05/2016 
-- Design Name: 
-- Module Name:    note_generator - Behavioral 
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

entity note_generator is
  port ( 
    clk       : in  std_logic;
    reset     : in  std_logic;
    note_sel  : in  std_logic_vector(6 downto 0);
    note_tick : out std_logic);
end note_generator;

architecture Behavioral of note_generator is

  -- Note constants
  constant C1 : unsigned(10 downto 0) := TO_UNSIGNED(1912, 11);
  constant D1 : unsigned(10 downto 0) := TO_UNSIGNED(1702, 11);
  constant E1 : unsigned(10 downto 0) := TO_UNSIGNED(1517, 11);
  constant F1 : unsigned(10 downto 0) := TO_UNSIGNED(1432, 11);
  constant G1 : unsigned(10 downto 0) := TO_UNSIGNED(1276, 11);
  constant A1 : unsigned(10 downto 0) := TO_UNSIGNED(1135, 11);
  constant B1 : unsigned(10 downto 0) := TO_UNSIGNED(1011, 11);
  constant C2 : unsigned(10 downto 0) := TO_UNSIGNED(955, 11);
  
  type MEM is array (127 downto 0) of unsigned(10 downto 0);
  
  
 -- Wave generation
  signal counter     : unsigned(15 downto 0);
  signal max_counter : unsigned(15 downto 0);
  signal map_out : std_logic_vector(15 downto 0);
  
  component note_map
    port(
      clka  : in std_logic;
      wea   : in std_logic_vector(0 downto 0);
      addra : in std_logic_vector(6 downto 0);
      dina  : in std_logic_vector(15 downto 0);
      douta : out std_logic_vector(15 downto 0)
    );
  end component;
  
  
  
  --note_map(0) := TO_UNSIGNED(57724,10);
--note_map(1) := TO_UNSIGNED(54484,10);
--note_map(2) := TO_UNSIGNED(51426,10);
--note_map(3) := TO_UNSIGNED(48540,10);
--note_map(4) := TO_UNSIGNED(45815,10);
--note_map(5) := TO_UNSIGNED(43244,10);
--note_map(6) := TO_UNSIGNED(40817,10);
--note_map(7) := TO_UNSIGNED(38526,10);
--note_map(8) := TO_UNSIGNED(36364,10);
--note_map(9) := TO_UNSIGNED(34323,10);
--note_map(10) := TO_UNSIGNED(32396,10);
--note_map(11) := TO_UNSIGNED(30578,10);
--note_map(12) := TO_UNSIGNED(28862,10);
--note_map(13) := TO_UNSIGNED(27242,10);
--note_map(14) := TO_UNSIGNED(25713,10);
--note_map(15) := TO_UNSIGNED(24270,10);
--note_map(16) := TO_UNSIGNED(22908,10);
--note_map(17) := TO_UNSIGNED(21622,10);
--note_map(18) := TO_UNSIGNED(20408,10);
--note_map(19) := TO_UNSIGNED(19263,10);
--note_map(20) := TO_UNSIGNED(18182,10);
--note_map(21) := TO_UNSIGNED(17161,10);
--note_map(22) := TO_UNSIGNED(16198,10);
--note_map(23) := TO_UNSIGNED(15289,10);
--note_map(24) := TO_UNSIGNED(14431,10);
--note_map(25) := TO_UNSIGNED(13621,10);
--note_map(26) := TO_UNSIGNED(12856,10);
--note_map(27) := TO_UNSIGNED(12135,10);
--note_map(28) := TO_UNSIGNED(11454,10);
--note_map(29) := TO_UNSIGNED(10811,10);
--note_map(30) := TO_UNSIGNED(10204,10);
--note_map(31) := TO_UNSIGNED(9631,10);
--note_map(32) := TO_UNSIGNED(9091,10);
--note_map(33) := TO_UNSIGNED(8581,10);
--note_map(34) := TO_UNSIGNED(8099,10);
--note_map(35) := TO_UNSIGNED(7645,10);
--note_map(36) := TO_UNSIGNED(7215,10);
--note_map(37) := TO_UNSIGNED(6810,10);
--note_map(38) := TO_UNSIGNED(6428,10);
--note_map(39) := TO_UNSIGNED(6067,10);
--note_map(40) := TO_UNSIGNED(5727,10);
--note_map(41) := TO_UNSIGNED(5405,10);
--note_map(42) := TO_UNSIGNED(5102,10);
--note_map(43) := TO_UNSIGNED(4816,10);
--note_map(44) := TO_UNSIGNED(4545,10);
--note_map(45) := TO_UNSIGNED(4290,10);
--note_map(46) := TO_UNSIGNED(4050,10);
--note_map(47) := TO_UNSIGNED(3822,10);
--note_map(48) := TO_UNSIGNED(3608,10);
--note_map(49) := TO_UNSIGNED(3405,10);
--note_map(50) := TO_UNSIGNED(3214,10);
--note_map(51) := TO_UNSIGNED(3034,10);
--note_map(52) := TO_UNSIGNED(2863,10);
--note_map(53) := TO_UNSIGNED(2703,10);
--note_map(54) := TO_UNSIGNED(2551,10);
--note_map(55) := TO_UNSIGNED(2408,10);
--note_map(56) := TO_UNSIGNED(2273,10);
--note_map(57) := TO_UNSIGNED(2145,10);
--note_map(58) := TO_UNSIGNED(2025,10);
--note_map(59) := TO_UNSIGNED(1911,10);
--note_map(60) := TO_UNSIGNED(1804,10);
--note_map(61) := TO_UNSIGNED(1703,10);
--note_map(62) := TO_UNSIGNED(1607,10);
--note_map(63) := TO_UNSIGNED(1517,10);
--note_map(64) := TO_UNSIGNED(1432,10);
--note_map(65) := TO_UNSIGNED(1351,10);
--note_map(66) := TO_UNSIGNED(1276,10);
--note_map(67) := TO_UNSIGNED(1204,10);
--note_map(68) := TO_UNSIGNED(1136,10);
--note_map(69) := TO_UNSIGNED(1073,10);
--note_map(70) := TO_UNSIGNED(1012,10);
--note_map(71) := TO_UNSIGNED(956,10);
--note_map(72) := TO_UNSIGNED(902,10);
--note_map(73) := TO_UNSIGNED(851,10);
--note_map(74) := TO_UNSIGNED(804,10);
--note_map(75) := TO_UNSIGNED(758,10);
--note_map(76) := TO_UNSIGNED(716,10);
--note_map(77) := TO_UNSIGNED(676,10);
--note_map(78) := TO_UNSIGNED(638,10);
--note_map(79) := TO_UNSIGNED(602,10);
--note_map(80) := TO_UNSIGNED(568,10);
--note_map(81) := TO_UNSIGNED(536,10);
--note_map(82) := TO_UNSIGNED(506,10);
--note_map(83) := TO_UNSIGNED(478,10);
--note_map(84) := TO_UNSIGNED(451,10);
--note_map(85) := TO_UNSIGNED(426,10);
--note_map(86) := TO_UNSIGNED(402,10);
--note_map(87) := TO_UNSIGNED(379,10);
--note_map(88) := TO_UNSIGNED(358,10);
--note_map(89) := TO_UNSIGNED(338,10);
--note_map(90) := TO_UNSIGNED(319,10);
--note_map(91) := TO_UNSIGNED(301,10);
--note_map(92) := TO_UNSIGNED(284,10);
--note_map(93) := TO_UNSIGNED(268,10);
--note_map(94) := TO_UNSIGNED(253,10);
--note_map(95) := TO_UNSIGNED(239,10);
--note_map(96) := TO_UNSIGNED(225,10);
--note_map(97) := TO_UNSIGNED(213,10);
--note_map(98) := TO_UNSIGNED(201,10);
--note_map(99) := TO_UNSIGNED(190,10);
--note_map(100) := TO_UNSIGNED(179,10);
--note_map(101) := TO_UNSIGNED(169,10);
--note_map(102) := TO_UNSIGNED(159,10);
--note_map(103) := TO_UNSIGNED(150,10);
--note_map(104) := TO_UNSIGNED(142,10);
--note_map(105) := TO_UNSIGNED(134,10);
--note_map(106) := TO_UNSIGNED(127,10);
--note_map(107) := TO_UNSIGNED(119,10);
--note_map(108) := TO_UNSIGNED(113,10);
--note_map(109) := TO_UNSIGNED(106,10);
--note_map(110) := TO_UNSIGNED(100,10);
--note_map(111) := TO_UNSIGNED(95,10);
--note_map(112) := TO_UNSIGNED(89,10);
--note_map(113) := TO_UNSIGNED(84,10);
--note_map(114) := TO_UNSIGNED(80,10);
--note_map(115) := TO_UNSIGNED(75,10);
--note_map(116) := TO_UNSIGNED(71,10);
--note_map(117) := TO_UNSIGNED(67,10);
--note_map(118) := TO_UNSIGNED(63,10);
--note_map(119) := TO_UNSIGNED(60,10);
--note_map(120) := TO_UNSIGNED(56,10);
--note_map(121) := TO_UNSIGNED(53,10);
--note_map(122) := TO_UNSIGNED(50,10);
--note_map(123) := TO_UNSIGNED(47,10);
--note_map(124) := TO_UNSIGNED(45,10);
--note_map(125) := TO_UNSIGNED(42,10);
--note_map(126) := TO_UNSIGNED(40,10);
--note_map(127) := TO_UNSIGNED(38,10);
  
begin
 -- 100 samples per note
 
 -- Wave generation
  process(clk, reset)
  begin
    if(reset = '1') then
      counter <= (others => '0');
    elsif(clk'event and clk = '1') then
      note_tick <= '0';
      
      if(counter = max_counter) then
        note_tick <= '1';
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
        
    end if;
  end process;

 max_counter <=  UNSIGNED(map_out);
  
  -- Note selection
  --max_counter <= note_map(_note_sel);
  
  Instance_note_map : note_map
  port map(
    clka  => clk,
    wea   => "0",
    addra => note_sel,
    dina  => "0000000000000000",
    douta => map_out
  );

end Behavioral;

