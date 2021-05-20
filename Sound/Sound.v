module Sound(
	input			CLK_50,
	input	[3:0]	SW,
	input	[1:0]	BUTTON,
	inout	[35:0]	GPIO
);

reg [32:0] counter = 0;
reg [20:0] note = 56818; //default A
reg [6:0]  notepos = 5;
reg [3:0]  switchpos;
reg [32:0] notetime = 0;
assign GPIO[20] = Speaker;
reg Speaker = 0;
reg state = 0;
	
	
always @(posedge CLK_50) begin
	case(notepos)
		0: note = 56818; //A
		1: note = 53658; //A#
		2: note = 50607; //B
		3: note = 95419; //C
		4: note = 91911; //C#
		5: note = 85034; //D
		6: note = 80385; //D#
		7: note = 75757; //E
		8: note = 71632; //F
		9: note = 67567; //F#
		10:note = 63755; //G
		11:note = 60240; //G#
	endcase

if(BUTTON[0]) begin
	if(counter < note)
		counter = counter + 1;
	else begin
		Speaker = ~Speaker;
		counter = 0;
	end
end
end
//==========================//

always @ (posedge CLK_50)
begin                     
	notetime <= notetime + 1;
  if(notetime == 2500000)	
	begin
		state <= ~state; 
		notetime <= 0;
		if(notepos <= 11)
			notepos = notepos + 1;
		else
			notepos = 0;
		break;
	end	 	
end
endmodule
