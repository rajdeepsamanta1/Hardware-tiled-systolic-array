`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2025 16:35:54
// Design Name: 
// Module Name: sys_tiling
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

module sys_tiling(input wire clk,
input wire reset,
input wire compute,
output reg [$clog2(`ROW_M)-1:0]index_i,
output reg [$clog2(`ROW_M)-1:0]index_j,
output reg [$clog2(`ROW_M)-1:0]index_k,
output reg done);

reg compute_buff;


always@(posedge clk)
begin
     if(reset)
     compute_buff<=0;
     
     else
     if(compute==1)
     compute_buff<=1;
end


always @(posedge clk)
begin
     
     
     if(reset)
     begin
          index_i<=0;
          index_j<=0;
          index_k<=0;
          done<=0;
     end
     
     else
     begin
          if(compute==1 && compute_buff==1)
          index_k<=index_k+(`VLEN/`SEW);
          
          if(compute==1 && index_k==`ROW_M-(`VLEN/`SEW))
          begin
               index_k<=0;
               index_j<=index_j+(`VLEN/`SEW);
          end
          
          if(compute==1 && index_j==`ROW_M-(`VLEN/`SEW) && index_k==`ROW_M-(`VLEN/`SEW))
          begin
               index_j<=0;
               index_i<=index_i+(`VLEN/`SEW);
          end
          
          if(index_i==`ROW_M-(`VLEN/`SEW) && index_j==`ROW_M-(`VLEN/`SEW) && index_k==`ROW_M-(`VLEN/`SEW))
          done<=1;
            
     
     end
end

         
endmodule
