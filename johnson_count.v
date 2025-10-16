`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2025 16:31:48
// Design Name: 
// Module Name: johnson_count
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

module johnson_count(
input wire clk,
input wire reset,
input wire deload,
output reg [`ROW_A-1:0]johnson_count
);

always @(posedge clk)
begin
     if(reset)
     johnson_count<=0;
     
     else
     if(deload==1)
     johnson_count<={johnson_count[`ROW_A-2:0], !johnson_count[`ROW_A-1]};
end

endmodule
