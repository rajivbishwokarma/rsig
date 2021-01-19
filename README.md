# rsig
Run: Synthesis Implementation (and bitstream) Generation

### 1. **Setting up the script**

***NOTE: Board files for the given FPGA device should already be installed and the FPGA device should be connected prior to starting this script***

Modify the last parameter in each statement.


#### a. Setup the project name in the following line
*Example: set {project_name} risc_v_cpu*
	
	set {project_name} *project_name*

#### b. Point to the location of all Verilog files
*Example: set {project_path} /home/user/fpga/*
	
	set {project_path} *absolute_path_of_the_files*

#### c. Enter the Verilog files -- one file in each line (without extension) -- used in the project.
*NOTE: First line should contain the top file*

*Example: set hdl_source_code(0) top*

	set hdl_source_code(0) *verilog_file_1*
	set hdl_source_code(1) *verilog_file_2*
	set hdl_source_code(2) *verilog_file_3*

#### d. Enter the name of the constraint file (without extension)
*Example: set {constraint} zybo-z710*
	
	set {constraint} *constraint*

#### e. Enter the FPGA device information
	set {fpga_part} *xc7z010clg400-1*
	set {fpga_id} *xc7z010_1*
	set {fpga_board} *digilentinc.com:zybo-z7-10:part0:1.0*

## 2. **Running the script**

 a. Place this script along with all the Verilog files 

 b. Start Xilinx Vivado 

 c. Change directory to the location of current files 

 d. Finally, start the script with
 	
	source rsig.tcl

## 3. **Next version update**
*TODO: Automate the process of file addition.*

*TODO: Automate the device add process."

## 4. **Conclusion**
This script was tested in Xilinx Vivado 2020.2 running on Ubuntu 2020.04.
