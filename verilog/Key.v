`timescale 1ns / 1ps
//`include "Sbox.v"

module Key(
    input  [3:0]   rc,
    input  [127:0] k_in,
    output [127:0] k_out
);
    wire [31:0] W0 = k_in[127:96];
    wire [31:0] W1 = k_in[95:64];
    wire [31:0] W2 = k_in[63:32];
    wire [31:0] W3 = k_in[31:0];

    wire [31:0] rot = {W3[23:0], W3[31:24]};  // RotWord
    wire [7:0] s0,s1,s2,s3;
    Sbox sb0(.a(rot[31:24]), .b(s0));
    Sbox sb1(.a(rot[23:16]), .b(s1));
    Sbox sb2(.a(rot[15:8]),  .b(s2));
    Sbox sb3(.a(rot[7:0]),   .b(s3));
    wire [31:0] sub = {s0,s1,s2,s3} ^ rcon(rc);

    assign k_out[127:96] = W0 ^ sub;
    assign k_out[95:64]  = (W0 ^ sub) ^ W1;
    assign k_out[63:32]  = (W0 ^ sub) ^ W1 ^ W2;
    assign k_out[31:0]   = (W0 ^ sub) ^ W1 ^ W2 ^ W3;

    function [31:0] rcon;
      input [3:0] rc;
      begin
        case(rc)
          4'h0: rcon=32'h01000000; 4'h1: rcon=32'h02000000;
          4'h2: rcon=32'h04000000; 4'h3: rcon=32'h08000000;
          4'h4: rcon=32'h10000000; 4'h5: rcon=32'h20000000;
          4'h6: rcon=32'h40000000; 4'h7: rcon=32'h80000000;
          4'h8: rcon=32'h1b000000; 4'h9: rcon=32'h36000000;
          default: rcon=32'h00000000;
        endcase
      end
    endfunction
endmodule
