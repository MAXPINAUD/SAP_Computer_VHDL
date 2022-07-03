library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity inst_reg is
generic (N : integer);
port(
  i_clk, i_reset, i_Li, i_Ei : in std_logic;
  i_inst : in std_logic_vector(N-1 downto 0);
  o_inst , o_addr : out std_logic_vector((N/2)-1 downto 0)
);
end entity;

architecture Behavioral of inst_reg is

signal temp : std_logic_vector (N-1 downto 0) := (others=>'0');

begin
process(i_clk, i_reset)
begin
  if (i_reset = '1') then
    temp <= (others => '0');
  else
    if (rising_edge(i_clk) and i_Li = '1') then
      temp <= i_inst;
    end if;
  end if;
end process;


o_inst <= temp(7 downto 4);
o_addr <= temp(3 downto 0) when i_Ei = '1' else (others=>'Z');
end architecture;
