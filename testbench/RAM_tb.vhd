library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.stop;

entity RAM_tb is
end entity;

architecture Behavioral of RAM_tb is
--Constants
constant bram_width : integer := 8;
constant bram_depth : integer := 16;
--Address width is equal to the square root of the RAM depth
constant ram_addr_w : integer := 4;

--Inputs
signal r_clk, r_OE, r_WE : std_logic:= '0';
signal r_addr : std_logic_vector(ram_addr_w-1 downto 0):=(others=>'0');
signal r_idata : std_logic_vector(bram_width-1 downto 0):=(others=>'0');
--Outputs
signal r_odata : std_logic_vector(bram_width-1 downto 0):=(others=>'0');
--Testbench Signals


begin

--Clock Signal Generation
r_clk <= not r_clk after 2 ns;

--Instantiate RAM
DUT : entity work.RAM
generic map(
  RAM_WIDTH => bram_width,
  RAM_DEPTH => bram_depth,
  ADDR_WIDTH => ram_addr_w
)
port map(
  i_clk => r_clk,
  i_OE => r_OE,
  i_WE => r_WE,
  i_addr => r_addr,
  i_data => r_idata,
  o_data => r_odata
);


  p_SEQUENCE : process
  begin
  for j in 0 to 2 loop
    if (j = 0) then
      r_WE <= '1';
      r_OE <= '0';
    elsif (j = 2) then
      r_WE <= '0';
      r_OE <= '1';
    end if;
    for i in 0 to bram_depth-1 loop
      r_idata <= std_logic_vector(to_unsigned(i, r_idata'length));
      r_addr <= std_logic_vector(to_unsigned(i, r_addr'length));
      wait for 20 ns;
    end loop;
  wait for 1 ns;
  end loop;
  wait for 10 ns;
  report "Test Successful";
  stop;
  end process;

  p_CHECKER : process(r_OE)
  begin
    if (r_OE = '1' and falling_edge(r_clk)) then
      assert (r_odata = r_addr) report "Failure of the RAM block" severity failure;
    end if;
  end process;
end architecture;
