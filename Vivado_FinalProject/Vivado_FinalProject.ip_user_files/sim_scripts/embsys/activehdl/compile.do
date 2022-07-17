vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/microblaze_v11_0_4
vlib activehdl/xil_defaultlib
vlib activehdl/axi_lite_ipif_v3_0_4
vlib activehdl/lib_cdc_v1_0_2
vlib activehdl/interrupt_control_v3_1_4
vlib activehdl/axi_gpio_v2_0_24
vlib activehdl/lib_pkg_v1_0_2
vlib activehdl/axi_timer_v2_0_24
vlib activehdl/fit_timer_v2_0_10
vlib activehdl/lib_srl_fifo_v1_0_2
vlib activehdl/axi_uartlite_v2_0_26
vlib activehdl/lmb_v10_v3_0_11
vlib activehdl/lmb_bram_if_cntlr_v4_0_19
vlib activehdl/blk_mem_gen_v8_4_4
vlib activehdl/generic_baseblocks_v2_1_0
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/axi_register_slice_v2_1_22
vlib activehdl/fifo_generator_v13_2_5
vlib activehdl/axi_data_fifo_v2_1_21
vlib activehdl/axi_crossbar_v2_1_23
vlib activehdl/axi_intc_v4_1_15
vlib activehdl/xlconcat_v2_1_4
vlib activehdl/mdm_v3_2_19
vlib activehdl/proc_sys_reset_v5_0_13
vlib activehdl/dist_mem_gen_v8_0_13
vlib activehdl/lib_fifo_v1_0_14
vlib activehdl/axi_quad_spi_v3_2_21

vmap xpm activehdl/xpm
vmap microblaze_v11_0_4 activehdl/microblaze_v11_0_4
vmap xil_defaultlib activehdl/xil_defaultlib
vmap axi_lite_ipif_v3_0_4 activehdl/axi_lite_ipif_v3_0_4
vmap lib_cdc_v1_0_2 activehdl/lib_cdc_v1_0_2
vmap interrupt_control_v3_1_4 activehdl/interrupt_control_v3_1_4
vmap axi_gpio_v2_0_24 activehdl/axi_gpio_v2_0_24
vmap lib_pkg_v1_0_2 activehdl/lib_pkg_v1_0_2
vmap axi_timer_v2_0_24 activehdl/axi_timer_v2_0_24
vmap fit_timer_v2_0_10 activehdl/fit_timer_v2_0_10
vmap lib_srl_fifo_v1_0_2 activehdl/lib_srl_fifo_v1_0_2
vmap axi_uartlite_v2_0_26 activehdl/axi_uartlite_v2_0_26
vmap lmb_v10_v3_0_11 activehdl/lmb_v10_v3_0_11
vmap lmb_bram_if_cntlr_v4_0_19 activehdl/lmb_bram_if_cntlr_v4_0_19
vmap blk_mem_gen_v8_4_4 activehdl/blk_mem_gen_v8_4_4
vmap generic_baseblocks_v2_1_0 activehdl/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_22 activehdl/axi_register_slice_v2_1_22
vmap fifo_generator_v13_2_5 activehdl/fifo_generator_v13_2_5
vmap axi_data_fifo_v2_1_21 activehdl/axi_data_fifo_v2_1_21
vmap axi_crossbar_v2_1_23 activehdl/axi_crossbar_v2_1_23
vmap axi_intc_v4_1_15 activehdl/axi_intc_v4_1_15
vmap xlconcat_v2_1_4 activehdl/xlconcat_v2_1_4
vmap mdm_v3_2_19 activehdl/mdm_v3_2_19
vmap proc_sys_reset_v5_0_13 activehdl/proc_sys_reset_v5_0_13
vmap dist_mem_gen_v8_0_13 activehdl/dist_mem_gen_v8_0_13
vmap lib_fifo_v1_0_14 activehdl/lib_fifo_v1_0_14
vmap axi_quad_spi_v3_2_21 activehdl/axi_quad_spi_v3_2_21

vlog -work xpm  -sv2k12 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work microblaze_v11_0_4 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/9285/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_microblaze_0_0/sim/embsys_microblaze_0_0.vhd" \

vcom -work axi_lite_ipif_v3_0_4 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work interrupt_control_v3_1_4 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_24 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/4318/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_axi_gpio_0_0/sim/embsys_axi_gpio_0_0.vhd" \

vcom -work lib_pkg_v1_0_2 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work axi_timer_v2_0_24 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/70d6/hdl/axi_timer_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_axi_timer_0_0/sim/embsys_axi_timer_0_0.vhd" \

vcom -work fit_timer_v2_0_10 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/e81b/hdl/fit_timer_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_fit_timer_0_0/sim/embsys_fit_timer_0_0.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work axi_uartlite_v2_0_26 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/5edb/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_axi_uartlite_0_0/sim/embsys_axi_uartlite_0_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../bd/embsys/ipshared/f811/hdl/nexys4io_v3_0_S00_AXI.v" \
"../../../bd/embsys/ipshared/f811/hdl/nexys4io_v3_0.v" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/f811/src/rgbpwm.v" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/f811/src/debounce.v" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/f811/src/sevensegment.v" \
"../../../bd/embsys/ip/embsys_nexys4io_0_0/sim/embsys_nexys4io_0_0.v" \

vcom -work lmb_v10_v3_0_11 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/c2ed/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_dlmb_v10_0/sim/embsys_dlmb_v10_0.vhd" \
"../../../bd/embsys/ip/embsys_ilmb_v10_0/sim/embsys_ilmb_v10_0.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_19 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/0b98/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_dlmb_bram_if_cntlr_0/sim/embsys_dlmb_bram_if_cntlr_0.vhd" \
"../../../bd/embsys/ip/embsys_ilmb_bram_if_cntlr_0/sim/embsys_ilmb_bram_if_cntlr_0.vhd" \

vlog -work blk_mem_gen_v8_4_4  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../bd/embsys/ip/embsys_lmb_bram_0/sim/embsys_lmb_bram_0.v" \

vlog -work generic_baseblocks_v2_1_0  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_22  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/af2c/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_21  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/54c0/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_23  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/bc0a/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../bd/embsys/ip/embsys_xbar_0/sim/embsys_xbar_0.v" \

vcom -work axi_intc_v4_1_15 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/47b8/hdl/axi_intc_v4_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_microblaze_0_axi_intc_0/sim/embsys_microblaze_0_axi_intc_0.vhd" \

vlog -work xlconcat_v2_1_4  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/4b67/hdl/xlconcat_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../bd/embsys/ip/embsys_microblaze_0_xlconcat_0/sim/embsys_microblaze_0_xlconcat_0.v" \

vcom -work mdm_v3_2_19 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/8715/hdl/mdm_v3_2_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_mdm_1_0/sim/embsys_mdm_1_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../bd/embsys/ip/embsys_clk_wiz_1_0/embsys_clk_wiz_1_0_clk_wiz.v" \
"../../../bd/embsys/ip/embsys_clk_wiz_1_0/embsys_clk_wiz_1_0.v" \

vcom -work proc_sys_reset_v5_0_13 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_rst_clk_wiz_1_100M_0/sim/embsys_rst_clk_wiz_1_100M_0.vhd" \

vlog -work dist_mem_gen_v8_0_13  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ip/embsys_PmodOLEDrgb_0_0/ip/PmodOLEDrgb_axi_quad_spi_0_0/simulation/dist_mem_gen_v8_0.v" \

vcom -work lib_fifo_v1_0_14 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ip/embsys_PmodOLEDrgb_0_0/ip/PmodOLEDrgb_axi_quad_spi_0_0/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work axi_quad_spi_v3_2_21 -93 \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ip/embsys_PmodOLEDrgb_0_0/ip/PmodOLEDrgb_axi_quad_spi_0_0/hdl/axi_quad_spi_v3_2_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_PmodOLEDrgb_0_0/ip/PmodOLEDrgb_axi_quad_spi_0_0/sim/PmodOLEDrgb_axi_quad_spi_0_0.vhd" \
"../../../bd/embsys/ip/embsys_PmodOLEDrgb_0_0/ip/PmodOLEDrgb_axi_gpio_0_1/sim/PmodOLEDrgb_axi_gpio_0_1.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ip/embsys_PmodOLEDrgb_0_0/ip/PmodOLEDrgb_pmod_bridge_0_0/src/pmod_concat.v" \
"../../../bd/embsys/ip/embsys_PmodOLEDrgb_0_0/ip/PmodOLEDrgb_pmod_bridge_0_0/sim/PmodOLEDrgb_pmod_bridge_0_0.v" \
"../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/35e8/hdl/PmodOLEDrgb_v1_0.v" \
"../../../bd/embsys/ip/embsys_PmodOLEDrgb_0_0/sim/embsys_PmodOLEDrgb_0_0.v" \

vcom -work xil_defaultlib -93 \
"../../../bd/embsys/ip/embsys_axi_gpio_1_0/sim/embsys_axi_gpio_1_0.vhd" \
"../../../bd/embsys/ip/embsys_axi_gpio_green_low_0/sim/embsys_axi_gpio_green_low_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/ec67/hdl" "+incdir+../../../../Vivado_FinalProject.gen/sources_1/bd/embsys/ipshared/d0f7" \
"../../../bd/embsys/sim/embsys.v" \

vlog -work xil_defaultlib \
"glbl.v"

