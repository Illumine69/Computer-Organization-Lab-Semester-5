module load_enable_register(
    input load,
    input enable,
    input [15:0] data,
    output reg [15:0] out
);
    reg [15:0] r = 0;
    always @(load || enable)
        begin
            if(load) begin
                r <= data;
            end
            if(enable)
                out <= r;
            else
                out <= 8'bzzzzzzzz;
        end
    
endmodule