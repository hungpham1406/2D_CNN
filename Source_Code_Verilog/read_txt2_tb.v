//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2023 09:01:24 PM
// Design Name: 
// Module Name: read_txt2_tb
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

`timescale 1ns / 1ps
module read_txt2_tb;

    reg clk;
    reg rst;
    wire [7:0] result;
    always #5 clk = ~clk;	
    initial 
    begin
        clk = 0;
        rst = 0;
        
    #10
        rst = 1;
    #10 
        rst = 0;
    #2617100
    $stop;
    end
    
    read_txt2 inst1(.clk(clk), .rst(rst), .result(result));

    
endmodule
