module Top_Level(
    input clk,
    input [2:0]reg_addr,
    input [3:0]mem_addr,
    input [31:0]data,
    input [1:0] opcode,
    input [31:0] data_out
);
    reg write_enable = 0;
    reg [31:0]data_in;
    reg calculating = 0;            // to prevent multiple call in the always clk loop
    reg [3:0] registers[0:7];       // register bank

    // block memory module call
    blk_mem_gen_0 blk_mem_gen_0(
        .clka(clk),
        .ena(1),
        .wea(write_enable),
        .addra(mem_addr),
        .dina(data_in),
        .douta(data_out)
    );

    always@(opcode)
        calculating = 1;


    always@(posedge clk)
    begin
        if(calculating)     // denotes that opcode has changed
        begin
            case(opcode)
                0: begin                // store data in memory location
                    data_in = data;
                    write_enable = 1;
                    end
                1: begin                // store data stored in specified register to specified memory location
                    data_in = registers[reg_addr];
                    write_enable = 1;
                end
                2: begin                // store data stored in specified memory location to specified register
                    write_enable = 0;
                    registers[reg_addr] = data_out;
                end
                3: begin                // Display the data in specified memory location
                    write_enable = 0;
                    $display("Data at memory %d is %d", 4*mem_addr, data_out);
                end
            endcase
        calculating = 0;        // switch case is called only when opcode changes
        end
    end
endmodule

module testbench();
    reg clk = 0;

    always #1 clk = ~clk;
    reg [2:0]reg_add;
    reg [3:0]mem_addr;
    reg [31:0]data;
    reg [1:0] opcode;
    wire [31:0]out;
    Top_Level REG_MEM(clk,reg_add,mem_addr,data,opcode,out);

    initial
        begin
            opcode = 0;
            data = 10;
            mem_addr = 4'd1;
            #100

            $display("Stored value %d at mem addr %d",data,4*mem_addr);

            opcode = 2;
            reg_add = 3'd4;
            mem_addr = 4'd1;
            #100

            $display("Stored value in register %d from memory %d",reg_add,4*mem_addr);

            opcode = 1;
            reg_add = 3'd4;
            mem_addr = 4'd3;
            #100

            $display("Stored value in memory %d from register %d",4*mem_addr,reg_add);

            opcode = 3;
            mem_addr = 4'd3;
            #100

            $finish;
        end
endmodule
