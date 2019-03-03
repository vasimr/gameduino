module oldram256x1s(
  input d,
  input we,
  input wclk,
  input [7:0] a,
  output o);

  wire sel0 = (a[7:6] == 0);
  wire o0;
  RAM64X1S r0(.O(o0), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .A4(a[4]), .A5(a[5]), .D(d), .WCLK(wclk), .WE(sel0 & we));

  wire sel1 = (a[7:6] == 1);
  wire o1;
  RAM64X1S r1(.O(o1), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .A4(a[4]), .A5(a[5]), .D(d), .WCLK(wclk), .WE(sel1 & we));

  wire sel2 = (a[7:6] == 2);
  wire o2;
  RAM64X1S r2(.O(o2), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .A4(a[4]), .A5(a[5]), .D(d), .WCLK(wclk), .WE(sel2 & we));

  wire sel3 = (a[7:6] == 3);
  wire o3;
  RAM64X1S r3(.O(o3), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .A4(a[4]), .A5(a[5]), .D(d), .WCLK(wclk), .WE(sel3 & we));

  assign o = (a[7] == 0) ? ((a[6] == 0) ? o0 : o1) : ((a[6] == 0) ? o2 : o3);
endmodule

module ring64(
  input clk,
  input i,
  output o);

  wire o0, o1, o2;
  SRL16E ring0( .CLK(clk), .CE(1), .D(i),  .A0(1), .A1(1), .A2(1), .A3(1), .Q(o0));
  SRL16E ring1( .CLK(clk), .CE(1), .D(o0), .A0(1), .A1(1), .A2(1), .A3(1), .Q(o1));
  SRL16E ring2( .CLK(clk), .CE(1), .D(o1), .A0(1), .A1(1), .A2(1), .A3(1), .Q(o2));
  SRL16E ring3( .CLK(clk), .CE(1), .D(o2), .A0(1), .A1(1), .A2(1), .A3(1), .Q(o));
endmodule

module ram256x1s(
  input d,
  input we,
  input wclk,
  input [7:0] a,
  output o);

  wire [1:0] rsel = a[7:6];
  wire [3:0] oo;
  genvar i;
  generate 
    for (i = 0; i < 4; i=i+1) begin : ramx
    RAM64X1S r0(.O(oo[i]), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .A4(a[4]), .A5(a[5]), .D(d), .WCLK(wclk), .WE((rsel == i) & we));
    end
  endgenerate

  assign o = oo[rsel];
endmodule

module ram448x1s(
  input d,
  input we,
  input wclk,
  input [8:0] a,
  output o);

  wire [2:0] rsel = a[8:6];
  wire [7:0] oo;
  genvar i;
  generate 
    for (i = 0; i < 7; i=i+1) begin : ramx
      RAM64X1S r0(.O(oo[i]), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .A4(a[4]), .A5(a[5]), .D(d), .WCLK(wclk), .WE((rsel == i) & we));
    end
  endgenerate

  assign o = oo[rsel];
endmodule

module ram400x1s(
  input d,
  input we,
  input wclk,
  input [8:0] a,
  output o);

  wire [2:0] rsel = a[8:6];
  wire [6:0] oo;
  genvar i;
  generate 
    for (i = 0; i < 6; i=i+1) begin : ramx
      RAM64X1S r0(.O(oo[i]), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .A4(a[4]), .A5(a[5]), .D(d), .WCLK(wclk), .WE((rsel == i) & we));
    end
  endgenerate
  RAM16X1S r6(.O(oo[6]), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .D(d), .WCLK(wclk), .WE((rsel == 6) & we));

  assign o = oo[rsel];
endmodule

module ram256x8s(
  input [7:0] d,
  input we,
  input wclk,
  input [7:0] a,
  output [7:0] o);
  genvar i;
  generate 
    for (i = 0; i < 8; i=i+1) begin : ramx
      ram256x1s ramx(
        .d(d[i]),
        .we(we),
        .wclk(wclk),
        .a(a),
        .o(o[i]));
    end
  endgenerate
endmodule

module ram32x8s(
  input [7:0] d,
  input we,
  input wclk,
  input [4:0] a,
  output [7:0] o);
  genvar i;
  generate 
    for (i = 0; i < 8; i=i+1) begin : ramx
      RAM32X1S r0(.O(o[i]), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .A4(a[4]), .D(d[i]), .WCLK(wclk), .WE(we));
    end
  endgenerate
endmodule

module ram64x8s(
  input [7:0] d,
  input we,
  input wclk,
  input [5:0] a,
  output [7:0] o);
  genvar i;
  generate 
    for (i = 0; i < 8; i=i+1) begin : ramx
      RAM64X1S r0(.O(o[i]), .A0(a[0]), .A1(a[1]), .A2(a[2]), .A3(a[3]), .A4(a[4]), .A5(a[5]), .D(d[i]), .WCLK(wclk), .WE(we));
    end
  endgenerate
endmodule

module mRAM32X1D(
  input D,
  input WE,
  input WCLK,
  input A0,     // port A
  input A1,
  input A2,
  input A3,
  input A4,
  input DPRA0,  // port B
  input DPRA1,
  input DPRA2,
  input DPRA3,
  input DPRA4,
  output DPO,   // port A out
  output SPO);  // port B out

  parameter INIT = 32'b0;
  wire hDPO;
  wire lDPO;
  wire hSPO;
  wire lSPO;
  RAM16X1D
    #( .INIT(INIT[15:0]) ) 
    lo(
    .D(D),
    .WE(WE & !A4),
    .WCLK(WCLK),
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .DPRA0(DPRA0),
    .DPRA1(DPRA1),
    .DPRA2(DPRA2),
    .DPRA3(DPRA3),
    .DPO(lDPO),
    .SPO(lSPO));
  RAM16X1D
    #( .INIT(INIT[31:16]) ) 
  hi(
    .D(D),
    .WE(WE & A4),
    .WCLK(WCLK),
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .DPRA0(DPRA0),
    .DPRA1(DPRA1),
    .DPRA2(DPRA2),
    .DPRA3(DPRA3),
    .DPO(hDPO),
    .SPO(hSPO));
  assign DPO = DPRA4 ? hDPO : lDPO;
  assign SPO = A4 ? hSPO : lSPO;
endmodule

module mRAM64X1D(
  input D,
  input WE,
  input WCLK,
  input A0,     // port A
  input A1,
  input A2,
  input A3,
  input A4,
  input A5,
  input DPRA0,  // port B
  input DPRA1,
  input DPRA2,
  input DPRA3,
  input DPRA4,
  input DPRA5,
  output DPO,   // port A out
  output SPO);  // port B out

  parameter INIT = 64'b0;
  wire hDPO;
  wire lDPO;
  wire hSPO;
  wire lSPO;
  mRAM32X1D
    #( .INIT(INIT[31:0]) ) 
    lo(
    .D(D),
    .WE(WE & !A5),
    .WCLK(WCLK),
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .A4(A4),
    .DPRA0(DPRA0),
    .DPRA1(DPRA1),
    .DPRA2(DPRA2),
    .DPRA3(DPRA3),
    .DPRA4(DPRA4),
    .DPO(lDPO),
    .SPO(lSPO));
  mRAM32X1D
    #( .INIT(INIT[63:32]) ) 
  hi(
    .D(D),
    .WE(WE & A5),
    .WCLK(WCLK),
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .A4(A4),
    .DPRA0(DPRA0),
    .DPRA1(DPRA1),
    .DPRA2(DPRA2),
    .DPRA3(DPRA3),
    .DPRA4(DPRA4),
    .DPO(hDPO),
    .SPO(hSPO));
  assign DPO = DPRA5 ? hDPO : lDPO;
  assign SPO = A5 ? hSPO : lSPO;
endmodule

module mRAM128X1D(
  input D,
  input WE,
  input WCLK,
  input A0,     // port A
  input A1,
  input A2,
  input A3,
  input A4,
  input A5,
  input A6,
  input DPRA0,  // port B
  input DPRA1,
  input DPRA2,
  input DPRA3,
  input DPRA4,
  input DPRA5,
  input DPRA6,
  output DPO,   // port A out
  output SPO);  // port B out
  parameter INIT = 128'h00000000000000000000000000000000;

  wire hDPO;
  wire lDPO;
  wire hSPO;
  wire lSPO;
  mRAM64X1D
   // #( .INIT(INIT[63:0]) ) 
    lo(
    .D(D),
    .WE(WE & !A6),
    .WCLK(WCLK),
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .A4(A4),
    .A5(A5),
    .DPRA0(DPRA0),
    .DPRA1(DPRA1),
    .DPRA2(DPRA2),
    .DPRA3(DPRA3),
    .DPRA4(DPRA4),
    .DPRA5(DPRA5),
    .DPO(lDPO),
    .SPO(lSPO));
  mRAM64X1D
   // #( .INIT(INIT[127:64]) ) 
    hi(
    .D(D),
    .WE(WE & A6),
    .WCLK(WCLK),
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .A4(A4),
    .A5(A5),
    .DPRA0(DPRA0),
    .DPRA1(DPRA1),
    .DPRA2(DPRA2),
    .DPRA3(DPRA3),
    .DPRA4(DPRA4),
    .DPRA5(DPRA5),
    .DPO(hDPO),
    .SPO(hSPO));
  assign DPO = DPRA6 ? hDPO : lDPO;
  assign SPO = A6 ? hSPO : lSPO;
endmodule


module mRAM256X1D(
  input D,
  input WE,
  input WCLK,
  input A0,     // port A
  input A1,
  input A2,
  input A3,
  input A4,
  input A5,
  input A6,
  input A7,
  input DPRA0,  // port B
  input DPRA1,
  input DPRA2,
  input DPRA3,
  input DPRA4,
  input DPRA5,
  input DPRA6,
  input DPRA7,
  output DPO,   // port A out
  output SPO);  // port B out

  wire hDPO;
  wire lDPO;
  wire hSPO;
  wire lSPO;
  mRAM128X1D
    lo(
    .D(D),
    .WE(WE & !A7),
    .WCLK(WCLK),
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .A4(A4),
    .A5(A5),
    .A6(A6),
    .DPRA0(DPRA0),
    .DPRA1(DPRA1),
    .DPRA2(DPRA2),
    .DPRA3(DPRA3),
    .DPRA4(DPRA4),
    .DPRA5(DPRA5),
    .DPRA6(DPRA6),
    .DPO(lDPO),
    .SPO(lSPO));
  mRAM128X1D
  hi(
    .D(D),
    .WE(WE & A7),
    .WCLK(WCLK),
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .A4(A4),
    .A5(A5),
    .A6(A6),
    .DPRA0(DPRA0),
    .DPRA1(DPRA1),
    .DPRA2(DPRA2),
    .DPRA3(DPRA3),
    .DPRA4(DPRA4),
    .DPRA5(DPRA5),
    .DPRA6(DPRA6),
    .DPO(hDPO),
    .SPO(hSPO));
  assign DPO = DPRA7 ? hDPO : lDPO;
  assign SPO = A7 ? hSPO : lSPO;
endmodule

module ram32x8d(
  input [7:0] ad,
  input wea,
  input wclk,
  input [4:0] a,
  input [4:0] b,
  output [7:0] ao,
  output [7:0] bo
  );
  genvar i;
  generate 
    for (i = 0; i < 8; i=i+1) begin : ramx
      mRAM32X1D ramx(
        .D(ad[i]),
        .WE(wea),
        .WCLK(wclk),
        .A0(a[0]),
        .A1(a[1]),
        .A2(a[2]),
        .A3(a[3]),
        .A4(a[4]),
        .DPRA0(b[0]),
        .DPRA1(b[1]),
        .DPRA2(b[2]),
        .DPRA3(b[3]),
        .DPRA4(b[4]),
        .SPO(ao[i]),
        .DPO(bo[i]));
    end
  endgenerate
endmodule

module ram64x8d(
  input [7:0] ad,
  input wea,
  input wclk,
  input [5:0] a,
  input [5:0] b,
  output [7:0] ao,
  output [7:0] bo
  );
  genvar i;
  generate 
    for (i = 0; i < 8; i=i+1) begin : ramx
      mRAM64X1D ramx(
        .D(ad[i]),
        .WE(wea),
        .WCLK(wclk),
        .A0(a[0]),
        .A1(a[1]),
        .A2(a[2]),
        .A3(a[3]),
        .A4(a[4]),
        .A5(a[5]),
        .DPRA0(b[0]),
        .DPRA1(b[1]),
        .DPRA2(b[2]),
        .DPRA3(b[3]),
        .DPRA4(b[4]),
        .DPRA5(b[5]),
        .SPO(ao[i]),
        .DPO(bo[i]));
    end
  endgenerate
endmodule

// Same but latched read port, for CPU
module ram32x8rd(
  input wclk,
  input [15:0] ad,
  input wea,
  input [4:0] a,
  input [4:0] b,
  output reg [15:0] ao,
  output reg [15:0] bo
  );
  wire [15:0] _ao;
  wire [15:0] _bo;
  always @(posedge wclk)
  begin
    ao <= _ao;
    bo <= _bo;
  end
  genvar i;
  generate 
    for (i = 0; i < 16; i=i+1) begin : ramx
      mRAM32X1D ramx(
        .D(ad[i]),
        .WE(wea),
        .WCLK(wclk),
        .A0(a[0]),
        .A1(a[1]),
        .A2(a[2]),
        .A3(a[3]),
        .A4(a[4]),
        .DPRA0(b[0]),
        .DPRA1(b[1]),
        .DPRA2(b[2]),
        .DPRA3(b[3]),
        .DPRA4(b[4]),
        .SPO(_ao[i]),
        .DPO(_bo[i]));
    end
  endgenerate
endmodule

module ram128x8rd(
  input wclk,
  input [15:0] ad,
  input wea,
  input [6:0] a,
  input [6:0] b,
  output reg [15:0] ao,
  output reg [15:0] bo
  );
  wire [15:0] _ao;
  wire [15:0] _bo;
  always @(posedge wclk)
  begin
    ao <= _ao;
    bo <= _bo;
  end
  genvar i;
  generate 
    for (i = 0; i < 8; i=i+1) begin : ramx
      mRAM128X1D ramx(
        .D(ad[i]),
        .WE(wea),
        .WCLK(wclk),
        .A0(a[0]),
        .A1(a[1]),
        .A2(a[2]),
        .A3(a[3]),
        .A4(a[4]),
        .A5(a[5]),
        .A6(a[6]),
        .DPRA0(b[0]),
        .DPRA1(b[1]),
        .DPRA2(b[2]),
        .DPRA3(b[3]),
        .DPRA4(b[4]),
        .DPRA5(b[5]),
        .DPRA6(b[6]),
        .SPO(_ao[i]),
        .DPO(_bo[i]));
    end
  endgenerate
endmodule

module ram256x8rd(
  input wclk,
  input [7:0] ad,
  input wea,
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] ao,
  output reg [7:0] bo
  );
  wire [7:0] _ao;
  wire [7:0] _bo;
  always @(posedge wclk)
  begin
    ao <= _ao;
    bo <= _bo;
  end
  genvar i;
  generate 
    for (i = 0; i < 8; i=i+1) begin : ramx
      mRAM256X1D ramx(
        .D(ad[i]),
        .WE(wea),
        .WCLK(wclk),
        .A0(a[0]),
        .A1(a[1]),
        .A2(a[2]),
        .A3(a[3]),
        .A4(a[4]),
        .A5(a[5]),
        .A6(a[6]),
        .A7(a[7]),
        .DPRA0(b[0]),
        .DPRA1(b[1]),
        .DPRA2(b[2]),
        .DPRA3(b[3]),
        .DPRA4(b[4]),
        .DPRA5(b[5]),
        .DPRA6(b[6]),
        .DPRA7(b[7]),
        .SPO(_ao[i]),
        .DPO(_bo[i]));
    end
  endgenerate
endmodule

module ram448x9s(
  input [8:0] d,
  input we,
  input wclk,
  input [8:0] a,
  output [8:0] o);
  genvar i;
  generate 
    for (i = 0; i < 9; i=i+1) begin : ramx
      ram448x1s ramx(
        .d(d[i]),
        .we(we),
        .wclk(wclk),
        .a(a),
        .o(o[i]));
    end
  endgenerate
endmodule

module ram400x9s(
  input [8:0] d,
  input we,
  input wclk,
  input [8:0] a,
  output [8:0] o);
  genvar i;
  generate 
    for (i = 0; i < 9; i=i+1) begin : ramx
      ram400x1s ramx(
        .d(d[i]),
        .we(we),
        .wclk(wclk),
        .a(a),
        .o(o[i]));
    end
  endgenerate
endmodule

module ram400x8s(
  input [7:0] d,
  input we,
  input wclk,
  input [8:0] a,
  output [7:0] o);
  genvar i;
  generate 
    for (i = 0; i < 8; i=i+1) begin : ramx
      ram400x1s ramx(
        .d(d[i]),
        .we(we),
        .wclk(wclk),
        .a(a),
        .o(o[i]));
    end
  endgenerate
endmodule

module ram400x7s(
  input [6:0] d,
  input we,
  input wclk,
  input [8:0] a,
  output [6:0] o);
  genvar i;
  generate 
    for (i = 0; i < 7; i=i+1) begin : ramx
      ram400x1s ramx(
        .d(d[i]),
        .we(we),
        .wclk(wclk),
        .a(a),
        .o(o[i]));
    end
  endgenerate
endmodule


