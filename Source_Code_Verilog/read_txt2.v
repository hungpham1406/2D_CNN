`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2023 08:59:29 PM
// Design Name: 
// Module Name: read_txt2
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

`define IMG_SIZE    100
`define KERNEL_SIZE 3
`define RES_SIZE    98
`define strides     2
`define POOLING_SIZE 49


module read_txt2(
    clk, rst, result 
    );
    input clk; 
    input rst;
    output [7:0] result;
    integer i;
    integer fd;
    integer fd2;
    integer signedValue;
    
    initial begin
        fd = $fopen("C:\\Vivaldo\\Project\\convolResult.txt", "w");
        fd2 = $fopen("C:\\Vivaldo\\Project\\result.txt", "w");
    end
    
    /*variable support for multiplication stage*/
    reg enable_convol;
    reg doneConvStage1;         /*Check if convolution stage 1 has finished or not*/
    
    reg [7:0] resultArray [0: `RES_SIZE * `RES_SIZE - 1]; 
    reg [3:0] imageArray[0: `IMG_SIZE * `IMG_SIZE - 1]; 
    reg [3:0] kernelArray[0: `KERNEL_SIZE * `KERNEL_SIZE - 1];
    reg [7:0] maxPoolArray [0:`RES_SIZE * `RES_SIZE - 1];
    
    reg isConvled [0:`RES_SIZE * `RES_SIZE - 1];
    
    reg [3:0] a;
    reg [3:0] b;

    wire check;
    
    reg [6:0] row_res;
    reg [6:0] col_res;
    
    reg [6:0] row_map;
    reg [6:0] col_map;
    reg [6:0] Fr_map;
    reg [6:0] Fc_map;
    reg [13:0] result_counter;
    /*------------------------*/
    
    /*variable support for adding stage*/
    reg begin_adding;
    
    wire [7:0] tmp_output1;
    wire [7:0] tmp_output2;
    wire [7:0] tmp_output3;
    wire [7:0] tmp_output;
    
    wire done_row1;
    wire done_row2;
    wire done_row3;
    wire en_sum;
    wire done_sum;
    
    /*-----------------------*/
    /*MAX POOL*/
    /*Max pool variables*/ 
    reg enable_max_pool;
    reg done_max_pool;
    reg [7:0] tmp_max_pool;
    
    reg [6:0] rowCount_image;
    reg [13:0] count_image;
    
    wire done; 
    wire [7:0] input1_image;    
    wire [7:0] input2_image;    
    wire [7:0] input3_image;
    wire [7:0] input4_image;
    
    wire [7:0] output_image;
    
    
    /*-----------------------*/ 
    ConvolutionStage1 c1_image(
        .a(a),
        .b(b),
        .clk(clk),
        .enable(enable_convol),
        .done(check),
        .prod(result)    
    );
    
    /*-----------------------*/    
    maxPooling c2_image(
        .clk(clk),
        .enable(enable_max_pool),
        .input1(input1_image),
        .input2(input2_image),
        .input3(input3_image),
        .input4(input4_image),
        .output1(output_image),
        .done(done)
    );
    /*-----------------------*/  
    /*
    why when we implement the mul then add, the data not over flow
    our input have 4 bits (0 ? 8)dec
    4bits * 4 bits = 6 bits maximun
    6bits + 6bits + 6bits = 8bits max ? handle overflow arithmetic 
    */

        
    /*-----------------------*/    
    always @ (posedge clk) begin
        if (rst) begin
            enable_convol <= 1'b1;
            begin_adding <= 1'b0;
            row_map <= 7'b0000000;
            col_map <= 7'b0000000;
            Fr_map <= 7'b0000000;
            Fc_map <= 7'b0000000;
            row_res <= 7'b0000000;
            col_res <= 7'b0000000;
            result_counter <= 14'b00000000000000;
            doneConvStage1 <= 1'b0;
            
            done_max_pool <= 1'b0;
            rowCount_image <= 7'b0000001;
            enable_max_pool <= 1'b0;
            count_image <= 0;
        end
        else if (!rst && enable_convol && !doneConvStage1) begin
            
            if(col_map < `KERNEL_SIZE) begin        //here
                a <= imageArray[`IMG_SIZE * row_map + col_map + Fr_map + Fc_map*`IMG_SIZE];
                b <= kernelArray[`KERNEL_SIZE * row_map + col_map];
                #12 resultArray[`KERNEL_SIZE * row_map + col_map] <= result;
               
            end
            if(resultArray[`KERNEL_SIZE * row_res + col_res] !== 1'bz) begin //here
                col_res <= col_res + 1;
            end
            if( check) begin
                col_map <= col_map + 1;
            end


            if (col_res == `RES_SIZE) begin
                col_res <= 7'b0000000;
                row_res <= row_res + 1;
            end
            
            if(row_res == `RES_SIZE) begin
                row_res <= 7'b0000000;
                col_res <= 7'b0000000;
            end
            
            if(col_map == `KERNEL_SIZE) begin
                col_map <= 7'b0000000;
                row_map <= row_map + 1;        
            end
            
            if(row_map == `KERNEL_SIZE) begin
                enable_convol <= 1'b0; 
                row_map <= 7'b0000000;
                col_map <= 7'b0000000;
                isConvled[Fr_map + Fc_map*`RES_SIZE] <= 1'b1;

                row_res <= 7'b0000000;
                col_res <= 7'b0000000;

            end               

        end
        
        if (isConvled[Fr_map + Fc_map*`RES_SIZE]) begin
            begin_adding <= 1'b1;
        end
        
        if (done_sum && begin_adding) begin
            
            $fwrite(fd, "%d\n", $signed(tmp_output));
            maxPoolArray[result_counter] = tmp_output;
            result_counter = result_counter + 1;
            
            begin_adding = 1'b0;

            for (i = 0; i < 9; i = i + 1)
                resultArray[i] = 1'bx;
                
            Fr_map = Fr_map + 1;
            
            if(Fr_map == `RES_SIZE) begin
                Fr_map = 7'b0000000;
                Fc_map = Fc_map + 1;
            end
            
            if(Fc_map == `RES_SIZE) begin
                enable_convol = 1'b0;
            end 
            enable_convol = 1'b1;

        end

        
        if(result_counter == `RES_SIZE * `RES_SIZE) begin
            $fclose(fd);
            result_counter = 14'b00000000000000;
            doneConvStage1 = 1'b1;
        end
        
        if(doneConvStage1) begin
            enable_max_pool <= 1'b1;
            if(enable_max_pool) begin
                if(rowCount_image < `RES_SIZE) begin
                    if(count_image < (rowCount_image*`RES_SIZE - 1 - `strides)) begin
                        count_image <= count_image + `strides; 
                        rowCount_image <= rowCount_image;
                    end
                    else begin
                        rowCount_image <= rowCount_image + `strides;
                        count_image <= rowCount_image*`RES_SIZE + `RES_SIZE;
                    end                    
                end
                else begin
                    count_image <= count_image;
                    rowCount_image <= rowCount_image;
                end
            end
            else begin
                count_image <= 0;
                rowCount_image <= 7'b0000001;
            end
            if(done) begin
                tmp_max_pool = output_image;
                result_counter <= result_counter + 1;
                done_max_pool <= 1'b1;
                if($signed(tmp_max_pool) < 0) begin 
                    tmp_max_pool = 8'b00000000;
                    $fwrite(fd2, "%d\n", tmp_max_pool);
                end
                else begin
                    $fwrite(fd2, "%d\n", $signed(tmp_max_pool));
                end
                if(result_counter == `POOLING_SIZE * `POOLING_SIZE - 1) begin
                    $fclose(fd2);
                    result_counter = 14'b00000000000000;
                end
            end
        end
    end /*end always*/
    
    assign en_sum = done_row1 && done_row2 && done_row3;
    initial $readmemb("C:\\Vivaldo\\Project\\grayscale_input2.txt", imageArray, 0, `IMG_SIZE * `IMG_SIZE - 1);
    initial $readmemb("C:\\Vivaldo\\Project\\kernel_edge_detect.txt", kernelArray, 0, `KERNEL_SIZE * `KERNEL_SIZE - 1);
    initial 
    for(i = 0; i < `RES_SIZE * `RES_SIZE; i = i + 1) begin
        isConvled[i] <= 0;
    end
    
    assign input1_image = (enable_max_pool && (rowCount_image < `RES_SIZE))?
                maxPoolArray[count_image + 0][7:0]:8'b00000000;
    assign input2_image = (enable_max_pool && (rowCount_image < `RES_SIZE))?
                maxPoolArray[count_image + 1][7:0]:8'b00000000;
    assign input3_image = (enable_max_pool && (rowCount_image < `RES_SIZE))?
                maxPoolArray[count_image + `RES_SIZE][7:0]:8'b00000000;
    assign input4_image = (enable_max_pool && (rowCount_image < `RES_SIZE))?
                maxPoolArray[count_image + `RES_SIZE + 1][7:0]:8'b00000000;
    
    
    /*-----SUB MODULE--------*/ 
    adderStage2 adder1(
        .input1(resultArray[0]),
        .input2(resultArray[1]),
        .input3(resultArray[2]),
        .clk(clk),
        .enable(begin_adding),
        .done(done_row1),
        .output1(tmp_output1)
    );
    
    adderStage2 adder2(
        .input1(resultArray[3]),
        .input2(resultArray[4]),
        .input3(resultArray[5]),
        .clk(clk),
        .enable(begin_adding),
        .done(done_row2),
        .output1(tmp_output2)
    );
    
    adderStage2 adder3(
        .input1(resultArray[6]),
        .input2(resultArray[7]),
        .input3(resultArray[8]),
        .clk(clk),
        .enable(begin_adding),
        .done(done_row3),
        .output1(tmp_output3)
    );
    
    adderStage2 adder4(
        .input1(tmp_output1),
        .input2(tmp_output2),
        .input3(tmp_output3),
        .clk(clk),
        .enable(en_sum),
        .done(done_sum),
        .output1(tmp_output)
    );  
    
endmodule