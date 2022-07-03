library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_B is
generic(
  N : integer
);
port(
  i_clk, i_Lb : in std_logic;
  i_data : in std_logic_vector(N-1 downto 0);
  o_data : out std_logic_vector(N-1 downto 0)
);
end entity;

architecture Behavioral of reg_B is
begin
  p_CLOCKED : process(i_clk, i_Lb)
  begin
    if (rising_edge(i_clk) and i_Lb = '1')then
        o_data <= i_data;
    end if;
  end process;

end architecture;
