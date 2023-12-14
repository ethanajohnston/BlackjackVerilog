`timescale 1ns/1ps

/*
	Tests functionality of microSeconds module
	By: Zach Henderson B00837636
*/


module testbench;

	//inputs
	reg clk;
	reg rst;
	//outputs
	wire [31:0] timeMicro;
	
	//Instantiate the Unit Under Test
	microSeconds uut(
		.clk(clk),
		.rst(rst),
		.timeMicro(timeMicro)
		
	);
	
	initial begin 
	clk = 0;
	rst = 0;
	forever #10 clk = ~clk;
	
	end
	
	initial begin
	#20 
	rst = 1;
	#30
	rst = 0;
	end
	
endmodule 