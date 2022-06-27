--Program Counter stores the address of the next instruction we are executing
--Program counter has 3 control signals: Program counter out, Jump and Count Enable
--Program Counter Out : tells PC to put stored value onto the BUS
--Jump signal : when high program counter should read values from the BUS
--Count Enable : allows count
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
generic(
  N : integer
);
port(
  i_clk, i_CO, i_jump, i_enable, i_reset : in std_logic;
  io_data : inout std_logic_vector (N-1 downto 0)
);
end program_counter;

architecture Behavioral of program_counter is
  signal i : unsigned (N-1 downto 0) := (others=>'0');
  begin
    p_counter : process(i_clk, i_enable, i_jump, i_reset)
    begin
      if (i_reset = '1') then
        i <= (others=>'0');
      else
        if (rising_edge(i_clk)) then
          if (i_jump = '1') then
            i <= unsigned(io_data);
          end if;
          if (i_enable = '1') then
              i <= i + 1;
          end if;
        end if;
      end if;
    end process;

io_data <= std_logic_vector(i) when (i_CO = '1' and i_jump = '0') else (others=>'Z');

end Behavioral;
