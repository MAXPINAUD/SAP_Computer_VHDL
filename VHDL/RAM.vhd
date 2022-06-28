library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
generic(
  RAM_WIDTH : integer;
  RAM_DEPTH : integer
);
port(
  i_clk, i_OE, i_WE : in std_logic;
  i_data : in std_logic_vector(RAM_WIDTH-1 downto 0);
  o_data : out std_logic_vector(RAM_WIDTH-1 downto 0)
);
end entity;

architecture Behavioral of RAM is

signal

begin

process(sensitivity_list)
begin

end process;

end Behavioral;
