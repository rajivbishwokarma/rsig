# R-SIG: Run Synthesis-Implementation-(and bit-stream)Generation
# Version: 1
# --------------------------------------------------------------------------------------------------------------
# START_PARAMETERS
set {project_name} zybo-auto-tcl
set {project_path} /home/red/FPGA/tcl/
set {orig_source_path}   $project_path
set {source_folder_path} $project_path

# This is the main module
set {file_1} top
set {file_2} op_assign
set {constraint} Zybo-Z7-Master

set {fpga_part} xc7z010clg400-1
set {fpga_id} xc7z010_1
set {fpga_board} digilentinc.com:zybo-z7-10:part0:1.0

# END_PARAMETERS

# --------------------------------------------------------------------------------------------------------------
# Fixed Parameters
append {project_path} $project_name
append {project_path} /

set {sources_folder_path} $project_path
append {source_folder_path} $project_name
append {sources_folder_path} .srcs/sources_1/new

# complete path and name of the .v file
set {source_file_1} $orig_source_path
set {original_top} $file_1
append {file_1} .v
append {source_file_1} $file_1

# complete path and name of the .v file
set {source_file_2} $orig_source_path
append {file_2} .v
append {source_file_2} $file_2

# complete path and name of the .xdc file
set {xdc_file} $orig_source_path
append {constraint} .xdc
append {xdc_file} $constraint

# complete path of the generated bitstream file
set {bitstream_path} $project_path
append {bitstream_path} $project_name
append {bitstream_path} .runs/impl_1/
append {bitstream_path} $original_top
append {bitstream_path} .bit

puts "----------------------------------------------------------"
puts "Complete path for the generated bitstream: $bitstream_path"
puts "----------------------------------------------------------"

# --------------------------------------------------------------------------------------------------------------
# create a project and set the board property.
create_project $project_name $project_path -part $fpga_part
set_property board_part $fpga_board [current_project]

# --------------------------------------------------------------------------------------------------------------
# make a new directory to put the files.
file mkdir $sources_folder_path

puts "----------------------------------------------------------"
puts "Complete path for the source folder: $source_folder_path"
puts "----------------------------------------------------------"
# --------------------------------------------------------------------------------------------------------------
# add an existing file to the project
add_files -norecurse $source_file_1
update_compile_order -fileset sources_1

add_files -norecurse $source_file_2
update_compile_order -fileset sources_1

# --------------------------------------------------------------------------------------------------------------
# set a file as top module: set_property top <module_name> [current_fileset]
set_property top $file_1 [current_fileset]
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

# run implementation 
# launch_runs impl_1

# run bit-stream generation
launch_runs impl_1 -to_step write_bitstream

# --------------------------------------------------------------------------------------------------------------
# wait for the bitstream file to be written
wait_on_run impl_1
if { [ get_property PROGRESS [ get_runs impl_1 ] ] != "100%" } {
	error "ERROR: impl_1 failed"
}

puts "[*] ================================================== [*]"
puts "Complete path for the bitstream file: $bitstream_path"
puts "[*] ================================================== [*]"
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

