SOURCES+=$$PWD/src/rf.sv
SOURCES+=$$PWD/testbench/rf_tb.sv

SOURCE_TOP+=rf_tb 

run: compile simulation

compile:
	@echo Try to compile 
	@echo '****************************************************************************' 
	@echo
	@vlog -sv -sv12compat $(SOURCES)
	@echo '****************************************************************************' 
	@echo
	@echo Compiling is finished
	@echo '****************************************************************************' 
	
simulation:
	@echo Try to simulate:
	@echo '****************************************************************************' 
	@echo
	@vsim $(SOURCE_TOP) -c -voptargs="+acc" -msglimit none -do "run 1ms;exit" 
	@echo '****************************************************************************' 
	@echo
	@echo Simulation is finished
	@echo '****************************************************************************' 