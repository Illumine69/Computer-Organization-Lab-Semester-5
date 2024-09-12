module data_mem(
    input [31:0] addr,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output reg [31:0] readData
);
    reg [31:0] mem [0:16];
    integer i, k;
    initial begin
        // $readmemh("data.txt", mem, 0, 1023);
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = i;
        // $display("Data memory loaded");
    end

    always @(*) begin
        // mem[0] <= 0;
        if (memRead) readData <= mem[addr[9:0]];
        if (memWrite) mem[addr[9:0]] <= writeData;
		for(k = 0; k < 10; k = k + 1) $display("mem[%d] = %d", k, mem[k]);
        $display("\t Data memory: addr = %d, writeData = %d, readData = %d, memread = %d, memWrite=%d", addr, writeData, readData, memRead, memWrite);
    end
endmodule