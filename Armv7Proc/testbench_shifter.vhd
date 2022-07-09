library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity testbench_shifter is
-- empty
end testbench_shifter;

architecture tb of testbench_shifter is

-- DUT component
component shifter is
port (
  data_in : in std_logic_vector(31 downto 0);
  shift_amount : in std_logic_vector(4 downto 0);
  shift_type : in std_logic_vector(1 downto 0);
  data_out : out std_logic_vector(31 downto 0);
  carry_out : out std_logic
);
end component;
signal data_in : std_logic_vector(31 downto 0);
signal shift_amount : std_logic_vector(4 downto 0);
signal shift_type : std_logic_vector(1 downto 0);
signal data_out : std_logic_vector(31 downto 0);
signal carry_out : std_logic;
begin
  -- Connect DUT
  DUT: shifter port map (data_in, shift_amount, shift_type, data_out, carry_out);



  process
  begin

    --LSL 3 units
    data_in <= "10111001010101111101000100001011";
    shift_type <= "00";
    shift_amount <="00011";
    wait for 0.5 ns;
    assert (data_out = "11001010101111101000100001011000" and carry_out = '1') report "Error in logical left shift" severity Error;

    --LSL 17 units
    data_in <= "10111001010101111101000100001011";
    shift_type <= "00";
    shift_amount <="10001";
    wait for 0.5 ns;
    assert (data_out = "10100010000101100000000000000000" and carry_out = '1') report "Error in logical left shift" severity Error;

    -- LSR 7 units
    data_in <= "10111001010101111101000100001011";
    shift_type <= "01";
    shift_amount <="00111";
    wait for 0.5 ns;
    assert (data_out = "00000001011100101010111110100010" and carry_out = '0') report "Error in logical right shift" severity Error;


    -- ASR 7 units
    data_in <= "10111001010101111101000100001011";
    shift_type <= "10";
    shift_amount <="00111";
    wait for 0.5 ns;
    assert (data_out = "11111111011100101010111110100010" and carry_out = '0') report "Error in arithmetic shift right" severity Error;

    -- ROR 14 units
    data_in <= "10111001010101111101000100001011";
    shift_type <= "11";
    shift_amount <="01110";
    wait for 0.5 ns;
    assert (data_out = "01000100001011101110010101011111" and carry_out = '0') report "Error in rotate right" severity Error;

    assert FALSE report "Test done." severity note;
    wait;
  end process;
end tb;
