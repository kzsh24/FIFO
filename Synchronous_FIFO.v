module FIFO_synch #(parameter Depth = 8, parameter width = 32)(
    input wire clk_r,
    input wire clk_w,
    input wire rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire [width-1:0] data_in,
    output reg [width-1:0] data_out,
    output wire full,
    output wire empty
);

localparam ptr_width = $clog2(Depth);

reg [width-1:0] fifo_mem [0:Depth-1];
reg [ptr_width:0] wr_ptr = 0;
reg [ptr_width:0] rd_ptr = 0;

always @(posedge clk_r or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= {width{1'bx}};
        rd_ptr <= 0;
    end else if (rd_en && !empty) begin
        data_out <= fifo_mem[rd_ptr[ptr_width-1:0]];
        rd_ptr <= rd_ptr + 1;
    end   
    else  data_out<=width-1'dx;
end

always @(posedge clk_w or negedge rst_n) begin
    if (!rst_n) begin
        wr_ptr <= 0;
    end else if (wr_en && !full) begin
        fifo_mem[wr_ptr[ptr_width-1:0]] <= data_in;
        wr_ptr <= wr_ptr + 1;
    end
end

assign empty = (wr_ptr == rd_ptr);
assign full  = (wr_ptr[ptr_width-1:0] == rd_ptr[ptr_width-1:0]) &&
               (wr_ptr[ptr_width] != rd_ptr[ptr_width]);

endmodule
