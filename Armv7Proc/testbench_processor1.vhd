





library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.MyTypes.all;

entity testbench_processor1 is
-- empty
end testbench_processor1;

architecture tb of testbench_processor1 is

-- DUT component
component datapath is
port(
  	reset: in std_logic;
  	clock: in std_logic
    );
end component;
signal reset:std_logic:='0';
signal clock:std_logic:='0';
begin
  -- Connect DUT
  DUT: datapath port map (reset, clock);



  process
  begin

    reset<='1';
    clock <= '1'; wait for 1 ns;
    reset<='0';
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;

    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;

    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;

    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;
    clock <= '1'; wait for 1 ns;
    clock <= '0';wait for 1 ns;



   	assert FALSE report "Test done." severity note;
    wait;
  end process;
end tb;
