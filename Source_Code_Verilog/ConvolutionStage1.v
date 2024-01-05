`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2023 09:09:15 PM
// Design Name: 
// Module Name: ConvolutionStage1
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


module ConvolutionStage1 (
    input [3:0] a, 
    input [3:0] b, 
    input clk,
    input enable,
    output wire done, 
    output reg [7:0] prod
);

    reg [3:0] b_reg;
    reg [3:0] count;

    always @(posedge clk) begin
        prod = 0;
        b_reg = b;
        count = 4'b0100;
        if (((a!=0) && (b!=0)) && enable)
        begin
            if(b_reg == 4'b1111) begin
                prod = {4'b1111, ~(a)} + 8'b00000001; 
            end
            else begin
                while (count) begin
                    prod = {(({4{b_reg[0]}} & a) + prod[7:4]), prod[3:1]};
                    b_reg = b_reg >> 1;
                    count = count - 1;
                end   
            end
        end
    end

    assign done = 1;
endmodule