library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;





entity shift2 is
port(
	data_in : in std_logic_vector(31 downto 0);
	select1 : in std_logic;
	carry_in : in std_logic;
	shift_type: in std_logic_vector(1 downto 0);
	carry_out : out std_logic;
	data_out : out std_logic_vector(31 downto 0)
);

end entity;



architecture arch of shift2 is
begin
process(data_in, shift_type, carry_in, select1)
begin
	if select1 = '1' then
	carry_out <= data_in(1);

			if shift_type = "00" or shift_type = "01" then
				data_out <= "00"&data_in(31 downto 2);
			elsif shift_type = "10" then
				if data_in(31) = '1' then
					data_out <="11"&data_in(31 downto 2);

				else data_out <= "00"&data_in(31 downto 2);
				end if;
			else
					data_out <= data_in(1 downto 0)&data_in(31 downto 2);
			end if;
	else carry_out<= carry_in;
			data_out<= data_in;
	end if;
end process;




end arch;
