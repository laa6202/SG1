onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/rx_data
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/rx_vld
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/clk_sys
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/rst_n
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/pluse_us
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/urx_data
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/start_uart
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/cnt_us
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/start_uart
add wave -noupdate /tb/sg1_top/u_commu_top/u_phy_urx/urx_data_falling
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2923 ns} 0}
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
WaveRestoreZoom {0 ns} {3150 ns}
