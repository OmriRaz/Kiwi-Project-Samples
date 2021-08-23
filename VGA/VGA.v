module VGA(
    input             CLK_50,
    input    [3:0]    SW,
    output   [7:0]    LED,
    output   [2:0]    RED,
    output   [2:0]    GREEN,
    output   [1:0]    BLUE,
    output            h_sync,
    output            v_sync	
);

wire InDisplayArea;
wire [9:0] CounterX;
wire [9:0] CounterY;
wire RowCounter;
reg [2:0] R_val = 3'b000;
reg [2:0] G_val = 3'b000;
reg [1:0] B_val = 2'b00;

assign RED[2:0] = R_val[2:0];
assign GREEN[2:0] = G_val[2:0];
assign BLUE[1:0] = B_val[1:0];
	
/*reg [7:0] pixel = 8'b00000000;
assign RED[2:0] = pixel [7:5];
assign GREEN[2:0] = pixel [4:2];
assign BLUE[1:0] = pixel [1:0];*/

Sync_gen Sync(
    .clk(CLK_50),
    .vga_h_sync(h_sync),
    .vga_v_sync(v_sync),
    .CounterX(CounterX),
    .CounterY(CounterY),
    .InDisplayArea(InDisplayArea)
);


always @(posedge CLK_50)
begin
    if(InDisplayArea) begin
        if((CounterX >= 100) & (CounterX <= 300) & (CounterY > 100) & (CounterY < 300)) begin
            R_val = 3'b111;
            G_val = 3'b111;
            B_val = 2'b11;
        end
        else begin
            R_val = 3'b000;
            G_val = 3'b000;
            B_val = 2'b00;
        end
    end
end
endmodule
