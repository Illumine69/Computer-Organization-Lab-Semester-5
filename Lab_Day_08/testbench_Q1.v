module testbench();

    reg [7:0] in1, in2;
    reg [2:0] func;
    reg clk = 0;
    always #1 clk = ~clk;
    wire [7:0]out;


    alu G1(in1, in2, func, clk, out);

    initial begin
        in1 = 1;
        in2 = 2;
        func = 3'b000;
        #10
        $display("ADD Function, %d  +%d  =%d", in1, in2, out);

        #50

        in1 = 5;
        in2 = 1;
        func = 3'b001;
        #10
        $display("SUBTRACT Function, %d  -%d  =%d", in1, in2, out);

        #50

        in1 = 12;
        in2 = 2;
        func = 3'b010;
        #10
        $display("IDENTITY Function, %d  = %d", in1, out);

        #50

        in1 = 9;
        in2 = 2;
        func = 3'b011;
        #10
        $display("LEFT SHIFT Function, %d << 1 =%d", in1, out);

        #50

        in1 = 6;
        in2 = 2;
        func = 3'b100;
        #10
        $display("RIGHT SHIFT Function, %d >> 1 = %d", in1, out);

        #50

        in1 = 23;
        in2 = 62;
        func = 3'b101;
        #10
        $display("AND Function, %d  & %d =%d", in1, in2, out);

        #50

        in1 = 50;
        in2 = 2;
        func = 3'b110;
        #10
        $display("NOT Function, ~%d = %d", in1, out);

        #50

        in1 = 23;
        in2 = 4;
        func = 3'b111;
        #10
        $display("OR Function, %d  |%d  = %d\n", in1, in2, out);

        #50

        in1 = 0;
        in2 = 42;
        func = 3'b000;
        #10
        $display("ADD Function, %d  +%d  =%d", in1, in2, out);

        #50

        in1 = 10;
        in2 = -20;
        func = 3'b001;
        #10
        $display("SUBTRACT Function, %d  -%d  =%d", in1, in2, out);

        #50

        in1 = 7;
        in2 = 0;
        func = 3'b010;
        #10
        $display("IDENTITY Function, %d  = %d", in1, out);

        #50

        in1 = 0;
        in2 = 2;
        func = 3'b011;
        #10
        $display("LEFT SHIFT Function, %d << 1 =%d", in1, out);

        #50

        in1 = 0;
        in2 = 2;
        func = 3'b100;
        #10
        $display("RIGHT SHIFT Function, %d >> 1 = %d", in1, out);

        #50

        in1 = 0;
        in2 = 12;
        func = 3'b101;
        #10
        $display("AND Function, %d  & %d =%d", in1, in2, out);

        #50

        in1 = 0;
        in2 = 21;
        func = 3'b110;
        #10
        $display("NOT Function, ~%d = %d", in1, out);

        #50

        in1 = 11;
        in2 = 0;
        func = 3'b111;
        #10
        $display("OR Function, %d  |%d  = %d", in1, in2, out);

        #50

        $finish;
    end
endmodule