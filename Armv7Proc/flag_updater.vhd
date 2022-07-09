library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.MyTypes.all;

entity flag_updater is
port(
  flag_enable: in std_logic;
  clock: in std_logic;
  DP_subclass: in DP_subclass_type;
  instr_class: in instr_class_type;
  s: in std_logic;
  operation : in optype;
  shift_rotate_type: in std_logic_vector(1 downto 0);
  shift_rotate_amount: in std_logic_vector(4 downto 0);
  carry_out_alu: in std_logic;
  carry_out_shifter: in std_logic;
  result_out_alu: in std_logic_vector(31 downto 0);
  flag_out: out std_logic_vector(3 downto 0);
  msb_1: in std_logic;
  msb_2: in std_logic
);

end flag_updater;


architecture arch of flag_updater is
begin
  process (clock)
  begin
  -- flag_out = (C,V,Z,N)
  if rising_edge(clock) and flag_enable = '1' then
      if instr_class = DP then
        if DP_subclass = arith then
           if s = '1' then  -- all 4 flags are affected and alu carry is used
              flag_out(3)<=carry_out_alu;
              if operation = add or operation = adc then
                flag_out(2)<=(msb_1 and msb_2 and (not result_out_alu(31))) or (not msb_1 and not msb_2 and result_out_alu(31));
              elsif operation = sub or operation = sbc then
                flag_out(2)<=(msb_1 and not msb_2 and (not result_out_alu(31))) or (not msb_1 and msb_2 and result_out_alu(31));
              else
                flag_out(2)<=(not msb_1 and msb_2 and (not result_out_alu(31))) or (msb_1 and not msb_2 and result_out_alu(31));
              end if;
              if result_out_alu = x"00000000" then
                  flag_out(1)<='1';
              else flag_out(1)<='0';
              end if;

              flag_out(0)<=result_out_alu(31);
           end if;
        elsif DP_subclass = comp then
            flag_out(3)<=carry_out_alu;
            if operation = cmn then
              flag_out(2)<=(msb_1 and msb_2 and (not result_out_alu(31))) or (not msb_1 and not msb_2 and result_out_alu(31));
            else
              flag_out(2)<=(msb_1 and not msb_2 and (not result_out_alu(31))) or (not msb_1 and msb_2 and result_out_alu(31));
            end if;
            if result_out_alu = x"00000000" then
                flag_out(1)<='1';
            else flag_out(1)<='0';
            end if;
            flag_out(0)<=result_out_alu(31);
        elsif DP_subclass = logic then
            if s = '1' then
                if shift_rotate_type = "00" and shift_rotate_amount = "00000" then  --no shift condition
                  if result_out_alu = x"00000000" then
                      flag_out(1)<='1';
                  else flag_out(1)<='0';
                  end if;
                  flag_out(0)<=result_out_alu(31);
                else
                    flag_out(3)<=carry_out_shifter;
                    if result_out_alu = x"00000000" then
                        flag_out(1)<='1';
                    else flag_out(1)<='0';
                    end if;
                    flag_out(0)<=result_out_alu(31);
                end if;
            end if;
        elsif DP_subclass = test then
            if s = '0' or (s = '1' and shift_rotate_type = "00" and shift_rotate_amount = "00000") then
                if result_out_alu = x"00000000" then
                    flag_out(1)<='1';
                else flag_out(1)<='0';
                end if;
                flag_out(0)<=result_out_alu(31);
            else
                flag_out(3)<=carry_out_shifter;
                if result_out_alu = x"00000000" then
                    flag_out(1)<='1';
                else flag_out(1)<='0';
                end if;

                flag_out(0)<=result_out_alu(31);
            end if;
        end if;
      end if;
  end if;

end process;



end arch;