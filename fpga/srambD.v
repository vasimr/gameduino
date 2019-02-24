module srambDrsws
(
	DIA, DIB, ADDRA, ADDRB, WEA, WEB, CLKA, CLKB, DOA, DOB 
);
	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 6;

	input [(DATA_WIDTH-1):0] DIA;
	input [(DATA_WIDTH-1):0] DIB;
	input [(ADDR_WIDTH-1):0] ADDRA;
	input [(ADDR_WIDTH-1):0] ADDRB;
	input WEA;
	input WEB;
	input CLKA;
	input CLKB;
	output reg [(DATA_WIDTH-1):0] DOA;
	output reg [(DATA_WIDTH-1):0] DOB;


	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge CLKA)
	begin // Port A
		if (WEA)
		begin
			ram[ADDRA] <= DIA;
			DOA <= DIA;
		end
		else
			DOA <= ram[ADDRA];
	end

	always @ (posedge CLKB)
	begin // Port b
		if (WEB)
		begin
			ram[ADDRB] <= DIB;
			DOB <= DIB;
		end
		else
			DOB <= ram[ADDRB];
	end

endmodule //srambD

module srambDraws
(
	DIA, DIB, ADDRA, ADDRB, WEA, WEB, CLKA, CLKB, DOA, DOB 
);
	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 6;

	input [(DATA_WIDTH-1):0] DIA;
	input [(DATA_WIDTH-1):0] DIB;
	input [(ADDR_WIDTH-1):0] ADDRA;
	input [(ADDR_WIDTH-1):0] ADDRB;
	input WEA;
	input WEB;
	input CLKA;
	input CLKB;
	output reg [(DATA_WIDTH-1):0] DOA;
	output reg [(DATA_WIDTH-1):0] DOB;


	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge CLKA)
	begin // Port A
		if (WEA)
		begin
			ram[ADDRA] <= DIA;
		end		
	end

	always @ (ram[ADDRA], ADDRA)
	begin
		DOA <= ram[ADDRA];
	end

	always @ (posedge CLKB)
	begin // Port b
		if (WEB)
		begin
			ram[ADDRB] <= DIB;
		end
			
	end

	always @ (ram[ADDRB], ADDRB)
	begin
		DOB <= ram[ADDRB];
	end

endmodule //srambD

module srambDS (
	clk,
	wr_addrA,
	wr_enA,
	wr_dataA,

	rd_addrB,
	rd_en,
	rd_dataB
	);
	parameter DATA_WIDTHA = 1;
	parameter ADDR_WIDTHA = 14;
	parameter DATA_WIDTHB = 16;
	parameter ADDR_WIDTHB = 9;

 	input clk;
	input [ADDR_WIDTHA-1:0] wr_addrA;
	input wr_enA;
	input [DATA_WIDTHA-1:0] wr_dataA;

	input [ADDR_WIDTHB-1:0] rd_addrB;
	input rd_en;
	output reg [DATA_WIDTHB:0] rd_dataB;

	// local variables
	reg mem [16384-1:0];
	reg [15:0] rd_data_pre;
	integer i,j;

	always @(posedge clk)
		if (wr_enA)
			mem[wr_addrA[13:0]] <= wr_dataA;

	always @(posedge clk)
		if (rd_en) begin
			for (i=0; i<16; i = i + 1)
				rd_data_pre[i] <= mem[{rd_addrB,i[3:0]}];
			end

	always @(rd_data_pre)
		rd_dataB <= rd_data_pre;

 
/*
	initial begin
		for (j=0; j<16384; j = j + 1)
			mem[j] = 1'b0;
	end
*/

endmodule //srambDS