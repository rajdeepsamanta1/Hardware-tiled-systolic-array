`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2025 16:43:00
// Design Name: 
// Module Name: pe_encode
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

module pe_encode(
input  [`MANTISSA:0] significand,
input  [`EXPONENT-1:0] Exponent_a,
output reg  [`MANTISSA:0] Significand,
output wire [`EXPONENT-1:0] Exponent_sub
);

    localparam SHIFT_WIDTH = $clog2(`MANTISSA);
    reg [SHIFT_WIDTH:0] shift;

    integer i;
    always @(*) begin
        shift = 0;
        Significand = 0;

        for (i = `MANTISSA; i >= 0; i = i - 1) begin
            if (significand[i] == 1'b1 && Significand == 0) begin
                shift = `MANTISSA  - i;
                Significand = significand << shift;
            end
        end
    end

    assign Exponent_sub = Exponent_a - shift;



endmodule
