`timescale 1ns / 1ps
module clk_divider_6(
input clk ,
input reset ,
output  clk_6
    );
reg Q1 , Q2 ,Q3;

always @(posedge clk or  negedge reset ) begin
    if (!reset )begin  
    Q1<=0;
    Q3<=0;
    Q2<=0;
     end
    else
    begin 
    Q1<=~Q3;
    Q2<=Q1;
    Q3<=Q2;
    end   
    end
    assign clk_6 = Q3; 
endmodule
