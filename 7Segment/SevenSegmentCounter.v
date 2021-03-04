module SevenSegmentCounter(

	input		CLK_50,	//Defining the 50MHz Clock of the Kiwi as an input
	output	[6:0]	HEX0,	//Defining the 7 Segment displays of the Kiwi as an output 
	output	[6:0]	HEX1,
	output	[6:0]	HEX2


);

reg [32:0] count = 0;  //This register is used for counting the iterations of the main loop (In order to generate the 1Hz clock)  
reg 	   state = 0;  //1Hz clock, generated in the 50MHz always loop.
reg [3:0]  SegVal = 0; //This register stores the current value which is being counted (the range for it is 0-9)
reg [6:0]  SegDat;     //This register stores the actual data for each segment of the 7 segment display

assign HEX0[0]=SegDat[0]; //assign each segment of the first 7 segment display to the appropriate bit of the segment data register
assign HEX0[1]=SegDat[1];
assign HEX0[2]=SegDat[2];
assign HEX0[3]=SegDat[3];
assign HEX0[4]=SegDat[4];
assign HEX0[5]=SegDat[5];
assign HEX0[6]=SegDat[6];

always @ (posedge CLK_50)	//Each time a positive edge on the clock signal is detected, the code inside of the loop is executed
begin                      	//The loop iterates 50 million times a second, because the clock input is 50MHz
	count <= count + 1;	//Each time the loop iterates, the counter register is incremented by 1
	if(count == 50000000) 	//For a 1Hz clock (one state change per second) we need to count until 50,000,000 (because of the 50MHz clock),
				//and when the counter hits 50,000,000, we change the state register and reset the counter back to zero. 
	begin
	state <= ~state;		//Invert the state (If the state was 0, invert it to 1, vice versa)
		if(SegVal<9)		//Check if the counted value is less than 9, 
					//because 9 is the largest decimal value that can be displayed on a 7 segment display.
			SegVal <= SegVal + 1;	//If the value is less than 9, increment the value by 1.
		else 
			SegVal <= 0;		//If the value is bigger than 9, reset the value to 0.
	count <= 0;				//Reset the counter for the 1Hz clock
	end	 
end	
always @ (state)	//Each time the state changes (1 time per second), 
	case (SegVal)	//Check what's the value of the 7 segment counter, and save the appropriate value data to the SegDat register.
		4'b0000:SegDat=7'b0111111;	// If the value is 0, save 1111110 to the segment data register //01111111
		4'b0001:SegDat=7'b0000110;	
		4'b0010:SegDat=7'b1011011;	
		4'b0011:SegDat=7'b1001111;	
		4'b0100:SegDat=7'b1100110;	
		4'b0101:SegDat=7'b1101101;		
		4'b0110:SegDat=7'b1111101;	
		4'b0111:SegDat=7'b0000111;	
		4'b1000:SegDat=7'b1111111;	
		4'b1001:SegDat=7'b1101111;	
	endcase
endmodule

