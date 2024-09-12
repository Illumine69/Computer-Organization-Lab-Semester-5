/*
Verilog Assignment 7
Problem No.: 1
Semester: 5
Group No.: 27
Yash Sirvi (21CS10083)
Sanskar Mittal (21CS10057)
*/

module testbench();

    reg [15:0] in;
    reg [3:0] func;
    reg clk = 0, reset = 0, nextstate = 0;
    always #1 clk = ~clk;
    wire [15:0]out;

    alu G1(in,clk, reset, nextstate, out);

    initial begin
        reset = 1;
        #1 reset = 0;
        in = 16'b0000000000000010;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000000000000111;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000000000000011;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        in = 16'b0000000000000011;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        func = 4'b0000;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 $display("ADD FUNC, lower 16 bits = %b", out);        
        #1 nextstate = 1;
        #1 nextstate = 0;
        $display("ADD FUNC, upper 16 bits = %b", out);
        // 00000000000001110000000000000010 + 00000000000000110000000000000011 = 00000000000010000000000000000101

        reset = 1;
        #1 reset = 0;
        in = 16'b0000000000000011;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000000000000011;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b000000000000001;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        in = 16'b0000000000001011;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        func = 4'b0001;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 $display("SUB FUNC, lower 16 bits = %b", out);        
        #1 nextstate = 1;
        #1 nextstate = 0;
        $display("SUB FUNC, upper 16 bits = %b", out);
        // 00000000000000110000000000000011 - 0000000000001011000000000000001 = 1111111111110000000000000000010

        reset = 1;
        #1 reset = 0;
        in = 16'b0000000000100011;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000000001000011;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000000000010010;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        in = 16'b0000010000001011;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        func = 4'b0010;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 $display("AND FUNC, lower 16 bits = %b", out);        
        #1 nextstate = 1;
        #1 nextstate = 0;
        $display("AND FUNC, upper 16 bits = %b", out);
        // 00000000010000110000000000100011 & 00000100000010110000000000010010 = 00000000000000110000000000000010

        reset = 1;
        #1 reset = 0;
        in = 16'b0000001000100010;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000100001000001;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000001000010000;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        in = 16'b0000010000001111;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        func = 4'b0011;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 $display("OR FUNC, lower 16 bits = %b", out);        
        #1 nextstate = 1;
        #1 nextstate = 0;
        $display("OR FUNC, upper 16 bits = %b", out);
        // 00001000010000010000001000100010 | 00000100000011110000001000010000 = 00001100010011110000001000110010

        reset = 1;
        #1 reset = 0;
        in = 16'b0000001000001010;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000100000000101;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000001000010010;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        in = 16'b0000000000001111;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        func = 4'b0100;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 $display("XOR FUNC, lower 16 bits = %b", out);        
        #1 nextstate = 1;
        #1 nextstate = 0;
        $display("XOR FUNC, upper 16 bits = %b", out);
        // 00001000000001010000001000001010 ^ 00000000000011110000001000010010 = 00001000000010100000000000011000

        reset = 1;
        #1 reset = 0;
        in = 16'b0010001000001010;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000100000100101;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000000000000000;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        in = 16'b0000000000000000;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        func = 4'b0101;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 $display("NOT FUNC, lower 16 bits = %b", out);        
        #1 nextstate = 1;
        #1 nextstate = 0;
        $display("NOT FUNC, upper 16 bits = %b", out);
        // ~00001000001001010010001000001010 = 11110111110110101101110111110101

        reset = 1;
        #1 reset = 0;
        in = 16'b0010011000001010;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0001100000000101;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000000000000001;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        in = 16'b0000000000000000;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        func = 4'b0110;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 $display("LSA FUNC, lower 16 bits = %b", out);        
        #1 nextstate = 1;
        #1 nextstate = 0;
        $display("LSA FUNC, upper 16 bits = %b", out);
        // 00011000000001010010011000001010 << 00000000000000000000000000000001 = 00110000000010100100110000010100

        
        reset = 1;
        #1 reset = 0;
        in = 16'b0010011001001010;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b1011100010000101;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000000000000001;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        in = 16'b0000000000000000;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        func = 4'b0111;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 $display("RSA FUNC, lower 16 bits = %b", out);        
        #1 nextstate = 1;
        #1 nextstate = 0;
        $display("RSA FUNC, upper 16 bits = %b", out);
        // 10111000100001010010011001001010 >>> 00000000000000000000000000000001 = 11011100010000101001001100100101

        reset = 1;
        #1 reset = 0;
        in = 16'b0010011001001010;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0011100000000101;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        in = 16'b0000000000000001;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        in = 16'b0000000000000000;
        #5
        nextstate = 1;
        #2 nextstate = 0;
        #5
        func = 4'b1000;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 nextstate = 1;
        #5 nextstate = 0;
        #5 $display("RSL FUNC, lower 16 bits = %b", out);        
        #1 nextstate = 1;
        #1 nextstate = 0;
        $display("RSL FUNC, upper 16 bits = %b", out);
        // 00111000000001010010011001001010 >> 00000000000000000000000000000001 = 00011100000000101001001100100101


        $finish;
    end
endmodule