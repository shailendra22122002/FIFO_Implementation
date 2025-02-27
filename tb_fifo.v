module tb_fifo();

    parameter DEPTH = 16;
    parameter DATA_WIDTH = 8;
    parameter PTR_SIZE = 5;

    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    wire full;
    wire empty;

    integer i;  // Declare loop variable outside the loop
    integer j;  // Another loop variable for reading

    // Instantiate FIFO
    fifo #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH),
        .PTR_SIZE(PTR_SIZE)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;  

    initial begin
        
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        // Reset the FIFO
        #10 rst_n = 1;  

        // Write data into the FIFO
        #10;
        wr_en = 1;
        for (i = 0; i < DEPTH; i = i + 1) begin  
            din = i;  
            #10;      
        end
        wr_en = 0;

        // Wait for a few cycles
        #30;

        // Read data from the FIFO
        rd_en = 1;
        for (j = 0; j < DEPTH; j = j + 1) begin  
            #10;  
        end
        rd_en = 0;

        #50;
        $finish;
    end

    initial begin
        $monitor("Time: %0t | wr_en = %b | rd_en = %b | din = %0d | dout = %0d | full = %b | empty = %b", 
                 $time, wr_en, rd_en, din, dout, full, empty);
    end

endmodule

