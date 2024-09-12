module reg_bank(
    input [4:0] reg1Addr,
    input [4:0] reg2Addr,
    input [4:0] regWrite,
    input signed [31:0] regWriteData,
    input write,
    input [1:0] stackOp,
    output [31:0] reg1Data,
    output [31:0] reg2Data,
    output [31:0] spOut,
    input clk,
    input reset
    );

    reg signed [31:0] reg_arr [31:0];

    assign reg1Data = reg_arr[reg1Addr];
    assign reg2Data = reg_arr[reg2Addr];
    assign spOut = reg_arr[29];
    integer i;
    always @(posedge clk)
    begin
        if (reset == 1)
        begin
            // reset registers till 32
            reg_arr[0] <= 0;
            reg_arr[1] <= 0;
            reg_arr[2] <= 0;
            reg_arr[3] <= 0;
            reg_arr[4] <= 0;
            reg_arr[5] <= 0;
            reg_arr[6] <= 0;
            reg_arr[7] <= 0;
            reg_arr[8] <= 0;
            reg_arr[9] <= 0;
            reg_arr[10] <= 0;
            reg_arr[11] <= 0;
            reg_arr[12] <= 0;
            reg_arr[13] <= 0;
            reg_arr[14] <= 0;
            reg_arr[15] <= 0;
            reg_arr[16] <= 0;
            reg_arr[17] <= 0;
            reg_arr[18] <= 0;
            reg_arr[19] <= 0;
            reg_arr[20] <= 0;
            reg_arr[21] <= 0;
            reg_arr[22] <= 0;
            reg_arr[23] <= 0;
            reg_arr[24] <= 0;
            reg_arr[25] <= 0;
            reg_arr[26] <= 0;
            reg_arr[27] <= 0;
            reg_arr[28] <= 0;
            reg_arr[29] <= 0;
            reg_arr[30] <= 0;
            reg_arr[31] <= 0;
            $display("Resetting registers");
        end 
        else
        begin
            if (write == 1 && regWrite != 0)
                begin
                reg_arr[regWrite] <= regWriteData;
                $display("\n\nRegister bank updated wef\t regWrite = %d \t regWriteData = %d\n\n", regWrite, regWriteData);
                end
            if (stackOp == 2'b01)
                reg_arr[29] <= reg_arr[29] + 4;
            else if (stackOp == 2'b10)
                reg_arr[29] <= reg_arr[29] - 4;
            $display("Register bank updated");
            for (i = 0; i < 32; i = i + 1)
                $display("reg_arr[%d] = %d", i, reg_arr[i]);
        end
    end
endmodule