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
add wave -noupdate /testbench/M1/state
add wave -noupdate /testbench/M1/displayState
add wave -noupdate -radix unsigned /testbench/M1/deckCardNumber
add wave -noupdate /testbench/M1/cardNumber
add wave -noupdate -radix unsigned /testbench/M1/playerSum
add wave -noupdate -radix unsigned /testbench/M1/dealerSum
add wave -noupdate -radix unsigned /testbench/M1/playerDisplay
add wave -noupdate -radix unsigned /testbench/M1/dealerDisplay
add wave -noupdate -radix unsigned /testbench/M1/playerCardValues
add wave -noupdate -radix unsigned /testbench/M1/dealerCardValues
add wave -noupdate -radix unsigned /testbench/M1/dealerCardNumber
add wave -noupdate -radix unsigned /testbench/M1/playerCardNumber
add wave -noupdate /testbench/M1/time_micro
add wave -noupdate /testbench/M1/seedObtained
add wave -noupdate /testbench/M1/SEED
add wave -noupdate /testbench/M1/shuffle1/SEED
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5670287 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
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
WaveRestoreZoom {5401234 ps} {6145500 ps}
