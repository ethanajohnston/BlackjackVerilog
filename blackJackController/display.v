module display (
	input clk,
	input rst,
	input [4:0] playerHand,
	input [4:0] dealerHand,
	input [2:0] state,
	input [1:0] displayState, 
	input rE,
	output reg [41:0] seg
);

	// Define digit registers to hold decomposed BCD values
	reg [4:0] playerHandDigit1; 
	reg [4:0] playerHandDigit0;
	reg [4:0] dealerHandDigit1;
	reg [4:0] dealerHandDigit0;

	// Define wires for BCD to 7-segment converter outputs
	wire [6:0] sseg_digit3;
	wire [6:0] sseg_digit2;
	wire [6:0] sseg_digit1;
	wire [6:0] sseg_digit0;

	// State parameters
	parameter IDLE = 3'b000;		 	// 0
	parameter DEAL = 3'b001; 			// 1
	parameter PLAYER_TURN = 3'b010; 	// 2
	parameter DEALER_TURN = 3'b011; 	// 3
	parameter END_GAME = 3'b100; 		// 4
	parameter LOAD = 3'b101; 			// 5


	// Instantiate BCD to 7-segment display converters
	bcdTo7Seg converter3 (.A(playerHandDigit1), .sseg(sseg_digit3));
	bcdTo7Seg converter2 (.A(playerHandDigit0), .sseg(sseg_digit2));
	bcdTo7Seg converter1 (.A(dealerHandDigit1), .sseg(sseg_digit1));
	bcdTo7Seg converter0 (.A(dealerHandDigit0), .sseg(sseg_digit0));
	
	
	// Task to handle the hand digits decomposition
	task handle_hand;
		input [4:0] hand;
		output [4:0] tens_digit; // BCD should be 4 bits
		output [4:0] ones_digit; // Changed 'reg' to not declare 'output' as 'reg'
		begin
			if(hand == 30) begin	
				tens_digit = 3; // Use division and modulus to find BCD digits
				ones_digit = 0;
			end
			else if(hand >= 20) begin
				tens_digit = 2; // Use division and modulus to find BCD digits
				ones_digit = hand - 20;
			end
			else if(hand >= 10) begin
				tens_digit = 1; // Use division and modulus to find BCD digits
				ones_digit = hand - 10;
			end
			else if(hand < 10) begin
				tens_digit = 0; // Use division and modulus to find BCD digits
				ones_digit = hand;
			end
		end
	endtask

	// Main state-machine and display logic
	always @(posedge clk or posedge rst) begin

		if (rst) begin

			seg[41:35] = 7'b1111111; // 'clear'
			seg[34:28] = 7'b1111111; // 'clear'
			seg[27:21] = 7'b1111111; // 'clear'
			seg[20:14] = 7'b1111111; // 'clear'
			seg[13:7]  = 7'b1111111; // 'clear'
			seg[6:0]   = 7'b1111111; // 'clear'

		end 
		else begin
			case (state)

				IDLE: 
				begin // Use begin-end for blocks with more than one statement
					if (rE) begin
						seg[41:35] = 7'b0011001; // 'r'
						seg[34:28] = 7'b0110000; // 'E'
						seg[27:21] = 7'b0100100; // 'S'
						seg[20:14] = 7'b0110000; // 'E'
						seg[13:7]  = 7'b1110000; // 't'
						seg[6:0]   = 7'b1111111; // 'clear'

					end 
					else begin
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

					seg[41:35] = 7'b1110001; // 'L'
					seg[34:28] = 7'b1100010; // 'o'
					seg[27:21] = 7'b0001000; // 'A'
					seg[20:14] = 7'b1000010; // 'd'
					seg[13:7]  = 7'b1111111; // 'clear'
					seg[6:0]   = 7'b1111111; // 'clear'					 

				end
				DEAL:
				begin
					handle_hand(playerHand, playerHandDigit1, playerHandDigit0);
					handle_hand(dealerHand, dealerHandDigit1, dealerHandDigit0);
					seg[41:35] = 7'b1111111; // 'clear'
					seg[34:28] = 7'b1111111; // 'clear'
					
					seg[6:0]   = sseg_digit0; // Update based on task outputs
					seg[13:7]  = sseg_digit1; // Corrected order based on PLAYER and DEALER digit outputs
					seg[20:14] = sseg_digit2; 
					seg[27:21] = sseg_digit3;
				
				end

				PLAYER_TURN, DEALER_TURN: 
				begin
					handle_hand(playerHand, playerHandDigit1, playerHandDigit0);
					handle_hand(dealerHand, dealerHandDigit1, dealerHandDigit0);

					seg[6:0]   = sseg_digit0; // Update based on task outputs
					seg[13:7]  = sseg_digit1; // Corrected order based on PLAYER and DEALER digit outputs
					seg[20:14] = sseg_digit2; 
					seg[27:21] = sseg_digit3;
					
					// 'P' or 'd' should place on the leftmost digits which are seg[41:35] and seg[34:28]
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
					handle_hand(playerHand, playerHandDigit1, playerHandDigit0);
					handle_hand(dealerHand, dealerHandDigit1, dealerHandDigit0);
					
					seg[6:0]   = sseg_digit0; // Update based on task outputs
					seg[13:7]  = sseg_digit1; // Corrected order based on PLAYER and DEALER digit outputs
					seg[20:14] = sseg_digit2; 
					seg[27:21] = sseg_digit3;
					
					case(displayState)
					2'b00: 
					begin // 'Lo'
						seg[41:35] = 7'b1110001; // 'L'
						seg[34:28] = 7'b1100010; // 'o'
					end
					2'b01: 
					begin // 'ti'
						seg[41:35] = 7'b1110000; // 't'
						seg[34:28] = 7'b1111011; // 'i'
					end
					2'b10:
					begin // 'yA'
						seg[41:35] = 7'b1000100; // 'y'
						seg[34:28] = 7'b0001000; // 'A'
					end
					2'b11: 
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
