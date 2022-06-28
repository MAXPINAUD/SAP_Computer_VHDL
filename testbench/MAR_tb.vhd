library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--Include stop package
use std.env.stop;

entity MAR_tb is
end entity;

architecture Behavioral of MAR_tb is
--Register width constant
constant REG_WIDTH : integer := 4;

--Input Signals
signal r_clk : std_logic:='0';
signal r_Lm, r_reset : std_logic:='0';
signal r_i_data : std_logic_vector(REG_WIDTH-1 downto 0);
--Output Signals
signal r_o_data : std_logic_vector(REG_WIDTH-1 downto 0):=(others=>'0');
--TestBench Signals
signal r_simulated_data : unsigned (REG_WIDTH-1 downto 0) := (others=>'0');

begin
--Clock Generator
r_clk <= not r_clk after 2 ns;

--Instantiate register
DUT : entity work.MAR
  generic map(N => REG_WIDTH)
  port map(
    i_clk => r_clk,
    i_Lm => r_Lm,
    i_reset => r_reset,
    i_data => r_i_data,
    o_data => r_o_data
  );

p_SEQUENCE : process
begin
  for i in 0 to 2**REG_WIDTH loop
    r_simulated_data <= r_simulated_data + 1;
    wait for 20 ns;
  end loop;

  --Send out message
  report "Test Successful";
  stop;
end process;

  p_CHECKER : process
  begin
    wait for 1 ns;
    if (r_Lm = '1' and falling_edge(r_clk))then
      assert (r_o_data = r_i_data) report "Failure : 011 output data doesn't correspond to input data" severity failure;
    end if;
  end process;

  r_Lm <= '1';
  r_i_data <= std_logic_vector(r_simulated_data);

end architecture;
