module FIFO_Asynch #(parameter Depth = 8, parameter width = 32)(
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

wire [ptr_width:0] rd_ptr_gray ,wr_ptr_gray ;
reg  [ptr_width:0] rd_ptr_gray_ff1 ,wr_ptr_gray_ff1 ;
reg  [ptr_width:0] rd_ptr_gray_ff2 ,wr_ptr_gray_ff2 ;
wire [ptr_width:0] rd_ptr_bin,wr_ptr_bin;


// Convert binary pointers to gray code
binary_to_gray #(.WIDTH(ptr_width+1)) b2g_rd (
    .bin(rd_ptr),
    .gray(rd_ptr_gray)
);

binary_to_gray #(.WIDTH(ptr_width+1)) b2g_wr (
    .bin(wr_ptr),
    .gray(wr_ptr_gray)
);

// Convert gray code pointers back to binary
gray_to_binary #(.WIDTH(ptr_width+1)) g2b_rd (
    .gray(rd_ptr_gray_ff2),
    .bin(rd_ptr_bin)
);

gray_to_binary #(.WIDTH(ptr_width+1)) g2b_wr (
    .gray(wr_ptr_gray_ff2),
    .bin(wr_ptr_bin)
);

always @(posedge clk_w or negedge rst_n) begin
    if (!rst_n) begin
        
        rd_ptr_gray_ff1 <= 0;
        rd_ptr_gray_ff2 <= 0;
    end else begin
        rd_ptr_gray_ff1 <= rd_ptr_gray;
        rd_ptr_gray_ff2 <= rd_ptr_gray_ff1;
    end
end

always @(posedge clk_r or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0;
        wr_ptr_gray_ff1 <= 0;
        wr_ptr_gray_ff2 <= 0;
    end else begin
        wr_ptr_gray_ff1 <= wr_ptr_gray;
        wr_ptr_gray_ff2 <= wr_ptr_gray_ff1;
    end
end



always @(posedge clk_r or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= {width{1'bx}};
        rd_ptr <= 0;
    end else if (rd_en && !empty) begin
        data_out <= fifo_mem[rd_ptr[ptr_width-1:0]];
        rd_ptr <= rd_ptr + 1;
    end   
    
end

always @(posedge clk_w or negedge rst_n) begin
    if (!rst_n) begin
        wr_ptr <= 0;
    end else if (wr_en && !full) begin
        fifo_mem[wr_ptr[ptr_width-1:0]] <= data_in;
        wr_ptr <= wr_ptr + 1;
    end
end

assign empty = (rd_ptr_gray == wr_ptr_gray_ff2);

assign full  = (wr_ptr_gray[ptr_width]     != rd_ptr_gray_ff2[ptr_width]) &&
               (wr_ptr_gray[ptr_width-1:0] == rd_ptr_gray_ff2[ptr_width-1:0]);


endmodule
