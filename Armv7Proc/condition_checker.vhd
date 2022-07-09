
library IEEE;
use IEEE.std_logic_1164.all;



entity condition_checker is
  port(
    flag_out: in std_logic_vector(3 downto 0);
    condition: in std_logic_vector(3 downto 0);
    p: out std_logic
  );
end condition_checker;

-- flag_out = (C,V,Z,N)

architecture arch of condition_checker is
begin
  process (condition, flag_out)

  begin
    if condition = "0000" then
         p <= flag_out(1);
    elsif condition = "0001" then
         p <= not flag_out(1);
    elsif condition = "0010" then
         p <= flag_out(3);
    elsif condition = "0011" then
         p <= not flag_out(3);
    elsif condition = "0100" then
         p <= flag_out(0);
    elsif condition = "0101" then
         p <= not flag_out(0);
    elsif condition = "0110" then
         p <= flag_out(2);
    elsif condition = "0111" then
         p <= not flag_out(2);
    elsif condition = "1000" then
         p <= flag_out(3) and (not flag_out(1));
    elsif condition = "1001" then
    	if flag_out(3) ='0' or  flag_out(1) ='1' then p<='1';
        else p<='0';
        end if;
    elsif condition = "1010" then

    	 if (flag_out(2) = flag_out(0)) then p<='1';
         else p<='0';
         end if;
    elsif condition = "1011" then
         if not(flag_out(2) = flag_out(0)) then p<='1';
         else p<='0';
         end if;
    elsif condition = "1100" then
    	if (flag_out(1) = '0') and (flag_out(0) = flag_out(2)) then p<='1';
        else p<='0';
        end if;
    elsif condition = "1101" then
    	if flag_out(1) = '1' or (not (flag_out(0) = flag_out(2))) then p<='1';
        else p<='0';
        end if;
    else
         p <= '1';
    end if;
  end process;




end architecture;
