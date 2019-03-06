`define YES
`define A7_DEBUG 1
`define USING_OLDISE 1
`define USE_AUDIO 1
`define USE_DIGITALAUDIO 1
//`define USE_SID 1
`include "revision.v"

// the main gameduino module

module Gameduino(
`ifdef A7_DEBUG
  input clk_100Mhz,
  output [3:0] vga_red,
  output [3:0] vga_green,
  output [3:0] vga_blue,
`else
  input clka,
  output [2:0] vga_red,
  output [2:0] vga_green,
  output [2:0] vga_blue,
`endif

  //inout [32:0] VGA_Bus,
  output vga_hsync_n,
  output vga_vsync_n,

  input SCK,  // arduino 13
  input MOSI, // arduino 11
  inout MISO, // arduino 12
  input SSEL, // arduino 9
 // inout AUX,  // arduino 2
  output AUDIOL,
  output AUDIOR

  //output flashMOSI,
  //input  flashMISO,
  //output flashSCK,
  //output flashSSEL

  );

wire flashMOSI;
wire flashMISO;
wire flashSCK;
wire flashSSEL;
wire AUX;

//clk32to50 papilio_clock (
//    .CLKIN_IN(clk_25Mhz), 
//    .CLKFX_OUT(CLKA), 
//    .CLKIN_IBUFG_OUT(CLKIN_IBUFG_OUT), 
//    .CLK0_OUT(CLK0_OUT)
//    );

`ifdef A7_DEBUG
  assign clka = clk_100Mhz;
`else
  //assign clka = clk_25MHz;
`endif

  wire mem_clk;
  wire [7:0] host_mem_data_wr;
  reg [7:0] mem_data_rd;
  reg [7:0] latched_mem_data_rd;
  wire [14:0] mem_w_addr;   // Combined write address
  wire [14:0] mem_r_addr;   // Combined read address
  wire [14:0] host_mem_w_addr;
  wire [14:0] host_mem_r_addr;
  wire host_mem_wr;
  wire mem_rd;

  wire vga_clk;
  
`ifdef A7_DEBUG
  clk_wiz_0 vga_ck_gen
  (
  // Clock out ports  
  .clk_out1(vga_clk),
  // Status and control signals               
  .reset(0), 
 // Clock in ports
  .clk_in1(clka)
  );
`else
    ck_div #(.DIV_BY(4), .MULT_BY(2)) vga_ck_gen(.ck_in(clka), .ck_out(vga_clk));
`endif

  wire [15:0] j1_insn;
  wire [12:0] j1_insn_addr;
  wire [15:0] j1_mem_addr;
  wire [15:0] j1_mem_dout;
  wire j1_mem_wr;

  wire [7:0] j1insnl_read;
  wire [7:0] j1insnh_read;
  wire [7:0] mem_data_rd0;
  wire [7:0] mem_data_rd1;
  wire [7:0] mem_data_rd2;
  wire [7:0] mem_data_rd3;
  wire [7:0] mem_data_rd4;
  wire [7:0] mem_data_rd5;
  wire [7:0] mem_data_rdAudio;

  wire gdMISO;
  wire [17:0] soundcounter;
  always @(posedge vga_clk)
  if (mem_rd)
    latched_mem_data_rd <= mem_data_rd;

  SPI_memory spi1(
    .clk(vga_clk),
    .SCK(SCK), .MOSI(MOSI), .MISO(gdMISO), .SSEL(SSEL),
    .raddr(host_mem_r_addr),
    .waddr(host_mem_w_addr),
    .data_w(host_mem_data_wr),
    .data_r(latched_mem_data_rd),
    .we(host_mem_wr),
    .re(mem_rd),
    .mem_clk(mem_clk));
  wire host_busy = host_mem_wr | mem_rd;
  wire mem_wr =            host_busy ? host_mem_wr : j1_mem_wr;
  wire [7:0] mem_data_wr = host_busy ? host_mem_data_wr : j1_mem_dout;
  wire [14:0] mem_addr =   host_busy ? (host_mem_wr ? host_mem_w_addr : host_mem_r_addr) : j1_mem_addr;
  assign mem_w_addr =      host_busy ? host_mem_w_addr : j1_mem_addr;
  assign mem_r_addr =      host_busy ? host_mem_r_addr : j1_mem_addr;

  reg signed [15:0] sample_l;
  reg signed [15:0] sample_r;

  reg [14:0] bg_color = 15'b010000011110100;
  reg [15:0] g0_color = 16'b1111111111111111;
  reg [15:0] g1_color = 16'b1000000000000000;
  reg [15:0] g2_color = 16'b1000000000000000;
  reg [15:0] g3_color = 16'b1000000000000000;
  reg [1:0] GPalette_Ctrl = 2'b00;
  reg [7:0] pin2mode = 0;
  wire pin2f = (pin2mode == 8'h46);
  wire pin2j = (pin2mode == 8'h4A);

  wire flashsel = (AUX == 0) & pin2f;

  assign MISO = SSEL ? (flashsel ? flashMISO : 1'bz) : gdMISO;
  // assign MISO = SSEL ? (1'bz ) : gdMISO;
  // PULLUP MISO_pullup(.O(MISO));
  // IOBUF MISO_iobuf(
  //   .I(gdMISO),
  //   .IO(MISO),
  //   .T(SSEL));


  // user-visible registers
  reg [7:0] frames;
  reg [8:0] scrollx;
  reg [8:0] scrolly;
  reg jkmode;

  wire [7:0] palette16l_read;
  wire [7:0] palette16h_read;
  wire [4:0] palette16_addr;
  wire [15:0] palette16_data;

  // 11'b00001xxxxx0: low
  wire palette16_wr = (mem_wr & (mem_w_addr[14:11] == 5) & (mem_w_addr[10:6] == 1));
  ram32x8d palette16l(
    .a(mem_addr[5:1]),
    .wclk(mem_clk),
    .wea((mem_w_addr[0] == 0) & palette16_wr),
    .ad(mem_data_wr),
    .ao(palette16l_read),
    .b(palette16_addr),
    .bo(palette16_data[7:0]));
  ram32x8d palette16h(
    .a(mem_addr[5:1]),
    .wclk(mem_clk),
    .wea((mem_w_addr[0] == 1) & palette16_wr),
    .ad(mem_data_wr),
    .ao(palette16h_read),
    .b(palette16_addr),
    .bo(palette16_data[15:8]));

  wire [7:0] palette4l_read;
  wire [7:0] palette4h_read;
  wire [4:0] palette4_addr;
  wire [15:0] palette4_data;

  // 11'b00010xxxxx0: low
  wire palette4_wr = (mem_wr & (mem_w_addr[14:11] == 5) & (mem_w_addr[10:6] == 2));
  ram32x8d palette4l(
    .a(mem_addr[5:1]),
    .wclk(mem_clk),
    .wea((mem_w_addr[0] == 0) & palette4_wr),
    .ad(mem_data_wr),
    .ao(palette4l_read),
    .b(palette4_addr),
    .bo(palette4_data[7:0]));
  ram32x8d palette4h(
    .a(mem_addr[5:1]),
    .wclk(mem_clk),
    .wea((mem_w_addr[0] == 1) & palette4_wr),
    .ad(mem_data_wr),
    .ao(palette4h_read),
    .b(palette4_addr),
    .bo(palette4_data[15:8]));

  // Generate CounterX and CounterY
  // A single line is 1040 clocks.  Line pair is 2080 clocks.

  reg [10:0] CounterX;
  reg [9:0] CounterY;
  wire CounterXmaxed = (CounterX==1040);

  always @(posedge vga_clk)
  if(CounterXmaxed)
    CounterX <= 0;
  else
    CounterX <= CounterX + 1;
  wire lastline = (CounterY == 665);
  wire [9:0] _CounterY = lastline ? 0 : (CounterY + 1);

  always @(posedge vga_clk)
  if (CounterXmaxed) begin
    CounterY <= _CounterY;
    if (lastline)
      frames <= frames + 1;
  end

  reg [12:0] comp_workcnt; // Compositor work address
  reg comp_workcnt_lt_400;
  always @(posedge vga_clk)
  begin
    if (CounterXmaxed & (CounterY[0] == 0)) begin
      comp_workcnt <= 0;
      comp_workcnt_lt_400 <= 1;
    end else begin
      comp_workcnt <= comp_workcnt + 1;
      if (comp_workcnt == 399)
        comp_workcnt_lt_400 <= 0;
    end
  end

// horizontal
//   Front porch  56
//   Sync         120
//   Back porch   64

// vertical
//   Front porch  37 lines
//   Sync         6
//   Back porch   23

// `define HSTART (53 + 120 + 61)
`define HSTART 0

  reg vga_HS, vga_VS, vga_active;
  always @(posedge vga_clk)
  begin
    vga_HS <= ((800 + 61) <= CounterX) & (CounterX < (800 + 61 + 120));
    vga_VS <= (35 <= CounterY) & (CounterY < (35 + 6));
    vga_active = ((`HSTART + 1) <= CounterX) & (CounterX < (`HSTART + 1 + 800)) & ((35 + 6 + 21) < CounterY) & (CounterY <= (35 + 6 + 21 + 600));
  end

  wire [10:0] xx = (CounterX - `HSTART);
  wire [10:0] xx_1 = (CounterX - `HSTART + 1);
  wire [10:0] yy = (CounterY + 2 - (35 + 6 + 21 + 1));    // yy range 0-665

  wire [10:0] column = comp_workcnt + scrollx;
  wire [10:0] row    = yy[10:1] + scrolly;
  wire [7:0] glyph;

  wire [11:0] picaddr = {row[8:3], column[8:3]};


  wire en_pic = (mem_addr[14:12] == 0);
  RAM_PICTURE picture(
    .dia(0), .doa(glyph), .wea(0),     .ena(1), .clka(vga_clk), .addra(picaddr), .ssra(0),
    .dib(mem_data_wr), .dob(mem_data_rd0),             .web(mem_wr), .enb(en_pic), .clkb(mem_clk), .addrb(mem_addr),.ssrb(0));

  reg [2:0] _column;
  always @(posedge vga_clk)
    _column = column;

  wire en_chr = (mem_addr[14:12] == 1);
  wire [1:0] charout;
  RAM_CHR chars(
    .dia(0), .doa(charout), .wea(0),     .ena(1), .clka(vga_clk), .addra({glyph, row[2:0], _column[2], ~_column[1:0]}), .ssra(0),
    .dib(mem_data_wr), .dob(mem_data_rd1),             .web(mem_wr), .enb(en_chr), .clkb(mem_clk), .addrb(mem_addr),.ssrb(0));

  reg [7:0] _glyph;
  reg glyph_MSB;
  reg [11:0] picaddr1;
  reg [11:0] picaddr2;
  reg [1:0] picaddr3;
  reg [1:0] _charout;
 
  always @(posedge vga_clk)
  begin
    _glyph <= glyph;
    glyph_MSB <= _glyph[7];
    picaddr1 <= picaddr;
    picaddr2 <= picaddr1;
    picaddr3 <= picaddr2[1:0];
    _charout <= charout;
  end


  wire [4:0] bg_r;
  wire [4:0] bg_g;
  wire [4:0] bg_b;
  wire [9:0] cpal_addr = (GPalette_Ctrl[0])? {_glyph, charout} : picaddr2[11:2];
  wire en_pal = (mem_addr[14:11] == 4'b0100);
  wire [15:0] char_matte;
  wire [15:0] cPal_out;
  RAM_PAL charpalette(
    .DIA(mem_data_wr),
    .WEA(mem_wr),
    .ENA(en_pal),
    .CLKA(mem_clk),
    .ADDRA(mem_addr),
    .DOA(mem_data_rd2),
    .SSRA(0),

    .DIB(0),
    .WEB(0),
    .ENB(1),
    .CLKB(vga_clk),
    .ADDRB(cpal_addr),
    .DOB(cPal_out),
    .SSRB(0)
  );

  wire [3:0] pix_colorSel;

  // instantiate the pixel decoder
  PixelDecoder pixdec(
    .PAL_Color(cPal_out),
    .CHR_X(picaddr3[1:0]),
    .color_select(pix_colorSel)
  );
  wire [7:0] GPalette_read;
  wire gpalette_wr = mem_wr & (mem_w_addr[14:5] == 10'b0101000001);
  wire [15:0] gPal_out;


`ifdef USING_OLDISE
  // instantiate the global palette
  GPalette_Old gpal(
	.clk( mem_clk ),
        // memory interface signals
	.mem_wr(gpalette_wr),	
     	.mem_data_wr(mem_data_wr), 
     	.mem_w_addr(mem_w_addr[4:0]),  
     	.mem_r_addr(mem_r_addr[4:0]),  
	.mem_data_rd(GPalette_read),
	// color mode info
	.glyph_MSB(glyph_MSB),   // the glyph ID's MSB (for color mode 1)
	.color_mode(GPalette_Ctrl[1]),  // the color mode, 0 for global 3, 1 for global 2
	.color_select(pix_colorSel), // value from RAM_COL
	.pixel_color(_charout), // value from RAM_CHR
        // color inputs
	.g0_color(g0_color), // global palette color 0
	.g1_color(g1_color), // global palette color 0
	.g2_color(g2_color), // global palette color 0
	.g3_color(g3_color), // -- global palette color 0
	// final color output
	.color_matte(gPal_out) 
  );
`else
  // instantiate the global palette
  GPalette gpal(
	.clk( mem_clk ),
        // memory interface signals
	.mem_wr(gpalette_wr),	
     	.mem_data_wr(mem_data_wr), 
     	.mem_w_addr(mem_w_addr[4:0]),  
     	.mem_r_addr(mem_r_addr[4:0]),  
	.mem_data_rd(GPalette_read),
	// color mode info
	.glyph_MSB(glyph_MSB),   // the glyph ID's MSB (for color mode 1)
	.color_mode(GPalette_Ctrl[1]),  // the color mode, 0 for global 3, 1 for global 2
	.color_select(pix_colorSel), // value from RAM_COL
	.pixel_color(_charout), // value from RAM_CHR
        // color inputs
	.g0_color(g0_color), // global palette color 0
	.g1_color(g1_color), // global palette color 0
	.g2_color(g2_color), // global palette color 0
	.g3_color(g3_color), // -- global palette color 0
	// final color output
	.color_matte(gPal_out) 
  );
`endif	

  assign char_matte = (GPalette_Ctrl[0])? cPal_out : gPal_out;

  // wire [4:0] bg_mix_r = bg_color[14:10] + char_matte[14:10];
  // wire [4:0] bg_mix_g = bg_color[9:5]   + char_matte[9:5];
  // wire [4:0] bg_mix_b = bg_color[4:0]   + char_matte[4:0];
  // wire [14:0] char_final = char_matte[15] ? {bg_mix_r, bg_mix_g, bg_mix_b} : char_matte[14:0];
  wire [14:0] char_final = char_matte[15] ? bg_color : char_matte[14:0];

  reg [7:0] mem_data_rd_reg;

  // Collision detection RAM is readable during vblank
  // writes coll_d to coll_w_addr during render
  wire coll_rd = (yy >= 600); // 1 means reading
  wire [7:0] coll_d;
  wire [7:0] coll_w_addr;
  wire coll_we;
  wire [7:0] coll_addr = coll_rd ? mem_r_addr[7:0] : coll_w_addr;
  wire [7:0] coll_o;
  ram256x8s coll(.o(coll_o), .a(coll_addr), .d(coll_d), .wclk(vga_clk), .we(~coll_rd & coll_we));
 // wire [7:0] screenshot_rd;



  reg j1_reset = 0;
  reg spr_disable = 1;
  reg [1:0] dith_en = 2'b11;
  reg spr_page = 0;

  // Screenshot notes
  // three states, controlled by screenshot_primed, _done:
  //  primed done                         composer.A
  //  0      0     screenshot disabled    write(comp_write)
  //  1      0     screenshot primed      write(comp_write)
  //  1      1     screenshot done        read(mem_r_addr[9:1])
//
//  reg [8:0] screenshot_yy;  // 9 bits, 0-400
//  reg screenshot_primed;
//  reg screenshot_done;
//  wire screenshot_reset;
  wire [8:0] public_yy = coll_rd ? 300 : yy[10:1];
/*
  always @(posedge vga_clk)
  begin
    if (screenshot_reset)
      screenshot_done <= 0;
    else if (CounterXmaxed & screenshot_primed & !screenshot_done & (public_yy == screenshot_yy)) begin
      screenshot_done <= 1;
    end
  end
*/
  always @(mem_data_rd_reg)
  begin
    casex (mem_r_addr[10:0])
    11'h000: mem_data_rd_reg <= 8'h6d;  // Gameduino ident
    11'h001: mem_data_rd_reg <= `REVISION;
    11'h002: mem_data_rd_reg <= frames;
    11'h003: mem_data_rd_reg <= coll_rd;  // called VBLANK, but really "is coll readable?"
    11'h004: mem_data_rd_reg <= scrollx[7:0];
    11'h005: mem_data_rd_reg <= scrollx[8];
    11'h006: mem_data_rd_reg <= scrolly[7:0];
    11'h007: mem_data_rd_reg <= scrolly[8];
    11'h008: mem_data_rd_reg <= jkmode;
    11'h009: mem_data_rd_reg <= j1_reset;
    11'h00a: mem_data_rd_reg <= spr_disable;
    11'h00b: mem_data_rd_reg <= spr_page;
    11'h00c: mem_data_rd_reg <= pin2mode;
    11'h00d: mem_data_rd_reg <= dith_en;
    11'h00e: mem_data_rd_reg <= bg_color[7:0];
    11'h00f: mem_data_rd_reg <= bg_color[14:8];
    11'h010: mem_data_rd_reg <= sample_l[7:0];
    11'h011: mem_data_rd_reg <= sample_l[15:8];
    11'h012: mem_data_rd_reg <= sample_r[7:0];
    11'h013: mem_data_rd_reg <= sample_r[15:8];
    11'h014: mem_data_rd_reg <= mem_data_rdAudio;
    11'h015: mem_data_rd_reg <= GPalette_Ctrl;
    11'h016: mem_data_rd_reg <= g0_color[7:0];
    11'h017: mem_data_rd_reg <= g0_color[15:8];
    11'h018: mem_data_rd_reg <= g1_color[7:0];
    11'h019: mem_data_rd_reg <= g1_color[15:8];
    11'h01a: mem_data_rd_reg <= g2_color[7:0];
    11'h01b: mem_data_rd_reg <= g2_color[15:8];
    11'h01c: mem_data_rd_reg <= g3_color[7:0];
    11'h01d: mem_data_rd_reg <= g3_color[15:8];   
    11'h01e: mem_data_rd_reg <= public_yy[7:0];
    11'h01f: mem_data_rd_reg <= public_yy[8];
    11'h02x: mem_data_rd_reg <= GPalette_read;
    11'h03x: mem_data_rd_reg <= GPalette_read;
    11'b00001xxxxx0: mem_data_rd_reg <= palette16l_read;
    11'b00001xxxxx1: mem_data_rd_reg <= palette16h_read;
    11'b00010xxxxx0: mem_data_rd_reg <= palette4l_read;
    11'b00010xxxxx1: mem_data_rd_reg <= palette4h_read;
    11'b001xxxxxxxx:
      mem_data_rd_reg <= coll_rd ? coll_o : 8'hff;
    11'b010xxxxxx00: mem_data_rd_reg <= mem_data_rdAudio;
    11'b010xxxxxx01: mem_data_rd_reg <= mem_data_rdAudio;
    11'b010xxxxxx10: mem_data_rd_reg <= mem_data_rdAudio;
    11'b010xxxxxx11: mem_data_rd_reg <= mem_data_rdAudio;
    11'b011xxxxxxx0: mem_data_rd_reg <= j1insnl_read;
    11'b011xxxxxxx1: mem_data_rd_reg <= j1insnh_read;
    //11'b1xxxxxxxxxx: mem_data_rd_reg <= screenshot_rd;
    // default: mem_data_rd_reg <= 0;
    endcase
  end



  //assign screenshot_reset = mem_wr & (mem_w_addr[14:11] == 5) & (mem_w_addr[10:0] == 11'h01f);
  always @(posedge mem_clk)
  begin
    if (mem_wr & mem_w_addr[14:11] == 5)
      casex (mem_w_addr[10:0])
      11'h004: scrollx[7:0]   <= mem_data_wr;
      11'h005: scrollx[8]     <= mem_data_wr;
      11'h006: scrolly[7:0]   <= mem_data_wr;
      11'h007: scrolly[8]     <= mem_data_wr;
      11'h008: jkmode         <= mem_data_wr;
      11'h009: j1_reset       <= mem_data_wr;
      11'h00a: spr_disable    <= mem_data_wr;
      11'h00b: spr_page       <= mem_data_wr;
      11'h00c: pin2mode       <= mem_data_wr;
      11'h00d: dith_en        <= mem_data_wr;
      11'h00e: bg_color[7:0]  <= mem_data_wr;
      11'h00f: bg_color[14:8] <= mem_data_wr;
      11'h010: sample_l[7:0]  <= mem_data_wr;
      11'h011: sample_l[15:8] <= mem_data_wr;
      11'h012: sample_r[7:0]  <= mem_data_wr;
      11'h013: sample_r[15:8] <= mem_data_wr;
      11'h015: GPalette_Ctrl  <= mem_data_wr;
      11'h016: g0_color[7:0]  <= mem_data_wr;
      11'h017: g0_color[15:8] <= mem_data_wr;
      11'h018: g1_color[7:0]  <= mem_data_wr;
      11'h019: g1_color[15:8] <= mem_data_wr;
      11'h01a: g2_color[7:0]  <= mem_data_wr;
      11'h01b: g2_color[15:8] <= mem_data_wr;
      11'h01c: g3_color[7:0]  <= mem_data_wr;
      11'h01d: g3_color[15:8] <= mem_data_wr; 
 //     11'h01e: screenshot_yy[7:0] <= mem_data_wr;
//      11'h01f: begin screenshot_primed <= mem_data_wr[7];
//               screenshot_yy[8] <= mem_data_wr; end
      endcase
  end

  /*
    0000-0fff Picture
    1000-1fff Character
    2000-27ff Character
    2800-2fff (Unused)
    3000-37ff Sprite values
    3800-3fff Sprite palette
    4000-7fff Sprite image
  */
  always @*
  begin
    case (mem_addr[14:11]) // 2K pages
    4'h0: mem_data_rd <= mem_data_rd0;  // pic
    4'h1: mem_data_rd <= mem_data_rd0;
    4'h2: mem_data_rd <= mem_data_rd1;  // chr
    4'h3: mem_data_rd <= mem_data_rd1;
    4'h4: mem_data_rd <= mem_data_rd2;  // pal
    4'h5: mem_data_rd <= mem_data_rd_reg;
    4'h6: mem_data_rd <= mem_data_rd3;  // sprval
    4'h7: mem_data_rd <= mem_data_rd4;  // sprpal
    4'h8: mem_data_rd <= mem_data_rd5;  // sprimg
    4'h9: mem_data_rd <= mem_data_rd5;  // sprimg
    4'ha: mem_data_rd <= mem_data_rd5;  // sprimg
    4'hb: mem_data_rd <= mem_data_rd5;  // sprimg
    4'hc: mem_data_rd <= mem_data_rd5;  // sprimg
    4'hd: mem_data_rd <= mem_data_rd5;  // sprimg
    4'he: mem_data_rd <= mem_data_rd5;  // sprimg
    4'hf: mem_data_rd <= mem_data_rd5;  // sprimg

    default: mem_data_rd <= 8'h97;
    endcase
  end

  // Sprite memory

  // Stage 1: scan for valid
  reg [8:0] s1_count;

  wire en_sprval = (mem_addr[14:11] == 4'b0110);
  wire [31:0] sprval_data;
  RAM_SPRVAL sprval(
    .DIA(mem_data_wr),
    .WEA(mem_wr),
    .ENA(en_sprval),
    .CLKA(mem_clk),
    .ADDRA(mem_addr),
    .DOA(mem_data_rd3),
    .SSRA(0),

    .DIB(0),
    .WEB(0),
    .ENB(1),
    .CLKB(vga_clk),
    .ADDRB({spr_page, s1_count[7:0]}),
    .DOB(sprval_data),
    .SSRB(0)
  );
  wire [9:0] sprpal_addr;
  wire [15:0] sprpal_data;
  wire en_sprpal = (mem_addr[14:11] == 4'b0111);
  RAM_SPRPAL sprpal(
    .DIA(mem_data_wr),
    .WEA(mem_wr),
    .ENA(en_sprpal),
    .CLKA(mem_clk),
    .ADDRA(mem_addr),
    .DOA(mem_data_rd4),
    .SSRA(0),

    .DIB(0),
    .WEB(0),
    .ENB(1),
    .CLKB(vga_clk),
    .ADDRB(sprpal_addr),
    .DOB(sprpal_data),
    .SSRB(0)
  );
  wire [13:0] sprimg_readaddr;
  wire [7:0] sprimg_data;
  wire en_sprimg = (mem_addr[14] == 1'b1);
//  ram16K_8_8 sprimg(
  RAM_SPRIMG sprimg(
    .dia(mem_data_wr),
    .wea(mem_wr),
    .ena(en_sprimg),
    .clka(mem_clk),
    .addra(mem_addr),
    .doa(mem_data_rd5),
    .ssra(0),

    .dib(0),
    .web(0),
    .enb(1),
    .clkb(vga_clk),
    .addrb(sprimg_readaddr),
    .dob(sprimg_data),
    .ssrb(0)
  );

  // Stage 1: scan for valid

  reg s1_consider;      // Consider the sprval on the next cycle
  wire s2_room;         // Does s2 fifo have room for one entry?
  always @(posedge vga_clk)
  begin
    if (comp_workcnt == 0) begin
      s1_count <= 0;
      s1_consider <= 0;
    end else
      if ((s1_count <= 255) & s2_room) begin
        s1_count <= s1_count + 1;
        s1_consider <= 1;
      end else begin
        s1_consider <= 0;
      end
  end
  wire [31:0] s1_out = sprval_data;
  wire [8:0] s1_y_offset = yy[9:1] - s1_out[24:16];
  wire s1_visible = (spr_disable == 0) & (s1_y_offset[8:4] == 0);
  wire s1_valid = s1_consider & s1_visible;
  reg [8:0] s1_id;
  always @(posedge vga_clk)
    s1_id <= s1_count;

  // Stage 2: fifo
  wire [4:0] s2_fullness;
  wire s3_read;
  wire [40:0] s2_out;
  fifo #(40) s2(.clk(vga_clk),
                .wr(s1_valid), .datain({s1_id, s1_out}),
                .rd(s3_read), .dataout(s2_out),
                .fullness(s2_fullness));
  assign s2_room = (s2_fullness < 14);

  wire s2_valid = s2_fullness != 0;

  // 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
  //    [     image     ] [          y             ]       [PAL] [  ROT ] [           x            ]

  /* Stage 3: read sprimg
    consume s2_out on last cycle 
    out: s3_valid, s3_pal, s3_out, s3_compaddr
  */

  reg [4:0] s3_state;
  reg [3:0] s3_pal;
  reg [31:0] s3_in;
  assign s3_read = (s3_state == 15);
  always @(posedge vga_clk)
  begin
    if (comp_workcnt < 403)
      s3_state <= 16;
    else if (s3_state == 16) begin
      if (s2_valid) begin
        s3_state <= 0;
        s3_in <= s2_out;
      end
    end else begin
      s3_state <= s3_state + 1;
    end
    s3_pal <= s2_out[15:12];
  end
  wire [3:0] s3_yoffset = yy[4:1] - s2_out[19:16];
  wire [3:0] s3_prev_state = (s3_state == 16) ? 0 : (s3_state + 1);
  wire [3:0] readx = (s2_out[9] ? s3_yoffset : s3_prev_state) ^ {4{s2_out[10]}};
  wire [3:0] ready = (s2_out[9] ? s3_prev_state : s3_yoffset) ^ {4{s2_out[11]}};
  assign sprimg_readaddr = {s2_out[30:25], ready, readx};
  wire [7:0] s3_out = sprimg_data;
  wire [8:0] s3_compaddr = s2_out[8:0] + s3_state;
  wire s3_valid = (s3_state != 16) & (s3_compaddr < 400);
  reg [8:0] s3_id;
  reg s3_jk;
  always @(posedge vga_clk)
  begin
    s3_id <= s2_out[40:32];
    s3_jk <= s2_out[31];
  end

  /* Stage 4: read sprpal
    out: s4_valid, s4_out, s4_compaddr
  */
  reg [15:0] sprpal4;
  reg [15:0] sprpal16;
  assign sprpal_addr = {s3_pal[1:0], s3_out};
  reg [8:0] s4_compaddr;
  reg s4_valid;
  reg [8:0] s4_id;
  reg s4_jk;
  wire [3:0] subfield4 = s3_pal[1] ? s3_out[7:4] : s3_out[3:0];
  wire [1:0] subfield2 = s3_pal[2] ? (s3_pal[1] ? s3_out[7:6] : s3_out[5:4]) : (s3_pal[1] ? s3_out[3:2] : s3_out[1:0]);
  assign palette4_addr = {s3_pal[0], subfield2};
  assign palette16_addr = {s3_pal[0], subfield4};
  always @(posedge vga_clk)
  begin
    s4_compaddr <= s3_compaddr;
    s4_valid <= s3_valid;
    s4_id <= s3_id;
    s4_jk <= s3_jk;
    sprpal4 <= palette4_data;
    sprpal16 <= palette16_data;
  end
  wire [15:0] s4_out = s3_pal[3] ? sprpal4 : ((s3_pal[3:2] == 0) ? sprpal_data : sprpal16);

  // Common signals for collision and composite
  wire sprite_write = s4_valid & !s4_out[15];  // transparency

  // Collision detect
  // Have 400x9 occupancy buffer.  If NEW overwrites a fragment OLD
  // (and their groups differ) write OLD to coll[NEW].
  // Reset coll to FF at start of frame.
  // Reset occ to FF at start of line, since sprites drawn 0->ff,
  // ff is impossible and means empty.

  wire coll_scrub = (yy == 0) & (comp_workcnt < 256);
  wire [8:0] occ_addr = comp_workcnt_lt_400 ? comp_workcnt : s4_compaddr;
  wire [8:0] occ_d = comp_workcnt_lt_400 ? 9'hff : {s4_jk, s4_id[7:0]};
  wire [8:0] oldocc;
  wire occ_w = comp_workcnt_lt_400 | sprite_write;
  ram400x9s occ(.o(oldocc), .a(occ_addr), .d(occ_d), .wclk(vga_clk), .we(occ_w));
  assign coll_d = coll_scrub ? 8'hff : oldocc[7:0];
  assign coll_w_addr = coll_scrub ? comp_workcnt : s4_id[7:0];
  // old contents 0xff, never write
  // jkmode=1 and JK's differ, allow write
  wire overwriting = (oldocc[7:0] != 8'hff);
  wire jkpass = (jkmode == 0) | (oldocc[8] ^ s4_jk);
  assign coll_we = coll_scrub | ((403 <= comp_workcnt) & sprite_write & overwriting & jkpass);

  // Composite

  wire comp_read = yy[1];   // which block is reading
  wire [8:0] comp_scanout = xx[9:1];
  wire [8:0] comp_write = (comp_workcnt < 403) ? (comp_workcnt - 3) : s4_compaddr;
  wire comp_part1 = (3 <= comp_workcnt) & (comp_workcnt < 403);
`ifdef NELLY
  wire [14:0] comp_out0;
  wire [14:0] comp_out1;
  RAMB16_S18_S18 composer(
    .DIPA(0),
    .DIA(comp_part1 ? char_final : s4_out),
    .WEA(comp_read == 1 & (comp_part1 | sprite_write)),
    .ENA(1),
    .CLKA(vga_clk),
    .ADDRA({1'b0, (comp_read == 0) ? comp_scanout : comp_write[8:0]}),
    .DOA(comp_out0),
    .SSRA(0),

    .DIPB(0),
    .DIB(comp_part1 ? char_final : s4_out),
    .WEB(comp_read == 0 & (comp_part1 | sprite_write)),
    .ENB(1),
    .CLKB(vga_clk),
    .ADDRB({1'b1, (comp_read == 1) ? comp_scanout : comp_write[8:0]}),
    .DOB(comp_out1),
    .SSRB(0)
  );
  wire [14:0] comp_out = comp_read ? comp_out1 : comp_out0;
`else
 // wire ss = screenshot_primed & screenshot_done;  // screenshot readout mode
 // wire [15:0] screenshot_rdHL;
  wire [0:0] screenshot_yy = 0;
 wire [15:0] screenshot_rdHL = 0;
 wire [14:0] comp_out;
  // Port A is the write, or read when screenshot is ready
  // Port B is scanout
  RAMB16_S18_S18
  composer(
    .DIPA(0),
    .DIA(comp_part1 ? char_final : s4_out),
    .WEA(!ss & (comp_part1 | sprite_write)),
    .ENA(1),
    .CLKA(vga_clk),
    .ADDRA(ss ? {screenshot_yy[0], mem_r_addr[9:1]} : {comp_read, comp_write[8:0]}),
    .DOA(screenshot_rdHL),
    .SSRA(0),

    .DIPB(0),
    .DIB(0),
    .WEB(0),
    .ENB(1),
    .CLKB(vga_clk),
    .ADDRB({!comp_read, comp_scanout}),
    .DOB(comp_out),
    .SSRB(0)
  );
  //assign screenshot_rd = mem_r_addr[0] ? screenshot_rdHL[15:8] : screenshot_rdHL[7:0];
`endif
  assign {bg_r,bg_g,bg_b} = comp_out;

  // Figure out from above signals when composite completes
  // by detecting pipeline idle
  wire composite_complete = (comp_workcnt > 403) & (s1_count == 256) & !s1_consider & !s2_valid & (s3_state == 16) & !s4_valid;

  // Signal generation

  wire [16:0] lfsr;
  lfsre lfsr0(
    .clk(vga_clk),
    .lfsr(lfsr));

  wire [1:0] dith;
  // 0 2
  // 3 1
  // if dith_en = 0, then dith = 0 always
  wire xdith = dith_en[0] & xx[0];
  wire ydith = dith_en[1] & yy[0];
  assign dith = {(xdith^ydith), ydith};
  wire [5:0] dith_r = (bg_r + dith);
  wire [5:0] dith_g = (bg_g + dith);
  wire [5:0] dith_b = (bg_b + dith);
  wire [2:0] f_r = {3{dith_r[5]}} | dith_r[4:2];
  wire [2:0] f_g = {3{dith_g[5]}} | dith_g[4:2];
  wire [2:0] f_b = {3{dith_b[5]}} | dith_b[4:2];

  wire [2:0] ccc = { charout[1], charout[0], charout[0] };

`ifdef A7_DEBUG
  assign vga_red =    vga_active ? {f_r,1'b0} : 0;
  assign vga_green =  vga_active ? {f_g,1'b0} : 0;
  assign vga_blue =   vga_active ? {f_b,1'b0} : 0;
  assign vga_hsync_n = ~vga_HS;
  assign vga_vsync_n = ~vga_VS;
`else
  assign vga_red =    vga_active ? f_r : 0;
  assign vga_green =  vga_active ? f_g : 0;
  assign vga_blue =   vga_active ? f_b : 0;
  assign vga_hsync_n = ~vga_HS;
  assign vga_vsync_n = ~vga_VS;
`endif
  //assign VGA_Bus[9:7] =    vga_active ? f_r : 0;
  //assign VGA_Bus[19:17] =  vga_active ? f_g : 0;
 // assign VGA_Bus[29:27] =   vga_active ? f_b : 0;
 // assign VGA_Bus[30] = ~vga_HS;
 // assign VGA_Bus[31] = ~vga_VS;  


`ifdef USE_AUDIO


`ifdef USE_SID

  GD_SID8580_Wrapper audio(
    .vga_clk(vga_clk),
    .mem_data_rd(mem_data_rdAudio),
    .mem_data_wr(mem_data_wr),
    .mem_w_addr(mem_w_addr),   // Combined write address
    .mem_r_addr(mem_r_addr),   // Combined read address
    .mem_rd(mem_rd),
    .mem_wr(mem_wr),
    .sample_l(sample_l),
    .sample_r(sample_r),
    .lfsr(lfsr),
    .soundcounterOut(soundcounter),
    .AUDIOL(AUDIOL),
    .AUDIOR(AUDIOR)
  );

`elsif USE_DIGITALAUDIO

  GD_DigitalAudio audio(
    .vga_clk(vga_clk),
    .mem_data_rd(mem_data_rdAudio),
    .mem_data_wr(mem_data_wr),
    .mem_w_addr(mem_w_addr),   // Combined write address
    .mem_r_addr(mem_r_addr),   // Combined read address
    .mem_rd(mem_rd),
    .mem_wr(mem_wr),
    .sample_l(sample_l),
    .sample_r(sample_r),
    .lfsr(lfsr),
    .soundcounterOut(soundcounter),
    .AUDIOL(AUDIOL),
    .AUDIOR(AUDIOR)
 );

`else

  // instantiate the sound system
  GD_AudioSystem audio(
    .vga_clk(vga_clk),
    .mem_data_rd(mem_data_rdAudio),
    .mem_data_wr(mem_data_wr),
    .mem_w_addr(mem_w_addr),   // Combined write address
    .mem_r_addr(mem_r_addr),   // Combined read address
    .mem_rd(mem_rd),
    .mem_wr(mem_wr),
    .sample_l(sample_l),
    .sample_r(sample_r),
    .lfsr(lfsr),
    .soundcounterOut(soundcounter),
    .AUDIOL(AUDIOL),
    .AUDIOR(AUDIOR)
 );
`endif // USE_SID


`endif // USE_AUDIO

  reg [2:0] busyhh;
  always @(posedge vga_clk) busyhh = { busyhh[1:0], host_busy };

  // J1 Peripherals
  reg [7:0] icap_i;   // ICAP in
  reg icap_write;
  reg icap_ce;
  reg icap_clk;

  wire [7:0] icap_o;  // ICAP out
  wire  icap_busy;

  reg j1_p2_dir = 1;    // pin defaults to input
  reg j1_p2_o = 1;

//  ICAP_SPARTAN3A ICAP_SPARTAN3A_inst (
//    .O(icap_o),
//    .BUSY(icap_busy),
//    .I(icap_i),
//    .WRITE(icap_write),
//    .CE(icap_ce),
//    .CLK(icap_clk));

  reg dna_read;
  reg dna_shift;
  reg dna_clk;
  wire dna_dout;
//  DNA_PORT dna(
//    .DOUT(dna_dout),
//    .DIN(0),
//    .READ(dna_read),
//    .SHIFT(dna_shift),
//    .CLK(dna_clk));

  wire j1_wr;

  reg [8:0] YYLINE;
  wire [9:0] yyline = (CounterY + 4 - (35 + 6 + 21 + 1));
  always @(posedge vga_clk)
  begin
    // if (xx == 400)
    if (composite_complete)
      YYLINE = yyline[9:1];
  end

  reg [15:0] freqhz = 8000;
  reg [7:0] freqtick;

  reg [26:0] freqd;
  wire [26:0] freqdN = freqd + freqhz - (freqd[26] ? 0 : 50000000);
  always @(posedge vga_clk)
  begin
    freqd = freqdN;
    if (freqd[26] == 0)
      freqtick = freqtick + 1;
  end

  reg [15:0] local_j1_read;
  always @*
  begin
    case ({j1_mem_addr[4:1], 1'b0})
    5'h00: local_j1_read <= YYLINE;
    5'h02: local_j1_read <= icap_o;
    5'h0c: local_j1_read <= freqtick;
    5'h0e: local_j1_read <= AUX;
    5'h12: local_j1_read <= lfsr;
    5'h14: local_j1_read <= soundcounter;
    5'h16: local_j1_read <= flashMISO;
    5'h18: local_j1_read <= dna_dout;

    // default: local_j1_read <= 16'hffff;
    endcase
  end

  wire [0:7] j1_mem_dout_be = j1_mem_dout;
  reg j1_flashMOSI;
  reg j1_flashSCK;
  reg j1_flashSSEL;

  always @(posedge vga_clk)
  begin
    if (j1_wr & (j1_mem_addr[15] == 1))
      case ({j1_mem_addr[4:1], 1'b0})
      // 5'h06: icap_i <= j1_mem_dout;
      // 5'h08: icap_write <= j1_mem_dout;
      // 5'h0a: icap_ce <= j1_mem_dout;
      // 5'h0c: icap_clk <= j1_mem_dout;
      5'h06: {icap_write,icap_ce,icap_clk,icap_i} <= j1_mem_dout;
      5'h08: {dna_read, dna_shift, dna_clk} <= j1_mem_dout;
      5'h0a: freqhz <= j1_mem_dout;
      5'h0e: j1_p2_o <= j1_mem_dout;
      5'h10: j1_p2_dir <= j1_mem_dout;
      5'h18: j1_flashMOSI <= j1_mem_dout;
      5'h1a: j1_flashSCK <= j1_mem_dout;
      5'h1c: j1_flashSSEL <= j1_mem_dout;
      endcase
  end

  assign j1_mem_wr = j1_wr & (j1_mem_addr[15] == 0);
  j0 j(.sys_clk_i(vga_clk),
       .sys_rst_i(j1_reset),
       .insn(j1_insn),
       .insn_addr(j1_insn_addr),
       .mem_wr(j1_wr),
       .mem_addr(j1_mem_addr),
       .mem_dout(j1_mem_dout),
       .mem_din(j1_mem_addr[15] ? local_j1_read : mem_data_rd),
       .pause(host_busy | (busyhh != 0))
       );

  // 0x2b00: j1 insn RAM
  wire jinsn_wr = (mem_wr & (mem_w_addr[14:8] == 6'h2b));
  RAM_CODEL jinsnl(.b(j1_insn_addr), .bo(j1_insn[7:0]),
    .a(mem_addr[7:1]),
    .wclk(vga_clk),
    .wea((mem_w_addr[0] == 0) & jinsn_wr),
    .ad(mem_data_wr),
    .ao(j1insnl_read));
  RAM_CODEH jinsnh(.b(j1_insn_addr), .bo(j1_insn[15:8]),
    .a(mem_addr[7:1]),
    .wclk(vga_clk),
    .wea((mem_w_addr[0] == 1) & jinsn_wr),
    .ad(mem_data_wr),
    .ao(j1insnh_read));

  assign flashMOSI = pin2j ? j1_flashMOSI : MOSI;
  assign flashSCK = pin2j ? j1_flashSCK : SCK;
  assign flashSSEL = pin2f ? AUX : (pin2j ? j1_flashSSEL : 1);

  assign AUX = (pin2j & (j1_p2_dir == 0)) ? j1_p2_o : 1'bz;

endmodule // Gameduino
