
/*
	Blinking LED

	This code turns an onboard LED on for one second, then off for one second infinitely

	Written for the μLab Kiwi development board, by Omri Raz, on the 14th of February, 2021.

*/

module Blink(
	input		CLK_50, //Defining the clock as an input (The onboard clock of the Kiwi is 50MHz)  
	output	[7:0]	LED  	//Defining the 8 built in LEDs on the Kiwi
				//Note: these definitions were made using the μLab Kiwi Project Generator.
);


reg [31:0] counter = 0; //Creating a register for counting the number of times the loop repeats itself
reg state = 0;		//Creating a register for the LED's state (On or Off)
assign LED[0] = state;  //Assign the LED's state to the state register
assign LED[7:1] = 7'b1111111; //turn off the unused LEDs (1 means that the led is OFF)


always @ (posedge CLK_50)  	//Each time a positive edge on the clock signal is detected, the code inside of the loop is executed
begin                      	//The loop iterates 50 million times a second, because the clock input is 50MHz
	counter <= counter + 1; //Each time the loop iterates, the counter register is incremented by 1
	if(counter == 50000000) //For a 1Hz clock (one state change per second) we need to count until 50,000,000 (because of the 50MHz clock),
				//and when the counter hits 50,000,000, we change the state of the LED and reset the counter back to zero. 
	begin
		state <= ~state; //Invert the state (If the state was 0, invert it to 1, vice versa)
		counter <= 0;	 //Reset the counter
	end	 	
end
endmodule

