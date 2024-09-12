`include "alu_integration.v"
`include "branching_mechanism.v"
`include "instruction_decoding.v"
`include "instruction_mem.v"
`include "mem.v"
`include "mux_s.v"
`include "program_counter.v"
`include "register_bank.v"
`include "main_control.v"

module risc(
    input clk, 
    input reset,
    output reg [31:0] out
);

    // always @(*)
    // begin
    //     $display("risc clk: %d", clk);
    // end
    wire [31:0] memAddr, memWriteData;
    wire [31:0] PC, NPC, ins, imm_val;
    wire [5:0] opcode, func;
    wire [4:0] reg1, reg2, dest_reg, shamt;
    wire [1:0] stackOp;
    wire [2:0] branch, aluOp;
    wire [31:0] reg1Data, reg2Data, regWriteData, spOut;
    wire [31:0] aluOut, memReadData;
    wire haltOp, writeReg, aluSource, memRegPC, memWrite, memRead;
    wire interrupt;

    wire [31:0] alu_in1, alu_in2, writeData;

    assign alu_in1 = branch[0] ? PC : reg1Data;
    assign alu_in2 = aluSource ? reg2Data : imm_val;
    assign memWriteData = stackOp[0] ? NPC : reg2Data; // PC + 4 or (SP or R2)
    assign regWriteData = memRegPC ?  memReadData : aluOut; // memRegPC = 0 -> aluOut, memRegPC = 1 -> memReadData
    
    // Mem Addr MUX
    two2four_maddr mem_addr_mux(
        .stackOp(stackOp),
        .aluOut(aluOut),
        .sp(spOut),
        .pc_in(PC),
        .out(memAddr)
    );

    instruction_mem IM(
        .pc(PC),
        .instr(ins)
    );
    
    program_counter P_counter(
        .pc_in(NPC),
        .clk(clk),
        .reset(reset),
        .haltOp(haltOp),
        .pc_out(PC)
    );

    instruction_decoder ID(
        .instruction(ins),
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .reg1(reg1),
        .reg2(reg2),
        .dest_reg(dest_reg),
        .shamt(shamt),
        .func(func),
        .imm(imm_val)
    );

    reg_bank RB(
        .reg1Addr(reg1),
        .reg2Addr(reg2),
        .regWrite(dest_reg),
        .regWriteData(regWriteData),
        .write(writeReg),
        .reg1Data(reg1Data),
        .reg2Data(reg2Data),
        .spOut(spOut),
        .clk(clk),
        .reset(reset)
    );

    alu ALU(
        .inp1(alu_in1),
        .inp2(alu_in2),
        .aluOp(aluOp),
        .func(func),
        .clk(clk),
        .reset(reset),
        .out(aluOut)
    );

    data_mem DM(
        .addr(memAddr),
        .writeData(memWriteData),
        .memWrite(memWrite),
        .memRead(memRead),
        .readData(memReadData)
    );

    main_control CU(
        .opcode(opcode),
        .interrupt(interrupt),
        .clk(clk),
        .branch(branch),
        .memRead(memRead),
        .memWrite(memWrite),
        .writeReg(writeReg),
        .memRegPC(memRegPC),
        .aluSource(aluSource),
        .aluOp(aluOp),
        .stackOp(stackOp),
        .haltOp(haltOp)
    );

    program_counter PC_counter(
        .pc_in(NPC),
        .clk(clk),
        .reset(reset),
        .haltOp(haltOp),
        .pc_out(PC)
    );  

    branching_mechanism BM(
        .pc_in(PC),
        .reg2Data(reg2Data), // For getting flags (>, ==, <)
        .branchOp(branch),
        .aluOut(aluOut),    // For getting aluin1+imm (PC + imm)
        .clk(clk),
        .reset(reset),
        .pc_out(NPC)
    );


endmodule