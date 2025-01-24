module fifo #(
    parameter DEPTH = 16,
    parameter DATA_WIDTH = 8,
    parameter PTR_SIZE = 5
)(
    input wire clk,
    input wire rst_n,        
    input wire wr_en,        
    input wire rd_en,        
    input wire [DATA_WIDTH-1:0] din,  
    output reg [DATA_WIDTH-1:0] dout, 
    output reg full,         
    output reg empty        
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1]; 
    reg [PTR_SIZE-1:0] wr_ptr, rd_ptr;    
    reg [PTR_SIZE:0] fifo_count;         

    // Write Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            dout <= 0;
        end else if (rd_en && !empty) begin
            dout <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // FIFO full and empty conditions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_count <= 0;
        end else begin
            case ({wr_en, rd_en})
                2'b10: fifo_count <= fifo_count + 1;  
                2'b01: fifo_count <= fifo_count - 1;  
                default: fifo_count <= fifo_count;    
            endcase
        end
    end

    // Full and empty flags
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            full <= 0;
            empty <= 1;
        end else begin
            full <= (fifo_count == DEPTH);
            empty <= (fifo_count == 0);
        end
    end

endmodule
