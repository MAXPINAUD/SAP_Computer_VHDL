library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.stop;

entity program_counter_tb is
end entity;

architecture Behavioral of program_counter_tb is

--WIDTH CONSTANT
constant BUS_WIDTH : integer := 4;

-- Input
signal r_clk : std_logic := '0';
signal r_control_sig : std_logic_vector(BUS_WIDTH-1 downto 0) := (others=>'0');
signal r_CO : std_logic := '0';
signal r_jump : std_logic := '0';
signal r_enable : std_logic := '0';
signal r_reset : std_logic := '0';

--Input/Output
signal r_io_data : std_logic_vector(BUS_WIDTH-1 downto 0) := (others=>'0');

--TestBench Signals
signal simulated_data : unsigned(BUS_WIDTH-1 downto 0) := (others=>'0');

begin
--Clock Generator
r_clk <= not r_clk after 2 ns;

--Instantiate Program Counter
DUT : entity work.program_counter
  generic map(
    N => BUS_WIDTH
  )
  port map(
    i_clk => r_clk,
    i_CO => r_CO,
    i_jump => r_jump,
    i_enable => r_enable,
    i_reset => r_reset,
    io_data => r_io_data
  );

p_SEQUENCE : process
begin

--Perform exhaustive testing of control Signals
for i in 0 to ((BUS_WIDTH*BUS_WIDTH)-1) loop
  r_control_sig <= std_logic_vector(to_unsigned(i,r_control_sig'length));
  wait for 20 ns;
end loop;
r_control_sig <= (others=>'0');
wait for 10 ns;
--Send out message
report "Test OK";
stop;
end process;

p_CHECKER : process
begin

wait for 1 ns;

case r_control_sig  is
  when "0000" =>
    assert(r_io_data = "ZZZZ") report "Failure: 0000, no high impedance" severity failure;
  when "0111"|"0110"|"0011"|"0010" =>
    assert(r_io_data = "0110") report "Failure: 0010, io_data incorrect r_jump" severity failure;
  when "0101"=>
    simulated_data <= unsigned(r_io_data);
    if (rising_edge(r_clk)) then
      simulated_data <= simulated_data + 1;
      assert (simulated_data = unsigned(r_io_data)) report "Failure: 0101, counter malfunction" severity failure;
    end if;
  when "1001"=>
    assert(r_io_data = "0000") report "Failure: 1000, reset malfunction" severity failure;
  when others => null;
end case;
end process;

r_io_data <= "0110" when (r_jump = '1') else (others=>'Z');

r_CO <= r_control_sig(0);
r_jump <= r_control_sig(1);
r_enable <= r_control_sig(2);
r_reset <= r_control_sig(3);
end architecture;
