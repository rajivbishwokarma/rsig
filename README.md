# rsig
Run: Synthesis Implementation (and bitstream) Generation

### 1. **Setting up the script**
*** NOTE: Board files for the given FPGA device should already be installed and the FPGA device should be connected prior to starting this script  ***
Modify the following parameters in the script.

#### a. Setup the project name in the following line
	set {project_name} zybo-auto-tcl

#### b. Point to the location of all Verilog files
	set {project_path} /home/red/FPGA/tcl/testing_rsig/

#### c. Enter all Verilog files -- one in each line -- used in the project.
	set hdl_source_code(0) top
	set hdl_source_code(1) op_assign
	set hdl_source_code(2) <name-without-extension>
	set hdl_source_code(.) <name-without-extension>
	set hdl_source_code(.) <name-without-extension>
	set hdl_source_code(n) <name-without-extension>

#### d. Enter the name of the constraint file (without extension)
	set {constraint} Zybo-Z7-Master

#### e. Enter the FPGA device information
	set {fpga_part} xc7z010clg400-1
	set {fpga_id} xc7z010_1
	set {fpga_board} digilentinc.com:zybo-z7-10:part0:1.0

## 2. **Running the script**

 a. Place this script along with all the Verilog files
 b. Start Xilinx Vivado
 c. Change directory to the location of current files
 d. Finally, start the script with
	source rsig.tcl

## 3. **Next version update**
*TODO: Automate the process of file addition.*

## 4. **Conclusion**
This script was tested in Xilinx Vivado 2020.2.
