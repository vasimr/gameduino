module sramb16DErsws
(
	DIA, DIB, ADDRA, ADDRB, WEA, WEB, CLKA, CLKB, DOA, DOB, BEA 
);
	parameter ADDR_WIDTH = 6;
	parameter DATA_WIDTH = 8;
	
	input [(DATA_WIDTH-1):0] DIA;
	input [(DATA_WIDTH-1):0] DIB;
	input [(ADDR_WIDTH-1):0] ADDRA;
	input [(ADDR_WIDTH-1):0] ADDRB;
	input [1:0] BEA;
	input WEA;
	input WEB;
	input CLKA;
	input CLKB;
	output reg [(DATA_WIDTH-1):0] DOA;
	output reg [(DATA_WIDTH-1):0] DOB;


	// Declare the RAM variable
	logic [1:0][(DATA_WIDTH/2-1):0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge CLKA)
	begin // Port A
		if (WEA)
		begin
			if( BEA[0] ) ram[ADDRA][0] <= DIA[0];
			if( BEA[1] ) ram[ADDRA][1] <= DIA[1];
			DOA <= DIA;
		end
		else
			DOA <= {ram[ADDRA][1],ram[ADDRA][0]};
	end

	always @ (posedge CLKB)
	begin // Port b
		//if (WEB)
		//begin
		//	ram[ADDRB][0] <= DIB[0];
		//	ram[ADDRB][1] <= DIB[1];
		//	DOB <= DIB;
		//end
		//else
			DOB <= {ram[ADDRB][1],ram[ADDRB][0]};
	end

endmodule //srambD

module sramb32DErsws
(
	DIA, DIB, ADDRA, ADDRB, WEA, WEB, CLKA, CLKB, DOA, DOB, BEA 
);
	parameter ADDR_WIDTH = 6;
	parameter DATA_WIDTH = 8;
	
	input [(DATA_WIDTH-1):0] DIA;
	input [(DATA_WIDTH-1):0] DIB;
	input [(ADDR_WIDTH-1):0] ADDRA;
	input [(ADDR_WIDTH-1):0] ADDRB;
	input [3:0] BEA;
	input WEA;
	input WEB;
	input CLKA;
	input CLKB;
	output reg [(DATA_WIDTH-1):0] DOA;
	output reg [(DATA_WIDTH-1):0] DOB;


	// Declare the RAM variable
	logic [3:0][(DATA_WIDTH/4-1):0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge CLKA)
	begin // Port A
		if (WEA)
		begin
			if( BEA[0] ) ram[ADDRA][0] <= DIA[0];
			if( BEA[1] ) ram[ADDRA][1] <= DIA[1];
			if( BEA[1] ) ram[ADDRA][2] <= DIA[1];
			if( BEA[1] ) ram[ADDRA][3] <= DIA[1];
			DOA <= DIA;
		end
		else
			DOA <= {ram[ADDRA][3],ram[ADDRA][2],ram[ADDRA][1],ram[ADDRA][0]};
	end

	always @ (posedge CLKB)
	begin // Port b
		//if (WEB)
		//begin
		//	ram[ADDRB][0] <= DIB[0];
		//	ram[ADDRB][1] <= DIB[1];
		//	DOB <= DIB;
		//end
		//else
			DOB <= {ram[ADDRB][3],ram[ADDRB][2],ram[ADDRB][1],ram[ADDRB][0]};
	end

endmodule //srambD

module sramb16DEraws
(
	DIA, DIB, ADDRA, ADDRB, WEA, WEB, CLKA, CLKB, DOA, DOB, BEA
);
	parameter ADDR_WIDTH = 6;
	parameter DATA_WIDTH = 8;
	
	input [(DATA_WIDTH-1):0] DIA;
	input [(DATA_WIDTH-1):0] DIB;
	input [(ADDR_WIDTH-1):0] ADDRA;
	input [(ADDR_WIDTH-1):0] ADDRB;
	input [1:0] BEA;
	input WEA;
	input WEB;
	input CLKA;
	input CLKB;
	output reg [(DATA_WIDTH-1):0] DOA;
	output reg [(DATA_WIDTH-1):0] DOB;


	// Declare the RAM variable
	logic [1:0][(DATA_WIDTH/2-1):0] ram[2**ADDR_WIDTH-1:0];

	always @ (posedge CLKA)
	begin // Port A
		if (WEA)
		begin
			if( BEA[0] ) ram[ADDRA][0] <= DIA[0];
			if( BEA[1] ) ram[ADDRA][1] <= DIA[1];
		end		
	end

	always @ (ram[ADDRA], ADDRA)
	begin
		DOA <= {ram[ADDRA][1],ram[ADDRA][0]};
	end

	always @ (posedge CLKB)
	begin // Port b
		//if (WEB)
		//begin
		//	ram[ADDRB][0] <= DIB[0];
		//	ram[ADDRB][1] <= DIB[1];
		//end
			
	end

	always @ (ram[ADDRB], ADDRB)
	begin
		DOB <= {ram[ADDRB][1],ram[ADDRB][0]};
	end

endmodule //srambD

