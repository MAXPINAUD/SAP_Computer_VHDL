library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_out is
generic(BUS_WIDTH : integer);
port(
  i_clk, i_Lo : in std_logic;
  i_data : in std_logic_vector(BUS_WIDTH-1 downto 0);
  o_data : out std_logic_vector(BUS_WIDTH-1 downto 0)
);
end entity;

architecture Behavioral of reg_out is

begin

process(i_clk)
begin
  if (rising_edge(i_clk) and i_Lo = '1') then
    o_data <= i_data;
  end if;
end process;

end architecture;
