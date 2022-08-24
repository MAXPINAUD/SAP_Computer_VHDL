library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Constants
constant bram_width : integer := 8;
constant bram_depth : integer := 16;
--Address width is equal to the square root of the RAM depth
constant ram_addr_w : integer := 4;

entity top is
generic(
N : integer := 8
);
port(
  i_clk : in std_logic;
  o_data : out std_logic_vector(N-1 downto 0)
);
end entity;

architecture Behavioral of top is


  --BUS signal
  signal r_BUS : std_logic_vector(N-1 downto 0);
  --PC signals
  signal r_i_CO_PC, r_i_clk_PC , r_i_en_PC , r_i_reset_PC , r_i_jump_PC : std_logic;
  --MAR signals
  signal r_o_data_MAR : std_logic_vector((N/2)-1 downto 0);
  signal r_i_reset_MAR, r_i_clk_MAR ,  r_i_Lm_MAR : std_logic;
  --RAM signals
  signal r_i_clk_RAM , r_i_OE_RAM , r_i_WE_RAM : std_logic;
  --IR signals
  signal r_o_inst_IR : std_logic_vector(N-1 downto 0);
  signal r_i_clk_IR , r_i_reset_IR , r_i_Li_IR , r_i_Ei_IR : std_logic;
  --REG_A signals
  signal r_o_data_ALU_reg_A : std_logic_vector(N-1 downto 0);
  signal r_i_clk_reg_A , r_i_La_reg_A , r_i_Ea_reg_A : std_logic;
  --ALU signals
  signal r_i_Su_ALU , r_i_Eu_ALU : std_logic;
  --REG_B signals
  signal r_o_data_reg_B : std_logic_vector(N-1 downto 0);
  signal r_i_clk_reg_B , r_i_Lb_reg_B : std_logic;
  --REG_OUT signals
  signal r_o_data_reg_OUT : std_logic_vector(N-1 downto 0);
  signal r_i_clk_reg_OUT , r_i_Lo_reg_OUT : std_logic;
  --CTRL Signals
  signal r_i_inst_ctrl : std_logic_vector((N/2)-1 downto 0);

begin

  PC : entity work.pc
  generic map (N => N)
  port map (
  i_clk => r_i_clk_PC,
  i_CO => r_i_CO_PC,
  i_jump => r_i_jump_PC,
  i_enable => r_i_en_PC,
  i_reset => r_i_reset_PC,
  io_data => r_BUS
  );

  MAR : entity work.MAR
  generic map (N => N)
  port map (
  i_clk => r_i_clk_MAR,
  i_Lm => r_i_Lm_MAR,
  i_reset => r_i_reset_MAR,
  i_data => r_BUS(3 downto 0),
  o_data => r_o_data_MAR
  );

  RAM : entity work.RAM
  generic map(
    RAM_WIDTH => bram_width,
    RAM_DEPTH => bram_depth,
    ADDR_WIDTH => ram_addr_w
  )
  port map(
    i_clk => r_i_clk_RAM,
    i_OE => r_i_OE_RAM,
    i_WE => r_i_WE_RAM_WE,
    i_addr => r_o_data_MAR,
    io_data => r_BUS
  );

  IR : entity work.inst_reg
  generic map (N => 8)
  port map (
    i_clk => r_i_clk_IR,
    i_reset => r_i_reset_IR,
    i_Li => r_i_Li_IR,
    i_Ei => r_i_Ei_IR,
    i_inst => r_BUS,
    o_inst => r_i_inst_ctrl,
    o_addr => r_BUS(3 downto 0)
  );

  

end architecture;
