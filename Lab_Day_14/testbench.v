module testbench();

reg [15:0] in;
wire [15:0] out;
reg clk = 0, reset, nextstate;

top_module top_module(
    .in(in),
    .clk(clk),
    .reset(reset),
    .nextstate(nextstate),
    .out(out)
);

always #1 clk = ~clk;


initial begin
    reset = 1;
    # 3 reset = 0;
    // state = Sinit_reg1;
    # 3 in = 16'b0000000000000000; // source reg1 = register[0]
    # 3 nextstate = 1;
    # 3 nextstate = 0;
    // state = Sinit11;
    in = 16'b0000000000000010; // value of source reg1 = 2
    # 3 nextstate = 1;
    # 3 nextstate = 0;
    // state = Sinit12;
    in = 16'b0000000000000000; 
    # 3 nextstate = 1;
    # 3 nextstate = 0;
    // state = Sinit_reg2;
    in = 16'b0000000000000001; // source reg2 = register[1]
    # 3 nextstate = 1;
    # 3 nextstate = 0;
    // state = Sinit21;
    in = 16'b0000000000000101; // value of source reg2 = 5
    # 3 nextstate = 1;
    # 3 nextstate = 0;
    // state = Sinit22;
    in = 16'b0000000000000000; 
    # 3 nextstate = 1;
    # 3 nextstate = 0;
    // state = Sreg_addr;
    in = 16'b00000_00001_00010_0; // destination reg = register[2]
    # 3 nextstate = 1;
    # 3 nextstate = 0;
    // state = Sfunc;
    in = 16'b0000_0000_0000_0111; // func = add
    # 50 nextstate = 1;
    # 3 nextstate = 0;
    // state = Sread1;
    $display("out1 = %d", out);
    # 3 nextstate = 1;
    # 3 nextstate = 0;
    // state = Sread2;
    $display("out2 = %d", out);
    

    $finish;
end

endmodule