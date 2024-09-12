module top_level_test;
    reg [2:0] source;
    reg [2:0] dest;
    reg move,in;
    reg [15:0] data;
    reg clk;
    wire [15:0] out;
    
    initial clk = 0;

    always #10 clk = ~clk;

    main_register MR1 (source,dest,move,in,data,clk,out);

    initial
        begin
            dest = 0; data = 2; in = 1; move = 0;
            #100 $display("Input %d into %d using IN", data, dest);

            source = 0; dest = 1; in = 0; move = 1;
            #200 $display("Move %d from %d to %d using MOVE", out, source, dest);

            dest = 0; data = 1; in = 1; move = 0;
            #300 $display("Inputt %d into %d using IN", out, dest);
            
            source = 4; dest = 0; move = 1; in = 0;
            #400 $display("Mov %d from %d to %d using MOVE", out, source, dest);

            #500 dest = 3; in = 1; move = 1;

            #1000000 $finish;
        end
endmodule
