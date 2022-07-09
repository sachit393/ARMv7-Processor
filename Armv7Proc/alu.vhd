library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.MyTypes.all;



entity ALU is
  port (operand1: in std_logic_vector(31 downto 0);
      operand2: in std_logic_vector(31 downto 0);
          carry_in:in std_logic;
          dp_type: in optype;
      result: out std_logic_vector(31 downto 0);
      carry_out: out std_logic
       );
end ALU;

architecture ALU_ARCH of ALU is

signal op1: std_logic_vector (32 downto 0);
signal s1: std_logic;
signal op2: std_logic_vector (32 downto 0);
signal s2: std_logic;
signal p_s: std_logic_vector (32 downto 0);

begin
  s1<= operand1(31);
    s2<= operand2(31);
--     one<= ;
  op1<= ('0' & operand1) ;
    op2<= ('0' & operand2) ;
    p_s<= (op1 and op2) when dp_type = andop or dp_type = tst else -- and + tst
          (op1 xor op2) when dp_type = eor or dp_type = teq else -- eor + teq
          (op1 or op2)  when dp_type = orr else -- or
          op2                when dp_type = mov else -- mov
          '0' & not(operand2)            when dp_type = mvn else -- mvn
          std_logic_vector(signed(op1) + signed('0' & not(operand2))+'1')   when (dp_type = sub or dp_type = cmp) else -- subtract+cmp
          std_logic_vector(signed(op2) + signed('0' & not(operand1))+'1')   when dp_type = rsb else -- reverse subtract
          std_logic_vector(signed(op1) + signed(op2))   when (dp_type = add or dp_type = cmn) else -- add + cmn
          std_logic_vector(signed(op1) + signed(op2) + carry_in) when dp_type = adc else -- add with carry
          std_logic_vector(signed(op1) +  signed('0' & not(operand2)) + carry_in ) when dp_type = sbc else -- subtract with carry
          std_logic_vector(signed(op2) + signed('0' & not(operand1)) + carry_in ) when dp_type = rsc else -- reverse subtract with carry
          (op1 and ('0' & not(operand2))) ; -- bic

  result <= p_s(31 downto 0);
    carry_out <= p_s(32);

end ALU_ARCH;
