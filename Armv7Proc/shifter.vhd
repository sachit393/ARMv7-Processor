library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity shifter is
port (
  data_in : in std_logic_vector(31 downto 0);
  shift_amount : in std_logic_vector(4 downto 0);
  shift_type : in std_logic_vector(1 downto 0);
  data_out : out std_logic_vector(31 downto 0);
  carry_out : out std_logic
);


end shifter;


architecture arch of shifter is

component shift1 is
port(
	data_in : in std_logic_vector(31 downto 0);
	select0 : in std_logic;
	carry_in : in std_logic;
	shift_type: in std_logic_vector(1 downto 0);
	carry_out : out std_logic;
	data_out : out std_logic_vector(31 downto 0)
);
end component;

component shift2 is
port(
	data_in : in std_logic_vector(31 downto 0);
	select1 : in std_logic;
	carry_in : in std_logic;
	shift_type: in std_logic_vector(1 downto 0);
	carry_out : out std_logic;
	data_out : out std_logic_vector(31 downto 0)
);
end component;

component shift3 is
port(
	data_in : in std_logic_vector(31 downto 0);
	select2 : in std_logic;
	carry_in : in std_logic;
	shift_type: in std_logic_vector(1 downto 0);
	carry_out : out std_logic;
	data_out : out std_logic_vector(31 downto 0)
);
end component;

component shift4 is
port(
	data_in : in std_logic_vector(31 downto 0);
	select3 : in std_logic;
	carry_in : in std_logic;
	shift_type: in std_logic_vector(1 downto 0);
	carry_out : out std_logic;
	data_out : out std_logic_vector(31 downto 0)
);
end component;

component shift5 is
port(
	data_in : in std_logic_vector(31 downto 0);
	select4 : in std_logic;
	carry_in : in std_logic;
	shift_type: in std_logic_vector(1 downto 0);
	carry_out : out std_logic;
	data_out : out std_logic_vector(31 downto 0)
);
end component;


component bit_reversal is
  port (
    enable : in std_logic;
    data_in: in std_logic_vector(31 downto 0);
    data_out: out std_logic_vector(31 downto 0)
  );
end component;

signal r_enable: std_logic;
signal r_data_in: std_logic_vector(31 downto 0);
signal data_out1: std_logic_vector(31 downto 0);
signal carry_out1: std_logic;
signal data_out2: std_logic_vector(31 downto 0);
signal carry_out2: std_logic;
signal data_out3: std_logic_vector(31 downto 0);
signal carry_out3: std_logic;
signal data_out4: std_logic_vector(31 downto 0);
signal carry_out4: std_logic;
signal r_data_out: std_logic_vector(31 downto 0);
-- signal data_out1: std_logic_vector(31 downto 0);
-- signal carry_out1: std_logic;
begin
  rev1: bit_reversal port map (r_enable, data_in, r_data_in);
  rev2: bit_reversal port map (r_enable, r_data_out, data_out);
  shf1: shift1 port map (r_data_in, shift_amount(0), '0', shift_type, carry_out1, data_out1);
  shf2: shift2 port map (data_out1, shift_amount(1), carry_out1, shift_type, carry_out2, data_out2);
  shf3: shift3 port map (data_out2, shift_amount(2), carry_out2, shift_type, carry_out3, data_out3);
  shf4: shift4 port map (data_out3, shift_amount(3), carry_out3, shift_type, carry_out4, data_out4);
  shf5: shift5 port map (data_out4, shift_amount(4), carry_out4, shift_type, carry_out, r_data_out);

  r_enable <= '1' when shift_type = "00" else
    '0';



end arch;
