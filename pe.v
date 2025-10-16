`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2025 23:51:59
// Design Name: 
// Module Name: pe
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

 module pe  (
  
    input wire clk,
    input wire reset,
    input wire reset_sys,
    input wire [`DATA_WIDTH - 1:0] a_in,
    input wire [`WEIGHT_WIDTH - 1:0] w_in,
    output reg [`DATA_WIDTH-1:0]a_out,
    output reg [`WEIGHT_WIDTH-1:0]w_out,
    output reg [`DATA_WIDTH+`WEIGHT_WIDTH - 1:0] res
    
);


always @(posedge clk)
begin
     if(reset || reset_sys)
     begin
          a_out<=0;
          w_out<=0;
     end
     
     else
     begin
          a_out<=a_in;
          w_out<=w_in;
     end
end


  
 
  
 
generate

if(`PIPELINE == 1 && `DATA_TYPE == 0)
begin

        reg [`DATA_WIDTH+`WEIGHT_WIDTH - 1:0] multi_os;
        always @(posedge clk)
        begin
              if (reset || reset_sys) 
              begin
            // reset logic
                    
		            multi_os<=0;
                    res <= 0;
                    
                    

               end 
               
               else 
               begin   
                   
                multi_os <= a_in * w_in;
                 res <= res + multi_os;
                    
               end
               
          end 
        
end


else if (`PIPELINE == 0 && `DATA_TYPE == 0)
begin
        
        wire [`DATA_WIDTH+`WEIGHT_WIDTH - 1:0] multi_os;
        always @(posedge clk)
        begin
              if (reset || reset_sys) 
              begin
            // reset logic
                    
		            
                    res <= 0;
                    
                    
               end 
               
               else 
               begin   
                   
                     
                     res <= res + multi_os;
                     
               end
               
          end 
          
          assign multi_os = a_in*w_in;
        
end


else if (`PIPELINE == 0 && `DATA_TYPE == 1)
begin
        
        wire [`DATA_WIDTH+`WEIGHT_WIDTH - 1:0] multi_os;
        wire [`DATA_WIDTH+`WEIGHT_WIDTH - 1:0] sum;
                 
        always @(posedge clk)
        begin
             if(reset || reset_sys)
             res<=0;
             
              
             else
             res<=sum;
            
        end
            



fp_mult #(
`include "config_sys.vh"
)mult(
.a_operand(a_in),
.b_operand(b_in),
.result(multi_os)
);


fp_add #(
`include "config_sys.vh"
)add(
.a_operand(res),
.b_operand(multi_os),
.result(sum)
);





end



else 
begin
        
        wire [`DATA_WIDTH+`WEIGHT_WIDTH - 1:0] multi_os;
        reg [`DATA_WIDTH+`WEIGHT_WIDTH - 1:0] multi_os_buff;
        wire [`DATA_WIDTH+`WEIGHT_WIDTH - 1:0] sum;
                 
        always @(posedge clk)
        begin
             if(reset)
             begin
             res<=0;
             multi_os_buff<=0;
             end
                         
             else
             begin
             res<=sum;
             multi_os_buff<=multi_os;
             end
        end
            



fp_mult #(
`include "config_sys.vh"
)mult(
.a_operand(a_in),
.b_operand(b_in),
.result(multi_os)
);


fp_add #(
`include "config_sys.vh"
)add(
.a_operand(res),
.b_operand(multi_os_buff),
.result(sum)
);





end





endgenerate


endmodule
