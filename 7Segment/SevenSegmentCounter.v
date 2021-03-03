module SevenSegmentCounter(

	input					CLK_50,
	output		[6:0]		HEX0,
	output		[6:0]		HEX1,
	output		[6:0]		HEX2


);


reg [26:0] count = 0;
reg [3:0] SegVal = 0;
reg [6:0] seg_data;

always @ (posedge CLK_50)  	//Each time a positive edge on the clock signal is detected, the code inside of the loop is executed
begin                      	//The loop iterates 50 million times a second, because the clock input is 50MHz
	count <= count + 1;		//Each time the loop iterates, the counter register is incremented by 1
	if(count == 50000000) 	//For a 1Hz clock (one state change per second) we need to count until 50,000,000 (because of the 50MHz clock),
							//and when the counter hits 50,000,000, we change the state of the LED and reset the counter back to zero. 
	begin
		if(SegVal<9)
			SegVal <= SegVal + 1;
		else 
			SegVal <= 0;
	count <= 0;	 //Reset the counter
	end	 
end	
always @(counter)
case (counter)
4'b0000:seg_data=7'b1111110;
4'b0001:seg_data=7'b0110000;
4'b0010:seg_data=7'b1101101;
4'b0011:seg_data=7'b1111001;
4'b0100:seg_data=7'b0110011;
4'b0101:seg_data=7'b1011011;
4'b0110:seg_data=7'b1011111;
4'b0111:seg_data=7'b1110000;
4'b1000:seg_data=7'b1111111;
4'b1001:seg_data=7'b1111011;
endcase
 
assign HEX0[0]=seg_data[6];
assign HEX0[1]=seg_data[5];
assign HEX0[2]=seg_data[4];
assign HEX0[3]=seg_data[3];
assign HEX0[4]=seg_data[2];
assign HEX0[5]=seg_data[1];
assign HEX0[6]=seg_data[0];
 

endmodule
