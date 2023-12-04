`timescale 1ns / 1ps

module testbench();

  // reg signals provide inputs to the design under test
  reg clk, rst, deal, hit, stand;

  // wire signals are used for outputs
  wire [3:0] state;

  // instantiate the design under test  
  blackJackController M1 (clk, rst, deal, hit, stand, state);

  // clock generation
  initial
    begin
	   rst = 1;
      clk = 0;
		deal = 0;
		hit = 0;
		stand = 0;
		
		forever #10 clk = ~clk;
    end

  // assign signal values at various simulation times
	initial
		begin
		
		#50
		rst = 0;
		 
		#400
		
		deal = 1;
		#20
		deal = 0;

		/*
		#200
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#10
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#50
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#50
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		#50
		flag = ~flag;
		$display("Dealt Card ->  %d  %d", card, cardValue);
		
		*/
		end // initial
	endmodule
