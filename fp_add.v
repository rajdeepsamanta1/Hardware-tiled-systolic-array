`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2025 16:40:46
// Design Name: 
// Module Name: fp_add
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

module fp_add(
input wire[`EXPONENT+`MANTISSA:0] a_operand,
input wire [`EXPONENT+`MANTISSA:0]b_operand,
output wire[`EXPONENT+`MANTISSA:0] result 
);

reg AddBar_Sub=0;
wire Exception;

wire operation_sub_addBar;
wire Comp_enable;
wire output_sign;

wire [`EXPONENT+`MANTISSA:0] operand_a,operand_b;
wire [`MANTISSA:0] significand_a,significand_b;
wire [`EXPONENT-1:0] exponent_diff;


wire [`MANTISSA:0] significand_b_add_sub;
wire [`EXPONENT-1:0] exponent_b_add_sub;

wire [`MANTISSA+1:0] significand_add;
wire [`EXPONENT+`MANTISSA-1:0] add_sum;

wire [`MANTISSA:0] significand_sub_complement;
wire [`MANTISSA+1:0] significand_sub;
wire [`EXPONENT+`MANTISSA-1:0] sub_diff;
wire [`MANTISSA+1:0] subtraction_diff; 
wire [`EXPONENT-1:0] exponent_sub;

//for operations always operand_a must not be less than b_operand
assign {Comp_enable,operand_a,operand_b} = (a_operand[`EXPONENT+`MANTISSA-1:0] < b_operand[`EXPONENT+`MANTISSA-1:0]) ? {1'b1,b_operand,a_operand} : {1'b0,a_operand,b_operand};

assign exp_a = operand_a[`EXPONENT+`MANTISSA-1:`MANTISSA];
assign exp_b = operand_b[`EXPONENT+`MANTISSA-1:`MANTISSA];

//Exception flag sets 1 if either one of the exponent is 255.
assign Exception = (&operand_a[`EXPONENT+`MANTISSA-1:`MANTISSA]) | (&operand_b[`EXPONENT+`MANTISSA-1:`MANTISSA]);

assign output_sign = AddBar_Sub ? Comp_enable ? !operand_a[`EXPONENT+`MANTISSA] : operand_a[`EXPONENT+`MANTISSA] : operand_a[`EXPONENT+`MANTISSA] ;

assign operation_sub_addBar = AddBar_Sub ? operand_a[`EXPONENT+`MANTISSA] ^ operand_b[`EXPONENT+`MANTISSA] : ~(operand_a[`EXPONENT+`MANTISSA] ^ operand_b[`EXPONENT+`MANTISSA]);

//Assigining significand values according to Hidden Bit.
//If exponent is equal to zero then hidden bit will be 0 for that respective significand else it will be 1
assign significand_a = (|operand_a[`EXPONENT+`MANTISSA-1:`MANTISSA]) ? {1'b1,operand_a[`MANTISSA-1:0]} : {1'b0,operand_a[`MANTISSA-1:0]};
assign significand_b = (|operand_b[`EXPONENT+`MANTISSA-1:`MANTISSA]) ? {1'b1,operand_b[`MANTISSA-1:0]} : {1'b0,operand_b[`MANTISSA-1:0]};

//Evaluating Exponent Difference
assign exponent_diff = operand_a[`EXPONENT+`MANTISSA-1:`MANTISSA] - operand_b[`EXPONENT+`MANTISSA-1:`MANTISSA];

//Shifting significand_b according to exponent_diff
assign significand_b_add_sub = significand_b >> exponent_diff;

assign exponent_b_add_sub = operand_b[`EXPONENT+`MANTISSA-1:`MANTISSA] + exponent_diff; 

//Checking exponents are same or not
assign perform = (operand_a[`EXPONENT+`MANTISSA-1:`MANTISSA] == exponent_b_add_sub);

///////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------ADD BLOCK------------------------------------------//

assign significand_add = (perform & operation_sub_addBar) ? (significand_a + significand_b_add_sub) : 25'd0; 

//Result will be equal to Most 23 bits if carry generates else it will be Least 22 bits.
assign add_sum[`MANTISSA-1:0] = significand_add[`MANTISSA+1] ? significand_add[`MANTISSA:1] : significand_add[`MANTISSA-1:0];

//If carry generates in sum value then exponent must be added with 1 else feed as it is.
assign add_sum[`EXPONENT+`MANTISSA-1:`MANTISSA] = significand_add[`MANTISSA+1] ? (1'b1 + operand_a[`EXPONENT+`MANTISSA-1:`MANTISSA]) : operand_a[`EXPONENT+`MANTISSA-1:`MANTISSA];

///////////////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------SUB BLOCK------------------------------------------//

assign significand_sub_complement = (perform & !operation_sub_addBar) ? ~(significand_b_add_sub) + 24'd1 : 24'd0 ; 

assign significand_sub = perform ? (significand_a + significand_sub_complement) : 25'd0;

pe_encode pe(significand_sub,operand_a[`EXPONENT+`MANTISSA-1:`MANTISSA],subtraction_diff,exponent_sub);

assign sub_diff[`EXPONENT+`MANTISSA-1:`MANTISSA] = exponent_sub;

assign sub_diff[`MANTISSA-1:0] = subtraction_diff[`MANTISSA-1:0];

///////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------OUTPUT--------------------------------------------//

//If there is no exception and operation will evaluate


assign result = ((!operation_sub_addBar) ? {output_sign,sub_diff} : {output_sign,add_sum});



endmodule
