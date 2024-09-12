// Assignment 4 (Verilog)
// Group No 27
// Question 1
// Semester 5
// Yash Sirvi (21CS10083)
// Sanskar Mittal (21CS10057)

module arithmatic_shift(
    input [7:0] a,
    input [7:0] q,
    output reg [7:0] a_out,
    output reg [7:0] q_out 
);
    reg a_buff;
    always @(a or q)
    begin
        // $display("\t shifter called, a = %d, q = %d", a, q);
        q_out = q >> 1;
        q_out[7] = a[0];
        // reg a_buff = a[7];
        a_buff = a[7];
        a_out = a >> 1;
        a_out[7] = a_buff;
        // $display("\t shifter called, a_out = %d, q_out = %d", a_out, q_out);
    end
endmodule

module adder(
    input [7:0] n1,
    input [7:0] n2,
    output reg[7:0] sum
);
    always @(n1 or n2)
        begin
            sum = n1 + n2;
            // $display("\tadder called");
        end
endmodule

module subtractor(
    input [7:0] n1,
    input [7:0] n2,
    output reg [7:0] diff
);
    always @(n1 or n2)
        begin
             diff = n1 + (~n2 + 1);
            //  $display("\tsub called, diff of %d, %d = %d",n1,n2, diff);
        end
endmodule


module booth_multiplier(
    input  signed[7:0] multiplicand,      // multiplicand
    input  signed[7:0] multiplier,      // multiplier
    input clk,          // clock
    output reg signed [15:0] prod
);
    reg  signed[7:0] M, Q;
    // assign M = multiplicand;
    // assign Q = multiplier;
    reg  signed[7:0] A = 8'b00000000;
    reg  signed[3:0]count = 7;
    reg calculating = 0, qbuff = 0;

    wire  [7:0]add_temp, sub_temp, shift_A, shift_Q;
    subtractor S1(A, M, sub_temp);
    adder A2(A, M, add_temp);
    arithmatic_shift shifter(A, Q, shift_A, shift_Q);


    always @(multiplicand or multiplier)
    begin
        calculating = 0;
    end

    always @(posedge clk)
        begin
            if (calculating == 0)
                begin
                Q <= multiplier;
                M <= multiplicand;
                calculating <= 1;
                end
            else
                begin
                if (count >= 0 && count <= 7 )
                    begin
                    // $display("\nA = %b, Q = %b, M = %d", A, Q, M);
                    // $display("Qi = %d, Qi-1 = %d", Q[0], qbuff);
                        if (qbuff == 0 && Q[0] == 1)
                            begin
                                A = sub_temp;
                                $display("A = %b, Q = %b, M = %d", A, Q, M);
                            end

                        else if (qbuff == 1 && Q[0] == 0)
                            begin
                                A = add_temp;
                                $display("A = %b, Q = %b, M = %d", A, Q, M);
                            end
                    count = count - 1;
                    end
                
                // $display("sub_temp = %d, add_temp = %d", sub_temp, add_temp);
                // $display("count = %d", count);
                end
        end
    always @(negedge clk)
        begin
            if (count >= -1 && count < 7 )
            begin 
                qbuff = Q[0];
                Q = shift_Q;
                A = shift_A;
                prod[15:8] = A;
                prod[7:0] = Q;
                $display("A = %b, Q = %b, M = %d\n", A, Q, M);
                // $display("Product of %d and %d is %d", multiplicand, multiplier, prod);
            end
        end
endmodule


module testbench();
    reg signed[7:0] M, Q;
    wire signed[15:0] out;
    reg clk = 0;
    reg calculating = 1;
    booth_multiplier multiplier(M, Q, clk,out);
    always #5 clk = ~clk;

    initial begin
        Q = 8'b00001101;
        M = 8'b11110110;
        // Q = 8'b00000001;
        // M = 8'b00000001;
        #100 $display("Product of %d and %d is %d", M, Q, out);
        $finish;
    end
endmodule   