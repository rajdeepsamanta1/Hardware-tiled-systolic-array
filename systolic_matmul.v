`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2025 23:50:46
// Design Name: 
// Module Name: systolic_matmul
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


`include "config_sys.vh"

module systolic_matmul(
    input wire clk, 
    input wire deload_out,
    input wire reset,
    input wire reset_sys,
    input wire compute_done,
    input wire [`DATA_WIDTH*`ROW_A-1:0] a_in, 
    input wire [`WEIGHT_WIDTH*`COL_W-1:0]w_in, 
    output reg [`OUT_WIDTH*`ROW_A-1:0]out
);


  
    wire [`DATA_WIDTH-1:0]a_out[`ROW_A-1:0][`COL_W-1:0];
    wire [`WEIGHT_WIDTH-1:0]w_out[`ROW_A-1:0][`COL_W-1:0];
    wire [`DATA_WIDTH+`WEIGHT_WIDTH-1:0] res[`ROW_A-1:0][`COL_W-1:0]; 
    //reg  [`DATA_WIDTH+`WEIGHT_WIDTH-1:0] res_buff[`ROW_A-1:0][`COL_W-1:0]; 
    

// the entire grid is generated
// the array consisting of rows and column are stacked
// they can operate concurrently on different tiles

 genvar i,j,k;     
    generate
       // genvar i, j, k;
        
            for (j = 0; j < `ROW_A; j = j + 1) begin 
                for (k = 0; k <`COL_W; k = k + 1) begin
                    pe #(
                    `include "config_sys.vh"
              
                    ) pe (
                    .clk(clk), 
                    .reset(reset), 
                    .reset_sys(reset_sys),                
                    .a_in( k==0 ? a_in[`DATA_WIDTH*(j+1)-1 :`DATA_WIDTH*(j)] : a_out[j][k-1] ),
                    .w_in( j==0 ? w_in[`WEIGHT_WIDTH*(k+1)-1 :`WEIGHT_WIDTH*(k)] : w_out[j-1][k] ),                    
                    .a_out(a_out[j][k]),
                    .w_out(w_out[j][k]),
                    .res(res[j][k])
                    );
                end
            end
        
        
    endgenerate
    
 // double buffering the resultant matrix
 
 /*genvar a,b,c;
 
 generate
 
   
            for (b = 0; b < `ROW_A; b = b + 1) 
            begin 
                for (c = 0; c <`COL_W; c = c + 1) 
                begin
                     always @(posedge clk)
                     begin
                       if(compute_done==1)
                       res_buff[b][c]<=res[b][c];
                       end
                end
            end
        
        
    endgenerate
    
    */
 
 
 reg [$clog2(`COL_W)-1:0]output_cnt;  
    
  // deloading output matrix
  
  genvar a;
  
  generate
  
  for(a=0; a<`ROW_A; a=a+1)
  begin
       
       always @(posedge clk)
       begin
            if(deload_out==1)
            out[`OUT_WIDTH*(a+1)-1:`OUT_WIDTH*a]<=res[output_cnt][a];
            
            
            
            else
            out<=0;
       end 
   end
   
   endgenerate  




always @(posedge clk)
begin
    if(reset)
    output_cnt<=0;
    
    else
    if(deload_out==1)
    output_cnt<=output_cnt+1;
    
    else
    output_cnt<=0;
end
  


endmodule
