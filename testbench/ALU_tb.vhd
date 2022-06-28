library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.stop;

entity ALU_tb is
end entity;

architecture Behavioral of ALU_tb is
--Constant Define
constant ALU_WIDTH : integer := 8;
--Input Signals
signal r_Su, r_Eu : std_logic := '0';
signal r_A, r_B : std_logic_vector(ALU_WIDTH-1 downto 0):= (others=> '0');
--Output Signals
signal r_result : std_logic_vector(ALU_WIDTH-1 downto 0):= (others => '0');
--TestBench Signals
signal r_s_A : signed (ALU_WIDTH-1 downto 0) := (others => '0');
signal r_s_B : signed (ALU_WIDTH-1 downto 0) := (others => '0');

begin
--Device under test
DUT : entity work.ALU
generic map(
  N => ALU_WIDTH
)
port map(
  i_Su => r_Su,
  i_Eu => r_Eu,
  i_A => r_A,
  i_B => r_B,
  o_result => r_result
);

r_Su <= not r_Su after 10 ns;

p_SEQUENCE : process
begin
for i in 0 to (2**ALU_WIDTH) loop
  r_s_A <= r_s_A + 1;
  r_s_B <= r_s_B - 1;
  wait for 20 ns;
end loop;

report "Test Successful";
stop;
end process;

p_CHECKER : process
begin
if (r_Su = '0') then
wait for 1 ns;
  assert (signed(r_result) = (r_s_A + r_s_B)) report "Failure: Addition Incorrect" severity failure;
else
wait for 1 ns;
  assert (signed(r_result) = (r_s_A - r_s_B)) report "Failure: Subtraction Incorrect" severity failure;
end if;
end process;

r_Eu <= '1';
r_A <= std_logic_vector(r_s_A);
r_B <= std_logic_vector(r_s_B);
end Behavioral;
