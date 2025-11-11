`timescale 1ns / 1ps
`include "Sbox.v"

module Sub_Bytes(
  input  [127:0] A,
  output [127:0] B1
);
  wire [7:0] sbox_out[0:15];
  wire [7:0] a[0:15];

  assign {a[0], a[4], a[8], a[12]} = {A[127:120], A[119:112], A[111:104], A[103:96]};
  assign {a[1], a[5], a[9], a[13]} = {A[95:88],   A[87:80],   A[79:72],   A[71:64]};
  assign {a[2], a[6], a[10],a[14]} = {A[63:56],   A[55:48],   A[47:40],   A[39:32]};
  assign {a[3], a[7], a[11],a[15]} = {A[31:24],   A[23:16],   A[15:8],    A[7:0]};

  genvar i;
  generate
    for (i=0; i<16; i=i+1)
      Sbox sbox_i(.a(a[i]), .b(sbox_out[i]));
  endgenerate

  assign B1 = {sbox_out[0], sbox_out[4], sbox_out[8],  sbox_out[12],
               sbox_out[1], sbox_out[5], sbox_out[9],  sbox_out[13],
               sbox_out[2], sbox_out[6], sbox_out[10], sbox_out[14],
               sbox_out[3], sbox_out[7], sbox_out[11], sbox_out[15]};
endmodule
