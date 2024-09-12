module shifter_8(input [31:0] x, output reg[31:0] y);
    always @ (x)
    begin
        y = x >> 8;
    end
endmodule

module adder_32(input [31:0] x, input [31:0] y, output reg[31:0] z);
    always@ (x or y)
    begin
        z = x + y;
    end
endmodule

module div255(
    input [15:0]inp,
    // input flag,
    input reset,
    input clk,
    output reg[31:0] y
);
    reg [31:0] x = 0;
    // reg flag = 0;
    parameter index = 0;
    reg [31:0]ytemp = 0;
    wire [31:0]y_temp1, y_temp2, y_temp3;
    reg [1:0]calculating = 0;
    wire [31:0]x_shifted_8, x_shifted_16, x_shifted_24;
    // assign x_shifted = x;
    shifter_8 x_8(x,x_shifted_8);
    shifter_8 x_16(x_shifted_8,x_shifted_16);
    shifter_8 x_24(x_shifted_16,x_shifted_24);
    adder_32 A(x_shifted_8, y, y_temp1);
    adder_32 B(x_shifted_16, y_temp1, y_temp2);
    adder_32 C(x_shifted_24, y_temp2, y_temp3);

    parameter S0 = 0, // Start State, reset
              S1 = 1, // get 16 MSB of x
              S2 = 2, // get 16 LSB of x
              S3 = 3, // Shift x by 8 bits
              S4 = 4; // Add ytemp1 and x_shifted
    reg [2:0]state = 0, cstate = 0;
    always@(posedge clk)
    begin
        cstate =  state;
        case (cstate)
            S0: begin
                if (reset == 1)
                begin
                    y <= 0;
                    calculating <= 0;
                    state <= S1;
                end
                else
                    state <= S0;
            end
            S1: begin
//                $display("Reading 16 MSB of 0\n");
                x[31:16] <= 0;
                state <= S2;
            end
            S2: begin
//                $display("Reading 16 LSB of %d\n", inp);
                #1
                x[15:0] <= inp;
                #1
                state <= S3;
            end
            S3: begin
            //    $display("y_1 = %d", y_temp1);
            //    $display("y_2 = %d", y_temp2);
            //    $display("y_3 = %d", y_temp3);
                state <= S0;
                y <= y_temp3;
            end
            default: state <= S0;
        endcase
    end
endmodule