`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2025 16:57:35
// Design Name: 
// Module Name: sim_test_top
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

module sim_test_top;

reg clk;
reg reset;
reg start;
 wire [`ADDR_WIDTH-1:0]addr_a;
 wire [`ADDR_WIDTH-1:0]addr_w;
  wire [`ADDR_WIDTH-1:0]addr_res;
 wire [`BUS_WIDTH-1:0]a;
 wire [`BUS_WIDTH-1:0]w;
 wire [`OUT_WIDTH*`ROW_A-1:0]out;
 wire load_a;
wire load_w;
wire deload_out;
wire compute;
//output wire compute,
wire [$clog2(`ROW_M)-1:0]index_i;
wire [$clog2(`ROW_M)-1:0]index_j;
wire [$clog2(`ROW_M)-1:0]index_k;
wire [$clog2(`ROW_M)-1:0]index_ii_a;
wire [$clog2(`ROW_M)-1:0]index_jj_a;
wire [$clog2(`ROW_M)-1:0]index_ii_w;
wire [$clog2(`ROW_M)-1:0]index_jj_w;
reg test_en;
wire [`DATA_WIDTH-1:0]test_data;

 
 always
 begin
 
 clk=1; #5;
 clk=0; #5;
 
 end
 
 //integer i, j;
 
 initial
 begin
 
 reset=1;
 start=0;
 
 #40;
 
 reset=0;
 start=1;
 
 #21600;
 
 start=0;
 
 test_en=1;
 
 
 end
 

sys_test_top#(
`include "config_sys.vh"
)uut(
.clk(clk),
.reset(reset),
.start(start),
.addr_a(addr_a),
.addr_w(addr_w),
.addr_res(addr_res),
.a(a),
.w(w),
.out(out),
//.compute(compute),
.load_a(load_a),
.load_w(load_w),
.deload_out(deload_out),
.compute(compute),
.index_i(index_i),
.index_j(index_j),
.index_k(index_k),
.index_ii_a(index_ii_a),
.index_jj_a(index_jj_a),
.index_ii_w(index_ii_w),
.index_jj_w(index_jj_w),
.test_en(test_en),
.test_data(test_data)

);


endmodule
