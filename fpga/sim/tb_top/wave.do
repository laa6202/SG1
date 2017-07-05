onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/urx_data
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/cnt_us
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/start_uart
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_utx/uart_tx
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_utx/tx_data
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_utx/tx_vld
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_utx/cnt_us
add wave -noupdate /tb/sg1_top/u_ov_inf/ov_sioc
add wave -noupdate /tb/sg1_top/u_ov_inf/ov_siod
add wave -noupdate /tb/sg1_top/u_ov_inf/u_iic_inf/scl_up
add wave -noupdate /tb/sg1_top/u_ov_inf/u_iic_inf/scl_donw
add wave -noupdate /tb/sg1_top/u_ov_inf/u_iic_reg/now_wr
add wave -noupdate /tb/sg1_top/u_ov_inf/u_iic_reg/now_rd
add wave -noupdate /tb/sg1_top/u_ov_inf/u_iic_inf/cfg_iic_devid
add wave -noupdate /tb/sg1_top/u_ov_inf/u_iic_inf/cfg_iic_addr
add wave -noupdate /tb/sg1_top/u_ov_inf/u_iic_inf/cfg_iic_wdata
add wave -noupdate /tb/sg1_top/u_ov_inf/u_iic_inf/act_iic_write
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25627 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 317
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {31500 ns}
