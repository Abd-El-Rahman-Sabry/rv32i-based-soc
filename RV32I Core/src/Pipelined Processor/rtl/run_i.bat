@echo on

REM Compile the Verilog source files
iverilog -o simulation.vvp  ./*.vh  ./*.v

REM Run the simulation and generate a VCD file
vvp simulation.vvp -lxt2

REM Open the waveform file in GTKWave (optional)
REM Make sure GTKWave is installed and in your PATH
gtkwave dump.vcd

REM End script
echo Simulation complete.
pause
