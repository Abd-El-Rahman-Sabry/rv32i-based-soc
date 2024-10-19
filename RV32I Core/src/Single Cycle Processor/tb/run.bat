@echo off
REM Set the QuestaSim environment (adjust the path to where QuestaSim is installed)

REM Compile Verilog source files

vlog ../rtl/*.vh
vlog ../rtl/*.v
vlog ./*.v

REM Run simulation (replace "sc_riscv_tb" with your testbench module name)
vsim sc_riscv_tb -do "run -all"

REM End script
echo Simulation complete.
pause
