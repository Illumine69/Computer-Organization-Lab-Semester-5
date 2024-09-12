module instruction_mem(
    input [31:0] pc,
    output reg [31:0] instr
);

    reg [31:0] mem [1023:0];
    initial begin
        $readmemb("instructions.mem", mem, 0, 1023);
    end

    always @(*) begin
        // $display("instruction_mem: pc = %d", pc);
        instr = mem[pc[9:0]]; end

endmodule

