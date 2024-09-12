module top_module(
    input [15:0] in,
    input clk,
    input reset,        // to reset the system configuration
    input nextstate,    // to get inputs in different states for 32 bits(since fpga has only 16 bits input)
    output reg [15:0] out
);

    reg [3:0] state = 0, func = 0;
    reg write = 1;
    reg lock = 0;       // to allow only one state change on key press
    reg write_to_reg = 1;
    // reg lock_write = 0;
    parameter   Sinit_reg1 = 0,
                Sinit11 = 1,
                Sinit12 = 2,
                Sinit_reg2 = 3,
                Sinit21 = 4,
                Sinit22 = 5,
                Sreg_addr = 6,
                Sfunc = 7,
                Sread1 = 8,
                Sread2 = 9;
            //   Sout2 = 7;
    reg [31:0] reg_write_data;
    wire [31:0] reg1Data, reg2Data ;
    reg [4:0] reg1Addr=0, reg2Addr=0, regWrite;
    alu_integration alu_integration(
        .reg1Addr(reg1Addr),
        .reg2Addr(reg2Addr),
        .regWrite(regWrite),
        .regWriteData(reg_write_data),
        .aluControl(func),
        .write(write),
        .write_to_reg(write_to_reg),
        .reg1Data(reg1Data),
        .reg2Data(reg2Data),
        .clk(clk),
        .reset(reset)
    );
    always @(posedge clk)
        begin
            // $display("state = %d, nextstate = %d, lock = %d", state, nextstate, lock);
            if (reset == 1)             // reset the input configuration
                state <= Sinit_reg1;
            if (nextstate == 1 && lock == 0)
                begin 
                    state = state + 1;      // move to next stwrite_to_regate
                    lock = 1;               // lock any furthur state change
                end
            if (nextstate == 0)         // prevent furthur state change unless state change key is released
                lock = 0;
            // $display("\nstate %d in = %b, reg_write_data = %d", state, in, reg_write_data);
            case(state)
                Sinit_reg1: regWrite = in[4:0]; // regWrite = 5'b00000;
                Sinit11: reg_write_data[15:0] = in;
                Sinit12: reg_write_data[31:16] = in;
                Sinit_reg2: regWrite = in[4:0]; // regWrite = 5'b00000;
                Sinit21: reg_write_data[15:0] = in;
                Sinit22: 
                begin
                reg_write_data[31:16] = in;
                end
                Sreg_addr: begin
                                write = 0;
                                write_to_reg = 0;
                                reg1Addr = in[15:11];
                                reg2Addr = in[10:6];
                                regWrite = in[5:1];
                            end
                Sfunc: begin 
                        write_to_reg = 1;
                        func = in[3:0];
                end
                Sread1: begin
                            write_to_reg = 0;
                            reg1Addr = regWrite;
                            // regWrite = 5;
                            out = reg1Data[15:0];
                        end
                Sread2: out = reg1Data[31:16];
            endcase
        end
endmodule

module reg_bank(
    input [4:0] reg1Addr,
    input [4:0] reg2Addr,
    input [4:0] regWrite,
    input [31:0] regWriteData,
    input write,
    output [31:0] reg1Data,
    output [31:0] reg2Data,
    input clk,
    input reset
    );

    reg [31:0] registers [31:0];

    assign reg1Data = registers[reg1Addr];
    assign reg2Data = registers[reg2Addr];
    integer i;
    always @(posedge clk)
    begin
        // $display("regbank reg1data = %d \t %d", reg1Data, reg1Addr);
        if (reset == 1)
        begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 0;
        end 
        else 
        begin
            if (write == 1)
            begin
                // $display("regbank regWriteData = %d \t register %d", regWriteData, regWrite);
                registers[regWrite] <= regWriteData;
            end
        end
    end
endmodule



