`timescale 1ns / 1ps
module Sub_Key(
    input  [127:0] key_in,
    input  [127:0] mc_sr_out,
    output [127:0] data_out
);
    assign data_out = mc_sr_out ^ key_in;
endmodule
