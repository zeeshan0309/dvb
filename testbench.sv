module tb;
  reg signed [15:0] x_re0, x_re1, x_re2, x_re3, x_re4, x_re5, x_re6, x_re7;
  reg signed [15:0] x_im0, x_im1, x_im2, x_im3, x_im4, x_im5, x_im6, x_im7;
  
  reg clk;
  reg reset = 1'd1;
  
  wire signed [15:0] y_re0, y_re1, y_re2, y_re3, y_re4, y_re5, y_re6, y_re7;
  wire signed [15:0] y_im0, y_im1, y_im2, y_im3, y_im4, y_im5, y_im6, y_im7;
  
  fft_1 M_UUT(
    .reset(reset),
    .x_re0(x_re0),
    .x_re1(x_re1),
    .x_re2(x_re2),
    .x_re3(x_re3),
    .x_re4(x_re4),
    .x_re5(x_re5),
    .x_re6(x_re6),
    .x_re7(x_re7),
    .x_im0(x_im0),
    .x_im1(x_im1),
    .x_im2(x_im2),
    .x_im3(x_im3),
    .x_im4(x_im4),
    .x_im5(x_im5),
    .x_im6(x_im6),
    .x_im7(x_im7),
    .clk(clk),
    .y_re0(y_re0),
    .y_re1(y_re1),
    .y_re2(y_re2),
    .y_re3(y_re3),
    .y_re4(y_re4),
    .y_re5(y_re5),
    .y_re6(y_re6),
    .y_re7(y_re7),
    .y_im0(y_im0),
    .y_im1(y_im1),
    .y_im2(y_im2),
    .y_im3(y_im3),
    .y_im4(y_im4),
    .y_im5(y_im5),
    .y_im6(y_im6),
    .y_im7(y_im7)
  );
  initial begin
    #13 reset = 1'd0;
  end
  
  always
    #5 clk = ~clk;
  
  initial
    begin
      $monitor($time, "clk= %b ; outRe0=%b ; outRe1 = %b ; outRe2 = %b ; outRe3 = %b ; outRe4 = %b ; outRe5 = %b ; outRe6 = %b ; outRe7=%b ; outIm0 = %b ; outIm1 = %b ; outIm2 = %b ; outIm3 = %b ; outIm4 = %b ; outIm5 = %b ; outIm6 = %b ; outIm7 = %b", clk, y_re0, y_re1, y_re2, y_re3, y_re4, y_re5, y_re6, y_re7, y_im0, y_im1, y_im2, y_im3, y_im4, y_im5, y_im6, y_im7);
      clk = 1'b0; x_re0 = 16'b0000000001_000000; x_re1 = 16'b0000000000_101101; x_re2 = 16'b0000000000_000000; x_re3 = 16'b0000000000_101101; x_re4 = 16'b0000000001_000000; x_re5 = 16'b1111111111_010010; x_re6 = 16'b1111111110_111111; x_re7 = 16'b1111111111_010010; x_im0 = 16'b0000000000_000000; x_im1 = 16'b0000000000_000000; x_im2 = 16'b0000000000_000000; x_im3 = 16'b0000000000_000000; x_im4 = 16'b0000000000_000000; x_im5 = 16'b0000000000_000000; x_im6 = 16'b0000000000_000000; x_im7 = 16'b0000000000_000000;
      #20 $finish;
    end
  
endmodule
