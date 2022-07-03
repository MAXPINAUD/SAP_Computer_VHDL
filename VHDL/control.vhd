library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
generic (N : integer);
port(
  i_clk : in std_logic;
  i_inst : in std_logic_vector(3 downto 0);
  o_pcO, o_Epc , o_rstPC, o_rstMAR, o_Lm,
  o_OE_RAM, o_WE_RAM, o_rstIR, o_Li, o_Ei,
  o_La, o_Ea, o_Su, o_Eu, o_Lb, o_Lo : out std_logic
);
end entity;

architecture Behavioral of control is
--rstIR/rstPC/rstMAr/Lo/pcO/Epc/Lm/OE_RAM/WE_RAM/Li/Ei/La/Ea/Su/Eu/Lb
--|15   14    13    12 |11  10  9    8   |  7     6 5  4 |3  2  1  0
signal control_reg : std_logic_vector(15 downto 0):= (others => '0');
type state_type is (init, fetch, load, increment, execute);
signal state : state_type := init;
begin

process(i_clk, i_inst)
variable step : integer := 0;
begin
  if (rising_edge(i_clk)) then
    case state is
      when init =>
        control_reg <= x"E000";
        state <= fetch;
      when fetch =>
        --Program counter out, MAR in
        control_reg <= x"0A00";
        state <= execute;
      when load =>
        --RAM out, instruction register in
        control_reg <= x"0140";
        state <= increment;
      when increment =>
        --Increment the Program counter
        control_reg <= x"0400";
        state <= execute;
      when execute =>
        case i_inst is
          when "0000"=>
          --LDA - load mem addr value into A reg
            case step is
              when 0 =>
              --Instruction register out and MAR in
                control_reg <= x"0220";
                step := step + 1;
              when 1 =>
              --RAM out and A register in
                control_reg <= x"0110";
                step := 0;
                state <= fetch;
              when others => null;
            end case;
          when "0001"=>
          --STA - store value of reg_A into mem addr
            case step is
              when 0 =>
                --address out of the instruction register and in the MAR
                control_reg <= x"0220";
                step := step + 1;
              when 1 =>
              --Reg_A out and RAM in
                control_reg <= x"0088";
                step := 0;
                state <= fetch;
              when others => null;
            end case;
          when "0010"=>
          --ADD - add addr value to reg A and store result in reg A
            case step is
              when 0 =>
              --Instruction register out and MAR in
                control_reg <= x"0220";
                step := step + 1;
              when 1 =>
              --RAM out and load reg_B
                control_reg <= x"0101";
                step := step + 1;
              when 2 =>
              --Put sum of ALU into acc_reg_A
                control_reg <= x"0012";
                step := 0;
                state <= fetch;
              when others => null;
            end case;
          when "0011"=>
          --SUB - subtract address value with reg A and store result in reg A
          case step is
            when 0 =>
            --Instruction register out and MAR in
              control_reg <= x"0220";
              step := step + 1;
            when 1 =>
            --RAM out and load reg_B and set ALU to sub
              control_reg <= x"0105";
              step := step + 1;
            when 2 =>
            --Put sum of ALU into acc_reg_A
              control_reg <= x"0016";
              step := 0;
              state <= fetch;
            when others => null;
          end case;
          when "0100"=>
          --JMP - execute instruction from addr
            --Instruction register out and MAR in
              control_reg <= x"0220";
              state <= load;
          when "0101"=>
          --OUT - outputs reg addr
            --reg_A out and load reg_out
            control_reg <= x"1008";
            state <= fetch;
          when "0110"=>
          --HLT - halts cpu operations
          null;
          when others => null;
        end case;
    end case;
  end if;
end process;

--Wiring to individual signal lines
o_rstIR <= control_reg(15);
o_rstPC <= control_reg(14);
o_rstMAR <= control_reg(13);
o_Lo <= control_reg(12);
o_pcO <= control_reg(11);
o_Epc <= control_reg(10);
o_Lm <= control_reg(9);
o_OE_RAM <= control_reg(8);
o_WE_RAM <= control_reg(7);
o_Li <= control_reg(6);
o_Ei <= control_reg(5);
o_La <= control_reg(4);
o_Ea <= control_reg(3);
o_Su <= control_reg(2);
o_Eu<= control_reg(1);
o_Lb <= control_reg(0);

end Behavioral;
