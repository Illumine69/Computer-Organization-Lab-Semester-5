module main_register(
    input [2:0] source, dest,
    input move, in,
    input [15:0] inp_d,
    input clk,
    output reg [15:0] out
);

    wire [15:0] R [7:0];
    reg enable;
    reg [7:0] load; 
    reg [15:0] inp_i;

    load_enable_register R0 ( load[0], enable, inp_i, R[0] );
    load_enable_register R1 ( load[1], enable, inp_i, R[1] );
    load_enable_register R2 ( load[2], enable, inp_i, R[2] );
    load_enable_register R3 ( load[3], enable, inp_i, R[3] );
    load_enable_register R4 ( load[4], enable, inp_i, R[4] );
    load_enable_register R5 ( load[5], enable, inp_i, R[5] );
    load_enable_register R6 ( load[6], enable, inp_i, R[6] );
    load_enable_register R7 ( load[7], enable, inp_i, R[7] );

    always @(posedge clk)
        begin
            load <= 0;
            enable <= 0;

            if (move && in) begin
                $display("Error: Move and In cannot be 1 at the same time!");
                $finish;
            end
            else begin
            if (move) begin
                    enable <= 1;
                    out <= R[source];
                    inp_i <= out; 
                    load[dest] <= 1;
                end
            else if (in) begin
                    enable <= 1;    
                    inp_i <= inp_d;
                    load[dest] <= 1;
                    out <= inp_d;
                end
            end
        end
endmodule