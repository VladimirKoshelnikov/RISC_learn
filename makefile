
SOURCES+=$$PWD/src/id.sv 
SOURCES+=$$PWD/testbench/id_tb.sv 

SOURCE_TOP+=id_tb 

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

