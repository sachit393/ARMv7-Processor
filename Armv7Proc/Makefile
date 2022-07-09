
GHDL = ghdl
FLAGS = "--std=08"

all:
	$(GHDL) -a $(FLAGS) TYPES.vhd datapath.vhd decoder.vhd FSM.vhd condition_checker.vhd alu.vhd flag_updater.vhd memory.vhd program_counter.vhd shifter.vhd shift1.vhd shift2.vhd shift3.vhd shift4.vhd shift5.vhd bit_reversal.vhd registerfile.vhd testbench_processor1.vhd testbench_shifter.vhd
	$(GHDL) -e $(FLAGS) testbench_processor1
	$(GHDL) -e $(FLAGS) testbench_shifter
	$(GHDL) -r $(FLAGS) testbench_processor1 --wave=testbench_processor1wave.ghw --stop-time=1us
	$(GHDL) -r $(FLAGS) testbench_shifter --wave=testbench_shifterwave.ghw --stop-time=1us
