library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
generic(
  N : integer
);
port(
  i_clk, i_load, i_RO, i_reset : in std_logic;
  i_data : in std_logic_vector(N-1 downto 0);
  o_data : out std_logic_vector(N-1 downto 0)
);
end entity;

architecture Behavioral of reg is

signal temp : std_logic_vector(N-1 downto 0):=(others=>'0');

begin
  p_CLOCKED : process(i_clk, i_load,i_RO, i_reset)
  begin
    if (i_reset = '1') then
      temp <= (others=> '0');
    else
      if (rising_edge(i_clk) and i_load = '1')then
        temp <= i_data;
      end if;
    end if;
  end process;

  o_data <= temp when i_RO = '1' else (others=>'Z');
end architecture;
