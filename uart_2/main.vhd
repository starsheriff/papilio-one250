library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity serial_transmitter is 
  Port(
    clk : in  STD_LOGIC;
    data_out : out STD_LOGIC;
    debug_out : out STD_LOGIC
  );
end serial_transmitter;

architecture Behavioral of serial_transmitter is
  signal shiftreg : std_logic_vector(15 downto 0) := "1111111010110100";
  signal counter : std_logic_vector(12 downto 0) := (others => '0');
begin 

  data_out <= shiftreg(0);
  debug_out <= shiftreg(0);
  
  process(clk) 
  begin
   if rising_edge(clk) then
    if counter=3332 then
      shiftreg <= shiftreg(0) & shiftreg(15 downto 1);
      counter <= (others => '0');
    else
      counter <= counter + 1;
    end if; -- counter
   end if; -- rising_edge
  end process;

end Behavioral;
  
