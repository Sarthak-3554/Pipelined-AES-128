`timescale 1ns / 1ps
module Mix_Column(
    input  [127:0] c_in1,
    output [127:0] c_out
);
    function [7:0] xtime; input [7:0] b;
      begin xtime = {b[6:0],1'b0} ^ (8'h1b & {8{b[7]}}); end
    endfunction
    function [7:0] m2; input [7:0] b; begin m2 = xtime(b); end endfunction
    function [7:0] m3; input [7:0] b; begin m3 = xtime(b) ^ b; end endfunction

    genvar k;
    generate
      for (k=0; k<4; k=k+1) begin : COL
        wire [7:0] a0 = c_in1[127-32*k -: 8];
        wire [7:0] a1 = c_in1[119-32*k -: 8];
        wire [7:0] a2 = c_in1[111-32*k -: 8];
        wire [7:0] a3 = c_in1[103-32*k -: 8];

        wire [7:0] c0 = m2(a0) ^ m3(a1) ^ a2      ^ a3;
        wire [7:0] c1 = a0      ^ m2(a1) ^ m3(a2) ^ a3;
        wire [7:0] c2 = a0      ^ a1      ^ m2(a2) ^ m3(a3);
        wire [7:0] c3 = m3(a0) ^ a1      ^ a2      ^ m2(a3);

        assign c_out[127-32*k -: 8] = c0;
        assign c_out[119-32*k -: 8] = c1;
        assign c_out[111-32*k -: 8] = c2;
        assign c_out[103-32*k -: 8] = c3;
      end
    endgenerate
endmodule
