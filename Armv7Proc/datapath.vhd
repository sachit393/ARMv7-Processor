-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;

library work;
use work.MyTypes.all;


entity datapath is
port(
  reset: in std_logic;
	clock: in std_logic
);

end entity;


architecture arch of datapath is


component program_counter is
  port(
  	reset: in std_logic;
  	clock: in std_logic;
    write_enable: in std_logic;
    new_pc: in std_logic_vector(31 downto 0);
    current_pc: out std_logic_vector(31 downto 0)
    );
end component;

component decoder is
 Port (
 instruction : in word;
 instr_class : out instr_class_type;
 operation : out optype;
 DP_subclass : out DP_subclass_type;
 DP_operand_src : out DP_operand_src_type;
 load_store : out load_store_type;
 DT_offset_sign : out DT_offset_sign_type;
 DT_operand_src: out DT_operand_src_type;
 DP_shifttype: out std_logic_vector(1 downto 0);
 DP_shiftamount: out DP_shiftamount_type;
 DT_shifttype: out std_logic_vector(1 downto 0)
);

end component;

component condition_checker is
  port(
    flag_out: in std_logic_vector(3 downto 0);
    condition: in std_logic_vector(3 downto 0);
    p: out std_logic
  );
end component;




component registerfile is
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
end component;

component shifter is
  port (
    data_in : in std_logic_vector(31 downto 0);
    shift_amount : in std_logic_vector(4 downto 0);
    shift_type : in std_logic_vector(1 downto 0);
    data_out : out std_logic_vector(31 downto 0);
    carry_out : out std_logic
  );

end component;

component alu is
  port (operand1: in std_logic_vector(31 downto 0);
      operand2: in std_logic_vector(31 downto 0);
          carry_in:in std_logic;
          dp_type: in optype;
      result: out std_logic_vector(31 downto 0);
      carry_out: out std_logic
       );
end component;



component memor is
  port (
  IorD: in std_logic;
	rw_address: in std_logic_vector(5 downto 0); --common read write address(7 bit for index 0 -127)
	data_write: in std_logic_vector(31 downto 0); --the data to be written to memory
	clock: in std_logic;
    write_enable0: in std_logic; --bits 7-0
    write_enable1: in std_logic; -- bits-15-8
    write_enable2:in std_logic; -- bits -23- 16
    write_enable3: in std_logic; -- bits 31 - 24
	data_out: out std_logic_vector(31 downto 0) -- read port
  ) ;
end component;

component flag_updater is
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

end component;

component FSM is
port(
  clock: in std_logic;
  instr_operation : in optype;
  DT_offset_sign: in DT_offset_sign_type;
  instr_class: in instr_class_type;
  load_store: in load_store_type;
  DP_subclass: in DP_subclass_type;
  DP_operand_src: in DP_operand_src_type;
  DT_operand_src: in DT_operand_src_type;
  DP_shifttype: in std_logic_vector(1 downto 0);
  DP_shiftamount: in DP_shiftamount_type;
  DT_shifttype: in std_logic_vector(1 downto 0);
  out_operation: out optype;
  pw: out std_logic;
  IorD: out std_logic;
  MW: out std_logic;
  IW: out std_logic;
  DW: out std_logic;
  M2R: out std_logic;
  Rsrc: out std_logic;
  Rsrc2: out std_logic;
  Rsrc3: out std_logic;
  RW: out std_logic;
  AW: out std_logic;
  BW: out std_logic;
  Asrc1: out std_logic;
  Asrc2: out integer;
  Fset: out std_logic;
  ReW: out std_logic;
  SW : out std_logic;
  XW : out std_logic;
  SCW : out std_logic
);
end component;

signal alu_operation: optype;
signal pw: std_logic;
signal IorD: std_logic;
signal MW: std_logic;
signal IW: std_logic;
signal DW: std_logic;
signal M2R: std_logic;
signal Rsrc: std_logic;
signal Rsrc2: std_logic;
signal Rsrc3: std_logic;
signal RW: std_logic;
signal AW: std_logic;
signal BW: std_logic;
signal Asrc1: std_logic;
signal Asrc2: integer;
signal Fset: std_logic;
signal ReW: std_logic;
signal XW: std_logic;
signal SW: std_logic;

signal A: std_logic_vector(31 downto 0);
signal B: std_logic_vector(31 downto 0);
signal X: std_logic_vector(31 downto 0);
signal IR: std_logic_vector(31 downto 0);
signal DR: std_logic_vector(31 downto 0);
signal Res: std_logic_vector(31 downto 0);
signal SR: std_logic_vector(31 downto 0);
signal SCR: std_logic;
-- signal jump: std_logic;
-- signal offset: std_logic_vector(23 downto 0);
-- signal current_pc: std_logic_vector(31 downto 0);
signal instruction: std_logic_vector(31 downto 0);
signal instr_class: instr_class_type;
signal operation: optype;
signal DP_subclass: DP_subclass_type;
signal DP_operand_src: DP_operand_src_type;
signal load_store: load_store_type;
signal DT_offset_sign: DT_offset_sign_type;
signal DT_operand_src: DT_operand_src_type;
signal DP_shifttype: std_logic_vector(1 downto 0);
signal DP_shiftamount: DP_shiftamount_type;
signal DT_shifttype: std_logic_vector(1 downto 0);
signal read_address1: std_logic_vector(3 downto 0);
signal read_address2: std_logic_vector(3 downto 0);
signal write_address: std_logic_vector(3 downto 0);
signal data_in: std_logic_vector(31 downto 0);
-- signal write_enable: std_logic;
signal data_out1: std_logic_vector(31 downto 0):=x"00000000";
signal data_out2: std_logic_vector(31 downto 0):=x"00000000";
signal operand1: std_logic_vector(31 downto 0):=x"00000000";
signal operand2: std_logic_vector(31 downto 0):=x"00000000";
signal result_alu: std_logic_vector(31 downto 0):=x"00000000";
signal carry_out_alu: std_logic;
signal flag_out: std_logic_vector(3 downto 0):="0000";
signal s: std_logic;
-- signal shift_rotate_type: std_logic_vector(1 downto 0):="00";
-- signal shift_rotate_amount: std_logic_vector(7 downto 0):="00000000";
-- signal carry_out_shifter: std_logic;
signal msb_1: std_logic;
signal msb_2: std_logic;
signal condition: std_logic_vector(3 downto 0);
signal alu_carry_in: std_logic;
signal p: std_logic;
signal rw_address: std_logic_vector(31 downto 0);
-- signal data_write: std_logic_vector(31 downto 0);
signal data_out_memory:std_logic_vector(31 downto 0);
signal new_pc:std_logic_vector(31 downto 0);
signal current_pc:std_logic_vector(31 downto 0);

signal write_enable0: std_logic;
signal write_enable1: std_logic;
signal write_enable2: std_logic;
signal write_enable3: std_logic;
signal msb_offset: std_logic;
signal mem_offset: signed(31 downto 0):= x"00000100";
signal SCW: std_logic;
signal shift_data_in: std_logic_vector(31 downto 0);
signal shift_rotate_amount: std_logic_vector(4 downto 0);
signal shift_type: std_logic_vector(1 downto 0);
signal shift_data_out: std_logic_vector(31 downto 0);
signal shift_carry_out: std_logic;
signal alu_operand1: std_logic_vector(31 downto 0);
signal alu_operand2: std_logic_vector(31 downto 0);

begin

  PC: program_counter port map (reset, clock, pw, new_pc, current_pc);
  FiniteSM: FSM port map (clock, operation, DT_offset_sign, instr_class, load_store, DP_subclass ,DP_operand_src, DT_operand_src, DP_shifttype, DP_shiftamount, DT_shifttype, alu_operation, pw, IorD, MW, IW, DW, M2R, Rsrc, Rsrc2, Rsrc3, RW, AW, BW, Asrc1, Asrc2, Fset, ReW, SW, XW, SCW);
  -- DECODE THE INSTRUCTION
  ID: decoder port map(IR, instr_class, operation, DP_subclass, DP_operand_src, load_store, DT_offset_sign, DT_operand_src, DP_shifttype, DP_shiftamount, DT_shifttype);
	M: memor port map(IorD, rw_address(7 downto 2), B, clock,write_enable0, write_enable1, write_enable2, write_enable3, data_out_memory);
  CC:condition_checker port map(flag_out, condition, p);
  SHFTR: shifter port map (shift_data_in, shift_rotate_amount, shift_type, shift_data_out, shift_carry_out);
  MY_ALU: alu port map(alu_operand1, alu_operand2, alu_carry_in, alu_operation, result_alu, carry_out_alu);

  condition<=IR(31 downto 28);
  FlagUpdate: flag_updater port map (Fset, clock, DP_subclass, instr_class, s,operation ,shift_type, shift_rotate_amount, carry_out_alu, SCR, result_alu, flag_out, msb_1, msb_2);
  RF: registerfile port map(read_address1, read_address2, write_address, data_in, RW, clock, data_out1, data_out2);
  new_pc<=result_alu(29 downto 0)&"00" ;
  s <= IR(20);
  msb_1 <= alu_operand1(31);
  msb_2 <= alu_operand2(31);
  msb_offset <= IR(23);
  operand1<="00"&current_pc(31 downto 2) when Asrc1 = '0' else
            A ;
  operand2<=x"000000"&IR(7 downto 0) when instr_class =  DP and DP_operand_src = imm and Asrc2 = 0 else
            B when (DP_operand_src = reg and Asrc2 = 0 and instr_class = DP) or (DT_operand_src = reg and instr_class = DT ) else
            x"00000001" when Asrc2 = 1 else
            x"00000"&IR(11 downto 0) when Asrc2 = 2 else
            x"00"&IR(23 downto 0) when msb_offset = '0' else
            x"FF"&IR(23 downto 0);

  alu_operand1 <= operand1;

  alu_operand2 <= operand2 when Rsrc3 = '1' else
                  SR;


  alu_carry_in <= '1' when instr_class = BRN else --for pc+4+4+offset
                  flag_out(3);

  data_in<= DR when M2R = '1' else
          Res;

  read_address1 <= IR(19 downto 16) when Rsrc2 = '0' else
                  IR(11 downto 8);

  read_address2<= IR(15 downto 12) when Rsrc = '1' else
                  IR(3 downto 0);

  write_address <= IR(15 downto 12);


  write_enable0 <= '1' when MW = '1' else
                  '0';
  write_enable1 <= '1' when MW = '1' else
                  '0';
  write_enable2 <= '1' when MW = '1' else
                  '0';
  write_enable3 <= '1' when MW = '1' else
                  '0';

  rw_address <= Res when IorD = '1' else
   				current_pc;


  shift_data_in <= operand2;

  shift_rotate_amount <= X(4 downto 0) when (instr_class = DP and DP_operand_src = reg and DP_shiftamount = reg ) else
                        IR(11 downto 7)  when (instr_class = DP and DP_operand_src = reg and DP_shiftamount = imm) else
                        IR(11 downto 8)&'0'  when (instr_class = DP and DP_operand_src = imm ) else
                        IR(11 downto 7)  when (instr_class = DT and DT_operand_src = reg) else
                        "00000";

  shift_type <= DP_shifttype when (instr_class = DP and DP_operand_src=reg) else
                "11" when (instr_class = DP and DP_operand_src = imm) else
                DT_shifttype when (instr_class = DT and DT_operand_src = reg) else
                "00";
  process (clock)
  begin
    if rising_edge(clock) then

      if IW = '1' then IR <= data_out_memory;
      end if;
      if DW = '1' then DR <= data_out_memory;
      end if;

      if AW = '1' then A<=data_out1;
      end if;
      if BW = '1' then B<=data_out2;
      end if;

      if XW = '1' then X<=data_out1;
      end if;
      if ReW = '1' then Res <= result_alu;
      end if;

      if SW = '1' then SR<= shift_data_out;
      end if;

      if SCW = '1' then SCR<= shift_carry_out;
      end if;
    end if;


    --alu operation




  end process;


end arch;
