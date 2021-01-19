# R-SIG: Run Synthesis-Implementation-(and bit-stream)Generation
# Version: 1
# --------------------------------------------------------------------------------------------------------------

# START_CONFIG_PARAMETERS

set {project_name} *project_name*
set {project_path} *absolute_path_of_files*

# Enter the name (without extension) of HDL files here;
# NOTE: Zero index should point to the top module in the design

set hdl_source_code(0) *verilog_file_1*
set hdl_source_code(1) *verilog_file_2*
set hdl_source_code(1) *verilog_file_3*

# Add constraint file
set {constraint} *constraint*

# Set the FPGA parameters
set {fpga_part} *fpga_part_number*
set {fpga_id} *fpga_id*
set {fpga_board} *board_information*

# END_CONFIG_PARAMETERS


# --------------------------------------------------------------------------------------------------------------
# Fixed Parameters
set {orig_source_path}   $project_path
set {source_folder_path} $project_path

append {project_path} $project_name /

set {sources_folder_path} $project_path
append {source_folder_path} $project_name / $project_name .srcs/sources_1/new

# This is the top module
set {original_top} $hdl_source_code(0)

# calculate the size of the array
set {source_num} [array size hdl_source_code]
puts "[*] Number of files: $source_num}"

# complete path and name of the .xdc file
set {xdc_file} $orig_source_path 
append {xdc_file} $constraint .xdc

# complete path of the generated bitstream file
set {bitstream_path} $project_path 
append {bitstream_path} $project_name .runs/impl_1/ $original_top .bit

# --------------------------------------------------------------------------------------------------------------
# create a project and set the board property.
create_project $project_name $project_path -part $fpga_part
set_property board_part $fpga_board [current_project]

# --------------------------------------------------------------------------------------------------------------
# make a new directory to put the files.
file mkdir $sources_folder_path

# --------------------------------------------------------------------------------------------------------------
# add .v extension and join the complete path and add to the project
for { set count 0 } { $count < $source_num } { incr count } {
	set source_file($count) $orig_source_path 
	append source_file($count) $hdl_source_code($count) .v
	
	add_files -norecurse $source_file($count)
	update_compile_order -fileset sources_1

	puts "[*] $source_file($count)"
}

# --------------------------------------------------------------------------------------------------------------
# set a file as top module: set_property top <module_name> [current_fileset]
set_property top $original_top [current_fileset]
update_compile_order -fileset sources_1

# --------------------------------------------------------------------------------------------------------------
# add constraint file 
add_files -fileset constrs_1 -norecurse $xdc_file

# --------------------------------------------------------------------------------------------------------------
# run synthesis
launch_runs synth_1

# wait until synthesis completes
wait_on_run synth_1
if { [ get_property PROGRESS [ get_runs synth_1 ] ] != "100%" } {
	error "ERROR: synth_1 failed"
}

# run bit-stream generation
launch_runs impl_1 -to_step write_bitstream

# --------------------------------------------------------------------------------------------------------------
# wait for the bitstream file to be written
wait_on_run impl_1
if { [ get_property PROGRESS [ get_runs impl_1 ] ] != "100%" } {
	error "ERROR: impl_1 failed"
}

# --------------------------------------------------------------------------------------------------------------
# open hardware manager
open_hw_manager

# autoconnect to the hardware
connect_hw_server -allow_non_jtag
open_hw_target

set_property PROGRAM.FILE $bitstream_path [get_hw_devices $fpga_id]
current_hw_device [get_hw_devices $fpga_id]

refresh_hw_device -update_hw_probes false [lindex [get_hw_devices $fpga_id] 0]

# --------------------------------------------------------------------------------------------------------------
# program the device
set_property PROBES.FILE {} [get_hw_devices $fpga_id]
set_property FULL_PROBES.FILE {} [get_hw_devices $fpga_id]
set_property PROGRAM.FILE $bitstream_path [get_hw_devices $fpga_id]
program_hw_devices [get_hw_devices $fpga_id]

# --------------------------------------------------------------------------------------------------------------
# refresh and get status of the device
refresh_hw_device [lindex [get_hw_devices $fpga_id] 0]

