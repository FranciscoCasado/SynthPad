----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:25:16 04/07/2016 
-- Design Name: 
-- Module Name:    synth_controller - Behavioral 
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

entity synth_controller is
  port ( 
    clk         : in  std_logic;
    reset       : in  std_logic;
    sw          : in  std_logic_vector(3 downto 0);
    wave_select : in  std_logic;
    note_rot    : in  std_logic;
    wave_out    : out std_logic_vector(11 downto 0));
end synth_controller;

architecture Behavioral of synth_controller is

  component voice_unit
  port(
    clk      : in  std_logic;
    reset    : in  std_logic;
    note_sel : in  std_logic_vector(2 downto 0);
    wave_sel : in  std_logic_vector(1 downto 0);          
    wave_out : out std_logic_vector(9 downto 0)
  );
  end component;
  
  component wave_mixer
	port(
    ctrl     : in std_logic_vector(3 downto 0);
    wave_1   : in std_logic_vector(9 downto 0);
    wave_2   : in std_logic_vector(9 downto 0);
    wave_3   : in std_logic_vector(9 downto 0);
    wave_4   : in std_logic_vector(9 downto 0);          
    wave_out : out std_logic_vector(11 downto 0)
    );
	end component;

begin

  Inst_voice_unit_1 : voice_unit
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => "000",
    wave_sel => "00", 
    wave_out => wave_1
  );
  
  Inst_voice_unit_2 : voice_unit
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => "000",
    wave_sel => "00", 
    wave_out => wave_2
  );
  
  Inst_voice_unit_3 : voice_unit
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => "000",
    wave_sel => "00", 
    wave_out => wave_3
  );
  
  Inst_voice_unit_4 : voice_unit 
  port map(
    clk      => clk,
    reset    => reset,
    note_sel => "000",
    wave_sel => "00", 
    wave_out => wave_4
  );
  
  Inst_wave_mixer: wave_mixer 
  port map(
    ctrl => sw,
    wave_1 => wave_1,
    wave_2 => wave_2,
    wave_3 => wave_3,
    wave_4 => wave_4,
    wave_out => wave_out 
	);
  
end Behavioral;

