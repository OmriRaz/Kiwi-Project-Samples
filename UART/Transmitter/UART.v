 module UART(
	input		CLK_50,
	input	[3:0]	SW,
	input	[1:0]	BUTTON,
	output	[6:0]	HEX0,
	output	[6:0]	HEX1,
	output	[6:0]	HEX2,
	output	[7:0]	LED,
	output		BaudRate,
	output		TxD,
	output		RxD

);

wire TX;
wire BaudTick = BaudGeneratorAcc[BaudGeneratorAccWidth];
assign BaudRate = BaudTick;
assign TxD_start = start;
reg start = 1;	 
assign LED[3:0] = LetterCount[3:0];

parameter ClkFrequency = 50000000;
	 
	 
parameter Baud = 9600;
parameter BaudGeneratorAccWidth = 16;
parameter BaudGeneratorInc = ((Baud<<(BaudGeneratorAccWidth-4))+(ClkFrequency>>5))/(ClkFrequency>>4);
reg [BaudGeneratorAccWidth:0] BaudGeneratorAcc;

	 
reg [3:0] state;
reg [3:0] LetterCount = 4'b0000;
reg muxbit;

reg [7:0] TxD_data = 8'b01100001;
always @(posedge CLK_50) begin
	BaudGeneratorAcc <= BaudGeneratorAcc[BaudGeneratorAccWidth-1:0] + BaudGeneratorInc;
	data[0] <= 8'b01110101;
	data[1] <= 8'b01001100;
	data[2] <= 8'b01100001;
	data[3] <= 8'b01100010;
end

/////////////////////1HZ CLOCK/////////////////////////////

reg [31:0] counter = 0; 
reg hz = 0;		
assign LED[5] = hz;  
//assign LED[7:1] = 7'b1111111;
reg stopbit = 0; 


always @ (posedge CLK_50)  	
begin                      	
	counter <= counter + 1; 
		if(counter == 50000000) begin
			hz <= ~hz; 
			counter <= 0;	 
		end	
end

//////////////////////////////////////////////////////////////
assign LED[6] = stopbit;

always @(posedge CLK_50)
begin

if(state == 4'b0000)	begin
	LetterCount = LetterCount + 1;
	if(LetterCount == 6) begin 
		//stopbit = 1;
		start <= 0;
		LetterCount = 0;
		
		
	end
end



case(LetterCount)
	4'b0000: TxD_data <= 8'b00001010;	//newline
	4'b0001: TxD_data <= 8'b01110101;	//u
	4'b0010: TxD_data <= 8'b01001100;	//L
	4'b0011: TxD_data <= 8'b01100001;	//a	
	4'b0100: TxD_data <= 8'b01100010;	//b
	4'b0101: TxD_data <= 8'b00000000;	//null
	4'b0110: TxD_data <= 8'b00001010;   //newline
	4'b0111: TxD_data <= 8'b01111110;	//~
	//4'b0101: start <= 0;
	//default: 
endcase
end

always @(posedge CLK_50) begin
case(state)
  4'b0000: if(TxD_start) state <= 4'b0100;
  4'b0100: if(BaudTick) state <= 4'b1000; // start
  4'b1000: if(BaudTick) state <= 4'b1001; // bit 0
  4'b1001: if(BaudTick) state <= 4'b1010; // bit 1
  4'b1010: if(BaudTick) state <= 4'b1011; // bit 2
  4'b1011: if(BaudTick) state <= 4'b1100; // bit 3
  4'b1100: if(BaudTick) state <= 4'b1101; // bit 4
  4'b1101: if(BaudTick) state <= 4'b1110; // bit 5
  4'b1110: if(BaudTick) state <= 4'b1111; // bit 6
  4'b1111: if(BaudTick) state <= 4'b0001; // bit 7
  4'b0001: if(BaudTick) state <= 4'b0010; // stop1
  4'b0010: if(BaudTick) state <= 4'b0000; // stop2		  
  default: if(BaudTick) state <= 4'b0000;
endcase
end


