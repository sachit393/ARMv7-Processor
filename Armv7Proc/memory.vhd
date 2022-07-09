library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- to write specific bytes into the memory from register 4 write enable signals are used
-- for loading information from memory to register only ldr (loading 32 bits) is considered
-- instructions for ldrb, ldrh will be taken care by program memory path (as instructed by professor on piazza)
entity memor is
  port (
  IorD: in std_logic;
	rw_address: in std_logic_vector(5 downto 0); --common read write address
	data_write: in std_logic_vector(31 downto 0); --the data to be written to memory
	clock: in std_logic;
    write_enable0: in std_logic; --bits 7-0
    write_enable1: in std_logic; -- bits-15-8
    write_enable2:in std_logic; -- bits -23- 16
    write_enable3: in std_logic; -- bits 31 - 24
	data_out: out std_logic_vector(31 downto 0) -- read port
  ) ;
end entity ; -- datamemory

architecture arch of memor is

type MEM is array (64 downto 0) of std_logic_vector(31 downto 0);
signal pmemory: MEM:=(
0=>x"E3A03005",
1=>x"E3A04001",
2=>x"E0834184",
3=>x"E00440A3",
4=>x"E3A05007",
5=>x"E3A04001",
6=>x"E0256413", 


others =>x"00000000"
);

signal dmemory: MEM;


begin

  data_out <= dmemory(to_integer(unsigned(rw_address))) when IorD = '1' else
              pmemory(to_integer(unsigned(rw_address)));

process(clock, rw_address, data_write, write_enable0, write_enable1, write_enable2, write_enable3) --except for data out everything should be on sensitivity list

begin


	if (rising_edge(clock)) then --  str for different bytes
		if write_enable0 = '1' then dmemory(to_integer(unsigned(rw_address)))(7 downto 0) <= data_write(7 downto 0); --depending on which write_enables are set we write the corresponding bits
        end if;
        if write_enable1 = '1' then dmemory(to_integer(unsigned(rw_address)))(15 downto 8) <= data_write(15 downto 8);
        end if;
        if write_enable2 = '1' then dmemory(to_integer(unsigned(rw_address)))(23 downto 16) <= data_write(23 downto 16);
        end if;
       	if write_enable3 = '1' then dmemory(to_integer(unsigned(rw_address)))(31 downto 24) <= data_write(31 downto 24);
        end if;


	end if;




end process;


end arch ; -- arch
