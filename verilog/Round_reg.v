`timescale 1ns / 1ps
module Round_reg(
    input              clk,
    input      [127:0] r_in,
    output reg [127:0] r_out
);
    always @(posedge clk) r_out <= r_in;
endmodule
