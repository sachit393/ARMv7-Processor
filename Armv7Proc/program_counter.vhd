library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;



entity program_counter is
port(
	reset: in std_logic;
	clock: in std_logic;
  write_enable: in std_logic;
  new_pc: in std_logic_vector(31 downto 0);
  current_pc: out std_logic_vector(31 downto 0)
  );
end entity;


architecture arch of program_counter is
signal pc: std_logic_vector(31 downto 0);
begin
current_pc<=pc;
process(clock)
begin
if rising_edge(clock) and reset = '1' then pc<=x"00000000";
elsif write_enable = '1' and rising_edge(clock) then pc<=new_pc;
end if;
end process;


end architecture;
