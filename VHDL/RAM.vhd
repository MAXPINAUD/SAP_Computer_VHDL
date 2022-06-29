library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
generic(
  RAM_WIDTH : integer;
  RAM_DEPTH : integer;
  ADDR_WIDTH : integer
);
port(
  i_clk, i_OE, i_WE : in std_logic;
  i_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
  i_data : in std_logic_vector(RAM_WIDTH-1 downto 0);
  o_data : out std_logic_vector(RAM_WIDTH-1 downto 0)
);
end entity;

architecture Behavioral of RAM is
type ram_array is array (0 to RAM_DEPTH) of std_logic_vector(RAM_WIDTH-1 downto 0);
signal ram : ram_array;
begin
process(i_clk)
begin
  if(rising_edge(i_clk) and i_WE = '1') then
    ram(to_integer(unsigned(i_addr))) <= i_data;
  end if;
end process;
--Output tri-state buffer
o_data <= ram(to_integer(unsigned(i_addr))) when i_OE = '1' else (others=>'Z');
end Behavioral;
