module VGA(

	input					CLK_50,
	input		[3:0]		SW,
	output	[7:0]		LED,
	output	[2:0] 	RED,
	output	[2:0]		GREEN,
	output	[1:0]		BLUE,
	output   			h_sync,
	output				v_sync
);

wire InDisplayArea;
wire RowCounter;
reg R_val = 0;
reg G_val = 0;
reg B_val = 0;


Sync_gen Sync(
      .clk(CLK_50),
      .vga_h_sync(h_sync),
      .vga_v_sync(v_sync),
      .CounterX(CounterX),
      .InDisplayArea(InDisplayArea)
    );

always @(posedge CLK_50)
	begin
		if(InDisplayArea)
		begin
			if (RED < 3'b111)
				R_val = R_val + 1;
			else
				R_val = 0;
		end
		else 
			begin
				R_val = 0;
				G_val = 0;
				B_val = 0;
			end
end
endmodule
