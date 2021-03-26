module Sync_gen(
    input 				clk,
    output 				vga_h_sync,
    output 				vga_v_sync,
    output reg 		InDisplayArea,
    output reg [9:0] CounterX,
    output reg [9:0] CounterY
  );
    reg h_sync, v_sync;

    wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
    wire CounterYmaxed = (CounterY == 525); // 10 + 2 + 33 + 480

    always @(posedge clk)
    if (CounterXmaxed)
      CounterX <= 0;
    else
      CounterX <= CounterX + 1;

    always @(posedge clk)
    begin
      if (CounterXmaxed)
      begin
        if(CounterYmaxed)
          CounterY <= 0;
        else
          CounterY <= CounterY + 1;
      end
    end

    always @(posedge clk)
    begin
      h_sync <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
      v_sync <= (CounterY > (480 + 10) && (CounterY < (480 + 10 + 2)));   // active for 2 clocks
    end

    always @(posedge clk)
    begin
        InDisplayArea <= (CounterX < 640) && (CounterY < 480);
    end

    assign vga_h_sync = ~h_sync;
    assign vga_v_sync = ~v_sync;

endmodule