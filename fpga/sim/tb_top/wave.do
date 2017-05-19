onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/rx_data
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/rx_vld
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/fx_wr
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/fx_data
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/fx_waddr
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/fx_raddr
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/fx_rd
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/fx_q
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/clk_sys
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/rst_n
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/st_fx
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/done_wait
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/cnt_wait
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/op_act
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/op_dev
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/op_addr
add wave -noupdate /tb/sg1_top/u_commu_top/u_fx_master/op_data
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
