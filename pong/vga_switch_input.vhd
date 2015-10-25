----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:31:09 10/18/2015 
-- Design Name: 
-- Module Name:    vga_switch_input - Behavioral 
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_switch_input is
  Port(
    clk : in STD_LOGIC;
    switches: in STD_LOGIC_VECTOR(7 downto 0);
    leds : out STD_LOGIC_VECTOR(7 downto 0);
    
    JOY_LEFT: in STD_LOGIC;
    JOY_RIGHT: in STD_LOGIC;
    
    hsync : out STD_LOGIC;
    vsync : out STD_LOGIC;
    
    red : out STD_LOGIC_VECTOR(2 downto 0);
    green : out STD_LOGIC_VECTOR(2 downto 0);
    blue : out STD_LOGIC_VECTOR(1 downto 0)
    );
end vga_switch_input;

architecture Behavioral of vga_switch_input is
  --signal hcount: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
  --signal vcount: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');  
  signal x_pos, y_pos: STD_LOGIC_VECTOR(9 downto 0);
  signal rgb: STD_LOGIC_VECTOR(7 downto 0);
  --signal x_pos: integer range 0 to 799;
  signal video_on: STD_LOGIC;
  
  COMPONENT sync_module
    Port ( start : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
           x_pos : out  STD_LOGIC_VECTOR(9 downto 0);
           y_pos : out  STD_LOGIC_VECTOR(9 downto 0);
           video_on : out STD_LOGIC);
  END COMPONENT;
  
  COMPONENT img_gen
    Port ( x_pos : in  STD_LOGIC_VECTOR (9 downto 0);
           y_pos : in  STD_LOGIC_VECTOR (9 downto 0);
           clk : in  STD_LOGIC;
           JOY_LEFT: in STD_LOGIC;
           JOY_RIGHT: in STD_LOGIC;
           video_on : in STD_LOGIC;
           rgb : out  STD_LOGIC_VECTOR (7 downto 0));
  END COMPONENT;
  
  
begin 
  Isync_module : sync_module
    PORT MAP (
      clk => clk, start => '0', reset => '0',
      hsync => hsync, vsync => vsync,
      x_pos => x_pos, y_pos => y_pos, 
      video_on => video_on);
      
  Iimg_gen : img_gen
    PORT MAP (
      x_pos => x_pos, y_pos => y_pos, clk => clk,
      video_on => video_on, rgb => rgb, 
      JOY_LEFT => JOY_LEFT, JOY_RIGHT => JOY_RIGHT);
      
  leds <= switches;
  
  red <= rgb(7 downto 5);
  green <= rgb(4 downto 2);
  blue <= rgb(1 downto 0);
  --red <= "000" when (video_on = '0')  else 
  --  switches(7 downto 5);
  --green <= "000" when video_on = '0' else
  --  switches(4 downto 2);
  --blue <= "00" when video_on = '0' else
  --  switches(1 downto 0);

end Behavioral;

