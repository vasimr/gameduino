module GD_DigitalAudio(
    input vga_clk,
    output reg [7:0] mem_data_rd,
    input [7:0] mem_data_wr,
    input [14:0] mem_w_addr,   // Combined write address
    input [14:0] mem_r_addr,   // Combined read address
    input mem_rd,
    input mem_wr,
    input signed [15:0] sample_l,
    input signed [15:0] sample_r,
    input lfsr,
    output [17:0] soundcounterOut,
    output AUDIOL,
    output AUDIOR
);

  reg [17:0] soundcounter;
 
  assign soundcounterOut = soundcounter;

  always @(posedge vga_clk)
    soundcounter <= soundcounter + 1;
  wire [5:0] vi = soundcounter;


  // Sample register

  reg signed [15:0] lacc;
  reg signed [15:0] racc;
  wire signed [15:0] lsum = lacc;
  wire signed [15:0] rsum = racc;
  wire zeroacc = (vi == 63);
  wire [15:0] _lacc = zeroacc ? sample_l :  lsum;
  wire [15:0] _racc = zeroacc ? sample_r :  rsum;
  reg signed [12:0] lvalue;
  reg signed [12:0] rvalue;
  always @(posedge vga_clk)
  begin
    if (vi == 63) begin
      lvalue <= lsum[15:3] /* + sample_l + 32768 */;
      rvalue <= rsum[15:3] /* + sample_r + 32768 */;
    end
    lacc <= _lacc;
    racc <= _racc;
  end

  wire signed [7:0] dither = soundcounter;
//  wire [15:0] dither = {soundcounter[0],
//                       soundcounter[1],
//                       soundcounter[2],
//                       soundcounter[3],
//                       soundcounter[4],
//                       soundcounter[5],
//                       soundcounter[6],
//                       soundcounter[7],
//                       soundcounter[8],
//                       soundcounter[9],
//                       soundcounter[10],
//                       soundcounter[11],
//                       soundcounter[12],
//                       soundcounter[13],
//                       soundcounter[14],
//                       soundcounter[15]
//                       };

`ifdef NELLY
  wire lau_out = lvalue >= dither;
  wire rau_out = rvalue >= dither;

  assign AUDIOL = lau_out;
  assign AUDIOR = rau_out;
`else
  wire [12:0] ulvalue = lvalue ^ 4096;
  wire [12:0] urvalue = rvalue ^ 4096;
  dac ldac(AUDIOL, ulvalue, vga_clk, 0);
  dac rdac(AUDIOR, urvalue, vga_clk, 0);
`endif

endmodule // GD_AudioSystem