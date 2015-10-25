----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:26:56 10/25/2015 
-- Design Name: 
-- Module Name:    img_gen - Behavioral 
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

entity img_gen is
    Port ( x_pos : in  STD_LOGIC_VECTOR (9 downto 0);
           y_pos : in  STD_LOGIC_VECTOR (9 downto 0);
           clk : in  STD_LOGIC;
           JOY_LEFT: in STD_LOGIC;
           JOY_RIGHT: in STD_LOGIC;
           video_on : in STD_LOGIC;
           rgb : out  STD_LOGIC_VECTOR (7 downto 0));
end img_gen;

architecture Behavioral of img_gen is
  signal x,y : integer range 0 to 800;
  
  signal mux:std_logic_vector(3 downto 0);
  
  signal rgb_transient: STD_LOGIC_VECTOR(7 downto 0);
  
  --wall
  constant wall_l:integer :=10;--the distance between wall and left side of screen
  constant wall_t:integer :=10;--the distance between wall and top side of screen
  constant wall_k:integer :=10;--wall thickness
  signal wall_on:std_logic;
  signal rgb_wall:std_logic_vector(7 downto 0) := "00000000";   
  
  -- bar
  signal bar_l,bar_l_next:integer :=100; --the distance between bar and left side of screen
  constant bar_t:integer :=420;--the distance between bar and top side of screen
  constant bar_k:integer :=10;--bar thickness
  constant bar_w:integer:=120;--bar width
  constant bar_v:integer:=10;--velocity of the bar
  signal bar_on:std_logic;
  --signal rgb_bar:std_logic_vector(2 downto 0); 

  --ball
  signal ball_l,ball_l_next:integer :=100;--the distance between ball and left side of screen
  signal ball_t,ball_t_next:integer :=100; --the distance between ball and top side of screen
  constant ball_w:integer :=20;--ball Height
  constant ball_u:integer :=20;--ball width
  constant x_v,y_v:integer:=3;-- horizontal and vertical speeds of the ball
  signal ball_on:std_logic;
  constant rgb_ball:std_logic_vector(7 downto 0) := "11111000"; 
  
  --refreshing(1/60)
  signal refresh_reg,refresh_next:integer;
  constant refresh_constant:integer:=416666;
  signal refresh_tick:std_logic;  
  
  --ball animation
  signal xv_reg,xv_next:integer:=3;--variable of the horizontal speed
  signal yv_reg,yv_next:integer:=3;--variable of the vertical speed  

  
begin
  x <= to_integer(unsigned(x_pos));
  y <= to_integer(unsigned(y_pos));
  
  --rgb <= "11111111" when x<10 and video_on='1' else
  --  "00000000";
  
  -- refresh
  process(clk)
  begin
    if rising_edge(clk) then
      refresh_reg <= refresh_next;
    end if;
  end process;
  refresh_next <= 0 when refresh_reg=refresh_constant else
    refresh_reg+1;
  refresh_tick <= '1' when refresh_reg=0 else '0';
  
  -- register
  process(clk)
  begin
    if rising_edge(clk) then
      ball_l<=ball_l_next;
      ball_t<=ball_t_next;
      xv_reg<=xv_next;
      yv_reg<=yv_next;
      bar_l<=bar_l_next;    
    end if;
  end process;
  
  -- bar movement
  process(refresh_tick, bar_l, JOY_LEFT, JOY_RIGHT)
  begin
    if rising_edge(refresh_tick) then
      if JOY_LEFT='0' and bar_l > bar_v then
        bar_l_next <= bar_l - bar_v;
      elsif JOY_RIGHT='0' and bar_l < (639-bar_v-bar_w) then
        bar_l_next <= bar_l + bar_v;
      end if;
    
    end if;
  end process;
  
  --ball animation
  process(refresh_tick, ball_l, ball_t, xv_reg, yv_reg)
  begin
    --ball_l_next <= ball_l;
    --ball_t_next <= ball_t;
    --xv_next <= xv_reg;
    --yv_next <= yv_reg;
    
    if rising_edge(refresh_tick) then
      if ball_t> 400 and ball_l > (bar_l -ball_u) and ball_l < (bar_l +120) then
        yv_next <= -y_v; --ball goes up
      elsif ball_t< 35 then
        yv_next <= y_v; --ball goes down
      end if;
      
      if ball_l < 10 then
        xv_next <= x_v;
      elsif ball_l > 600 then
        xv_next <= -x_v;
      end if;
      
      ball_l_next <= ball_l + xv_reg;
      ball_t_next <= ball_t + yv_reg;
    end if;
  end process;
    
  -- (old)wall_on <= '1' when x<10 or x>628 or y<10 or y>440 else '0';
  wall_on <= '1' when x > wall_l and x < (640-wall_l) and y> wall_t and y < (wall_t+ wall_k) else
                      '0'; 
  
  bar_on <= '1' when x > bar_l and x < (bar_l+bar_w) and y> bar_t and y < (bar_t+ bar_k) else
                    '0';

  ball_on <= '1' when x > ball_l and x < (ball_l+ball_u) and y> ball_t and y < (ball_t+ ball_w) else
                     '0'; 
    
  -- multiplexing final output
  mux <= video_on & wall_on & bar_on & ball_on;
  with mux select
    rgb_transient <= "01110110" when "1000", --background
           "11111111" when "1100", --wall
           "11111000" when "1010", --bar
           rgb_ball when "1001", --ball
           "00000000" when others;
  
  
  -- buffering the output
  process(clk)
  begin
    if rising_edge(clk) then
      rgb <= rgb_transient;
    end if;
  end process;

end Behavioral;

