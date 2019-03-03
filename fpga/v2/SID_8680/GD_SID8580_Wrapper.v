module GD_SID8580_Wrapper(
    input vga_clk,
    output [7:0] mem_data_rd,
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

  wire writeSID = mem_wr & (mem_w_addr[14:5] == 10'b0101010000);
  wire [4:0] addrSID = 0;
  wire [17:0] SIDAduioL = 0;
  wire [17:0] SIDAudioR = 0;
  wire signed [15:0] lsum = 0;
  wire signed [15:0] rsum = 0;
  assign addrSID = (writeSID)? mem_w_addr[4:0] : mem_r_addr[4:0];

// sound counter
  reg [17:0] soundcounter;
 
  assign soundcounterOut = soundcounter;

  always @(posedge vga_clk)
    soundcounter <= soundcounter + 1;

  wire [5:0] vi = soundcounter;



sid8580 sid (
	.reset(0),

	.clk(vga_clk),
	.ce_1m(writeSID),

	.we(writeSID),
	.addr(addrSID),
	.data_in(mem_data_wr),
	.data_out(mem_data_rd),

	.extfilter_en(0),
	.audio_data(SIDAduioL)
       );

  assign lsum = SIDAduioL[17:2];
  assign rsum = SIDAduioL[17:2];

  reg signed [15:0] lacc;
  reg signed [15:0] racc;
  wire zeroacc = (vi == 63);
  wire [15:0] _lacc = zeroacc ? sample_l : lsum;
  wire [15:0] _racc = zeroacc ? sample_r : rsum;
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

  // the final dac process

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

endmodule 