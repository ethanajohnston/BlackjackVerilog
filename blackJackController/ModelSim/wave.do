onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/rst
add wave -noupdate /testbench/clk
add wave -noupdate -divider Buttons
add wave -noupdate /testbench/deal
add wave -noupdate /testbench/stand
add wave -noupdate /testbench/hit
add wave -noupdate -divider Loader
add wave -noupdate /testbench/M1/shuffleFlag
add wave -noupdate /testbench/M1/loadFlag
add wave -noupdate /testbench/M1/remainingCards
add wave -noupdate -divider Other
add wave -noupdate -radix unsigned /testbench/state
add wave -noupdate /testbench/M1/cardNumber
add wave -noupdate -radix unsigned /testbench/M1/playerSum
add wave -noupdate -radix unsigned /testbench/M1/dealerSum
add wave -noupdate -radix unsigned /testbench/M1/playerDisplay
add wave -noupdate -radix unsigned /testbench/M1/dealerDisplay
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3459083 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 190
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
WaveRestoreZoom {3278921 ps} {4067129 ps}
