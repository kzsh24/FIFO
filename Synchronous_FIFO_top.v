module top (
 
    input wire clk_w,   
    input wire rst_n,         
    input wire [31:0] data_in,  
    input wire wr_en,
    input wire rd_en,
    output wire [31:0] data_out,
    output wire full,
    output wire clk_r,
    output wire empty
);

    //wire  clk_r;
   
    

    clk_devider_6 clk_div_inst (
        .clk(clk_w),
        .reset(rst_n),
        .clk_6(clk_r)
    );

   

    FIFO_synch fifo_inst (
        .clk_r(clk_r),
        .clk_w(clk_w),
        .rst_n(rst_n),            
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );



endmodule
