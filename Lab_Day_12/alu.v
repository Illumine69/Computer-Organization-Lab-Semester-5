/*
Verilog Assignment 7
Problem No.: 1
Semester: 5
Group No.: 27
Yash Sirvi (21CS10083)
Sanskar Mittal (21CS10057)
*/

module add(
    input [31:0] n1,
    input [31:0] n2,
    output [31:0] sum
);

    assign sum = n1 + n2;
endmodule

module subtract(
    input signed [31:0] n1,
    input signed [31:0] n2,
    output [31:0] diff
);
    assign diff = n1 - n2;
endmodule

module and_gate(
    input [31:0] n1,
    input [31:0] n2,
    output [31:0] out
);

    assign out = n1 & n2;
endmodule

module or_gate(
    input [31:0] n1,
    input [31:0] n2,
    output [31:0] out
);

    assign out = n1 | n2;
endmodule

module xor_gate(
    input [31:0] n1,
    input [31:0] n2,
    output [31:0] out
);

    assign out = n1 ^ n2;
endmodule

module not_gate(
    input [31:0] inp,
    output [31:0] out
);

    assign out = ~inp;
endmodule

module left_shift_arithmetic(
    input [31:0] n1,
    input [31:0] n2,
    output [31:0] out
);

    assign out = n1 << n2;  
endmodule

module right_shift_arithmetic(
    input signed [31:0] n1,
    input signed [31:0] n2,
    output [31:0] out
);

    assign out = n1 >>> n2;
endmodule

module right_shift_logical(
    input [31:0] n1,
    input [31:0] n2,
    output [31:0] out
);

    assign out = n1 >> n2;
endmodule

module alu(
    input [15:0] in,
    input clk,
    input reset,        // to reset the system configuration
    input nextstate,    // to get inputs in different states for 32 bits(since fpga has only 16 bits input)
    output reg[15:0] out
);

    reg [3:0] state = 0, func = 0;
    reg lock = 0;       // to allow only one state change on key press
    reg [31:0]output32;
    parameter SI11 = 0,
              SI12 = 1,
              SI21 = 2,
              SI22 = 3,
              Sfunc = 4,
              SCalc = 5,
              Sout2 = 6;
    reg [31:0]inp1, inp2;
    wire [31:0]outputs[8:0]; // 8 outputs from 8 modules

    // Instantiating 9 modules
    add G1(inp1, inp2, outputs[0]);
    subtract G2(inp1, inp2, outputs[1]);
    and_gate G3(inp1, inp2, outputs[2]);
    or_gate G4(inp1, inp2, outputs[3]);
    xor_gate G5(inp1, inp2, outputs[4]);
    not_gate G6(inp1, outputs[5]);
    left_shift_arithmetic G7(inp1, inp2, outputs[6]);
    right_shift_arithmetic G8(inp1, inp2, outputs[7]);
    right_shift_logical G9(inp1, inp2, outputs[8]);
   
    always @(posedge clk)
        begin
            if (reset == 1)             // reset the input configuration
                state <= SI11;
            if (nextstate == 1 && lock == 0)
                state = state + 1;      // move to next state
                lock = 1;               // lock any furthur state change
            if (nextstate == 0)         // prevent furthur state change unless state chnage key is released
                lock = 0;
            case(state)
                SI11: inp1[15:0] = in;
                SI12: inp1[31:16] = in;
                SI21: inp2[15:0]  = in;
                SI22: inp2[31:16] = in;
                Sfunc: func = in[3:0];
                SCalc: begin
                    // Selecting output based on func
                    // States:
                    // 0000: ADD
                    // 0001: SUBTRACT
                    // 0010: AND
                    // 0011: OR
                    // 0100: XOR
                    // 0101: NOT
                    // 0110: LSA
                    // 0111: RSA
                    // 1000: RSL
                    case(func)
                        4'b0000: output32 = outputs[0];
                        4'b0001: output32 = outputs[1];
                        4'b0010: output32 = outputs[2];
                        4'b0011: output32 = outputs[3];
                        4'b0100: output32 = outputs[4];
                        4'b0101: output32 = outputs[5];
                        4'b0110: output32 = outputs[6];
                        4'b0111: output32 = outputs[7];
                        4'b1000: output32 = outputs[8];
                        default: output32 = 0;
                    endcase
                    out = output32[15:0];
                end
                Sout2: out = output32[31:16];
                default: state <= SI11;
            endcase
        end
endmodule