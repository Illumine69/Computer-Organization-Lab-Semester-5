module branching_mechanism(
    input signed [31:0] pc_in, 
    input signed [31:0] reg2Data,
    input [2:0] branchOp,
    input [31:0] aluOut,
    input clk,
    input reset,    
    output reg [31:0] pc_out
);

    always @(posedge clk)
    begin
        // $display("%d", (branchOp == 3'b011 && reg2Data < 0));
        // if ((branchOp == 3'b011 && reg2Data < 0) || 
        //          (branchOp == 3'b101 && reg2Data > 0) || 
        //          (branchOp == 3'b111 && reg2Data == 0))
        //          $display("\n\n\n\nWeird Ahh Branching\n\n\n\n");
        if (reset == 1)
            pc_out <= 0;
        else if ((branchOp == 3'b011 && reg2Data < 0) || 
                 (branchOp == 3'b101 && reg2Data > 0) || 
                 (branchOp == 3'b111 && reg2Data == 0) ||
                 (branchOp == 3'b001))
            pc_out <= aluOut;
        else
            pc_out <= pc_in + 1;
        $display("branching_mechanism: pc_out = %d", pc_out);
    end
endmodule