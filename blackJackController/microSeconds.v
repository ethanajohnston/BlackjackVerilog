
// Set clk period to 20ns in simulation

module microSeconds (
	input clk, rst,
	output reg [31:0] timeMicro // Output time in microSeconds
);

	reg [31:0] counter;    // 32-bit counter to measure time

	// Convert the counter to milliseconds
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			counter = 0;
			timeMicro = 0;
		end	 
		else if (counter >= 10) begin // Assuming a 10 MHz clock for a 1-second period. FREQUENCY IN MHZ / 1 000 000 = f_per_uS
			timeMicro = timeMicro + 1;
			counter = 0;
		end
		else begin
			counter = counter + 1;
		end
	end

endmodule
