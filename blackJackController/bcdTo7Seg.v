/*
	Converts Binary Coded Decimal (BCD) to seven segment display output
	By: Zach Henderson
*/

module bcdTo7Seg(
    input [4:0] number,
    output [6:0] sevenSeg
);

assign sevenSeg = 
    (number == 5'b00000) ? 7'b0000001 : // 0
    (number == 5'b00001) ? 7'b1001111 : // 1
    (number == 5'b00010) ? 7'b0010010 : // 2
    (number == 5'b00011) ? 7'b0000110 : // 3
    (number == 5'b00100) ? 7'b1001100 : // 4
    (number == 5'b00101) ? 7'b0100100 : // 5
    (number == 5'b00110) ? 7'b0100000 : // 6
    (number == 5'b00111) ? 7'b0001111 : // 7
    (number == 5'b01000) ? 7'b0000000 : // 8
    (number == 5'b01001) ? 7'b0000100 : // 9
    7'b1111111; // All segments off when input is invalid

endmodule
