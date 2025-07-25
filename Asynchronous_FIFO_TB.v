`timescale 1ns/1ps

module asynch_fif0_tb;

    parameter DATA_WIDTH = 32;
    parameter DEPTH      = 128;
    parameter PTR_WIDTH  = $clog2(DEPTH);

 
    reg clkA = 0;  
    reg clkB = 0;  
    reg rst_n = 0;

    
    reg wr_en = 0;
    reg rd_en = 0;
    reg [DATA_WIDTH-1:0] data_in = 0;
    wire [DATA_WIDTH-1:0] data_out;
    wire full, empty;


    FIFO_Asynch #(
        .Depth(DEPTH),
        .width(DATA_WIDTH)
    ) dut (
        .clk_r(clkB),
        .clk_w(clkA),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #6.25 clkA = ~clkA;  // 80 MHz
    always #10   clkB = ~clkB;  // 50 MHz

   
    integer i;
    integer data_sent = 0;
    integer data_received = 0;

    initial begin
        rst_n = 0;
        #50;
        rst_n = 1;
    end

    // WRITE ONLY 
    initial begin
        @(posedge rst_n);
        #20;

        for (i = 0; i < 120; i = i + 1) begin
            @(posedge clkA);
            if (!full) begin
                wr_en <= 1;
                data_in <= i;
                data_sent=data_sent+1;
            end else begin
                wr_en <= 0;
                i = i - 1; // retry if full
            end
        end

        wr_en <= 0;
        @(posedge clkA);
        $display("✅ Writing complete: 120 items sent.FIFO is full: %b", full);
    end

//READ ONLY 
    initial begin
        @(posedge rst_n);
       
        #1700;  

        forever begin
            @(posedge clkB);
            if (!empty) begin
                rd_en <= 1;
                data_received=data_received+1;
            end else begin
                rd_en <= 0;
            end

            if (data_received == 120) begin
                rd_en <= 0;
                @(posedge clkB);
                $display("✅ Reading complete: 120 items received. FIFO is empty: %b", empty);
                $finish;
            end
        end
    end

   

endmodule
