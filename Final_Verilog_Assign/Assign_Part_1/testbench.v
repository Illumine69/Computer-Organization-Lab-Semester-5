/*
Verilog Assignment 7
Problem No.: 1
Semester: 5
Group No.: 27
Yash Sirvi (21CS10083)
Sanskar Mittal (21CS10057)
*/

module testbench();

    reg [31:0] in1, in2;
    reg [3:0] func;
    reg clk = 0;
    always #1 clk = ~clk;
    wire [31:0]out;

    // change to 7 bits inputs due to size limitation on FPGA board
    alu G1(in1, in2, func, clk, out);

    initial begin
        in1 = 10;
        in2 = 6;
        func = 3'b0000;
        #50
        $display("ADD Function, %d  +%d  =%d", in1, in2, out);

        #10 
        in1 = 12;
        in2 = 2;
        func = 3'b0001;
        #50
        $display("SUBTRACT Function, %d  -%d  =%d", in1, in2, out);

        #10
        in1 = 23;
        in2 = 62;
        func = 3'b0010;
        #50
        $display("AND Function, %d  & %d =%d", in1, in2, out);

        #10
        in1 = 19;
        in2 = 81;
        func = 3'b0011;
        #50
        $display("OR Function, %d  | %d =%d", in1, in2, out);

        #10
        in1 = 51;
        in2 = 62;
        func = 3'b0100;
        #50
        $display("XOR Function, %d  ^ %d =%d", in1, in2, out);

        #10
        in1 = 12;
        func = 3'b0101;
        #50
        $display("NOT Function, ~%d =%d", in1, out);

        #10
        in1 = 9;
        in2 = 1;
        func = 3'b0110;
        #50
        $display("LEFT SHIFT Function, %d << %d =%d", in1, in2, out);

        #10
        in1 = 6;
        in2 = 1;
        func = 3'b0111;
        #50
        $display("RIGHT SHIFT ARITHMETIC Function, %d >>> %d =%d", in1, in2, out);

        #10
        in1 = 21;
        in2 = 1;
        func = 3'b1000;
        #50
        $display("RIGHT SHIFT LOGICAL Function, %d >> %d =%d", in1, in2, out);

        $finish;
    end
endmodule