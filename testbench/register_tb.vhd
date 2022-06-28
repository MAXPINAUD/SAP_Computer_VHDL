library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--Include stop package
use std.env.stop;

entity reg_tb is
end entity;

architecture Behavioral of reg_tb is
--Register width constant
constant REG_WIDTH : integer := 8;
constant CTRL_SIG_CNT : integer := 3;

--Input Signals
signal r_clk : std_logic:='0';
signal r_load, r_RO, r_reset : std_logic:='0';
signal r_i_data : std_logic_vector(REG_WIDTH-1 downto 0);
--Output Signals
signal r_o_data : std_logic_vector(REG_WIDTH-1 downto 0):=(others=>'0');
--TestBench Signals
signal r_control_sig : std_logic_vector(CTRL_SIG_CNT-1 downto 0):=(others=>'0');
signal r_simulated_data : unsigned (REG_WIDTH-1 downto 0) := X"EF";

begin
--Clock Generator
r_clk <= not r_clk after 2 ns;

--Instantiate register
DUT : entity work.reg
  generic map(N => REG_WIDTH)
  port map(
    i_clk => r_clk,
    i_load => r_load,
    i_RO => r_RO,
    i_reset => r_reset,
    i_data => r_i_data,
    o_data => r_o_data
  );

p_SEQUENCE : process
begin
  for i in 0 to ((CTRL_SIG_CNT*CTRL_SIG_CNT)-1) loop
    r_control_sig <= std_logic_vector(to_unsigned(i,r_control_sig'length));
    r_simulated_data <= r_simulated_data + 1;
    wait for 20 ns;
  end loop;
  r_control_sig <= (others=>'0');
  wait for 10 ns;
  --Send out message
  report "Test Successful";
  stop;
end process;

  p_CHECKER : process
  variable prev_content : unsigned (REG_WIDTH-1 downto 0) := (others => '0');
  begin
  wait for 1 ns;
    case r_control_sig is
      when "000" =>
        assert (r_o_data = "ZZZZZZZZ") report "Failure : 000 normal output malfunction" severity failure;
        prev_content := (others=> '0');
      when "001" =>
        prev_content := r_simulated_data;
      when "010" =>
        assert (std_logic_vector(r_o_data) = std_logic_vector(prev_content)) report "Failure : 010 output does not correspond to previous content" severity failure;
      when "011" =>
        wait for 4 ns;
        assert (r_o_data = r_i_data) report "Failure : 011 output data doesn't correspond to input data" severity failure;
      when "110" | "111" =>
        assert (r_o_data = X"00") report "Failure : RESET HIGH output not resetting" severity failure;
      when others => null;
    end case;
  end process;

  r_load <= r_control_sig(0);
  r_RO <= r_control_sig(1);
  r_reset <= r_control_sig(2);
  r_i_data <= std_logic_vector(r_simulated_data);
end architecture;
