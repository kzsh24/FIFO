module tb_top;

 parameter Width = 32, Depth = 8;
 reg clk_w=0,rst_n = 0, wr_en = 0, rd_en = 0;
 reg [31:0] data_in = 0;
 wire [31:0] data_out;
 wire full, empty;
 


always  #8 clk_w = ~clk_w; //60MHZ
    top dut (
        .clk_w(clk_w),
        .clk_r(clk_r),
        .rst_n(rst_n),
        .data_in(data_in),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    

    initial begin
    rst_n = 0;
    #50;
    rst_n = 1;

    // wite 7 values (fill most of FIFO)
    wr_en = 1;
    data_in = 32'h1234ABCD;  #15;
    data_in = 32'h14AC1268;  #15;
    data_in = 32'h4D4D4D67;  #15;
    data_in = 32'h8E7E6E5E;  #15;
    data_in = 32'hEEE54678;  #15;
    data_in = 32'hAAAAA543;  #15;
    data_in = 32'hFFFFFFFA;  #15;
    data_in = 32'hCECECECE;  #15;
    wr_en = 0;

    #50;

    //  Read all values
    rd_en = 1;
    #750;  
    rd_en = 0;

    //  Try reading again (FIFO  is empty )
    #50;
    rd_en = 1;
    #100;
    rd_en = 0;

    //  Write again  
    wr_en = 1;
    data_in = 32'hCAFEBABE; #15;
    data_in = 32'hBABABABA; #15;
    data_in = 32'h12345678; #15;
    wr_en = 0;

    //  Read again
    #40;
    rd_en = 1;
    #300;
    rd_en = 0;


    $finish;
end

 endmodule
