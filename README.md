# rsig
Run, Synthesis Implementation (and bitstream) Generation

1. Setting up the script

Modify the following parameters in the script

	a. First, setup the project name and location in the following lines
	   
	set {project_name} zybo-auto-tcl
	set {project_path} /home/red/FPGA/tcl/testing_rsig/

	b. Enter all Verilog files -- one in each line -- used in the project.

	set hdl_source_code(0) top
	set hdl_source_code(1) op_assign
	set hdl_source_code(2) <name-without-extension>
	set hdl_source_code(.) <name-without-extension>
	set hdl_source_code(.) <name-without-extension>
	set hdl_source_code(n) <name-without-extension>

	c. Enter the name of the constraint file (without extension)
	set {constraint} Zybo-Z7-Master

	d. Enter the FPGA device information
	set {fpga_part} xc7z010clg400-1
	set {fpga_id} xc7z010_1
	set {fpga_board} digilentinc.com:zybo-z7-10:part0:1.0

2. Next version update
3. Conclusion
