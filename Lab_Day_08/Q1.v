module add(
    input [7:0] n1,
    input [7:0] n2,
    output [7:0] sum
);

    // Carry lookahead adder
    wire [7:0]c;    // carry
    wire [7:0]p;    // propagate
    wire [7:0]g;    // generate

    assign p = n1 ^ n2;     // p = n1 xor n2
    assign g = n1 & n2;     // g = n1 and n2
    assign c[0] = 0;        // c0 = 0 (no carry in)
    // ci+1 = gi + pi.ci
    assign c[1] = g[0] | (p[0] & c[0]); 
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign sum = p ^ c;    // sum = p xor c
endmodule


module subtract(
    input [7:0] n1,
    input [7:0] n2,
    output [7:0] diff
);

    wire [7:0] n2_comp; // two's complement of n2, gives -n2
    wire [7:0] one;    // 8-bit 1
    wire [7:0] sum;   // sum of n2_comp and 1

    // Taking two's complement
    // n2_comp = ~n2 + 1
    assign n2_comp = ~n2;   
    assign one = 8'b00000001;
    add G1(n2_comp, one, sum); // sum = n2_comp + 1
    add G2(n1, sum, diff);  // diff = n1 + (-n2)
endmodule

module identity(
    input [7:0] inp, 
    output [7:0] out
);

    assign out = inp; // identity function
endmodule

module left_shift(
    input [7:0] inp,
    output [7:0] out
);

    assign out = inp << 1;  // left shift by 1, effectively multiplying by 2

endmodule


module right_shift(
    input [7:0] inp,
    output [7:0] out
);

    assign out = inp >> 1; // right shift by 1, effectively integer division by 2

endmodule

module and_gate(
    input [7:0] n1,
    input [7:0] n2,
    output [7:0] out
);

    assign out = n1 & n2; // bitwise and

endmodule

module not_gate(
    input [7:0] inp,
    output [7:0] out
);

    assign out = ~inp;  // bitwise not
    // since numbers are unsigned, complement of a 8 bit number n will be 2^8 - n - 1
    // eg 5 = 00000101, complement = 11111010 = 250 = 256 - 5 - 1

endmodule


module or_gate(
    input [7:0] n1,
    input [7:0] n2,
    output [7:0] out
);

    assign out = n1 | n2; // bitwise or

endmodule


module alu(
    input [7:0] in1,
    input [7:0] in2,
    input [2:0] func,
    input clk, // clock
    output reg[7:0] out
);
    // reg [7:0] out;
    wire [7:0]outputs[7:0]; // 8 outputs from 8 modules
    // Instantiating 8 modules
    add G1(in1, in2, outputs[0]);
    subtract G2(in1, in2, outputs[1]);
    identity G3(in1, outputs[2]);
    left_shift G4(in1, outputs[3]);
    right_shift G5(in1, outputs[4]);
    and_gate G6(in1, in2, outputs[5]);
    not_gate G7(in1, outputs[6]);
    or_gate G8(in1, in2, outputs[7]);
    always @(posedge clk)
        begin
            // Selecting output based on func
            // States:
            // 000: ADD
            // 001: SUBTRACT
            // 010: IDENTITY
            // 011: LEFT SHIFT
            // 100: RIGHT SHIFT
            // 101: AND
            // 110: NOT
            // 111: OR
            case(func)
                3'b000: out = outputs[0]; 
                3'b001: out = outputs[1];
                3'b010: out = outputs[2];
                3'b011: out = outputs[3];
                3'b100: out = outputs[4];
                3'b101: out = outputs[5];
                3'b110: out = outputs[6];
                3'b111: out = outputs[7];
            endcase
        end
endmodule
