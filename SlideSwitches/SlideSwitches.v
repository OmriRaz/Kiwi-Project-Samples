
/*
	Blinking LED
	
	This code turns an 4 onboard LEDs according to the slide switches' position.
	
	Written for the μLab Kiwi development board, by Omri Raz, on the 5th of March, 2021.
	
*/

module SlideSwitches(

	input					CLK_50, //Defining the clock as an input (The onboard clock of the Kiwi is 50MHz)
	input		[3:0]		SW,	  //Defining the 4 built in slide switches on the Kiwi.
	output	[7:0]		LED	  //Defining the 8 built in LEDs on the Kiwi.
									  //Note: these definitions were made using the μLab Kiwi Project Generator.

);


assign LED[7:4] = 4'b1111; //Turn off the unused LEDs (1 means that the led is OFF)
assign LED[3:0] = SW[3:0]; //Assign the LEDs in position 0-3 (4 in total) to the 4 slide switches.

endmodule
