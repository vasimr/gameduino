
module RAM_SPRIMG (
    input [7:0] dia,
    output [7:0] doa,
    input wea,
    input ena,
    input clka,
    input ssra,
    input [14:0] addra,
    input [7:0] dib,
    output [7:0] dob,
    input web,
    input enb,
    input clkb,
    input ssrb,
    input [14:0] addrb
    );

    RAMB16_S1_S1 #(
      .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram0 (
      .DIA(dia[0]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[0]),
      .SSRA(ssra),

      .DIB(dib[0]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[0]),
      .SSRB(ssrb)
      );

    RAMB16_S1_S1 #(
      .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram1 (
      .DIA(dia[1]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[1]),
      .SSRA(ssra),

      .DIB(dib[1]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[1]),
      .SSRB(ssrb)
      );

    RAMB16_S1_S1 #(
      .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram2 (
      .DIA(dia[2]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[2]),
      .SSRA(ssra),

      .DIB(dib[2]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[2]),
      .SSRB(ssrb)
      );

    RAMB16_S1_S1 #(
      .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram3 (
      .DIA(dia[3]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[3]),
      .SSRA(ssra),

      .DIB(dib[3]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[3]),
      .SSRB(ssrb)
      );

    RAMB16_S1_S1 #(
      .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram4 (
      .DIA(dia[4]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[4]),
      .SSRA(ssra),

      .DIB(dib[4]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[4]),
      .SSRB(ssrb)
      );

    RAMB16_S1_S1 #(
           .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram5 (
      .DIA(dia[5]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[5]),
      .SSRA(ssra),

      .DIB(dib[5]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[5]),
      .SSRB(ssrb)
      );

    RAMB16_S1_S1 #(
         .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram6 (
      .DIA(dia[6]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[6]),
      .SSRA(ssra),

      .DIB(dib[6]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[6]),
      .SSRB(ssrb)
      );

    RAMB16_S1_S1 #(
            .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram7 (
      .DIA(dia[7]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[7]),
      .SSRA(ssra),

      .DIB(dib[7]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[7]),
      .SSRB(ssrb)
      );

endmodule


module RAM_PICTURE (
    input [7:0] dia,
    output [7:0] doa,
    input wea,
    input ena,
    input clka,
    input ssra,
    input [12:0] addra,
    input [7:0] dib,
    output [7:0] dob,
    input web,
    input enb,
    input clkb,
    input ssrb,
    input [12:0] addrb
    );

    RAMB16_S4_S4 #(
           .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram0 (
      .DIA(dia[4*0+3:4*0]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[4*0+3:4*0]),
      .SSRA(ssra),

      .DIB(dib[4*0+3:4*0]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[4*0+3:4*0]),
      .SSRB(ssrb)
      );

    RAMB16_S4_S4 #(
          .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram1 (
      .DIA(dia[4*1+3:4*1]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[4*1+3:4*1]),
      .SSRA(ssra),

      .DIB(dib[4*1+3:4*1]),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB(dob[4*1+3:4*1]),
      .SSRB(ssrb)
      );

endmodule


module RAM_CHR (
    input [1:0] dia,
    output [1:0] doa,
    input wea,
    input ena,
    input clka,
    input ssra,
    input [14:0] addra,
    input [7:0] dib,
    output [7:0] dob,
    input web,
    input enb,
    input clkb,
    input ssrb,
    input [12:0] addrb
    );

    RAMB16_S1_S4 #(
      .INIT_00(256'h00FFFFFF0000000000FFF7100000000000300000000000000000000000000000),
.INIT_01(256'h00FFEFCF000000000070300000000000CF0E00000000000000FFFF0E00000000),
.INIT_02(256'h0F00000000000000FF00000000000000F1000000000000000800000000000000),
.INIT_03(256'hF3F00000000000008F0E08000000000000000000000000FF00000000F1701000),
.INIT_04(256'h0000EFEFCF8F00000000F07030000000CF030000000000000F0C000000000000),
.INIT_05(256'h0000000000EFCF0F00000000007E3E0C000000FFEFC300000000F03000000000),
.INIT_06(256'h00000000008F0F0C0000000000FFF7F300FFFFCF00000000007E1C0800000000),
.INIT_07(256'h00000000FFEF8F0E00000000FFF7F3F00070301000000000000F000000000000),
.INIT_08(256'h006363F763F763630000000000C6C6C600810081818181810000000000000000),
.INIT_09(256'h00000000000381C000B366D683C6C6830060660381C066060081E7B0E386F3C0),
.INIT_0A(256'h00008181E7818100000081E7C3E78100000381C0C0C0810300C08103030381C0),
.INIT_0B(256'h0000060381C06000008181000000000000000000E70000000381810000000000),
.INIT_0C(256'h00C36660C16066C300E70381C06066C300E781818181838100C36667E7E666C3),
.INIT_0D(256'h0003030381C060E700C36666C70603C100C3666060C706E700C0C0E7C6C3C1C0),
.INIT_0E(256'h038181008181000000818100818100000083C060E36666C300C36666C36666C3),
.INIT_0F(256'h0081008181C066C3000381C060C08103000000E700E7000000C08103060381C0),
.INIT_10(256'h00C36606060666C300C76666C76666C700666666E76666C300C306E6A6E666C3),
.INIT_11(256'h00C36666E60666C300060606C70606E700E70606C70606E70087C6666666C687),
.INIT_12(256'h0066C6870787C6660083C6C0C0C0C0E300E78181818181E700666666E7666666),
.INIT_13(256'h00C36666666666C3006666E6E7676666003636B6B6F7773600E7060606060606),
.INIT_14(256'h00C36660C30666C3006666C6C76666C70063C6A6666666C300060606C76666C7),
.INIT_15(256'h003677F7B6B636360081C3666666666600C366666666666600818181818181E7),
.INIT_16(256'h00C70606060606C700E7060381C060E700818181C3666666006666C381C36666),
.INIT_17(256'hFF00000000000000000000002466C38100E36060606060E3000060C081030600),
.INIT_18(256'h00C3660666C3000000C7666666C7060600E366E360C3000000E70303C70363C1),
.INIT_19(256'hC360E36666E3000000030303C70303C100C306E766C3000000E3666666E36060),
.INIT_1A(256'h0066C687C6660606078181818183008100C38181818300810066666666C70606),
.INIT_1B(256'h00C3666666C300000066666666C700000036B6B6F763000000C3818181818183),
.INIT_1C(256'h00C760C306E300000006060667C600007060E36666E300000606C76666C70000),
.INIT_1D(256'h0063F7B6B63600000081C3666666000000E366666666000000C1030303C70303),
.INIT_1E(256'h00C08181078181C000E70381C0E70000C360E366666600000066C381C3660000),
.INIT_1F(256'hFFFFFFFFFFFFFFFF000000000064B61300038181E08181030081818100818181),
.INIT_20(256'h0F0E0800000000000000000000000C00000000000000FFFF00000000F1F03000),
.INIT_21(256'h000000000000FFEF0000000000703010000000000008000000000000000000CF),
.INIT_22(256'hF0F0F070707070700C080808000000007030303030101000000000000E0C0800),
.INIT_23(256'h10303030707070700C0C0C0C0E0E0E0E70F0F0F0F0F0F0F00E0E0E0E0E0C0C0C),
.INIT_24(256'h000000000000000E8F0000000000000000000000000000100000000000080808),
.INIT_25(256'h0F8F8F8F8FCFFFFFF9FFFFFFFFFFFFFF00000030000000000000000000000800),
.INIT_26(256'h08080000000070F0FFFFFFEFCFCFEFFF9FFFFFFFFFFFFFFFF0F1F1F1F1F3FFFF),
.INIT_27(256'hFFFFFFF7F3F3F7FF1010000000000E0F00000000000010F0000000000000080F),
.INIT_28(256'hCFCFCF8F0F080000F3F3F3F1F01000000000000000000808080CEFEFFFFFFFFF),
.INIT_29(256'h0F0F0F0F0F0000001C0C0ECFEFFFFFFF1030F7F7FFFFFFFF0000000000001010),
.INIT_2A(256'hF7F7FFFFFFFFFFFFFFFFEF0F0C0808081E1C0030B1FFFFFF7838000C8DFFFFFF),
.INIT_2B(256'hFFFFF7F030101010EFEFFFFFFFFFFFFF0F8F8FCFCFEFEFEFF0F1F1F3F3F7F7F7),
.INIT_2C(256'hCFEFFFFFFFFFFFFF0F0F0F0F0F0F0F0E0F0F0F0F0F0F0F0FFFFFFFFFFFFFFC3C),
.INIT_2D(256'h00000010101010008F8F8F0F0F0F0E0EF1F1F1F0F0F070700000000808080800),
.INIT_2E(256'hFFFF8D0C00B878F0000083838300000000000F0F0F0F0F0FF3F7FFFFFFFFFFFF),
.INIT_2F(256'hFFFFFFFFFFFFFFF3FFFFFFFFFFF97030FFFFFFFFFFFFFFEFFFFFB130001C1E0E),
.INIT_30(256'h0000000000000000FFFFFFFFFFFFFFF7FFFFFFFFFF9F0E0CFFFFFFFFFFFFFFCF),
.INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000)
    ) ram0 (
      .DIA(dia[0]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[0]),
      .SSRA(ssra),

      .DIB({dib[6+0],dib[4+0],dib[2+0],dib[0+0]}),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB({dob[6+0],dob[4+0],dob[2+0],dob[0+0]}),
      .SSRB(ssrb)
      );

    RAMB16_S1_S4 #(
      .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_08(256'h006363F763F763630000000000C6C6C600810081818181810000000000000000),
.INIT_09(256'h00000000000381C000B366D683C6C6830060660381C066060081E7B0E386F3C0),
.INIT_0A(256'h00008181E7818100000081E7C3E78100000381C0C0C0810300C08103030381C0),
.INIT_0B(256'h0000060381C06000008181000000000000000000E70000000381810000000000),
.INIT_0C(256'h00C36660C16066C300E70381C06066C300E781818181838100C36667E7E666C3),
.INIT_0D(256'h0003030381C060E700C36666C70603C100C3666060C706E700C0C0E7C6C3C1C0),
.INIT_0E(256'h038181008181000000818100818100000083C060E36666C300C36666C36666C3),
.INIT_0F(256'h0081008181C066C3000381C060C08103000000E700E7000000C08103060381C0),
.INIT_10(256'h00C36606060666C300C76666C76666C700666666E76666C300C306E6A6E666C3),
.INIT_11(256'h00C36666E60666C300060606C70606E700E70606C70606E70087C6666666C687),
.INIT_12(256'h0066C6870787C6660083C6C0C0C0C0E300E78181818181E700666666E7666666),
.INIT_13(256'h00C36666666666C3006666E6E7676666003636B6B6F7773600E7060606060606),
.INIT_14(256'h00C36660C30666C3006666C6C76666C70063C6A6666666C300060606C76666C7),
.INIT_15(256'h003677F7B6B636360081C3666666666600C366666666666600818181818181E7),
.INIT_16(256'h00C70606060606C700E7060381C060E700818181C3666666006666C381C36666),
.INIT_17(256'hFF00000000000000000000002466C38100E36060606060E3000060C081030600),
.INIT_18(256'h00C3660666C3000000C7666666C7060600E366E360C3000000E70303C70363C1),
.INIT_19(256'hC360E36666E3000000030303C70303C100C306E766C3000000E3666666E36060),
.INIT_1A(256'h0066C687C6660606078181818183008100C38181818300810066666666C70606),
.INIT_1B(256'h00C3666666C300000066666666C700000036B6B6F763000000C3818181818183),
.INIT_1C(256'h00C760C306E300000006060667C600007060E36666E300000606C76666C70000),
.INIT_1D(256'h0063F7B6B63600000081C3666666000000E366666666000000C1030303C70303),
.INIT_1E(256'h00C08181078181C000E70381C0E70000C360E366666600000066C381C3660000),
.INIT_1F(256'hFFFFFFFFFFFFFFFF000000000064B61300038181E08181030081818100818181),
.INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_25(256'h7030303030000000000000000000000000000000000000000000000000000000),
.INIT_26(256'hF3F3F7FFFF8F0F06000000001010000000000000000000000E0C0C0C0C000000),
.INIT_27(256'h0000000008080000CFCFEFFFFFF1F060FFFFFFFFFFEF0F0EFFFFFFFFFFF7F070),
.INIT_28(256'h1010103070F0F7FF0808080C0E0FEFFFFFFFFFFFF7F7F3F3F310000000000000),
.INIT_29(256'h0000000000000000C7E1F07030000000CF08000000000000FFFFFFFFEFEFCFCF),
.INIT_2A(256'h000000000000000000000010F0F3F3F3F0F1EFEF8F0000000F8FF7F7F1000000),
.INIT_2B(256'h000000080FCFCFCF000000000000000070303010100000000E0C0C0808000000),
.INIT_2C(256'h1000000000000000F0F0F0F0F0F0F0F000000000000000000000000000000387),
.INIT_2D(256'hF3FFEFCFCFCFCFEF303030707070F0F00C0C0C0E0E0E0F0FCFFFF7F3F3F3F3F7),
.INIT_2E(256'h0000F1F7F78F0F0F000000000000000000000000000000000800000000000000),
.INIT_2F(256'h0000000000000000000000000000068F000000000000000000008FEFEFF1F0F0),
.INIT_30(256'h0000000000000000000000000000000000000000000060F10000000000000000),
.INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
.INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000)
    ) ram1 (
      .DIA(dia[1]),
      .WEA(wea),
      .ENA(ena),
      .CLKA(clka),
      .ADDRA(addra),
      .DOA(doa[1]),
      .SSRA(ssra),

      .DIB({dib[6+1],dib[4+1],dib[2+1],dib[0+1]}),
      .WEB(web),
      .ENB(enb),
      .CLKB(clkb),
      .ADDRB(addrb),
      .DOB({dob[6+1],dob[4+1],dob[2+1],dob[0+1]}),
      .SSRB(ssrb)
      );

endmodule


module RAM_PAL (
    input [7:0] DIA,
    output [7:0] DOA,
    input WEA,
    input ENA,
    input CLKA,
    input SSRA,
    input [10:0] ADDRA,
    input [15:0] DIB,
    output [15:0] DOB,
    input WEB,
    input ENB,
    input CLKB,
    input SSRB,
    input [9:0] ADDRB
    );

    RAMB16_S9_S18 #(
      .INIT_00(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_01(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_02(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_03(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_04(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_05(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_06(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_07(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_08(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_09(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_0A(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_0B(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_0C(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_0D(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_0E(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_0F(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_10(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_11(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_12(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_13(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_14(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_15(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_16(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_17(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_18(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_19(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_1A(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_1B(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_1C(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_1D(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_1E(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_1F(256'h7FFF0000000080007FFF0000000080007FFF0000000080007FFF000000008000),.INIT_20(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_21(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_22(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_23(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_24(256'h0000000000008000000000000000800000000000000080000000000000008000),.INIT_25(256'h00002175800010AA00000000800010AA00000000000080000000000000008000),.INIT_26(256'h00002175800010AA00002175800010AA00000000800010AA00002175800010AA),.INIT_27(256'h00002175800010AA00002175800010AA00002175800010AA00002175800010AA),.INIT_28(256'h00002175800010AA00002175800010AA00002175800010AA00002175800010AA),.INIT_29(256'h000000002CA5800020842CA58000184200002175800010AA00002175800010AA),.INIT_2A(256'h00000000217510AA00002175800010AA20842CA58000184220842CA580001842),.INIT_2B(256'h00002175800010AA00000000217510AA00002175800010AA00002175800010AA),.INIT_2C(256'h00002175800010AA00002CA580001842000000002CA5800020842CA580001842),.INIT_2D(256'h00002175800010AA00002175800010AA00002175800010AA00002175800010AA),.INIT_2E(256'h20842CA580001842000000002CA58000000000002CA5800000002175800010AA),.INIT_2F(256'h00000000800010AA00002175800010AA00000000800010AA20842CA580001842),.INIT_30(256'h000000000000000000000000800010AA00002175800010AA00000000800010AA),.INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),.INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000)
    ) ram (
      .DIPA(0),
      .DIA(DIA),
      .WEA(WEA),
      .ENA(ENA),
      .CLKA(CLKA),
      .ADDRA(ADDRA),
      .DOA(DOA),
      .SSRA(SSRA),

      .DIPB(0),
      .DIB(DIB),
      .WEB(WEB),
      .ENB(ENB),
      .CLKB(CLKB),
      .ADDRB(ADDRB),
      .DOB(DOB),
      .SSRB(SSRB)
      );

endmodule


module RAM_SPRVAL (
    input [7:0] DIA,
    output [7:0] DOA,
    input WEA,
    input ENA,
    input CLKA,
    input SSRA,
    input [10:0] ADDRA,
    input [31:0] DIB,
    output [31:0] DOB,
    input WEB,
    input ENB,
    input CLKB,
    input SSRB,
    input [8:0] ADDRB
    );

    RAMB16_S9_S36 #(
           .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram (
      .DIPA(0),
      .DIA(DIA),
      .WEA(WEA),
      .ENA(ENA),
      .CLKA(CLKA),
      .ADDRA(ADDRA),
      .DOA(DOA),
      .SSRA(SSRA),

      .DIPB(0),
      .DIB(DIB),
      .WEB(WEB),
      .ENB(ENB),
      .CLKB(CLKB),
      .ADDRB(ADDRB),
      .DOB(DOB),
      .SSRB(SSRB)
      );

endmodule


module RAM_SPRPAL (
    input [7:0] DIA,
    output [7:0] DOA,
    input WEA,
    input ENA,
    input CLKA,
    input SSRA,
    input [10:0] ADDRA,
    input [15:0] DIB,
    output [15:0] DOB,
    input WEB,
    input ENB,
    input CLKB,
    input SSRB,
    input [9:0] ADDRB
    );

    RAMB16_S9_S18 #(
           .INIT_00(0),
.INIT_01(0),
.INIT_02(0),
.INIT_03(0),
.INIT_04(0),
.INIT_05(0),
.INIT_06(0),
.INIT_07(0),
.INIT_08(0),
.INIT_09(0),
.INIT_0A(0),
.INIT_0B(0),
.INIT_0C(0),
.INIT_0D(0),
.INIT_0E(0),
.INIT_0F(0),
.INIT_10(0),
.INIT_11(0),
.INIT_12(0),
.INIT_13(0),
.INIT_14(0),
.INIT_15(0),
.INIT_16(0),
.INIT_17(0),
.INIT_18(0),
.INIT_19(0),
.INIT_1A(0),
.INIT_1B(0),
.INIT_1C(0),
.INIT_1D(0),
.INIT_1E(0),
.INIT_1F(0),
.INIT_20(0),
.INIT_21(0),
.INIT_22(0),
.INIT_23(0),
.INIT_24(0),
.INIT_25(0),
.INIT_26(0),
.INIT_27(0),
.INIT_28(0),
.INIT_29(0),
.INIT_2A(0),
.INIT_2B(0),
.INIT_2C(0),
.INIT_2D(0),
.INIT_2E(0),
.INIT_2F(0),
.INIT_30(0),
.INIT_31(0),
.INIT_32(0),
.INIT_33(0),
.INIT_34(0),
.INIT_35(0),
.INIT_36(0),
.INIT_37(0),
.INIT_38(0),
.INIT_39(0),
.INIT_3A(0),
.INIT_3B(0),
.INIT_3C(0),
.INIT_3D(0),
.INIT_3E(0),
.INIT_3F(0)
    ) ram (
      .DIPA(0),
      .DIA(DIA),
      .WEA(WEA),
      .ENA(ENA),
      .CLKA(CLKA),
      .ADDRA(ADDRA),
      .DOA(DOA),
      .SSRA(SSRA),

      .DIPB(0),
      .DIB(DIB),
      .WEB(WEB),
      .ENB(ENB),
      .CLKB(CLKB),
      .ADDRB(ADDRB),
      .DOB(DOB),
      .SSRB(SSRB)
      );

endmodule


module RAM_CODEL (
  input wclk,
  input [7:0] ad,
  input wea,
  input [6:0] a,
  input [6:0] b,
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

      mRAM128X1D
      #( .INIT(0) )
      ram0(
        .D(ad[0]),
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
        .SPO(_ao[0]),
        .DPO(_bo[0]));

      mRAM128X1D
      #( .INIT(0) )
      ram1(
        .D(ad[1]),
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
        .SPO(_ao[1]),
        .DPO(_bo[1]));

      mRAM128X1D
      #( .INIT(0) )
      ram2(
        .D(ad[2]),
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
        .SPO(_ao[2]),
        .DPO(_bo[2]));

      mRAM128X1D
      #( .INIT(0) )
      ram3(
        .D(ad[3]),
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
        .SPO(_ao[3]),
        .DPO(_bo[3]));

      mRAM128X1D
      #( .INIT(0) )
      ram4(
        .D(ad[4]),
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
        .SPO(_ao[4]),
        .DPO(_bo[4]));

      mRAM128X1D
      #( .INIT(0) )
      ram5(
        .D(ad[5]),
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
        .SPO(_ao[5]),
        .DPO(_bo[5]));

      mRAM128X1D
      #( .INIT(0) )
      ram6(
        .D(ad[6]),
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
        .SPO(_ao[6]),
        .DPO(_bo[6]));

      mRAM128X1D
      #( .INIT(0) )
      ram7(
        .D(ad[7]),
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
        .SPO(_ao[7]),
        .DPO(_bo[7]));

endmodule


module RAM_CODEH (
  input wclk,
  input [7:0] ad,
  input wea,
  input [6:0] a,
  input [6:0] b,
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

      mRAM128X1D
           #( .INIT(0) )
      ram0(
        .D(ad[0]),
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
        .SPO(_ao[0]),
        .DPO(_bo[0]));

      mRAM128X1D
           #( .INIT(0) )
      ram1(
        .D(ad[1]),
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
        .SPO(_ao[1]),
        .DPO(_bo[1]));

      mRAM128X1D
           #( .INIT(0) )
      ram2(
        .D(ad[2]),
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
        .SPO(_ao[2]),
        .DPO(_bo[2]));

      mRAM128X1D
           #( .INIT(0) )
      ram3(
        .D(ad[3]),
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
        .SPO(_ao[3]),
        .DPO(_bo[3]));

      mRAM128X1D
           #( .INIT(0) )
      ram4(
        .D(ad[4]),
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
        .SPO(_ao[4]),
        .DPO(_bo[4]));

      mRAM128X1D
            #( .INIT(0) )
      ram5(
        .D(ad[5]),
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
        .SPO(_ao[5]),
        .DPO(_bo[5]));

      mRAM128X1D
          #( .INIT(0) )
      ram6(
        .D(ad[6]),
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
        .SPO(_ao[6]),
        .DPO(_bo[6]));

      mRAM128X1D
            #( .INIT(0) )
      ram7(
        .D(ad[7]),
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
        .SPO(_ao[7]),
        .DPO(_bo[7]));

endmodule

