library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.MyTypes.all;


entity FSM is
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
	SCW: out std_logic
);

end entity;




architecture arch of FSM is

type STATE is (InstrFetch, ReadRegi, DP, DT, WriteRegiAlu,
						STR, LDR, WriteRegiDm, B, DP_DT_Shift, getShiftAmount );
signal present_state:STATE:=B; -- before the next rising edge

begin
process(clock)
begin

	if rising_edge(clock) then
		if present_state = InstrFetch then
				present_state <= ReadRegi after 0.1 ns;
				AW<='1' after 0.1 ns; --to avoid the register being enabled immediately (By the end of next clock cycle this would be done)
				BW<='1' after 0.1 ns; -- we would read ins [19-16] and ins[3-0] even if the instruction is DT type
				MW<='0' after 0.1 ns;
				IW<='0' after 0.1 ns;
				RW<='0' after 0.1 ns;
				Asrc1<='0' after 0.1 ns; --does not matter
				Asrc2<=0 after 0.1 ns; -- does nto matter
				Fset<='0' after 0.1 ns;
				ReW<='0' after 0.1 ns;
				PW<='0' after 0.1 ns;
				DW<='0' after 0.1 ns;
				IorD<='0' after 0.1 ns;
				M2R<='0' after 0.1 ns;
				Rsrc<='0' after 0.1 ns;
				Rsrc3<='0' after 0.1 ns;
				SCW <='0' after 0.1 ns;
				XW<='0' after 0.1 ns;
				SW<='0' after 0.1 ns;
				Rsrc2<='0' after 0.1 ns;
				out_operation<=instr_operation after 0.1 ns; --does not matter
		elsif present_state = ReadRegi then
		  if ((instr_class = DP and DP_shiftamount = imm and DP_operand_src = reg) or (DP_operand_src = imm and instr_class = DP)) then-- go to state DP
				 present_state <= DP_DT_Shift after 0.1 ns;
				 Asrc1<='0' after 0.1 ns;
				 Asrc2<=0 after 0.1 ns;
				 ReW<='0' after 0.1 ns;
				 Fset<='0' after 0.1 ns;
				 PW<='0' after 0.1 ns;
			   	 Rsrc3<='0' after 0.1 ns;
				 SCW <='1' after 0.1 ns;
				 IorD <= '0' after 0.1 ns;
				 MW<='0' after 0.1 ns;
 				 RW<='0' after 0.1 ns;
 				 AW<='0' after 0.1 ns;
 				 BW<='0' after 0.1 ns;
				 AW<='0' after 0.1 ns;
 			 	 BW<='0' after 0.1 ns;
 			 	 IW<='0' after 0.1 ns;
 			 	 DW<='0' after 0.1 ns;
 			 	 M2R<='0' after 0.1 ns;
 			 	 Rsrc <='0' after 0.1 ns;
 			 	 out_operation<=instr_operation after 0.1 ns;
				 SW<='1' after 0.1 ns;
				 XW <='0' after 0.1 ns;
				 Rsrc2<='0' after 0.1 ns;
				-- present_state<= DP after 0.1 ns; -- this would happen at next clock edge
				-- Asrc1 <='1' after 0.1 ns;
				-- Asrc2 <=0 after 0.1 ns;
				-- Rew<='1' after 0.1 ns;
				-- Fset<='1' after 0.1 ns; --flag would be updated if required
				-- PW<='0' after 0.1 ns;
				-- IorD<='0' after 0.1 ns;
				-- MW<='0' after 0.1 ns;
				-- RW<='0' after 0.1 ns;

				-- AW<='0' after 0.1 ns;
				-- BW<='0' after 0.1 ns;
				-- IW<='0' after 0.1 ns;
				-- DW<='0' after 0.1 ns;
				-- M2R<='0' after 0.1 ns;
				-- Rsrc <='0' after 0.1 ns;
				-- out_operation<=instr_operation after 0.1 ns;
			elsif instr_class = DP and DP_shiftamount = reg and DP_operand_src = reg then
				present_state <= getShiftAmount;
				Rsrc2 <= '1' after 0.1 ns;
				XW<='1' after 0.1 ns;
				Asrc1<='0' after 0.1 ns;
				Asrc2<=0 after 0.1 ns;
				Fset <= '0' after 0.1 ns;
				Rew <= '1' after 0.1 ns;
				IorD <= '0' after 0.1 ns;
				MW <= '0' after 0.1 ns;
				IW <= '0' after 0.1 ns;
				DW <= '0' after 0.1 ns;
				M2R <= '0' after 0.1 ns;
				RW <= '0' after 0.1 ns;
				AW <= '0' after 0.1 ns;
				BW <= '0' after 0.1 ns;
				Rsrc <= '0' after 0.1 ns;
				PW<= '0' after 0.1 ns;
				Rsrc3<='0' after 0.1 ns;
				SCW <='0' after 0.1 ns;
				SW<='0' after 0.1 ns;
			elsif instr_class = DT then
				present_state <= DP_DT_Shift after 0.1 ns;
				Asrc1<='0' after 0.1 ns;
				Asrc2<=0 after 0.1 ns;
				ReW<='0' after 0.1 ns;
				Fset<='0' after 0.1 ns;
				PW<='0' after 0.1 ns;
					Rsrc3<='0' after 0.1 ns;

				IorD <= '0' after 0.1 ns;
				MW<='0' after 0.1 ns;
				RW<='0' after 0.1 ns;
				AW<='0' after 0.1 ns;
				BW<='0' after 0.1 ns;
				AW<='0' after 0.1 ns;
				BW<='0' after 0.1 ns;
				IW<='0' after 0.1 ns;
				DW<='0' after 0.1 ns;
				M2R<='0' after 0.1 ns;
				Rsrc <='0' after 0.1 ns;
				out_operation<=instr_operation after 0.1 ns;
				SW<='1' after 0.1 ns;
				SCW <='1' after 0.1 ns;
				XW <='0' after 0.1 ns;
				Rsrc2<='0' after 0.1 ns;
				-- present_state <= DT after 0.1 ns;
				-- Asrc1 <= '1' after 0.1 ns;
				-- Asrc2 <= 2 after 0.1 ns;
				-- Fset <= '0' after 0.1 ns;
				-- Rew <= '1' after 0.1 ns;
				-- IorD <= '0' after 0.1 ns;
				-- MW <= '0' after 0.1 ns;
				-- IW <= '0' after 0.1 ns;
				-- DW <= '0' after 0.1 ns;
				-- M2R <= '0' after 0.1 ns;
				-- RW <= '0' after 0.1 ns;
				-- AW <= '0' after 0.1 ns;
				-- BW <= '1' after 0.1 ns;
				-- Rsrc <= '1' after 0.1 ns;
				-- PW<= '0' after 0.1 ns;
				-- Rsrc3<='0' after 0.1 ns;
				--
				-- XW<='0' after 0.1 ns;
				-- SW<='0' after 0.1 ns;
				-- Rsrc2<='0' after 0.1 ns;
				--
				-- if DT_offset_sign = plus then out_operation<=add after 0.1 ns;
				-- else out_operation<=sub after 0.1 ns;
				-- end if;


			elsif instr_class = DP and DP_shiftamount = reg and DP_operand_src = reg then
				present_state <= getShiftAmount;
				Rsrc2 <= '1' after 0.1 ns;
				XW<='1' after 0.1 ns;
				Asrc1<='0' after 0.1 ns;
				Asrc2<=0 after 0.1 ns;
				Fset <= '0' after 0.1 ns;
				Rew <= '1' after 0.1 ns;
				IorD <= '0' after 0.1 ns;
				MW <= '0' after 0.1 ns;
				IW <= '0' after 0.1 ns;
				DW <= '0' after 0.1 ns;
				M2R <= '0' after 0.1 ns;
				RW <= '0' after 0.1 ns;
				AW <= '0' after 0.1 ns;
				BW <= '0' after 0.1 ns;
				Rsrc <= '0' after 0.1 ns;
				PW<= '0' after 0.1 ns;
				Rsrc3<='0' after 0.1 ns;
				SCW <='0' after 0.1 ns;
				SW<='0' after 0.1 ns;
				XW<='0' after 0.1 ns;
				SW<='0' after 0.1 ns;
				Rsrc2<='0' after 0.1 ns;

			-- elsif instr_class = DT then
			-- 	present_state <= DT after 0.1 ns;
			-- 	Asrc1 <= '1' after 0.1 ns;
			-- 	Asrc2 <= 2 after 0.1 ns;
			-- 	Fset <= '0' after 0.1 ns;
			-- 	Rew <= '1' after 0.1 ns;
			-- 	IorD <= '0' after 0.1 ns;
			-- 	MW <= '0' after 0.1 ns;
			-- 	IW <= '0' after 0.1 ns;
			-- 	DW <= '0' after 0.1 ns;
			-- 	M2R <= '0' after 0.1 ns;
			-- 	RW <= '0' after 0.1 ns;
			-- 	AW <= '0' after 0.1 ns;
			-- 	BW <= '1' after 0.1 ns;
			-- 	Rsrc <= '1' after 0.1 ns;
			-- 	PW<= '0' after 0.1 ns;
			-- 	Rsrc3<='0' after 0.1 ns;
			--
			-- 	XW<='0' after 0.1 ns;
			-- 	SW<='0' after 0.1 ns;
			-- 	Rsrc2<='0' after 0.1 ns;
			-- 	if DT_offset_sign = plus then out_operation<=add after 0.1 ns;
			-- 	else out_operation<=sub after 0.1 ns;
			-- 	end if;


				if load_store = load then
					IorD<='1' after 0.1 ns;  --reading from memory
					MW<='0' after 0.1 ns;
					DW<='1' after 0.1 ns;
					RW<='0' after 0.1 ns;
					AW<='0' after 0.1 ns;
					BW<='0' after 0.1 ns;
					ReW<='0' after 0.1 ns;
					Fset<='0' after 0.1 ns;
					Asrc1<='0' after 0.1 ns;
					Asrc2<=0 after 0.1 ns;
					IW<='0' after 0.1 ns;
					PW<='0' after 0.1 ns;
					SW <= '0' after 0.1 ns;
					SCW<='0' after 0.1 ns;
					Rsrc2 <= '0' after 0.1 ns;
					Rsrc3 <= '0' after 0.1 ns;
					XW <= '0' after 0.1 ns;
					Rsrc <= '0' after 0.1 ns;
				elsif load_store = store then
					MW<='1' after 0.1 ns;
					IW<='0' after 0.1 ns;
					IorD<='0' after 0.1 ns;
					DW<='0' after 0.1 ns;
					AW<='0' after 0.1 ns;
					BW<='0' after 0.1 ns;
					ReW<='0' after 0.1 ns;
					Fset<='0' after 0.1 ns;
					Asrc1<='0' after 0.1 ns;
					Asrc2<=0 after 0.1 ns;
					PW<='0' after 0.1 ns;
					RW<='1' after 0.1 ns;
					SW <= '0' after 0.1 ns;
					SCW<='0' after 0.1 ns;
					Rsrc2 <= '0' after 0.1 ns;
					Rsrc3 <= '0' after 0.1 ns;
					XW <= '0' after 0.1 ns;
					Rsrc <= '0' after 0.1 ns;
				end if;
			elsif instr_class = BRN then
				present_state <= B after 0.1 ns;
				PW <= '1' after 0.1 ns;
				Rsrc3<='1' after 0.1 ns;
				IorD <= '0' after 0.1 ns;
				MW <= '0' after 0.1 ns;
				Asrc1 <= '0' after 0.1 ns;
				Asrc2 <=  3 after 0.1 ns;
				Rew <= '0' after 0.1 ns;
				Fset <= '0' after 0.1 ns;
				IW <= '0' after 0.1 ns;
				DW <= '0' after 0.1 ns;
				M2R <= '0' after 0.1 ns;
				RW <= '0' after 0.1 ns;
				Rsrc <= '0' after 0.1 ns;
				AW<='0' after 0.1 ns;
				BW<='0' after 0.1 ns;
				out_operation<= adc after 0.1 ns;
				XW<='0' after 0.1 ns;
				SW<='0' after 0.1 ns;
				Rsrc2<='0' after 0.1 ns;
				SCW <= '0' after 0.1 ns;

			end if;
		elsif present_state = getShiftAmount then
			present_state <= DP_DT_Shift after 0.1 ns;
			Asrc1<='0' after 0.1 ns;
			Asrc2<=0 after 0.1 ns;
			ReW<='0' after 0.1 ns;
			Fset<='0' after 0.1 ns;
			PW<='0' after 0.1 ns;
			Rsrc3<='0' after 0.1 ns;
			SCW <= '1' after 0.1 ns;
			IorD <= '0' after 0.1 ns;
			MW<='0' after 0.1 ns;
			RW<='0' after 0.1 ns;
			AW<='0' after 0.1 ns;
			BW<='0' after 0.1 ns;
			IW<='0' after 0.1 ns;
			DW<='0' after 0.1 ns;
			M2R<='0' after 0.1 ns;
			Rsrc <='0' after 0.1 ns;
			out_operation<=instr_operation after 0.1 ns;
			SW<='1' after 0.1 ns;
			XW <='0' after 0.1 ns;
			Rsrc2 <= '0' after 0.1 ns;

		elsif present_state = DP_DT_Shift then
			if instr_class = DP then
				present_state<= DP after 0.1 ns; -- this would happen at next clock edge
				Asrc1 <='1' after 0.1 ns;
				Asrc2 <=0 after 0.1 ns;
				Rew<='1' after 0.1 ns;
				Fset<='1' after 0.1 ns; --flag would be updated if required
				PW<='0' after 0.1 ns;
				IorD<='0' after 0.1 ns;
				MW<='0' after 0.1 ns;
				RW<='0' after 0.1 ns;
				Rsrc3<='0' after 0.1 ns;
				SCW <= '0' after 0.1 ns;
				AW<='0' after 0.1 ns;
				BW<='0' after 0.1 ns;
				IW<='0' after 0.1 ns;
				DW<='0' after 0.1 ns;
				M2R<='0' after 0.1 ns;
				Rsrc <='0' after 0.1 ns;
				out_operation<=instr_operation after 0.1 ns;
				SW<='0' after 0.1 ns;
				XW <='0' after 0.1 ns;
				Rsrc2 <= '0' after 0.1 ns;
			elsif instr_class = DT then
				present_state <= DT after 0.1 ns;
				Asrc1 <= '1' after 0.1 ns;
				Asrc2 <= 2 after 0.1 ns;
				Fset <= '0' after 0.1 ns;
				Rew <= '1' after 0.1 ns;
				IorD <= '0' after 0.1 ns;
				MW <= '0' after 0.1 ns;
				IW <= '0' after 0.1 ns;
				DW <= '0' after 0.1 ns;
				M2R <= '0' after 0.1 ns;
				RW <= '0' after 0.1 ns;
				AW <= '0' after 0.1 ns;
				BW <= '1' after 0.1 ns;
				Rsrc <= '1' after 0.1 ns;
				PW<= '0' after 0.1 ns;
				Rsrc3<='0' after 0.1 ns;
				SCW<='0' after 0.1 ns;
				XW<='0' after 0.1 ns;
				SW<='0' after 0.1 ns;
				Rsrc2<='0' after 0.1 ns;
				if DT_offset_sign = plus then out_operation<=add after 0.1 ns;
				else out_operation<=sub after 0.1 ns;
				end if;
			end if;

		elsif present_state = DP then
			present_state <= WriteRegiAlu after 0.1 ns;
			M2R <= '0' after 0.1 ns;
			if DP_subclass = arith or DP_subclass = logic then RW <='1' after 0.1 ns;
			else RW <= '0' after 0.1 ns;
			end if;
			AW <= '0'  after 0.1 ns;
			BW <= '0' after 0.1 ns;
			Asrc1 <= '0' after 0.1 ns;
			Asrc2 <= 0 after 0.1 ns;
			Fset <= '0' after 0.1 ns;
			ReW <= '0' after 0.1 ns;
			PW <= '0' after 0.1 ns;
			Rsrc3<='0' after 0.1 ns;

			IW <= '0' after 0.1 ns;
			DW <= '0' after 0.1 ns;
			IorD <= '0' after 0.1 ns;
			Rsrc <= '0' after 0.1 ns;
			MW <= '0' after 0.1 ns;
			out_operation<=instr_operation after 0.1 ns;
			SW<='0' after 0.1 ns;
			SCW<='0' after 0.1 ns;
			XW <='0' after 0.1 ns;
			Rsrc2 <= '0' after 0.1 ns;

		elsif present_state = DT then
			if load_store = load then
				present_state <= LDR;
				IorD<='1' after 0.1 ns;  --reading from memory
				MW<='0' after 0.1 ns;
				DW<='1' after 0.1 ns;
				RW<='0' after 0.1 ns;
				AW<='0' after 0.1 ns;
				BW<='0' after 0.1 ns;
				ReW<='0' after 0.1 ns;
				Fset<='0' after 0.1 ns;
				Asrc1<='0' after 0.1 ns;
				Asrc2<=0 after 0.1 ns;
				IW<='0' after 0.1 ns;
				PW<='0' after 0.1 ns;
				Rsrc <= '0' after 0.1 ns;
				M2R <= '0' after 0.1 ns;
				SW<='0' after 0.1 ns;
				SCW <= '0' after 0.1 ns;
				XW <='0' after 0.1 ns;
				Rsrc2 <= '0' after 0.1 ns;

			elsif load_store = store then
				present_state <= STR;
				MW<='1' after 0.1 ns;
				IW<='0' after 0.1 ns;
				IorD<='1' after 0.1 ns;
				DW<='0' after 0.1 ns;
				AW<='0' after 0.1 ns;
				BW<='0' after 0.1 ns;
				ReW<='0' after 0.1 ns;
				Fset<='0' after 0.1 ns;
				Asrc1<='0' after 0.1 ns;
				Asrc2<=0 after 0.1 ns;
				PW<='0' after 0.1 ns;
				RW<='0' after 0.1 ns;
				Rsrc <= '0' after 0.1 ns;
				M2R <= '0' after 0.1 ns;
				out_operation<=instr_operation after 0.1 ns;
				SW<='0' after 0.1 ns;
				SCW <='0' after 0.1 ns;
				XW <='0' after 0.1 ns;
				Rsrc2 <= '0' after 0.1 ns;
				Rsrc3<='0' after 0.1 ns;

			end if;

		elsif present_state = WriteRegiAlu or present_state =  WriteRegiDm or present_state =  STR or present_state =  B then
			present_state<= InstrFetch after 0.1 ns;
			IW <= '1' after 0.1 ns;
			IorD <= '0' after 0.1 ns;
			MW <= '0' after 0.1 ns;
			Asrc1 <= '0' after 0.1 ns;
			Asrc2 <= 1 after 0.1 ns;
			PW <= '1' after 0.1 ns;
			Rsrc3<='1' after 0.1 ns;

			RW <= '0' after 0.1 ns;
			AW <= '0' after 0.1 ns;
			BW <= '0' after 0.1 ns;
			Fset <= '0' after 0.1 ns;
			ReW <= '0' after 0.1 ns;
			M2R <= '0' after 0.1 ns;
			DW <= '0' after 0.1 ns;
			Rsrc <= '0' after 0.1 ns;
			out_operation<= add after 0.1 ns;
			SW<='0' after 0.1 ns;
			SCW <='0' after 0.1 ns;
			XW <='0' after 0.1 ns;
			Rsrc2 <= '0' after 0.1 ns;


		elsif present_state = LDR then
			present_state <= WriteRegiDm after 0.1 ns;
			M2R <= '1' after 0.1 ns;
			RW <= '1' after 0.1 ns;
			IW <= '0' after 0.1 ns;
			IorD <= '0' after 0.1 ns;
			MW <= '0' after 0.1 ns;
			Asrc1 <= '0' after 0.1 ns;
			Asrc2 <= 0 after 0.1 ns;
			PW <= '0' after 0.1 ns;
			AW <= '0' after 0.1 ns;
			BW <= '0' after 0.1 ns;
			Fset <= '0' after 0.1 ns;
			ReW <= '0' after 0.1 ns;
			DW <= '0' after 0.1 ns;
			Rsrc<= '0' after 0.1 ns;
			out_operation<= instr_operation after 0.1 ns;
			SW<='0' after 0.1 ns;
			SCW <='0' after 0.1 ns;
			XW <='0' after 0.1 ns;
			Rsrc2 <= '0' after 0.1 ns;
			Rsrc3<='0' after 0.1 ns;
		end if;








	end if;  -- if clock is not rising



end process;


end architecture;
