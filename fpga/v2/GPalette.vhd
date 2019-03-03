library ieee;     
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


entity GPalette is
	port(
	-- internal interface signals
  	signal clk 	: in std_logic;
	signal mem_wr 	: in std_logic;
	-- memory interface signals
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
end entity GPalette;

architecture RTL of GPalette is
	component sram is 
	generic ( 
	constant SIZE : integer := 1024; 
	constant DWIDTH : integer := 32; 
	constant AWIDTH : integer := 10 
	); 
	port ( 
	signal clock : in std_logic; 
	signal rd_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
	signal wr_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
	signal rd_addrB : in std_logic_vector ((AWIDTH - 1) downto 0); 
	signal wr_en : in std_logic_vector (((DWIDTH / 8) - 1) downto 0); 
	signal din : in std_logic_vector ((DWIDTH - 1) downto 0);
	signal doutB : out std_logic_vector ((DWIDTH - 1) downto 0);
	signal dout : out std_logic_vector ((DWIDTH - 1) downto 0)
	); 
	end component sram;

	signal tRead : std_logic_vector(15 downto 0);
	signal tWrite : std_logic_vector(15 downto 0);
	signal bwe : std_logic_vector(1 downto 0);
	signal colorRd : std_logic_vector(3 downto 0);
	signal regColor : std_logic_vector(15 downto 0);

begin

	-- setup the byte write enable
	bwe <= (mem_wr AND mem_w_addr(0)) & (mem_wr AND (NOT mem_w_addr(0)));
	
	tWrite <= mem_data_wr & mem_data_wr;
	-- instantiate the register block
	regFile: entity work.sram(raws) generic map( SIZE => 16, DWIDTH => 16, AWIDTH => 3 )
			port map(
				clock => clk,
				rd_addr => mem_r_addr(4 downto 1),
				wr_addr => mem_w_addr(4 downto 1),
				rd_addrB => colorRd,
				wr_en => bwe,
				din => tWrite,
				doutB => regColor,
				dout => tRead
			);

	-- the memory mux selection process
	mem_mux : process( mem_r_addr ) is
	begin
		if( mem_r_addr(0) = '1' ) then
			mem_data_rd <= tRead(15 downto 8);
		else
			mem_data_rd <= tRead(7 downto 0);
		end if;
	end process mem_mux;


	-- the register file address process
	reg_addr_proc : process(glyph_MSB, color_mode, color_select, pixel_color)
	begin
		
	end process reg_addr_proc;

end architecture RTL;