// gameduino lfsr module

module lfsre(
    input clk,
    output reg [16:0] lfsr);
wire d0;

xnor(d0,lfsr[16],lfsr[13]);

always @(posedge clk) begin
    lfsr <= {lfsr[15:0],d0};
end
endmodule 