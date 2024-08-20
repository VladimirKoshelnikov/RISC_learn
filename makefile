
SOURCES+=$$PWD/src/ram.sv 
SOURCES+=$$PWD/src/alu.sv 
#SOURCES+=$$PWD/src/cpu.sv 
#SOURCES+=$$PWD/src/id.sv 
#SOURCES+=$$PWD/src/mux_bus_2_1.sv 
#SOURCES+=$$PWD/src/pc.sv 
#SOURCES+=$$PWD/src/rf.sv 
#SOURCES+=$$PWD/src/rom.sv

SOURCES+=$$PWD/testbench/alu_tb.sv 

SOURCE_TOP+=alu_tb 

run: syntesis elaborate simulation

syntesis:
	@echo Try to compile design
	@echo '****************************************************************************' 
	@echo
	@xvlog -sv $(SOURCES) 
	@echo '****************************************************************************' 
	@echo
	@echo Compiling is finished
	@echo '****************************************************************************' 
	
elaborate:
	@echo Try to elaborate design
	@echo '****************************************************************************' 
	@echo
	@xelab -debug typical -top $(SOURCE_TOP) -snapshot tb_snapshot
	@echo '****************************************************************************' 
	@echo
	@echo Compiling is finished
	@echo '****************************************************************************' 
	

simulation:
	@echo Try to simulate:
	@echo '****************************************************************************' 
	@echo
	@xsim tb_snapshot -R -sv_seed 1023025 
	@echo '****************************************************************************' 
	@echo
	@echo Simulation is finished
	@echo '****************************************************************************' 

