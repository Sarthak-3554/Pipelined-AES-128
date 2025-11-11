`timescale 1ns / 1ps
module Shift_Rows(
    input  [127:0] b_in,
    output [127:0] b_out
);
    // [127:120]=s0,0 [119:112]=s1,0 [111:104]=s2,0 [103:96]=s3,0
    // [95:88]=s0,1  [87:80]=s1,1  [79:72]=s2,1  [71:64]=s3,1
    // [63:56]=s0,2  [55:48]=s1,2  [47:40]=s2,2  [39:32]=s3,2
    // [31:24]=s0,3  [23:16]=s1,3  [15:8]=s2,3   [7:0]=s3,3

    
    assign b_out[127:120]=b_in[127:120];
    assign b_out[95:88]  =b_in[95:88];
    assign b_out[63:56]  =b_in[63:56];
    assign b_out[31:24]  =b_in[31:24];

    assign b_out[119:112]=b_in[87:80];
    assign b_out[87:80]  =b_in[55:48];
    assign b_out[55:48]  =b_in[23:16];
    assign b_out[23:16]  =b_in[119:112];

    assign b_out[111:104]=b_in[47:40];
    assign b_out[79:72]  =b_in[15:8];
    assign b_out[47:40]  =b_in[111:104];
    assign b_out[15:8]   =b_in[79:72];

    assign b_out[103:96] =b_in[7:0];
    assign b_out[71:64]  =b_in[103:96];
    assign b_out[39:32]  =b_in[71:64];
    assign b_out[7:0]    =b_in[39:32];
endmodule
