module UART(

	input						CLK_50,
	input			[3:0]		SW,
	input			[1:0]		BUTTON,
	output		[6:0]		HEX0,
	output		[6:0]		HEX1,
	output		[6:0]		HEX2,
	output		[7:0]		LED,
	output					BaudRate,
	output					TxD


);

wire TX;
wire BaudTick = BaudGeneratorAcc[BaudGeneratorAccWidth];
assign BaudRate = BaudTick;
assign TxD_start = ~BUTTON[0];
assign LED[3:0] = LetterCount[3:0];

parameter ClkFrequency = 50000000;
parameter Baud = 115200;
parameter BaudGeneratorAccWidth = 16;
parameter BaudGeneratorInc = ((Baud<<(BaudGeneratorAccWidth-4))+(ClkFrequency>>5))/(ClkFrequency>>4);
reg [BaudGeneratorAccWidth:0] BaudGeneratorAcc;
reg [3:0] state;
reg [3:0] LetterCount = 0;
reg muxbit;

reg [7:0] TxD_data = 8'b00110101;


always @(posedge CLK_50)
  BaudGeneratorAcc <= BaudGeneratorAcc[BaudGeneratorAccWidth-1:0] + BaudGeneratorInc;


always @(posedge CLK_50)
begin

if(state == 4'b0000)	begin
	LetterCount = LetterCount + 1;
	if(LetterCount == 4) begin 
		LetterCount = 0;
	end
end

case(LetterCount)
	4'b0000: TxD_data <= 8'b01110101;
	4'b0001: TxD_data <= 8'b01001100;
	4'b0010: TxD_data <= 8'b01100001;
	4'b0011: TxD_data <= 8'b01100010;
	default: TxD_data <= 8'b01111110;
endcase

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



// the state machine starts when "TxD_start" is asserted, but advances when "BaudTick" is asserted (115200 times a second)


always @(state[2:0])
case(state[2:0])
  0: muxbit <= TxD_data[0];
  1: muxbit <= TxD_data[1];
  2: muxbit <= TxD_data[2];
  3: muxbit <= TxD_data[3];
  4: muxbit <= TxD_data[4];
  5: muxbit <= TxD_data[5];
  6: muxbit <= TxD_data[6];
  7: muxbit <= TxD_data[7];
endcase

// combine start, data, and stop bits together
assign TxD = (state<4) | (state[3] & muxbit);

endmodule
