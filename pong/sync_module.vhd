----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:34:23 10/24/2015 
-- Design Name: 
-- Module Name:    sync_module - Behavioral 
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

entity sync_module is
    Port ( start : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
           x_pos : out  STD_LOGIC_VECTOR(9 downto 0);
           y_pos : out  STD_LOGIC_VECTOR(9 downto 0);
           video_on : out STD_LOGIC);
end sync_module;

architecture Behavioral of sync_module is
  signal hcount, vcount: integer range 0 to 799;
  --signal hsync, vsync: std_logic;
  signal video : std_logic;
  
  signal x_ct : integer range 0 to 640;
begin

  process(clk)
  begin
    if rising_edge(clk) then
      -- resetting counters when end is reached
      if hcount = 799 then
        hcount <= 0;
        if vcount = 524 then
          vcount <= 0;
        else
          vcount <= vcount+1;
        end if;
      else
        hcount <= hcount+1;
      end if;
      
      -- vsync 
      if (vcount >= 490) and (vcount <= 492) then
        vsync <= '0';
      else
        vsync <= '1';
      end if;
      
      -- hsync
      if (hcount >= 656) and (hcount <= 752) then
        hsync <= '0';
      else
        hsync <= '1';
      end if;
      
      -- video signal and position
      if (hcount <= 640) and (vcount <= 480) then
        video_on <= '1';
        x_pos <= std_logic_vector(to_unsigned(hcount, x_pos'length));
        y_pos <= std_logic_vector(to_unsigned(vcount, y_pos'length));
      else
        video_on <= '0';
        x_pos <= std_logic_vector(to_unsigned(0, x_pos'length));
        y_pos <= std_logic_vector(to_unsigned(0, x_pos'length));
      end if;
      
    end if;
  end process;

end Behavioral;

