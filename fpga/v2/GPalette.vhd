library ieee;     
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


--entity GPalette is
--	port(
--	-- internal interface signals
--  	signal clk 	: in std_logic;
--	-- memory interface signals
--	signal mem_wr 	: in std_logic;
--     	signal mem_data_wr : in std_logic_vector(7 downto 0);
--     	signal mem_w_addr  : in std_logic_vector(4 downto 0);
--     	signal mem_r_addr  : in std_logic_vector(4 downto 0);
--	signal mem_data_rd : out std_logic_vector(7 downto 0);
--	-- color mode info
--	signal glyph_MSB   : in std_logic; -- the glyph ID's MSB (for color mode 1)
--	signal color_mode  : in std_logic; -- the color mode, 0 for global 3, 1 for global 2
--	signal color_select: in std_logic_vector(3 downto 0); -- value from RAM_COL
--	signal pixel_color : in std_logic_vector(1 downto 0);        -- value from RAM_CHR
--        -- color inputs
--	signal g0_color : in std_logic_vector(15 downto 0); -- global palette color 0
--	signal g1_color : in std_logic_vector(15 downto 0); -- global palette color 0
--	signal g2_color : in std_logic_vector(15 downto 0); -- global palette color 0
--	signal g3_color : in std_logic_vector(15 downto 0); -- global palette color 0
--	-- final color output
--	signal color_matte : out std_logic_vector(15 downto 0)
--	);
--end entity GPalette;

--architecture RTL of GPalette is
--	component sram is 
--	generic ( 
--	constant SIZE : integer := 1024; 
--	constant DWIDTH : integer := 32; 
--	constant AWIDTH : integer := 10 
--	); 
--	port ( 
--	signal clock : in std_logic; 
--	signal rd_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
--	signal wr_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
--	signal rd_addrB : in std_logic_vector ((AWIDTH - 1) downto 0); 
--	signal wr_en : in std_logic_vector (((DWIDTH / 8) - 1) downto 0); 
--	signal din : in std_logic_vector ((DWIDTH - 1) downto 0);
--	signal doutB : out std_logic_vector ((DWIDTH - 1) downto 0);
--	signal dout : out std_logic_vector ((DWIDTH - 1) downto 0)
--	); 
--	end component sram;


--	signal tReadA : std_logic_vector(15 downto 0);
--	signal tReadB : std_logic_vector(15 downto 0);
--	signal tWrite : std_logic_vector(15 downto 0);
--	signal bweA : std_logic_vector(1 downto 0);
--	signal bweB : std_logic_vector(1 downto 0);
--	signal colorRdA : std_logic_vector(2 downto 0);
--	signal colorRdB : std_logic_vector(2 downto 0);
--	signal regColorA : std_logic_vector(15 downto 0);
--	signal regColorB : std_logic_vector(15 downto 0);
--	signal palA : std_logic_vector(15 downto 0);
--	signal palB : std_logic_vector(15 downto 0);
--    signal color_T : std_logic_vector(15 downto 0);

--begin


--	-- setup the byte write enable
--	bweA <= ((mem_wr AND mem_w_addr(0)) & (mem_wr AND (NOT mem_w_addr(0)))) AND ( (NOT mem_w_addr(4)) & (NOT mem_w_addr(4)));
--	bweB <= ((mem_wr AND mem_w_addr(0)) & (mem_wr AND (NOT mem_w_addr(0)))) AND (mem_w_addr(4) & mem_w_addr(4));

--	tWrite <= mem_data_wr & mem_data_wr;
--	-- instantiate the register block
--	regFileA: entity work.sram(raws) generic map( SIZE => 8, DWIDTH => 16, AWIDTH => 3 )
--			port map(
--				clock => clk,
--				rd_addr => mem_r_addr(3 downto 1),
--				wr_addr => mem_w_addr(3 downto 1),
--				rd_addrB => colorRdA,
--				wr_en => bweA,
--				din => tWrite,
--				doutB => regColorA,
--				dout => tReadA
--			);

--	regFileB: entity work.sram(raws) generic map( SIZE => 8, DWIDTH => 16, AWIDTH => 3 )
--			port map(
--				clock => clk,
--				rd_addr => mem_r_addr(3 downto 1),
--				wr_addr => mem_w_addr(3 downto 1),
--				rd_addrB => colorRdB,
--				wr_en => bweB,
--				din => tWrite,
--				doutB => regColorB,
--				dout => tReadB
--			);

--	-- the memory mux selection process
--	mem_mux : process( mem_r_addr ) is
--		variable tRead : std_logic_vector(15 downto 0);
--	begin
--		if( mem_r_addr(4) = '1' ) then
--			tRead := tReadB;
--		else
--			tRead := tReadA;
--		end if;

--		if( mem_r_addr(0) = '1' ) then
--			mem_data_rd <= tRead(15 downto 8);
--		else
--			mem_data_rd <= tRead(7 downto 0);
--		end if;
--	end process mem_mux;


--	-- the register file address process
--	reg_addr_proc : process(glyph_MSB, color_mode, color_select, pixel_color, regColorA, regColorB,
--				g0_color, g1_color, g2_color, g3_color, palA, palB )
--	begin
--		-- default cause to prevent a latch (just in case)
--		colorRdA <= (others => '0');
--		colorRdB <= (others => '0');
--		color_T <= g0_color;
--		palA <= regColorA;
--		palB <= regColorB;
--		if( color_mode = '1' ) then
--			if( glyph_MSB = '0' ) then -- first 128 charactes
--			-- G0, G1, {C0, C1, C2, C3}, {C8, C9, C10, C11}
--				colorRdA <= "0" & color_select(3 downto 2);
--				colorRdB <= "0" & color_select(1 downto 0);

--				case(pixel_color) is
--				when "00" =>
--					color_T <= g0_color;
--				when "01" =>
--					color_T <= g1_color;
--				when "10" =>
--					color_T <= palA;
--				when "11" => 
--					color_T <= palB;
--				when others =>
--					color_T <= g0_color;
--				end case;

--			else -- second 128 characters
--			-- G2, G3, {C4, C5, C6, C7}, {C12, C13, C14, C15}
--				colorRdA <= "1" & color_select(3 downto 2);
--				colorRdB <= "1" & color_select(1 downto 0);

--				case(pixel_color) is
--				when "00" =>
--					color_T <= g2_color;
--				when "01" =>
--					color_T <= g3_color;
--				when "10" =>
--					color_T <= palA;
--				when "11" => 
--					color_T <= palB;
--				when others =>
--					color_T <= g2_color;
--				end case;
--			end if;

--			palA <= regColorA;

--		else
--			-- same mode for all
--			-- G0, G1, G2, {C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15}
--			colorRdA <= color_select(2 downto 0);
--			colorRdB <= color_select(2 downto 0);

--			if( color_select(3) = '0') then
--				palA <= regColorA; 
--			else
--				palA <= regColorB; 
--			end if;

--				case(pixel_color) is
--				when "00" =>
--					color_T <= g0_color;
--				when "01" =>
--					color_T <= g1_color;
--				when "10" =>
--					color_T <= g2_color;
--				when "11" => 
--					color_T <= palA;
--				when others =>
--					color_T <= g0_color;
--				end case;
--		end if;
--	end process reg_addr_proc;

--   color_matte <= color_T;
--end architecture RTL;

library ieee;     
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


entity GPalette_Old is
	port(
	-- internal interface signals
  	signal clk 	: in std_logic;
	-- memory interface signals
	signal mem_wr 	: in std_logic;
     	signal mem_data_wr : in std_logic_vector(7 downto 0);
     	signal mem_w_addr  : in std_logic_vector(4 downto 0);
     	signal mem_r_addr  : in std_logic_vector(4 downto 0);
	signal mem_data_rd : out std_logic_vector(7 downto 0);
	-- color mode info
	signal glyph_MSB   : in std_logic; -- the glyph ID's MSB (for color mode 1)
	signal color_mode  : in std_logic; -- the color mode, 0 for global 3, 1 for global 2
	signal color_select: in std_logic_vector(3 downto 0); -- value from RAM_COL
	signal pixel_color : in std_logic_vector(1 downto 0);        -- value from RAM_CHR
        -- color inputs
	signal g0_color : in std_logic_vector(15 downto 0); -- global palette color 0
	signal g1_color : in std_logic_vector(15 downto 0); -- global palette color 0
	signal g2_color : in std_logic_vector(15 downto 0); -- global palette color 0
	signal g3_color : in std_logic_vector(15 downto 0); -- global palette color 0
	-- final color output
	signal color_matte : out std_logic_vector(15 downto 0)
	);
end entity GPalette_Old;

architecture RTL_Old of GPalette_Old is
	
	component RegFile16_8 is 
	generic(
	constant COL0 : std_logic_vector(15 downto 0) := (others => '0');
	constant COL1 : std_logic_vector(15 downto 0) := (others => '0');
	constant COL2 : std_logic_vector(15 downto 0) := (others => '0');
	constant COL3 : std_logic_vector(15 downto 0) := (others => '0');
	constant COL4 : std_logic_vector(15 downto 0) := (others => '0');
	constant COL5 : std_logic_vector(15 downto 0) := (others => '0');
	constant COL6 : std_logic_vector(15 downto 0) := (others => '0');
	constant COL7 : std_logic_vector(15 downto 0) := (others => '0')
	);
	port ( 
	signal clock : in std_logic; 
	signal rd_addr : in std_logic_vector (2 downto 0); 
	signal wr_addr : in std_logic_vector (2 downto 0); 
	signal rd_addrB : in std_logic_vector (2 downto 0); 
	signal wr_en : in std_logic_vector (1 downto 0); 
	signal din : in std_logic_vector (15 downto 0);
	signal doutB : out std_logic_vector (15 downto 0);
	signal dout : out std_logic_vector (15 downto 0)
	); 
	end component RegFile16_8;


	signal tReadA : std_logic_vector(15 downto 0);
	signal tReadB : std_logic_vector(15 downto 0);
	signal tWrite : std_logic_vector(15 downto 0);
	signal bweA : std_logic_vector(1 downto 0);
	signal bweB : std_logic_vector(1 downto 0);
	signal colorRdA : std_logic_vector(2 downto 0);
	signal colorRdB : std_logic_vector(2 downto 0);
	signal regColorA : std_logic_vector(15 downto 0);
	signal regColorB : std_logic_vector(15 downto 0);
	signal palA : std_logic_vector(15 downto 0);
	signal palB : std_logic_vector(15 downto 0);
    	signal color_T : std_logic_vector(15 downto 0);

begin


	-- setup the byte write enable
	bweA <= ((mem_wr AND mem_w_addr(0)) & (mem_wr AND (NOT mem_w_addr(0)))) AND ( (NOT mem_w_addr(4)) & (NOT mem_w_addr(4)));
	bweB <= ((mem_wr AND mem_w_addr(0)) & (mem_wr AND (NOT mem_w_addr(0)))) AND (mem_w_addr(4) & mem_w_addr(4));

	tWrite <= mem_data_wr & mem_data_wr;
	-- instantiate the register block
	regFileA: component RegFile16_8
			generic map(
				COL0 => X"7FFF", -- C64 color 1
				COL1 => X"0000", -- C64 color 0
				COL2 => X"30C5", -- C64 color 2
				COL3 => X"3675", -- C64 color 3
				COL4 => X"34F0", -- C64 color 4
				COL5 => X"2A28", -- C64 color 5
				COL6 => X"188E", -- C64 color 6
				COL7 => X"5B0D"  -- C64 color 7
			)
			port map(
				clock => clk,
				rd_addr => mem_r_addr(3 downto 1),
				wr_addr => mem_w_addr(3 downto 1),
				rd_addrB => colorRdA,
				wr_en => bweA,
				din => tWrite,
				doutB => regColorA,
				dout => tReadA
			);

	regFileB: component RegFile16_8
			generic map(
				COL0 => X"3525", -- C64 color 8
				COL1 => X"20C0", -- C64 color 9
				COL2 => X"4D8A", -- C64 color A
				COL3 => X"2108", -- C64 color B
				COL4 => X"35AD", -- C64 color C
				COL5 => X"4B30", -- C64 color D
				COL6 => X"3576", -- C64 color E
				COL7 => X"4A52"  -- C64 color F
			)
			port map(
				clock => clk,
				rd_addr => mem_r_addr(3 downto 1),
				wr_addr => mem_w_addr(3 downto 1),
				rd_addrB => colorRdB,
				wr_en => bweB,
				din => tWrite,
				doutB => regColorB,
				dout => tReadB
			);

	-- the memory mux selection process
	mem_mux : process( mem_r_addr ) is
		variable tRead : std_logic_vector(15 downto 0);
	begin
		if( mem_r_addr(4) = '1' ) then
			tRead := tReadB;
		else
			tRead := tReadA;
		end if;

		if( mem_r_addr(0) = '1' ) then
			mem_data_rd <= tRead(15 downto 8);
		else
			mem_data_rd <= tRead(7 downto 0);
		end if;
	end process mem_mux;


	-- the register file address process
	reg_addr_proc : process(glyph_MSB, color_mode, color_select, pixel_color, regColorA, regColorB,
				g0_color, g1_color, g2_color, g3_color, palA, palB )
	begin
		-- default cause to prevent a latch (just in case)
		colorRdA <= (others => '0');
		colorRdB <= (others => '0');
		color_T <= g0_color;
		palA <= regColorA;
		palB <= regColorB;
		if( color_mode = '1' ) then
			if( glyph_MSB = '0' ) then -- first 128 charactes
			-- G0, G1, {C0, C1, C2, C3}, {C8, C9, C10, C11}
				colorRdA <= "0" & color_select(3 downto 2);
				colorRdB <= "0" & color_select(1 downto 0);

				case(pixel_color) is
				when "00" =>
					color_T <= g0_color;
				when "01" =>
					color_T <= g1_color;
				when "10" =>
					color_T <= palA;
				when "11" => 
					color_T <= palB;
				when others =>
					color_T <= g0_color;
				end case;

			else -- second 128 characters
			-- G2, G3, {C4, C5, C6, C7}, {C12, C13, C14, C15}
				colorRdA <= "1" & color_select(3 downto 2);
				colorRdB <= "1" & color_select(1 downto 0);

				case(pixel_color) is
				when "00" =>
					color_T <= g2_color;
				when "01" =>
					color_T <= g3_color;
				when "10" =>
					color_T <= palA;
				when "11" => 
					color_T <= palB;
				when others =>
					color_T <= g2_color;
				end case;
			end if;

			palA <= regColorA;

		else
			-- same mode for all
			-- G0, G1, G2, {C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15}
			colorRdA <= color_select(2 downto 0);
			colorRdB <= color_select(2 downto 0);

			if( color_select(3) = '0') then
				palA <= regColorA; 
			else
				palA <= regColorB; 
			end if;

				case(pixel_color) is
				when "00" =>
					color_T <= g0_color;
				when "01" =>
					color_T <= g1_color;
				when "10" =>
					color_T <= g2_color;
				when "11" => 
					color_T <= palA;
				when others =>
					color_T <= g0_color;
				end case;
		end if;
	end process reg_addr_proc;

   color_matte <= color_T;
end architecture RTL_Old;