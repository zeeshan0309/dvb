/*================
DIF FFT MODULE
================
by Zeeshan & Arsalan
=================================================================
	requires 16 data inputs: x_re0, x_re1, x_re2, x_re3, x_re4, x_re5, x_re6, x_re7, x_im0, x_im1, x_im2, x_im3, x_im4, x_im5, x_im6, x_im7;
    
    requires clk, reset;
    
    outputs 16 data: y_re0, y_re1, y_re2, y_re3, y_re4, y_re5, y_re6, y_re7, y_im0, y_im1, y_im2, y_im3, y_im4, y_im5, y_im6, y_im7;
=================================================================
	Stages of FFT calculation are manually coded.
    Twiddle factors are stored within main modules as wires.
=================================================================*/

module fft_1(reset, x_re0, x_re1, x_im0, x_im1, y_re0, y_re1, y_im0, y_im1, x_re2, x_re3, x_re4, x_re5, x_re6, x_re7, x_im2, x_im3, x_im4, x_im5, x_im6, x_im7, y_re2, y_re3, y_re4, y_re5, y_re6, y_re7,  y_im2, y_im3, y_im4, y_im5, y_im6, y_im7, clk);
  
  input signed [15:0] x_re0, x_re1, x_re2, x_re3, x_re4, x_re5, x_re6, x_re7;
  input signed [15:0] x_im0, x_im1, x_im2, x_im3, x_im4, x_im5, x_im6, x_im7;
  input reset;
  output wire signed [15:0] y_re0, y_re1, y_re2, y_re3, y_re4, y_re5, y_re6, y_re7;
  output wire signed [15:0] y_im0, y_im1, y_im2, y_im3, y_im4, y_im5, y_im6, y_im7;
  
  input clk;
  
  wire signed [7:0] w0_re = 8'b01111111;
  wire signed [7:0] w0_im = 8'b00000000;
  
  wire signed [7:0] w1_re = 8'b01011010;
  wire signed [7:0] w1_im = 8'b10100100;
  
  wire signed [7:0] w2_re = 8'b00000000;
  wire signed [7:0] w2_im = 8'b10000000;
  
  wire signed [7:0] w3_re = 8'b10100100;
  wire signed [7:0] w3_im = 8'b10100100;
  
  reg [15:0] temp_re [0:7];
  reg [15:0] temp_im [0:7];
  wire [15:0] temp_re_temp [0:7];
  wire [15:0] temp_im_temp [0:7];
  
  wire [15:0] temp_re_2 [0:7];
  wire [15:0] temp_im_2 [0:7];
  always@(posedge clk) begin
    if(reset) begin
      temp_re[0] <= x_re0;
      temp_re[1] <= x_re1;
      temp_re[2] <= x_re2;
      temp_re[3] <= x_re3;
      temp_re[4] <= x_re4;
      temp_re[5] <= x_re5;
      temp_re[6] <= x_re6;
      temp_re[7] <= x_re7;
  
      temp_im[0] <= x_im0;
      temp_im[1] <= x_im1;
      temp_im[2] <= x_im2;
      temp_im[3] <= x_im3;
      temp_im[4] <= x_im4;
      temp_im[5] <= x_im5;
      temp_im[6] <= x_im6;
      temp_im[7] <= x_im7;
    end
  end
  
  //stage 1
  butterfly B10(
    .inRe1(temp_re[0]),
    .inRe2(temp_re[4]),
    .inIm1(temp_im[0]),
    .inIm2(temp_im[4]),
    .outRe1(temp_re_temp[0]),
    .outRe2(temp_re_temp[4]),
    .outIm1(temp_im_temp[0]),
    .outIm2(temp_im_temp[4]),
    .twiddle_re(w0_re),
    .twiddle_im(w0_im)
  );
  
  butterfly B11(
    .inRe1(temp_re[1]),
    .inRe2(temp_re[5]),
    .inIm1(temp_im[1]),
    .inIm2(temp_im[5]),
    .outRe1(temp_re_temp[1]),
    .outRe2(temp_re_temp[5]),
    .outIm1(temp_im_temp[1]),
    .outIm2(temp_im_temp[5]),
    .twiddle_re(w1_re),
    .twiddle_im(w1_im)
  );
  
  butterfly B12(
    .inRe1(temp_re[2]),
    .inRe2(temp_re[6]),
    .inIm1(temp_im[2]),
    .inIm2(temp_im[6]),
    .outRe1(temp_re_temp[2]),
    .outRe2(temp_re_temp[6]),
    .outIm1(temp_im_temp[2]),
    .outIm2(temp_im_temp[6]),
    .twiddle_re(w2_re),
    .twiddle_im(w2_im)
  );
  
  butterfly B13(
    .inRe1(temp_re[3]),
    .inRe2(temp_re[7]),
    .inIm1(temp_im[3]),
    .inIm2(temp_im[7]),
    .outRe1(temp_re_temp[3]),
    .outRe2(temp_re_temp[7]),
    .outIm1(temp_im_temp[3]),
    .outIm2(temp_im_temp[7]),
    .twiddle_re(w3_re),
    .twiddle_im(w3_im)
  );
  
  //stage2
  butterfly B20(
    .inRe1(temp_re_temp[0]),
    .inRe2(temp_re_temp[2]),
    .inIm1(temp_im_temp[0]),
    .inIm2(temp_im_temp[2]),
    .outRe1(temp_re_2[0]),
    .outRe2(temp_re_2[2]),
    .outIm1(temp_im_2[0]),
    .outIm2(temp_im_2[2]),
    .twiddle_re(w0_re),
    .twiddle_im(w0_im)
  );
  
  butterfly B21(
    .inRe1(temp_re_temp[1]),
    .inRe2(temp_re_temp[3]),
    .inIm1(temp_im_temp[1]),
    .inIm2(temp_im_temp[3]),
    .outRe1(temp_re_2[1]),
    .outRe2(temp_re_2[3]),
    .outIm1(temp_im_2[1]),
    .outIm2(temp_im_2[3]),
    .twiddle_re(w2_re),
    .twiddle_im(w2_im)
  );
  
  butterfly B22(
    .inRe1(temp_re_temp[4]),
    .inRe2(temp_re_temp[6]),
    .inIm1(temp_im_temp[4]),
    .inIm2(temp_im_temp[6]),
    .outRe1(temp_re_2[4]),
    .outRe2(temp_re_2[6]),
    .outIm1(temp_im_2[4]),
    .outIm2(temp_im_2[6]),
    .twiddle_re(w0_re),
    .twiddle_im(w0_im)
  );
  
  butterfly B23(
    .inRe1(temp_re_temp[5]),
    .inRe2(temp_re_temp[7]),
    .inIm1(temp_im_temp[5]),
    .inIm2(temp_im_temp[7]),
    .outRe1(temp_re_2[5]),
    .outRe2(temp_re_2[7]),
    .outIm1(temp_im_2[5]),
    .outIm2(temp_im_2[7]),
    .twiddle_re(w2_re),
    .twiddle_im(w2_im)
  );
  
  //stage3
  butterfly B30(
    .inRe1(temp_re_2[0]),
    .inRe2(temp_re_2[1]),
    .inIm1(temp_im_2[0]),
    .inIm2(temp_im_2[1]),
    .outRe1(y_re0),
    .outRe2(y_re4),
    .outIm1(y_im0),
    .outIm2(y_im4),
    .twiddle_re(w0_re),
    .twiddle_im(w0_im)
  );
  
  butterfly B31(
    .inRe1(temp_re_2[2]),
    .inRe2(temp_re_2[3]),
    .inIm1(temp_im_2[2]),
    .inIm2(temp_im_2[3]),
    .outRe1(y_re2),
    .outRe2(y_re6),
    .outIm1(y_im2),
    .outIm2(y_im6),
    .twiddle_re(w0_re),
    .twiddle_im(w0_im)
  );
  
  butterfly B32(
    .inRe1(temp_re_2[4]),
    .inRe2(temp_re_2[5]),
    .inIm1(temp_im_2[4]),
    .inIm2(temp_im_2[5]),
    .outRe1(y_re1),
    .outRe2(y_re5),
    .outIm1(y_im1),
    .outIm2(y_im5),
    .twiddle_re(w0_re),
    .twiddle_im(w0_im)
  );
  
  butterfly B33(
    .inRe1(temp_re_2[6]),
    .inRe2(temp_re_2[7]),
    .inIm1(temp_im_2[6]),
    .inIm2(temp_im_2[7]),
    .outRe1(y_re3),
    .outRe2(y_re7),
    .outIm1(y_im3),
    .outIm2(y_im7),
    .twiddle_re(w0_re),
    .twiddle_im(w0_im)
  );
endmodule


/*
================
butterfly module
=================================================================
	requires 6 data inputs: inRe1, inIm1, inRe2, inIm2, twiddle_re, twiddle_im;
    require clk;
    
    outputs 4 data: outRe1, outIm1, outRe2, outIm2;
=================================================================
*/
module butterfly(inRe1, inIm1, inRe2, inIm2, outRe1, outIm1, outRe2, outIm2, twiddle_re, twiddle_im);
  input signed [15:0] inRe1;
  input signed [15:0] inRe2;
  input signed [15:0] inIm1;
  input signed [15:0] inIm2;
    
  input signed [7:0] twiddle_re;
  input signed [7:0] twiddle_im;
  
  output signed [15:0] outRe1;
  output signed [15:0] outRe2;
  output signed [15:0] outIm1;
  output signed [15:0] outIm2;
  
  reg [23:0] temp_outRe2;
  reg [23:0] temp_outIm2;
  
  always@(*) begin
    temp_outRe2 <= ( (twiddle_re)*(inRe1-inRe2) - (twiddle_im)*(inIm1-inIm2) );    
    temp_outIm2 <= ( (twiddle_im)*(inRe1-inRe2) + (twiddle_re)*(inIm1-inIm2) );
  end
  
   assign outRe1 = (inRe1 + inRe2);
   assign outIm1 = (inIm1 + inIm2);
      
   assign outRe2 = {temp_outRe2[22:7]};
   assign outIm2 = {temp_outIm2[22:7]};
  
endmodule
