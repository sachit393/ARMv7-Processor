library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;





entity shift5 is
port(
	data_in : in std_logic_vector(31 downto 0);
	select4 : in std_logic;
	carry_in : in std_logic;
	shift_type: in std_logic_vector(1 downto 0);
	carry_out : out std_logic;
	data_out : out std_logic_vector(31 downto 0)
);

end entity;



architecture arch of shift5 is
begin
process(data_in, shift_type, carry_in, select4)
begin
	if select4 = '1' then
	carry_out <= data_in(15);

			if shift_type = "00" or shift_type = "01" then
				data_out <= "0000000000000000"&data_in(31 downto 16);
			elsif shift_type = "10" then
				if data_in(31) = '1' then
					data_out <="1111111111111111"&data_in(31 downto 16);

				else data_out <= "0000000000000000"&data_in(31 downto 16);
				end if;
			else
					data_out <= data_in(15 downto 0)&data_in(31 downto 16);
			end if;
	else carry_out<= carry_in;
			data_out<= data_in;
	end if;
end process;




end arch;
