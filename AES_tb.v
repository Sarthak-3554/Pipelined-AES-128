`timescale 1ns / 1ps
`include "AES_Encryption.v"

module AES_tb_multi;

  // Parameters
  parameter CLK_PERIOD_NS = 10;
  parameter PIPE_LATENCY  = 20;  // expected latency cycles
  parameter N_INPUTS      = 5;

  // DUT signals
  reg clk;
  reg [127:0] Data_in;
  reg [127:0] key_in;
  wire [127:0] cipher_out;

  AES_Encryption dut (
    .clk(clk),
    .Data_in(Data_in),
    .key_in(key_in),
    .cipher_out(cipher_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #(CLK_PERIOD_NS/2) clk = ~clk;
  end

  // Test vectors
  reg [127:0] pt [0:N_INPUTS-1];
  reg [127:0] expected [0:N_INPUTS-1];
  integer i, cycle_count, out_count;

  initial begin
    // Initialize test vectors
    key_in = 128'h2b7e151628aed2a6abf7158809cf4f3c;

    pt[0] = 128'h3243f6a8885a308d313198a2e0370734;
    pt[1] = 128'h00112233445566778899aabbccddeeff;
    pt[2] = 128'hffffffffffffffffffffffffffffffff;
    pt[3] = 128'h00000000000000000000000000000000;
    pt[4] = 128'h1234567890abcdef1234567890abcdef;

    // NIST reference ciphertexts (for same key)
    expected[0] = 128'h3925841d02dc09fbdc118597196a0b32;
    expected[1] = 128'h8df4e9aac5c7573a27d8d055d6e4d64b;
    expected[2] = 128'h8af2860142f786f409307c1a3f7eaaac;
    expected[3] = 128'h7df76b0c1ab899b33e42f047b91b546f;
    expected[4] = 128'h7838e4e0a0876581f7fde709c2f5ad6c;

    $display("-------------------------------------------------------------");
    $display(" AES-128 Pipelined Encryption Test (Multiple Inputs)");
    $display("-------------------------------------------------------------");
    $display(" Clock period: %0dns", CLK_PERIOD_NS);
    $display(" Latency expected: %0d cycles", PIPE_LATENCY);
    $display("-------------------------------------------------------------");

    // Initial values
    Data_in = 0;
    cycle_count = 0;
    out_count = 0;

    // Wait a few cycles before start
    repeat (2) @(posedge clk);

    // Feed 5 plaintexts, one per clock
    for (i = 0; i < N_INPUTS; i = i + 1) begin
      @(negedge clk);
      Data_in <= pt[i];
      $display("[%0t] Input Block %0d: %h", $time, i, pt[i]);
      @(posedge clk);
    end

    // After last input, keep clocking to flush pipeline
    for (i = 0; i < PIPE_LATENCY+1  ; i = i + 1) begin
      @(posedge clk);
      cycle_count = cycle_count + 1;

      if (cycle_count >= PIPE_LATENCY-N_INPUTS+2 && out_count < N_INPUTS) begin
        $display("[%0t] Output Block %0d: %h", $time, out_count, cipher_out);
        if (cipher_out === expected[out_count])
          $display("    PASS (matches expected)");
        else
          $display("    FAIL (expected %h)", expected[out_count]);
        out_count = out_count + 1;
      end
    end

    $display("-------------------------------------------------------------");
    $display(" Total inputs : %0d", N_INPUTS);
    $display(" Throughput   : 1 output per clock (expected)");
    $display("-------------------------------------------------------------");
    $finish;
  end

endmodule
