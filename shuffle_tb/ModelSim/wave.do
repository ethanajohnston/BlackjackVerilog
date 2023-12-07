onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/rst
add wave -noupdate -divider Other
add wave -noupdate /testbench/M1/SEED
add wave -noupdate /testbench/M1/seedSet
add wave -noupdate -divider <NULL>
add wave -noupdate -label Clock /testbench/clk
add wave -noupdate -divider Shuffle
add wave -noupdate -label {Shuffle Flag} -radix unsigned /testbench/M1/shuffleFlag
add wave -noupdate -label {Remaining Card Count} -radix unsigned /testbench/M1/remainingCount
add wave -noupdate -label {Random Card} -radix unsigned /testbench/M1/randomCard
add wave -noupdate -divider <NULL>
add wave -noupdate -divider Loader
add wave -noupdate -label {Load Count} -radix unsigned /testbench/M1/loadCount
add wave -noupdate -label {Load Flag} -radix unsigned /testbench/loadFlag
add wave -noupdate /testbench/M1/card
add wave -noupdate -label {Loaded Card} -radix unsigned /testbench/card
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1813981 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 156
configure wave -valuecolwidth 38
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
WaveRestoreZoom {1016231 ps} {1828619 ps}
