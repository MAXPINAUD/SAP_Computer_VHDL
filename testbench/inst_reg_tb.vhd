library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.stop;

entity inst_reg_tb is
end entity;

architecture Behavioral of inst_reg_tb is

constant INST_WIDTH : integer := 8;
constant ADDR_WIDTH : integer := INST_WIDTH/2;


--Inputs
signal r_clk, r_reset, r_Li, r_Ei : std_logic := '0';
signal r_iinst : std_logic_vector(INST_WIDTH-1 downto 0) := (others => '0');
--Outputs
signal r_oinst, r_oaddr : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
--TestBench
signal r_control_sig : std_logic_vector (2 downto 0) := (others => '0');
signal prev_content : std_logic_vector(INST_WIDTH-1 downto 0);

begin

DUT: entity work.inst_reg
generic map (N => 8)
port map (
  i_clk => r_clk,
  i_reset => r_reset,
  i_Li => r_Li,
  i_Ei => r_Ei,
  i_inst => r_iinst,
  o_inst => r_oinst,
  o_addr => r_oaddr
);

--Clock Signal Generator
r_clk <= not r_clk after 2 ns;

p_SEQUENCE : process
begin
  for i in 0 to 8 loop
      r_control_sig <= std_logic_vector(to_unsigned(i,r_control_sig'length));
      wait for 20 ns;
  end loop;
  wait for 10 ns;
  report "Test Successful";
  stop;
end process;

p_SEQ_DATA : process(r_clk)
begin
    if (rising_edge(r_clk)) then
      r_iinst <= std_logic_vector(unsigned(r_iinst) + 1) ;
    end if;
end process;

p_CHECKER : process
begin
  wait for 4 ns;
  case r_control_sig is
    when "101"=>
      assert (r_oinst = X"0" and r_oaddr = X"0") report "Failure : reset signal" severity failure;
    when "100" =>
      assert (r_oaddr = prev_content(3 downto 0) and r_oinst = prev_content(7 downto 4))
      report "Failure : Outputs not equal to loaded content" severity error;
    when "110"=>
      wait for 4 ns;
      assert (r_oaddr = r_iinst(3 downto 0) and r_oinst = r_iinst(7 downto 4))
      report "Failure : Outputs not equal to inputs" severity failure;
    when others => null;
  end case;
end process;

p_prevContent : process(r_control_sig, r_iinst)
begin
    if (r_control_sig = "010") then
      prev_content <= r_iinst;
    elsif (r_control_sig = "011") then
      prev_content <= (others => '0');
    end if;
end process;
r_reset <= r_control_sig(0);
r_Li <= r_control_sig(1);
r_Ei <= r_control_sig(2);
end architecture;
