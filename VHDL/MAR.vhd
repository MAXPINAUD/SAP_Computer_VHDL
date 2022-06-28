library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAR is
  generic(N : integer);
  port(
    i_clk, i_Lm, i_reset : in std_logic;
    i_data : in std_logic_vector(N-1 downto 0);
    o_data : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture Behavioral of MAR is

  signal temp : std_logic_vector(N-1 downto 0):=(others=>'0');

  begin
    p_CLOCKED : process(i_clk, i_Lm)
    begin
      if (i_reset = '1') then
        temp <= (others=> '0');
      else
        if (rising_edge(i_clk) and i_Lm = '1')then
          o_data <= i_data;
        end if;
      end if;
    end process;
end Behavioral;
