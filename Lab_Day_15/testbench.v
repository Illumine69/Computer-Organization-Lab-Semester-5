`include "RISC.v"

module tb();
    reg clk = 0,reset=0;
    always #1 clk = ~clk;
    wire [31:0] out;
    risc RISC(
        .clk(clk),
        .reset(reset),
        .out(out)
    );

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(10, tb);
        reset = 1;
        #2;
        reset = 0;
        #75;
        $finish;
    end
    
endmodule