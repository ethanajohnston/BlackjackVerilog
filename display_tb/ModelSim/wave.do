onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst
add wave -noupdate -radix unsigned /testbench/playerHand
add wave -noupdate -radix unsigned /testbench/dealerHand
add wave -noupdate -radix unsigned /testbench/state
add wave -noupdate -radix unsigned /testbench/displayState
add wave -noupdate -radix unsigned /testbench/resetToReshuffle
add wave -noupdate /testbench/seg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {186047 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {181714 ps} {245714 ps}
