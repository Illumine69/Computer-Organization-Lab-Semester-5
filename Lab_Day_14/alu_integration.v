module alu_integration(
    input [4:0] reg1Addr,
    input [4:0] reg2Addr,
    input [4:0] regWrite,
    input [3:0] aluControl,
    input [31:0] regWriteData,
    input write,
    input write_to_reg,
    input clk,
    input reset,
    input run,
    output [31:0] reg1Data,
    output [31:0] reg2Data
);
    // if (run == 1)
    // begin
    wire [31:0] aluResult;
    reg [31:0]reg_bank_write_data;

    always @(posedge clk)
    begin
        if (write == 1 )
            reg_bank_write_data <= regWriteData;
        else 
            reg_bank_write_data <= aluResult;
        // $display("reg_bank_write_data %d", reg_bank_write_data);
        // $display("reg1data = %d", reg1Data);
    end 

    reg_bank reg_bank(
        .reg1Addr(reg1Addr),
        .reg2Addr(reg2Addr),
        .regWrite(regWrite),
        .regWriteData(reg_bank_write_data),
        .write(write_to_reg),
        .reg1Data(reg1Data),
        .reg2Data(reg2Data),
        .clk(clk),
        .reset(reset)
    );


    alu alu(.inp1(reg1Data),
            .inp2(reg2Data),
            .func(aluControl),
            .clk(clk),
            .reset(reset),
            .out(aluResult)
    );
    // end
endmodule
