LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;
-- SRAMb Entity is a bitwise SRAM.
--    This means that it can be any number of bits in Width, with a single write enable signal.
-- Contains two SRAMb architectures
--    RSWS (Read Synchronous, Write Synchronous)  Writes on CLK, and Reads on CLK
--	  RAWS (Read ASynchronous, Write Synchronous) Writes on CLK, and Reads ASYNC

entity RegFile16_8 is 
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
end entity RegFile16_8;

architecture RTL of RegFile16_8 is 

	type ARRAY_SLV_DWIDTH is array ( natural range <> ) of std_logic_vector (15 downto 0); 
	type ARRAY_SLV_BWE is array ( natural range <> ) of std_logic_vector (1 downto 0); 
	constant InitV : ARRAY_SLV_DWIDTH(0 to 7) := (COL0, COL1, COL2, COL3, COL4, COL5, COL6, COL7);
	signal mOut : ARRAY_SLV_DWIDTH (0 to 7); 
	signal mbe : ARRAY_SLV_BWE (0 to 7); 

	component RegLine16 is 
	generic ( 	
	constant INIT_V : std_logic_vector(15 downto 0) := (others => '0') 
	); 
	port( 	
	signal clock : in std_logic; 
	signal din : in std_logic_vector(15 downto 0);
	signal wr_en : in std_logic_vector (1 downto 0); 
	signal dout : out std_logic_vector(15 downto 0)
	); 
	end component RegLine16;
	
begin 

   GEN_REG: 
   for I in 0 to 7 generate
      REGX : component RegLine16 generic map( INIT_V => InitV(I) )
			port map(
			clock => clock,
			wr_en => mbe(I),
			din => din,
			dout => mOut(I)	
			);
   end generate GEN_REG;
	
	process( wr_addr, rd_addrB, rd_addr, wr_en, mOut ) is
	begin
		mbe <= (others => (others => '0'));

		case( wr_addr ) is
		when "000" =>
			mbe(0) <= wr_en;
		when "001" =>
			mbe(1) <= wr_en;
		when "010" =>
			mbe(2) <= wr_en;
		when "011" =>
			mbe(3) <= wr_en;
		when "100" =>
			mbe(4) <= wr_en;
		when "101" =>
			mbe(5) <= wr_en;
		when "110" =>
			mbe(6) <= wr_en;
		when "111" =>
			mbe(7) <= wr_en;
		when others =>
			mbe(0) <= wr_en;
		end case;


		case( rd_addr ) is
		when "000" =>
			dout <= mOut(0);
		when "001" =>
			dout <= mOut(1);
		when "010" =>
			dout <= mOut(2);
		when "011" =>
			dout <= mOut(3);
		when "100" =>
			dout <= mOut(4);
		when "101" =>
			dout <= mOut(5);
		when "110" =>
			dout <= mOut(6);
		when "111" =>
			dout <= mOut(7);
		when others =>
			dout <= mOut(0);
		end case;

		case( rd_addrB ) is
		when "000" =>
			doutB <= mOut(0);
		when "001" =>
			doutB <= mOut(1);
		when "010" =>
			doutB <= mOut(2);
		when "011" =>
			doutB <= mOut(3);
		when "100" =>
			doutB <= mOut(4);
		when "101" =>
			doutB <= mOut(5);
		when "110" =>
			doutB <= mOut(6);
		when "111" =>
			doutB <= mOut(7);
		when others =>
			doutB <= mOut(0);
		end case;
	end process;

	
end architecture RTL;

