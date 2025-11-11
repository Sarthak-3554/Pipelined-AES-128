
`timescale 1ns / 1ps
`include "Sub_Bytes.v"
`include "Shift_Rows.v"
`include "Mix_Column.v"
`include "Sub_Key.v"
`include "Round_reg.v"
`include "Key.v"       

module AES_Encryption(
    input              clk,
    input      [127:0] Data_in,
    input      [127:0] key_in,
    output     [127:0] cipher_out
);

    reg [127:0] din_reg, key_reg;
    always @(posedge clk) begin
        din_reg <= Data_in;
        key_reg <= key_in;
    end

    wire [127:0] rk0, rk1, rk2, rk3, rk4, rk5, rk6, rk7, rk8, rk9, rk10;
    KeyPipe KP (
        .clk(clk),
        .key_in(key_reg),
        .rk0(rk0), .rk1(rk1), .rk2(rk2), .rk3(rk3), .rk4(rk4),
        .rk5(rk5), .rk6(rk6), .rk7(rk7), .rk8(rk8), .rk9(rk9), .rk10(rk10)
    );

    wire [127:0] s0 = din_reg ^ rk0;

    wire [127:0] r1a, r1b;
    round_half_a R1A (.clk(clk), .din(s0), .q(r1a));
    round_half_b #(.USE_MC(1)) R1B (.clk(clk), .din(r1a), .rk(rk1), .q(r1b));

    wire [127:0] r2a, r2b;
    round_half_a R2A (.clk(clk), .din(r1b), .q(r2a));
    round_half_b #(.USE_MC(1)) R2B (.clk(clk), .din(r2a), .rk(rk2), .q(r2b));

    wire [127:0] r3a, r3b;
    round_half_a R3A (.clk(clk), .din(r2b), .q(r3a));
    round_half_b #(.USE_MC(1)) R3B (.clk(clk), .din(r3a), .rk(rk3), .q(r3b));

    wire [127:0] r4a, r4b;
    round_half_a R4A (.clk(clk), .din(r3b), .q(r4a));
    round_half_b #(.USE_MC(1)) R4B (.clk(clk), .din(r4a), .rk(rk4), .q(r4b));

    wire [127:0] r5a, r5b;
    round_half_a R5A (.clk(clk), .din(r4b), .q(r5a));
    round_half_b #(.USE_MC(1)) R5B (.clk(clk), .din(r5a), .rk(rk5), .q(r5b));

    wire [127:0] r6a, r6b;
    round_half_a R6A (.clk(clk), .din(r5b), .q(r6a));
    round_half_b #(.USE_MC(1)) R6B (.clk(clk), .din(r6a), .rk(rk6), .q(r6b));

    wire [127:0] r7a, r7b;
    round_half_a R7A (.clk(clk), .din(r6b), .q(r7a));
    round_half_b #(.USE_MC(1)) R7B (.clk(clk), .din(r7a), .rk(rk7), .q(r7b));

    wire [127:0] r8a, r8b;
    round_half_a R8A (.clk(clk), .din(r7b), .q(r8a));
    round_half_b #(.USE_MC(1)) R8B (.clk(clk), .din(r8a), .rk(rk8), .q(r8b));

    wire [127:0] r9a, r9b;
    round_half_a R9A (.clk(clk), .din(r8b), .q(r9a));
    round_half_b #(.USE_MC(1)) R9B (.clk(clk), .din(r9a), .rk(rk9), .q(r9b));

    wire [127:0] r10a, r10b;
    round_half_a R10A (.clk(clk), .din(r9b), .q(r10a));
    round_half_b #(.USE_MC(0)) R10B (.clk(clk), .din(r10a), .rk(rk10), .q(r10b));

    assign cipher_out = r10b;

endmodule

module round_half_a(
    input  clk,
    input  [127:0] din,
    output [127:0] q
);
    wire [127:0] sb, sr;
    Sub_Bytes  SB (.A(din), .B1(sb));
    Shift_Rows SR (.b_in(sb), .b_out(sr));
    Round_reg  RR (.clk(clk), .r_in(sr), .r_out(q));
endmodule


module round_half_b #(
    parameter USE_MC = 1
) (
    input  clk,
    input  [127:0] din,
    input  [127:0] rk,
    output [127:0] q
);
    wire [127:0] temp, ark;
    generate
        if (USE_MC) begin : WITH_MC
            Mix_Column MC (.c_in1(din), .c_out(temp));
        end else begin : NO_MC
            assign temp = din;
        end
    endgenerate

    Sub_Key   AK (.key_in(rk), .mc_sr_out(temp), .data_out(ark));
    Round_reg RR (.clk(clk), .r_in(ark), .r_out(q));
endmodule


module KeyPipe(
  input              clk,
  input      [127:0] key_in,
  output     [127:0] rk0, rk1, rk2, rk3, rk4, rk5, rk6, rk7, rk8, rk9, rk10
);
  reg [127:0] k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10;
  wire [127:0] k1_n, k2_n, k3_n, k4_n, k5_n, k6_n, k7_n, k8_n, k9_n, k10_n;

  Key K1 (.rc(4'd0), .k_in(k0),  .k_out(k1_n));
  Key K2 (.rc(4'd1), .k_in(k1),  .k_out(k2_n));
  Key K3 (.rc(4'd2), .k_in(k2),  .k_out(k3_n));
  Key K4 (.rc(4'd3), .k_in(k3),  .k_out(k4_n));
  Key K5 (.rc(4'd4), .k_in(k4),  .k_out(k5_n));
  Key K6 (.rc(4'd5), .k_in(k5),  .k_out(k6_n));
  Key K7 (.rc(4'd6), .k_in(k6),  .k_out(k7_n));
  Key K8 (.rc(4'd7), .k_in(k7),  .k_out(k8_n));
  Key K9 (.rc(4'd8), .k_in(k8),  .k_out(k9_n));
  Key KA (.rc(4'd9), .k_in(k9),  .k_out(k10_n));

  always @(posedge clk) begin
    k0  <= key_in;
    k1  <= k1_n;
    k2  <= k2_n;
    k3  <= k3_n;
    k4  <= k4_n;
    k5  <= k5_n;
    k6  <= k6_n;
    k7  <= k7_n;
    k8  <= k8_n;
    k9  <= k9_n;
    k10 <= k10_n;
  end

  assign rk0=k0;  assign rk1=k1;  assign rk2=k2;  assign rk3=k3;  assign rk4=k4;
  assign rk5=k5;  assign rk6=k6;  assign rk7=k7;  assign rk8=k8;  assign rk9=k9;
  assign rk10=k10;
endmodule
