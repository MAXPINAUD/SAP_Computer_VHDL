library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
generic(N : integer);
port(
  i_Su, i_Eu : in std_logic;
  i_A, i_B : in std_logic_vector(N-1 downto 0);
  o_result : out std_logic_vector(N-1 downto 0)
);
end entity;

architecture Behavioral of ALU is
signal temp : signed (N-1 downto 0);
begin

process (i_Su, i_A, i_B)
begin
  if (i_Su = '0') then
    temp <= i_A + i_B;
  else
    temp <= i_A - i_B;
  end if;
end process;

o_result <= temp when i_Eu = '1' else (others => 'Z');
end Behavioral;
