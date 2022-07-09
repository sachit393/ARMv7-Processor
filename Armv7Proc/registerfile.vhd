
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;


entity registerfile is
  port (
	read_address1: in std_logic_vector(3 downto 0);
	read_address2: in std_logic_vector(3 downto 0);
	write_address: in std_logic_vector(3 downto 0);
	data_in: in std_logic_vector(31 downto 0);
	write_enable: in std_logic;
	clock: in std_logic;
	data_out1: out std_logic_vector(31 downto 0);
	data_out2: out std_logic_vector(31 downto 0)
  ) ;
end entity ; -- registerfile

architecture arch of registerfile is

type rf is array (0 to 15) of std_logic_vector(31 downto 0);

signal r: rf:= ( OTHERS=>X"00000000");

begin
        		data_out1 <= r(to_integer(unsigned(read_address1))); data_out2 <= 			r(to_integer(unsigned(read_address2)));
	process(clock,read_address1,read_address2,write_address, data_in,write_enable)
	begin

	if write_enable = '1' and rising_edge(clock) then
		r(to_integer(unsigned(write_address)))<=data_in;
		end if;

				-- contents are stored on rising edge of the clock if write enable is 1


	end process;


  end arch ; -- arch
