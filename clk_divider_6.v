`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2025 11:22:56 AM
// Design Name: 
// Module Name: clk_divider_6
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
