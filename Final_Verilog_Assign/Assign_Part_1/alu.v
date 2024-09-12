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
    signed input [31:0] n1,
    signed input [31:0] n2,
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
    signed input [31:0] n1,
    signed input [31:0] n2,
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
endmodule;

module alu(
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] func,
    input clk,
    output reg[31:0] out
);
    
    wire [31:0]outputs[8:0]; // 8 outputs from 8 modules

    // Instantiating 9 modules
    add G1(in1, in2, outputs[0]);
    subtract G2(in1, in2, outputs[1]);
    and_gate G3(in1, in2, outputs[2]);
    or_gate G4(in1, in2, outputs[3]);
    xor_gate G5(in1, in2, outputs[4]);
    not_gate G6(in1, outputs[5]);
    left_shift_arithmetic G7(in1, in2, outputs[6]);
    right_shift_arithmetic G8(in1, in2, outputs[7]);
    right_shift_logical G9(in1, in2, outputs[8]);
   
    always @(posedge clk)
        begin
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
                4'b0000: out = outputs[0];
                4'b0001: out = outputs[1];
                4'b0010: out = outputs[2];
                4'b0011: out = outputs[3];
                4'b0100: out = outputs[4];
                4'b0101: out = outputs[5];
                4'b0110: out = outputs[6];
                4'b0111: out = outputs[7];
                4'b1000: out = outputs[8];
                default: out = 0;
            endcase
        end
endmodule
