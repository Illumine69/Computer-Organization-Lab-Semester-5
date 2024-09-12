module main_control(
    input [5:0] opcode,
    input interrupt,
    input clk,
    output reg [2:0] branch,
    output reg memRead,
    output reg memWrite,
    output reg memRegPC,
    output reg [2:0] aluOp,
    output reg aluSource,
    output reg [1:0] stackOp,
    output reg writeReg,
    output reg haltOp
);

    
 // Opcode		ALUop	    ALUcontrol_input	ALUsource	Write Reg	MemWrite	MemRead*	memRegPC	Stack Op	Branch haltOp
 // ------------------------------------------------------------------------------------------------------------------------------
 // 000000		001	        0001	            1	        1	        0	        0	        0	        00	        000     0
 // 000001	    010	        0001	            0	        1	        0	        0	        0	        00	        000     0
 // 000101	    011	        0010	            0	        1	        0	        0	        0	        00	        000     0
 // 001001	    100	        0011	            0	        1	        0	        0	        0	        00	        000     0
 // 001101	    101	        0100	            0	        1	        0	        0	        0	        00	        000     0
 // 010001	    110	        0101	            0	        1	        0	        0	        0	        00	        000     0
 // 010101	    000	        0001	            0	        1	        0	        1	        1	        00	        000     0
 // 011001	    000	        0001	            0	        0	        1	        1	        0	        00	        000     0
 // 011101	    000	        0001	            0	        1	        0	        1	        1	        00	        000     0
 // 100001	    000	        0001	            0	        0	        1	        0	        0	        00	        000     0
 // 100101      000         0001                0           1           0           0           0           00          000     0
 // 000010	    000	        0001	            0	        1	        0	        0	        0	        00	        001     0
 // 000110	    000	        0001	            0	        0	        0	        0	        0	        00	        011     0
 // 001010	    000	        0001	            0	        0	        0	        0	        0	        00	        101     0
 // 001110	    000	        0001	            0	        0	        0	        0	        0	        00	        111     0
 // 010010	    000	        0000	            0	        0	        1	        1	        0	        10	        000     0
 // 010110	    000	        0000	            0	        1	        0	        1	        0	        01	        000     0
 // 011010	    000	        0000	            0	        0	        1	        1	        0	        10	        001     0
 // 011110	    000	        0000	            0	        1	        0	        1	        1	        01	        000     0
 // 100010	    000	        0000	            0	        0	        0	        0	        0	        00	        000     1
 // 100110	    000	        0000	            0	        0	        0	        0	        0	        00	        000     0

parameter   ALU = 6'b000000,
            ADDI = 6'b000001,
            SUBI = 6'b000101,
            SLAI = 6'b001001,
            SRAI = 6'b001101,
            SRLI = 6'b010001,
            LD = 6'b010101,
            ST = 6'b011001,
            LDSP = 6'b011101,
            STSP = 6'b100001,
            MOVE=  6'b100101,
            BR	=  6'b000010,
            BMI	=  6'b000110,
            BPL	=  6'b001010,
            BZ	=  6'b001110,
            PUSH=  6'b010010,
            POP	=  6'b010110,
            CALL=  6'b011010,
            RET	=  6'b011110,
            HALT=  6'b100010,
            NOP	=  6'b100110;

    reg current_state;
    reg [4:0] micro_clk;

    initial begin
        aluOp =0;
        aluSource =0;  
        writeReg = 0;
        memWrite = 0;
        memRead = 0;
        memRegPC = 0;
        stackOp = 0;
        branch =0;
        haltOp =0;
        // updatePC =0;
        current_state = 0;
        micro_clk = 0;
    end

    always @ (posedge clk)
    begin
        case(current_state)
            0: begin
                current_state <=1;
                haltOp <=1;
            end
            1: begin
                case(opcode)
                    ALU:begin
                        $display("R type");
                        case(micro_clk)
                            0: begin
                            aluOp <= 3'b000;
                            aluSource <= 1'b1;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b000;
                            micro_clk <= 1;
                            end
                            1: begin
                                writeReg <= 1'b1;
                                micro_clk <= 2;
                            end
                            2: begin
                                current_state <= 0;
                                micro_clk <= 0;
                                writeReg <= 1'b0;
                                haltOp <= 1'b0;
                            end
                        endcase
                        end

                    // I Type
                    ADDI, MOVE: begin
                        case(micro_clk)
                            0: begin
                            aluOp <= 3'b010;
                            aluSource <= 1'b0;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b000;
                            micro_clk <= 1;
                            end
                            1: begin
                                writeReg <= 1'b1;
                                micro_clk <= 2;
                            end
                            2: begin
                                writeReg <= 1'b0;
                                haltOp <= 1'b0;
                                current_state <= 0;
                                micro_clk <= 0;
                            end
                        endcase
                        end
                    SUBI: begin
                        case(micro_clk)
                            0: begin
                            aluOp <= 3'b011;
                            aluSource <= 1'b0;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b000;
                            micro_clk <= 1;
                            end
                            1: begin
                                writeReg <= 1'b1;
                                micro_clk <= 2;
                            end
                            2: begin
                                writeReg <= 1'b0;
                                haltOp <= 1'b0;
                                current_state <= 0;
                                micro_clk <= 0;
                            end
                        endcase
                        end
                    SLAI: begin
                        case(micro_clk)
                            0: begin
                            aluOp <= 3'b100;
                            aluSource <= 1'b0;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b000;
                            micro_clk <= 1;
                            end
                            1: begin
                                writeReg <= 1'b1;
                                micro_clk <= 2;
                            end
                            2: begin
                                writeReg <= 1'b0;
                                haltOp <= 1'b0;
                                current_state <= 0;
                                micro_clk <= 0;
                            end
                        endcase
                        end
                    SRAI:
                        begin
                        case(micro_clk)
                            0: begin
                            aluOp <= 3'b101;
                            aluSource <= 1'b0;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b000;
                            micro_clk <= 1;
                            end
                            1: begin
                                writeReg <= 1'b1;
                                micro_clk <= 2;
                            end
                            2: begin
                                writeReg <= 1'b0;
                                haltOp <= 1'b0;
                                current_state <= 0;
                                micro_clk <= 0;
                            end
                        endcase
                        end
                    SRLI:
                        begin
                        case(micro_clk)
                            0: begin
                            aluOp <= 3'b110;
                            aluSource <= 1'b0;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b000;
                            micro_clk <= 1;
                            end
                            1: begin
                                writeReg <= 1'b1;
                                micro_clk <= 2;
                            end
                            2: begin
                                writeReg <= 1'b0;
                                haltOp <= 1'b0;
                                current_state <= 0;
                                micro_clk <= 0;
                            end
                        endcase
                        end

                    LD, LDSP: begin
                        case(micro_clk)
                            0: begin
                                haltOp <= 1'b1;
                                aluOp <= 3'b000;
                                aluSource <= 1'b0;
                                branch <= 3'b000;
                                stackOp <= 2'b00; 
                                micro_clk <= 1;
                                end
                            1: begin
                                memRead <= 1'b1;   
                                memWrite <= 1'b0;  
                                micro_clk <= 2;
                                end
                            2: begin
                                writeReg <= 1'b1;  
                                memRegPC <= 2'b1; 
                                micro_clk <=3;
                                end
                            3: begin
                                memRead <= 1'b0;
                                memRegPC <= 2'b0;
                                writeReg <= 1'b0;
                                current_state <= 0;
                                micro_clk <=0;
                                haltOp <= 1'b0;
                                end
                        endcase
                    end

                    ST, STSP: begin
                        case(micro_clk)
                            0: begin
                                haltOp <= 1'b1;
                                aluOp <= 3'b000;
                                aluSource <= 1'b0;
                                micro_clk <= 1;
                                writeReg <= 1'b0;  
                                branch <= 3'b000;
                                end
                            1: begin
                                // mem write enable
                                stackOp <= 2'b00;
                                memRead <= 1'b1;
                                memWrite <= 1'b1;
                                micro_clk <= 2;
                                end
                            2: begin
                                writeReg <= 1'b0;  
                                memRegPC <= 2'b0; 
                                micro_clk <=3;
                                end
                            3: begin
                                memRead <= 1'b0;
                                memWrite <= 1'b0;
                                memRegPC <= 2'b0;
                                writeReg <= 1'b0;
                                haltOp <= 1'b0;
                                current_state <= 0;
                                end
                        endcase
                        end 
                    BR: begin
                        case(micro_clk)
                            0: begin
                            aluOp <= 3'b000;
                            aluSource <= 1'b0;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            writeReg <= 1'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b001;
                            micro_clk <= 1;
                            haltOp <= 1'b1;
                            end
                            1: begin
                                micro_clk <=2;
                            end
                            2: begin // buffer for aluOut
                                current_state <= 0;
                                micro_clk <= 0;
                                haltOp <= 1'b0;
                            end
                        endcase
                        end
                    BMI: begin
                        case(micro_clk)
                            0: begin
                            aluOp <= 3'b000;
                            aluSource <= 1'b0;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            writeReg <= 1'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b011;
                            micro_clk <= 1;
                            haltOp <= 1'b1;
                            end
                            1: begin
                                micro_clk <=2;
                            end
                            2: begin // buffer for aluOut
                                current_state <= 0;
                                micro_clk <= 0;
                                haltOp <= 0;
                            end
                        endcase
                        end

                    BPL:begin
                        case(micro_clk)
                            0: begin
                                branch <= 3'b101;
                                aluOp <= 3'b000;
                                aluSource <= 1'b0;
                                memWrite <= 1'b0;
                                memRead <= 1'b0;
                                memRegPC <= 2'b0;
                                writeReg <= 1'b0;
                                stackOp <= 2'b00;
                                micro_clk <= 1;
                                haltOp <= 1'b1;
                            end
                            1: begin
                                micro_clk <=2;
                            end
                            2: begin // buffer for aluOut
                                current_state <= 0;
                                micro_clk <= 0;
                                haltOp <= 0;
                            end
                        endcase
                        end

                    BZ:begin 
                        case(micro_clk)
                            0: begin
                                branch <= 3'b111;
                                aluOp <= 3'b000;
                                aluSource <= 1'b0;
                                memWrite <= 1'b0;
                                memRead <= 1'b0;
                                memRegPC <= 2'b0;
                                writeReg <= 1'b0;
                                stackOp <= 2'b00;
                                micro_clk <= 1;
                                haltOp <= 1'b1;
                            end
                            1: begin
                                micro_clk <=2;
                                branch <= 3'b111;
                            end
                            2: begin // buffer for aluOut
                                current_state <= 0;
                                micro_clk <= 0;
                                haltOp <= 0;
                            end
                        endcase
                        end

                    PUSH: begin
                        case(micro_clk)
                            0: begin 
                                writeReg <= 1'b0;
                                branch <= 3'b000;
                                aluOp <= 3'b000;
                                aluSource <= 1'b1;
                                memRead <= 1'b0;
                                memRegPC <= 2'b0;
                                stackOp <= 2'b10;
                                memWrite <= 1'b0;
                                micro_clk  <= 1;
                                haltOp <= 1'b1;
                            end
                            1: begin 
                                micro_clk  <= 2;
                            end
                            2: begin 
                                // initiate memory write
                                memWrite <= 1;
                                micro_clk <= 3;
                            end
                            3: begin 
                                current_state <= 0;
                                micro_clk <= 0;
                                haltOp <= 0;
                            end
                endcase
                    end
                    POP: begin
                        case(micro_clk) 
                            0: begin 
                                branch <= 3'b000;
                                aluOp <= 3'b000;
                                aluSource <= 1'b0;
                                memWrite <= 1'b0;
                                memRegPC <= 1'b0; 
                                stackOp <= 2'b01;
                                micro_clk <= 1;
                                haltOp <= 1'b1;
                            end
                            1: begin 
                                memRead <= 1;
                                micro_clk <= 2;
                            end
                            2: begin 
                                memRead <= 0;
                                writeReg <= 1;
                                micro_clk <= 3;
                            end
                            3: begin 
                                writeReg <= 0; 
                                memRegPC <= 0;
                                micro_clk <= 4;
                            end
                            4: begin 
                                writeReg <= 1;
                                micro_clk <= 5;
                            end
                            5: begin 
                                writeReg <= 0;
                                haltOp <= 0;
                                micro_clk <= 0;
                                current_state <= 0;
                            end
                        endcase
                        end
                    CALL: begin
                        case(micro_clk)
                            0: begin 
                                branch <= 3'b001;
                                aluOp <= 3'b000;
                                aluSource <= 1'b0;
                                memRead <= 1'b1;
                                memRegPC <= 2'b0;
                                writeReg <= 1'b0;
                                stackOp <= 2'b10;
                                micro_clk <= 1;
                                haltOp <= 1'b1;
                            end
                            1: begin 
                                writeReg <= 1;
                                micro_clk <= 2;
                            end
                            2: begin 
                                writeReg <= 0;
                                memWrite <= 1'b1;
                                micro_clk <= 3;
                            end
                            3: begin
                                memWrite <= 0;
                                micro_clk <= 4; 
                            end
                            4: begin 
                                haltOp <= 0; 
                                micro_clk <= 0;
                                current_state <= 0;
                            end
                        endcase
                    end

                    RET: begin 
                        case(micro_clk)
                            0: begin 
                                branch <= 3'b000;
                                aluOp <= 3'b000;
                                aluSource <= 0; 
                                memWrite <= 0;      
                                memRegPC <= 1;
                                stackOp <= 2'b01;
                                micro_clk <= 1;
                            end
                            1: begin    
                                memRead <= 1;
                                micro_clk <= 2;
                            end
                            2: begin 
                                memRead <= 0;
                                writeReg <= 1;
                                micro_clk <= 3;
                            end
                            3: begin
                                writeReg <= 0;
                                haltOp <= 0;
                                micro_clk <= 0;
                                current_state <= 0;
                        end
                    endcase
                end
                    HALT: begin
                        case (micro_clk)
                        0: begin
                            aluOp <= 3'b000;
                            aluSource <= 1'b0;
                            writeReg <= 1'b0;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b000;
                            haltOp <= 1'b1;
                            micro_clk <= 1;
                        end
                        1:
                        begin
                            if (interrupt == 1) begin
                                haltOp <= 0;
                                current_state <= 0;
                            end
                                micro_clk <= 0;
                        end
                        endcase
                    end
                    NOP: begin 
                        case (micro_clk)
                        0: begin
                            aluOp <= 3'b000;
                            aluSource <= 1'b0;
                            writeReg <= 1'b0;
                            memWrite <= 1'b0;
                            memRead <= 1'b0;
                            memRegPC <= 2'b0;
                            stackOp <= 2'b00;
                            branch <= 3'b000;
                            haltOp <= 1'b1;
                            micro_clk <= 1;
                        end
                        1:
                        begin
                                haltOp <= 0;
                                current_state <= 0;
                                micro_clk <= 0;
                        end
                        endcase
                    end
                endcase
            end
        endcase
        // $display("current_state: %d", current_state);
        // $display("opcode: %d", opcode);
    end
endmodule