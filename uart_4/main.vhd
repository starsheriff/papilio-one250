library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity serial_transmitter is 
  Port(
    clk : in  STD_LOGIC;
    data_out : out STD_LOGIC;
    switches : in STD_LOGIC_VECTOR(7 downto 0);
    leds : out STD_LOGIC_VECTOR(7 downto 0);
    JOY_PUSH : in STD_LOGIC
  );
end serial_transmitter;

architecture Behavioral of serial_transmitter is
  signal data_shiftreg : std_logic_vector(9 downto 0) := (others => '1');
  signal busy_shiftreg : std_logic_vector(9 downto 0) := (others => '0');
  signal counter : std_logic_vector(12 downto 0) := (others => '0');
  signal data_byte : std_logic_vector(7 downto 0) := (others => '1');
  --signal data_buf : std_logic_vector(7 downto 0) := (others => '0');
  signal send : std_logic := '0';
  signal sig_old : std_logic := '0';

begin 

  data_out <= data_shiftreg(0);
  --debug_out <= shiftreg(0);
  leds <= switches;
  send <= not JOY_PUSH;
  data_byte <= switches;

  
  process(clk) 
  begin
    if rising_edge(clk) then
      if busy_shiftreg(0) = '0' then
        sig_old <= send;
        if sig_old='0' and send='1' then      
          -- least significant bit is 0 indicating that the line is free
          -- now set the whole shiftregister to 1, indicating that the line is busy
          busy_shiftreg <= (others => '1'); 
          data_shiftreg <= '1' & data_byte & '0';
          counter <= (others => '0');
        end if;
      else
        if counter=3332 then
          data_shiftreg <= '1' & data_shiftreg(9 downto 1);
          busy_shiftreg <= '0' & busy_shiftreg(9 downto 1);
          counter <= (others => '0');
        else
          counter <= counter + 1;
        end if; -- counter
      end if; -- rising_edge
    end if; 
  end process;

end Behavioral;
  
