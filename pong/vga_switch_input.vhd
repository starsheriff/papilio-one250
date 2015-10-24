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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_switch_input is
  Port(
    clk : in STD_LOGIC;
    switches: in STD_LOGIC_VECTOR(7 downto 0);
    leds : out STD_LOGIC_VECTOR(7 downto 0);
    
    hsync : out STD_LOGIC;
    vsync : out STD_LOGIC;
    
    red : out STD_LOGIC_VECTOR(2 downto 0);
    green : out STD_LOGIC_VECTOR(2 downto 0);
    blue : out STD_LOGIC_VECTOR(1 downto 0)
    );
end vga_switch_input;

architecture Behavioral of vga_switch_input is
  signal hcount: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
  signal vcount: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
begin
  leds <= switches;
  
  process(clk, hcount)
  begin 
    if rising_edge(clk) then
      if hcount = 799 then
        hcount <= "0000000000";
        if vcount = 524 then
          vcount <= "0000000000";
        else
          vcount <= vcount+1;
        end if;
      else
        hcount <= hcount+1;
      end if;
      
      if (vcount >= 490) and (vcount <= 492) then
        vsync <= '0';
      else
        vsync <= '1';
      end if;
      
      if (hcount >= 656) and (hcount <= 752) then
        hsync <= '0';
      else
        hsync <= '1';
      end if;
      
      if (hcount <= 640) and (vcount <= 480) then
        red <= switches(7 downto 5);
        green <= switches(4 downto 2);
        blue <= switches(1 downto 0);
      else
        red <= "000";
        green <= "000";
        blue <= "00";
      end if;
      
    end if;
  end process;
  


end Behavioral;

