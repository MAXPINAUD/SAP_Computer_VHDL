library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acc_reg_A is
generic(
  N : integer
);
port(
  i_clk, i_La, i_Ea : in std_logic;
  i_data : in std_logic_vector(N-1 downto 0);
  o_data : out std_logic_vector(N-1 downto 0);
  o_data_ALU : out std_logic_vector(N-1 downto 0)
);
end entity;

architecture Behavioral of acc_reg_A is

signal temp : std_logic_vector(N-1 downto 0):=(others=>'0');

begin
  p_CLOCKED : process(i_clk, i_La,i_Ea)
  begin
    if (rising_edge(i_clk) and i_La = '1')then
        temp <= i_data;
    end if;
  end process;

  o_data <= temp when i_Ea = '1' else (others=>'Z');
  o_data_ALU <= temp;
end architecture;
