`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2025 16:40:28
// Design Name: 
// Module Name: fp_mult
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

module fp_mult(
input wire[`EXPONENT+`MANTISSA:0] a_operand,
input wire[`EXPONENT+`MANTISSA:0] b_operand,
output wire[`EXPONENT+`MANTISSA:0] result
);


wire sign,product_round,normalised,zero;
wire [`EXPONENT:0] exponent,sum_exponent;
wire [`MANTISSA-1:0] product_mantissa;
wire [`MANTISSA:0] operand_a,operand_b;
wire [`MANTISSA*2+1:0] product,product_normalised; //48 Bits


assign sign = a_operand[`EXPONENT+`MANTISSA] ^ b_operand[`EXPONENT+`MANTISSA];

//Exception flag sets 1 if either one of the exponent is 255.
assign Exception = (&a_operand[`EXPONENT+`MANTISSA-1:`MANTISSA]) | (&b_operand[`EXPONENT+`MANTISSA-1:`MANTISSA]);

//Assigining significand values according to Hidden Bit.
//If exponent is equal to zero then hidden bit will be 0 for that respective significand else it will be 1

assign operand_a = (|a_operand[`EXPONENT+`MANTISSA-1:`MANTISSA]) ? {1'b1,a_operand[`MANTISSA-1:0]} : {1'b0,a_operand[`MANTISSA-1:0]};

assign operand_b = (|b_operand[`EXPONENT+`MANTISSA-1:`MANTISSA]) ? {1'b1,b_operand[`MANTISSA-1:0]} : {1'b0,b_operand[`MANTISSA-1:0]};

assign product = operand_a * operand_b;			//Calculating Product

assign product_round = |product_normalised[`MANTISSA-1:0];  //Ending 22 bits are OR'ed for rounding operation.

assign normalised = product[`MANTISSA*2+1] ? 1'b1 : 1'b0;	

assign product_normalised = normalised ? product : product << 1;	//Assigning Normalised value based on 48th bit

//Final Manitssa.
assign product_mantissa = product_normalised[`MANTISSA*2:`MANTISSA+1] + (product_normalised[`MANTISSA] & product_round); 

assign zero = Exception ? 1'b0 : (product_mantissa == 0) ? 1'b1 : 1'b0;

assign sum_exponent = a_operand[`EXPONENT+`MANTISSA-1:`MANTISSA] + b_operand[`EXPONENT+`MANTISSA-1:`MANTISSA];

assign exponent = sum_exponent - 8'd127 + normalised;


assign result =  {sign,exponent[`EXPONENT-1:0],product_mantissa};



endmodule
