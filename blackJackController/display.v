/*
	Displays all data to seven segment displays
	By: Zach Henderson
*/

module display (
	input clk,
	input rst,
	input [4:0] playerHand,
	input [4:0] dealerHand,
	input [2:0] state,
	input [1:0] displayState, 
	input resetToReshuffle,
	output reg [41:0] seg
);

// State parameters
parameter IDLE = 3'b000;		 	// 0
parameter DEAL = 3'b001; 			// 1
parameter PLAYER_TURN = 3'b010; 	// 2
parameter DEALER_TURN = 3'b011; 	// 3
parameter END_GAME = 3'b100; 		// 4
parameter LOAD = 3'b101; 			// 5

// Win States
parameter LOSE = 2'b00;		 	// 0
parameter TIE = 2'b01; 			// 1
parameter WIN = 2'b10; 			// 2
parameter BJ = 2'b11; 			// 3

// Digit registers to hold decomposed BCD values
reg [4:0] playerHandDigit1; 
reg [4:0] playerHandDigit0;
reg [4:0] dealerHandDigit1;
reg [4:0] dealerHandDigit0;

// Wires for BCD to 7-segment converter outputs
wire [6:0] digit3;
wire [6:0] digit2;
wire [6:0] digit1;
wire [6:0] digit0;

// Instantiate BCD to 7-segment display converters
bcdTo7Seg converter3 (.number(playerHandDigit1), .sevenSeg(digit3));
bcdTo7Seg converter2 (.number(playerHandDigit0), .sevenSeg(digit2));
bcdTo7Seg converter1 (.number(dealerHandDigit1), .sevenSeg(digit1));
bcdTo7Seg converter0 (.number(dealerHandDigit0), .sevenSeg(digit0));

// Task to handle the hand digits decomposition
task HandleHand (
	input [4:0] hand,
	output [4:0] tensDigit,
	output [4:0] oneDigit
);

	begin
		if(hand == 30) begin	
			tensDigit = 3;
			oneDigit = 0;
		end
		else if(hand >= 20) begin
			tensDigit = 2;
			oneDigit = hand - 20;
		end
		else if(hand >= 10) begin
			tensDigit = 1;
			oneDigit = hand - 10;
		end
		else if(hand < 10) begin
			tensDigit = 0;
			oneDigit = hand;
		end
	end
endtask


// Main state-machine and display logic
always @(posedge clk or posedge rst) begin

	if (rst) begin
		// Clear Screens
		seg[41:35] = 7'b1111111; // 'clear'
		seg[34:28] = 7'b1111111; // 'clear'
		seg[27:21] = 7'b1111111; // 'clear'
		seg[20:14] = 7'b1111111; // 'clear'
		seg[13:7]  = 7'b1111111; // 'clear'
		seg[6:0]   = 7'b1111111; // 'clear'

		playerHandDigit1 = 5'11111;
		playerHandDigit0 = 5'11111;
		dealerHandDigit1 = 5'11111;
		dealerHandDigit0 = 5'11111;

	end 
	else begin
		case (state)

			IDLE: 
			begin
				if (resetToReshuffle) begin
					// Display Reset
					seg[41:35] = 7'b0011001; // 'r'
					seg[34:28] = 7'b0110000; // 'E'
					seg[27:21] = 7'b0100100; // 'S'
					seg[20:14] = 7'b0110000; // 'E'
					seg[13:7]  = 7'b1110000; // 't'
					seg[6:0]   = 7'b1111111; // 'clear'

				end 
				else begin
					// Display Deal
					seg[41:35] = 7'b1000010; // 'd'
					seg[34:28] = 7'b0110000; // 'E'
					seg[27:21] = 7'b0001000; // 'A'
					seg[20:14] = 7'b1110001; // 'L'
					seg[13:7]  = 7'b1111111; // 'clear'
					seg[6:0]   = 7'b1111111; // 'clear'
				end
			end

			LOAD: 
			begin
				// Display Load
				seg[41:35] = 7'b1110001; // 'L'
				seg[34:28] = 7'b1100010; // 'o'
				seg[27:21] = 7'b0001000; // 'A'
				seg[20:14] = 7'b1000010; // 'd'
				seg[13:7]  = 7'b1111111; // 'clear'
				seg[6:0]   = 7'b1111111; // 'clear'					 
			end

			DEAL:
			begin
				// Set numbers to displays					
				HandleHand(playerHand, playerHandDigit1, playerHandDigit0);
				HandleHand(dealerHand, dealerHandDigit1, dealerHandDigit0);

				seg[6:0]   = digit0;
				seg[13:7]  = digit1;
				seg[20:14] = digit2; 
				seg[27:21] = digit3;
				seg[41:35] = 7'b1111111; // 'clear'
				seg[34:28] = 7'b1111111; // 'clear'
			end

			PLAYER_TURN, DEALER_TURN: 
			begin
				// Set numbers to displays
				HandleHand(playerHand, playerHandDigit1, playerHandDigit0);
				HandleHand(dealerHand, dealerHandDigit1, dealerHandDigit0);

				seg[6:0]   = digit0;
				seg[13:7]  = digit1;
				seg[20:14] = digit2; 
				seg[27:21] = digit3;
				
				// Display pt or dt depending on whos turn
				if (state == PLAYER_TURN) begin
					seg[41:35] = 7'b0011000; // 'P'
					seg[34:28] = 7'b1110000; // 't'
				end
				else if (state == DEALER_TURN) begin
					seg[41:35] = 7'b1000010; // 'd'
					seg[34:28] = 7'b1110000; // 't'
				end
			end
			
			END_GAME: 
			begin
				// Set numbers to displays
				HandleHand(playerHand, playerHandDigit1, playerHandDigit0);
				HandleHand(dealerHand, dealerHandDigit1, dealerHandDigit0);
				
				seg[6:0]   = digit0;
				seg[13:7]  = digit1;
				seg[20:14] = digit2; 
				seg[27:21] = digit3;
				
				case(displayState)
					LOSE: 
					begin // 'Lo'
						seg[41:35] = 7'b1110001; // 'L'
						seg[34:28] = 7'b1100010; // 'o'
					end
					TIE: 
					begin // 'ti'
						seg[41:35] = 7'b1110000; // 't'
						seg[34:28] = 7'b1111011; // 'i'
					end
					WIN:
					begin // 'yA'
						seg[41:35] = 7'b1000100; // 'y'
						seg[34:28] = 7'b0001000; // 'A'
					end
					BJ: 
					begin // 'bJ'
						seg[41:35] = 7'b1100000; // 'b'
						seg[34:28] = 7'b1000011; // 'J'
					end
				endcase
			end

			default: 
			begin
				seg[41:35] = 7'b1111111; // 'clear'
				seg[34:28] = 7'b1111111; // 'clear'
				seg[27:21] = 7'b1111111; // 'clear'
				seg[20:14] = 7'b1111111; // 'clear'
				seg[13:7]  = 7'b1111111; // 'clear'
				seg[6:0]   = 7'b1111111; // 'clear'
			end
		endcase

	end
end

endmodule
