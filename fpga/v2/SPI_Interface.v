// SPI can be many things, so to be clear, this implementation:
//   MSB first
//   CPOL 0, leading edge when SCK rises
//   CPHA 0, sample on leading, setup on trailing

module SPI_memory(
  input clk,
  input SCK, input MOSI, output MISO, input SSEL,
  output wire [15:0] raddr,   // read address
  output reg [15:0] waddr,    // write address
  output reg [7:0] data_w,
  input [7:0] data_r,
  output reg we,
  output reg re,
  output mem_clk
);
  reg [15:0] paddr;
  reg [4:0] count;
  wire [4:0] _count = (count == 23) ? 16 : (count + 1);

  assign mem_clk = clk;

  // sync SCK to the FPGA clock using a 3-bits shift register
  reg [2:0] SCKr;  always @(posedge clk) SCKr <= {SCKr[1:0], SCK};
  wire SCK_risingedge = (SCKr[2:1]==2'b01);  // now we can detect SCK rising edges
  wire SCK_fallingedge = (SCKr[2:1]==2'b10);  // and falling edges

  // same thing for SSEL
  reg [2:0] SSELr;  always @(posedge clk) SSELr <= {SSELr[1:0], SSEL};
  wire SSEL_active = ~SSELr[1];  // SSEL is active low
  wire SSEL_startmessage = (SSELr[2:1]==2'b10);  // message starts at falling edge
  wire SSEL_endmessage = (SSELr[2:1]==2'b01);  // message stops at rising edge

// and for MOSI
  reg [1:0] MOSIr;  always @(posedge clk) MOSIr <= {MOSIr[0], MOSI};
  wire MOSI_data = MOSIr[1];

  assign raddr = (count[4] == 0) ? {paddr[14:0], MOSI} : paddr;

  always @(posedge clk)
  begin
    if (~SSEL_active) begin
      count <= 0;
      re <= 0;
      we <= 0;
    end else
      if (SCK_risingedge) begin
        if (count[4] == 0) begin
          we <= 0;
          paddr <= raddr;
          re <= (count == 15);
        end else begin
          data_w <= {data_w[6:0], MOSI_data};
          if (count == 23) begin
            we <= paddr[15];
            re <= !paddr[15];
            waddr <= paddr;
            paddr <= paddr + 1;
          end else begin
            we <= 0;
            re <= 0;
          end
        end
        count <= _count;
      end
      if (SCK_fallingedge) begin
        re <= 0;
        we <= 0;
      end
  end

  reg readbit;
  always @*
  begin
    case (count[2:0])
    3'd0: readbit <= data_r[7];
    3'd1: readbit <= data_r[6];
    3'd2: readbit <= data_r[5];
    3'd3: readbit <= data_r[4];
    3'd4: readbit <= data_r[3];
    3'd5: readbit <= data_r[2];
    3'd6: readbit <= data_r[1];
    3'd7: readbit <= data_r[0];
    endcase
  end
  assign MISO = readbit;

endmodule