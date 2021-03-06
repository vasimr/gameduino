LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;
-- SRAMb Entity is a bitwise SRAM.
--    This means that it can be any number of bits in Width, with a single write enable signal.
-- Contains two SRAMb architectures
--    RSWS (Read Synchronous, Write Synchronous)  Writes on CLK, and Reads on CLK
--	  RAWS (Read ASynchronous, Write Synchronous) Writes on CLK, and Reads ASYNC

entity sramb is 
generic ( 	
	constant SIZE : integer := 1024; 
	constant AWIDTH : integer := 10; 
	constant DWIDTH : integer := 32 
); 
port( 	
	signal clock : in std_logic; 
	signal rd_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
	signal wr_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
	signal rd_addrB : in std_logic_vector ((AWIDTH - 1) downto 0); 
	signal wr_en : in std_logic; 
	signal din : in std_logic_vector ((DWIDTH - 1) downto 0);
	signal doutB : out std_logic_vector ((DWIDTH - 1) downto 0);
	signal dout : out std_logic_vector ((DWIDTH - 1) downto 0)
); 
end entity sramb;

architecture rsws of sramb is 

	type ARRAY_SLV_DWIDTH is array ( natural range <> ) of std_logic_vector ((DWIDTH - 1) downto 0); 
	signal mem : ARRAY_SLV_DWIDTH (0 to (SIZE - 1)); 
	signal read_addr : std_logic_vector ((AWIDTH - 1) downto 0) := std_logic_vector(resize(to_unsigned(0, 2), AWIDTH));

begin 

	sramb_write_process : process (clock) 
	begin 
	
		if ( rising_edge(clock) ) then 
		
			dout <= std_logic_vector(to_01(unsigned( mem(to_integer(to_01(unsigned(rd_addr)))))));
			doutB <= std_logic_vector(to_01(unsigned( mem(to_integer(to_01(unsigned(rd_addrB)))))));
			if ( wr_en = '1' ) then
				mem(to_integer(to_01(unsigned(wr_addr)))) <= std_logic_vector(to_01(unsigned(din)));
			end if; 
			
			
		end if; 
		
	end process sramb_write_process;
	
	
end architecture rsws;

architecture raws of sramb is 

	type ARRAY_SLV_DWIDTH is array ( natural range <> ) of std_logic_vector ((DWIDTH - 1) downto 0); 
	signal mem : ARRAY_SLV_DWIDTH (0 to (SIZE - 1)); 
	signal read_addr : std_logic_vector ((AWIDTH - 1) downto 0) := std_logic_vector(resize(to_unsigned(0, 2), AWIDTH));

begin 

	sramb_write_process : process (clock) 
	begin 
	
		if ( rising_edge(clock) ) then 
		
			if ( wr_en = '1' ) then
				mem(to_integer(to_01(unsigned(wr_addr)))) <= std_logic_vector(to_01(unsigned(din)));
			end if; 
			

			
		end if; 
		
	end process sramb_write_process;

	doutB <= std_logic_vector(to_01(unsigned( mem(to_integer(to_01(unsigned(rd_addrB)))))));
	dout <= std_logic_vector(to_01(unsigned( mem(to_integer(to_01(unsigned(rd_addr)))))));
	
end architecture raws;
