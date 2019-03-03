module GD_AudioSystem(
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
    output soundcounterOut,
    output AUDIOL,
    output AUDIOR
);

  wire [7:0] voicefl_read;
  wire [7:0] voicefh_read;
  wire [7:0] voicela_read;
  wire [7:0] voicera_read;

  reg [6:0] modvoice = 64;

   always @(*)
  begin
    casex (mem_r_addr[10:0])
    11'h014: mem_data_rd <= modvoice;
    11'b010xxxxxx00: mem_data_rd <= voicefl_read;
    11'b010xxxxxx01: mem_data_rd <= voicefh_read;
    11'b010xxxxxx10: mem_data_rd <= voicela_read;
    11'b010xxxxxx11: mem_data_rd <= voicera_read;
    default: mem_data_rd <= 0;
    endcase
  end

  always @(posedge vga_clk)
  begin
    if (mem_wr & mem_w_addr[14:11] == 5)
      casex (mem_w_addr[10:0])
      11'h014: modvoice       <= mem_data_wr;
      endcase
  end

  wire [14:0] mem_addr = mem_w_addr;
  reg [17:0] soundcounter;
  always @(posedge vga_clk)
    soundcounter <= soundcounter + 1;
  wire [5:0] viN = soundcounter + 1;
  wire [5:0] vi = soundcounter;

  wire voice_wr = mem_wr & (mem_w_addr[14:11] == 5) & (mem_w_addr[10:8] == 3'b010);
  wire voicefl_wr = voice_wr & (mem_w_addr[1:0] == 2'b00);
  wire voicefh_wr = voice_wr & (mem_w_addr[1:0] == 2'b01);
  wire voicela_wr = voice_wr & (mem_w_addr[1:0] == 2'b10);
  wire voicera_wr = voice_wr & (mem_w_addr[1:0] == 2'b11);

  wire [7:0] voicela_data;
  wire [7:0] voicera_data;
  wire [7:0] voicefl_data;
  wire [7:0] voicefh_data;
  wire [5:0] voice_addr = mem_addr[7:2];

  ram64x8d voicefl(
    .a(voice_addr),
    .wclk(mem_clk),
    .wea(voicefl_wr),
    .ad(mem_data_wr),
    .ao(voicefl_read),
    .b(viN),
    .bo(voicefl_data));

  ram64x8d voicefh(
    .a(voice_addr),
    .wclk(mem_clk),
    .wea(voicefh_wr),
    .ad(mem_data_wr),
    .ao(voicefh_read),
    .b(viN),
    .bo(voicefh_data));

  ram64x8d voicela(
    .a(voice_addr),
    .wclk(mem_clk),
    .wea(voicela_wr),
    .ad(mem_data_wr),
    .ao(voicela_read),
    .b(viN),
    .bo(voicela_data));

  ram64x8d voicera(
    .a(voice_addr),
    .wclk(mem_clk),
    .wea(voicera_wr),
    .ad(mem_data_wr),
    .ao(voicera_read),
    .b(viN),
    .bo(voicera_data));

  /*
  An 18-bit counter, multiplied by the frequency gives a single bit
  pulse that advances the voice's wave counter.
  Frequency of 4 means 1Hz, 16385 means 4095.75Hz.
  18-bit counter increments every 1/(2**18), or 262144 Hz.
  */
`define MASTERFREQ (1 << 22)
  reg [27:0] d;
  wire [27:0] dInc = d[27] ? (`MASTERFREQ) : (`MASTERFREQ - 50000000);
  wire [27:0] dN = d + dInc;

  reg [16:0] soundmaster;   // This increments at MASTERFREQ Hz
  always @(posedge vga_clk)
  begin
    d = dN;
    // clock B tick whenever d[27] is zero
    if (dN[27] == 0) begin
      soundmaster <= soundmaster + 1;
    end
  end

  wire [6:0] hsin;
  wire [6:0] wavecounter;
  wire [6:0] note = wavecounter[6:0];

`ifdef YES
RAM64X1S #(.INIT(64'b0000000000110101100010001111010010010111100010001101011000000000) /* 0 */
) sin0(.O(hsin[0]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]), .D(0), .WCLK(vga_clk), .WE(0));
RAM64X1S #(.INIT(64'b0101010101101100011100010101001111100101010001110001101101010101) /* 1 */
) sin1(.O(hsin[1]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]), .D(0), .WCLK(vga_clk), .WE(0));
RAM64X1S #(.INIT(64'b0110011001001001010101001100111111111001100101010100100100110011) /* 2 */
) sin2(.O(hsin[2]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]), .D(0), .WCLK(vga_clk), .WE(0));
RAM64X1S #(.INIT(64'b0010110100100100110011000011111111111110000110011001001001011010) /* 3 */
) sin3(.O(hsin[3]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]), .D(0), .WCLK(vga_clk), .WE(0));
RAM64X1S #(.INIT(64'b0001110011100011110000111111111111111111111000011110001110011100) /* 4 */
) sin4(.O(hsin[4]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]), .D(0), .WCLK(vga_clk), .WE(0));
RAM64X1S #(.INIT(64'b0000001111100000001111111111111111111111111111100000001111100000) /* 5 */
) sin5(.O(hsin[5]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]), .D(0), .WCLK(vga_clk), .WE(0));
RAM64X1S #(.INIT(64'b0000000000011111111111111111111111111111111111111111110000000000) /* 6 */
) sin6(.O(hsin[6]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]), .D(0), .WCLK(vga_clk), .WE(0));
`else
ROM64X1 #(.INIT(64'b0000000000110101100010001111010010010111100010001101011000000000) /* 0 */) sin0(.O(hsin[0]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]));
ROM64X1 #(.INIT(64'b0101010101101100011100010101001111100101010001110001101101010101) /* 1 */) sin1(.O(hsin[1]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]));
ROM64X1 #(.INIT(64'b0110011001001001010101001100111111111001100101010100100100110011) /* 2 */) sin2(.O(hsin[2]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]));
ROM64X1 #(.INIT(64'b0010110100100100110011000011111111111110000110011001001001011010) /* 3 */) sin3(.O(hsin[3]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]));
ROM64X1 #(.INIT(64'b0001110011100011110000111111111111111111111000011110001110011100) /* 4 */) sin4(.O(hsin[4]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]));
ROM64X1 #(.INIT(64'b0000001111100000001111111111111111111111111111100000001111100000) /* 5 */) sin5(.O(hsin[5]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]));
ROM64X1 #(.INIT(64'b0000000000011111111111111111111111111111111111111111110000000000) /* 6 */) sin6(.O(hsin[6]), .A0(note[0]), .A1(note[1]), .A2(note[2]), .A3(note[3]), .A4(note[4]), .A5(note[5]));
`endif

  wire signed [7:0] sin = note[6] ? (8'h00 - hsin) : hsin;

  wire voiceshape = voicefh_data[7];
  wire [14:0] voicefreq = {voicefh_data[6:0], voicefl_data};

  wire [35:0] derived = {1'b0, soundmaster} * voicefreq;

  wire highfreq = voicefreq[14];
  wire newpulse = highfreq ? derived[18] : derived[17]; // pulse is a square wave frequency 64*f
  wire oldpulse;
  wire [6:0] nextwavecounter = voiceshape ? lfsr : (wavecounter + (highfreq ? 2 : 1));
  wire [6:0] _wavecounter = (newpulse != oldpulse) ? nextwavecounter : wavecounter;

`ifdef NELLY
  ram64x8s voicestate(
    .a(viN),
    .we(1),
    .wclk(vga_clk),
    .d({_wavecounter, newpulse}),
    .o({wavecounter, oldpulse}));
`else
  wire [8:0] vsi = {_wavecounter, newpulse};
  wire [8:0] vso;
  ring64 vs0(.clk(vga_clk), .i(vsi[0]), .o(vso[0]));
  ring64 vs1(.clk(vga_clk), .i(vsi[1]), .o(vso[1]));
  ring64 vs2(.clk(vga_clk), .i(vsi[2]), .o(vso[2]));
  ring64 vs3(.clk(vga_clk), .i(vsi[3]), .o(vso[3]));
  ring64 vs4(.clk(vga_clk), .i(vsi[4]), .o(vso[4]));
  ring64 vs5(.clk(vga_clk), .i(vsi[5]), .o(vso[5]));
  ring64 vs6(.clk(vga_clk), .i(vsi[6]), .o(vso[6]));
  ring64 vs7(.clk(vga_clk), .i(vsi[7]), .o(vso[7]));
  assign wavecounter = vso[7:1];
  assign oldpulse = vso[0];
`endif

  wire signed [8:0] lamp = voicela_data;
  wire signed [8:0] ramp = voicera_data;
  reg signed [35:0] lmodulated;
  reg signed [35:0] rmodulated;
  always @(posedge vga_clk)
  begin
    lmodulated = lamp * sin;
    rmodulated = ramp * sin;
  end

  // Have lmodulated and rmodulated

  reg signed [15:0] lacc;
  reg signed [15:0] racc;
  wire signed [15:0] lsum = lacc + lmodulated[15:0];
  wire signed [15:0] rsum = racc + rmodulated[15:0];
  wire signed [31:0] lprod = lacc * lmodulated;
  wire signed [31:0] rprod = racc * rmodulated;
  wire zeroacc = (vi == 63);
  wire [15:0] _lacc = zeroacc ? sample_l : ((vi == modvoice) ? lprod[30:15] : lsum);
  wire [15:0] _racc = zeroacc ? sample_r : ((vi == modvoice) ? rprod[30:15] : rsum);
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