onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Clock /testbench/clk
add wave -noupdate /testbench/rst
add wave -noupdate /testbench/stand
add wave -noupdate /testbench/hit
add wave -noupdate -label {DEAL BTN} /testbench/deal
add wave -noupdate -divider Other
add wave -noupdate /testbench/M1/cardNumber
add wave -noupdate -radix unsigned /testbench/M1/dealerCardNumber
add wave -noupdate -radix unsigned /testbench/M1/playerCardNumber
add wave -noupdate -divider {Game Play}
add wave -noupdate -label Clock /testbench/clk
add wave -noupdate -label {STAND BTN} /testbench/stand
add wave -noupdate -label {HIT BTN} /testbench/hit
add wave -noupdate -label {DEAL BTN} /testbench/deal
add wave -noupdate -label {Game State} /testbench/M1/state
add wave -noupdate -label {Play Hand Sum} -radix unsigned /testbench/M1/playerSum
add wave -noupdate -label {Dealer Hand Sum} -radix unsigned /testbench/M1/dealerSum
add wave -noupdate -label {Player Display} -radix unsigned /testbench/M1/playerDisplay
add wave -noupdate -label {Dealer Display} -radix unsigned /testbench/M1/dealerDisplay
add wave -noupdate -label {Player Hand} -radix unsigned /testbench/M1/playerCardValues
add wave -noupdate -label {Dealer Hand} -radix unsigned /testbench/M1/dealerCardValues
add wave -noupdate -label {Win State} /testbench/M1/displayState
add wave -noupdate -label RESHUFFLE /testbench/M1/resetToReshuffle
add wave -noupdate -label {Deck Card Num} -radix unsigned /testbench/M1/deckCardNumber
add wave -noupdate -divider SEED
add wave -noupdate -label {DEAL BTN} /testbench/deal
add wave -noupdate -label SEED -radix unsigned /testbench/M1/SEED
add wave -noupdate -label {uS Time} -radix unsigned /testbench/M1/timeMicro
add wave -noupdate -divider Loader
add wave -noupdate -label Clock /testbench/clk
add wave -noupdate -label {Seed Obtained} /testbench/M1/seedObtained
add wave -noupdate -label {Shuffle Flag} /testbench/M1/shuffleFlag
add wave -noupdate -label {Load Flag} -radix unsigned /testbench/M1/loadFlag
add wave -noupdate -label {Remaining Cards} -radix unsigned /testbench/M1/remainingCards
add wave -noupdate -label {Loaded Card} -radix unsigned /testbench/M1/currentCard
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15314018 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 124
configure wave -valuecolwidth 40
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
WaveRestoreZoom {14311670 ps} {15954438 ps}
