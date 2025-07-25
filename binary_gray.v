module binary_to_gray #(
    parameter WIDTH = 8  
)(
    input  wire [WIDTH-1:0] bin,
    output wire [WIDTH-1:0] gray
);

    assign gray = bin ^ (bin >> 1);

endmodule

module gray_to_binary #(
    parameter WIDTH = 8  
)(
    input  wire [WIDTH-1:0] gray,
    output wire [WIDTH-1:0] bin
);

    reg [WIDTH-1:0] binary_reg;
    integer i;

    always @(*) begin
        binary_reg[WIDTH-1] = gray[WIDTH-1];  
        for (i = WIDTH-2; i >= 0; i = i - 1)
            binary_reg[i] = binary_reg[i+1] ^ gray[i];
    end

    assign bin = binary_reg;

endmodule
