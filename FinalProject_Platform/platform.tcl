# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\PortlandState\ECE_544\Labs\544_Final_Project\FinalProject_Platform\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\PortlandState\ECE_544\Labs\544_Final_Project\FinalProject_Platform\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {FinalProject_Platform}\
-hw {D:\PortlandState\ECE_544\Labs\544_Final_Project\nexysA7fpga.xsa}\
-proc {microblaze_0} -os {freertos10_xilinx} -fsbl-target {psu_cortexa53_0} -out {D:/PortlandState/ECE_544/Labs/544_Final_Project}

platform write
platform generate -domains 
platform active {FinalProject_Platform}
platform active {FinalProject_Platform}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/nexysA7fpga.xsa}
platform generate
platform active {FinalProject_Platform}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/nexysA7fpga.xsa}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/nexysA7fpga.xsa}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/nexysA7fpga.xsa}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/nexysA7fpga.xsa}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/Vivado_FinalProject/nexysA7fpga.xsa}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/Vivado_FinalProject/nexysA7fpga.xsa}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/Vivado_FinalProject/nexysA7fpga.xsa}
platform active {FinalProject_Platform}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/nexysA7fpga.xsa}
platform generate
platform generate -domains 
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/nexysA7fpga.xsa}
platform generate -domains 
platform config -updatehw {D:/PortlandState/ECE_544/Labs/Final_prj_2/project_5.xpr/project_5/nexysA7fpga.xsa}
platform generate -domains 
platform clean
platform generate
platform clean
platform config -updatehw {D:/PortlandState/ECE_544/Labs/Final_prj_2/project_5.xpr/project_5/nexysA7fpga.xsa}
platform generate
platform generate -domains 
platform clean
platform generate
platform clean
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/Vivado_FinalProject/nexysA7fpga.xsa}
platform generate
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/Vivado_FinalProject/nexysA7fpga.xsa}
platform generate -domains 
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/Vivado_OG/project_5_pmod_og_ip.xpr/project_5/nexysA7fpga.xsa}
platform generate
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/Vivado_OG/project_5_pmod_og_ip.xpr/project_5/nexysA7fpga.xsa}
platform generate -domains 
platform clean
platform clean
platform clean
platform active {FinalProject_Platform}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/project_5_old_pmod_no_count.xpr/project_5/nexysA7fpga.xsa}
platform generate
platform generate -domains freertos10_xilinx_domain 
platform clean
platform clean
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/project_5_old_pmod_no_count.xpr/project_5/nexysA7fpga.xsa}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/Vivado_OG/project_5_pmod_og_ip.xpr/project_5/nexysA7fpga.xsa}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/project_5_old_pmod_no_count.xpr/project_5/nexysA7fpga.xsa}
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/project_5_old_pmod_no_count.xpr/project_5/nexysA7fpga.xsa}
platform generate
platform generate -domains 
platform config -updatehw {D:/PortlandState/ECE_544/Labs/544_Final_Project/project_5_old_pmod_no_count.xpr/project_5/nexysA7fpga.xsa}
platform generate -domains 
