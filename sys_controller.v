`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2025 23:51:05
// Design Name: 
// Module Name: sys_controller
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


module sys_controller(
input wire clk,
input wire reset,
input wire start,
output reg compute,
output reg load_a,
output reg load_w,
output reg deload,
output reg deload_out,
output reg reset_sys
);

reg [31:0]count;

reg [31:0]count_tile;

always @(posedge clk)
begin
     if(reset)
     count_tile<=0;
     
     else
     if(compute==1)
     count_tile<=count_tile+1;
end


always @(posedge clk)
begin
     if(reset)
     begin
          load_a<=0;
          load_w<=0;
          deload<=0;
          deload_out<=0;
          count<=0;
          compute<=0;
          reset_sys<=0;
     end
     
     
     else
     begin
          if(start)
          begin
               count<=count+1;
               
               if(count==1)
               compute<=1;
               
               else
               compute<=0;
               
               if(count>=2 && count<=`VLEN/`SEW+1)
               begin
                    load_a<=1;
                   
               end
               
               else
               load_a<=0;
               
               if(count>=(`VLEN/`SEW)+2 && count<=`VLEN/`SEW+`VLEN/`SEW+1)
               begin
                    load_w<=1;
                  
               end
               
               else
               load_w<=0;
               
               if(count>=(`VLEN/`SEW)+(`VLEN/`SEW)+3 && count<=(`VLEN/`SEW) +(`VLEN/`SEW)+2+2*(`VLEN/`SEW))
               deload<=1;
               
               else
               deload<=0;
               
               
               if(count>=(`VLEN/`SEW)+(`VLEN/`SEW)+2+2*(`VLEN/`SEW)+(`VLEN/`SEW)+1 && count<=(`VLEN/`SEW) +(`VLEN/`SEW)+2+2*(`VLEN/`SEW)+(`VLEN/`SEW)+4 && count_tile%(`COL_M/(`VLEN/`SEW))==0)
               deload_out<=1;
               
               else
               deload_out<=0;
               
               if(count==(`VLEN/`SEW) +(`VLEN/`SEW)+2+2*(`VLEN/`SEW)+2*(`VLEN/`SEW)+5 && count_tile%(`COL_N/(`VLEN/`SEW))==0)
               reset_sys<=1;
               
               else
               reset_sys<=0;
               
               if(count==(`VLEN/`SEW) +(`VLEN/`SEW)+2+2*(`VLEN/`SEW)+2*(`VLEN/`SEW)+6)
               count<=0;
         end
     end
end



endmodule
