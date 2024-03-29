module adderStage2(
    input [7:0] input1, 
    input [7:0] input2, 
    input [7:0] input3,
    output reg [7:0] output1,
    input clk,
    input enable, 
    output reg done
);
    always @ (posedge clk) begin

        if(enable) begin
//            $display("Input1 = %d", input1);
//            $display("Input2 = %d", input2);
//            $display("Input3 = %d", input3);
            if(input1 !== 8'bx && input2 !== 8'bx && input3 !== 8'bx) begin
                output1 = input1 + input2 + input3;
                done = 1'b1;
            end
        end
        else begin
            output1 = 0;
            done = 1'b0;
        end    
    end
endmodule