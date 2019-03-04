LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;
-- SRAM Entity is a bytewise SRAM.
--    This means that it must be Byte Aligned in width, with each byte containing a Byte write enable signal.

-- Contains two SRAM architectures
--    RSWS (Read Synchronous, Write Synchronous)  Writes on CLK, and Reads on CLK
--	  RAWS (Read ASynchronous, Write Synchronous) Writes on CLK, and Reads ASYNC

entity sram is 
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
end entity sram;

architecture rsws of sram is

component sramb is 
generic ( 	
	constant SIZE : integer := 1024; 
	constant AWIDTH : integer := 10; 
	constant DWIDTH : integer := 32 
); 
port( 	
	signal clock : in std_logic; 
    signal rd_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
    signal wr_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
    signal wr_en : in std_logic; 
    signal din : in std_logic_vector ((DWIDTH - 1) downto 0);
    signal rd_addrB : in std_logic_vector ((AWIDTH - 1) downto 0); 
    signal doutB : out std_logic_vector ((DWIDTH - 1) downto 0);
    signal dout : out std_logic_vector ((DWIDTH - 1) downto 0)
); 
end component sramb;

  function log2( input : integer )
        return integer is 
        variable log : integer;
        variable tmp : integer;
    begin
        tmp := input;
        log := 0;
        while tmp > 1 loop
            tmp := tmp / 2;
            log := log + 1;
        end loop;
        if ( (input /= 0) and (input /= (to_unsigned(1, 32) SLL log)) ) then
            log := log + 1;
        end if;
        return log;
    end log2;


	constant NUM_BYTES : integer := DWIDTH / 8; 
	constant SELECT_BITS : integer := log2(NUM_BYTES); 
	
begin 



	sram_block : for i in 0 to (NUM_BYTES - 1) GENERATE
	
			sramb_instance : entity work.sramb(rsws) generic map( 
							SIZE => SIZE, 
							AWIDTH => AWIDTH, 
							DWIDTH => 8 
						) 
						port map( 
							clock => clock, 
							din => din(((8 * (i + 1)) - 1) downto (8 * i)), 
							rd_addr => rd_addr((AWIDTH - 1) downto 0), 
							wr_addr => wr_addr((AWIDTH - 1) downto 0), 
							rd_addrB => rd_addrB((AWIDTH - 1) downto 0),
							wr_en => wr_en(i), 
							dout => dout(((8 * (i + 1)) - 1) downto (8 * i)),
							doutB => doutB(((8 * (i + 1)) - 1) downto (8 * i)) 
						); 
						
	end generate sram_block;

end architecture rsws;

architecture raws of sram is

component sramb is 
generic ( 	
	constant SIZE : integer := 1024; 
	constant AWIDTH : integer := 10; 
	constant DWIDTH : integer := 32 
); 
port( 	
	signal clock : in std_logic; 
    signal rd_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
    signal wr_addr : in std_logic_vector ((AWIDTH - 1) downto 0); 
    signal wr_en : in std_logic; 
    signal din : in std_logic_vector ((DWIDTH - 1) downto 0);
    signal rd_addrB : in std_logic_vector ((AWIDTH - 1) downto 0); 
    signal doutB : out std_logic_vector ((DWIDTH - 1) downto 0);
    signal dout : out std_logic_vector ((DWIDTH - 1) downto 0)
); 
end component sramb;

  function log2( input : integer )
        return integer is 
        variable log : integer;
        variable tmp : integer;
    begin
        tmp := input;
        log := 0;
        while tmp > 1 loop
            tmp := tmp / 2;
            log := log + 1;
        end loop;
        if ( (input /= 0) and (input /= (to_unsigned(1, 32) SLL log)) ) then
            log := log + 1;
        end if;
        return log;
    end log2;


	constant NUM_BYTES : integer := DWIDTH / 8; 
	constant SELECT_BITS : integer := log2(NUM_BYTES); 
	
begin 



	sram_block : for i in 0 to (NUM_BYTES - 1) GENERATE
	
			sramb_instance : entity work.sramb(raws) generic map( 
							SIZE => SIZE, 
							AWIDTH => AWIDTH, 
							DWIDTH => 8 
						) 
						port map( 
							clock => clock, 
							din => din(((8 * (i + 1)) - 1) downto (8 * i)), 
							rd_addr => rd_addr((AWIDTH - 1) downto 0), 
							wr_addr => wr_addr((AWIDTH - 1) downto 0), 
							rd_addrB => rd_addrB((AWIDTH - 1) downto 0),
							wr_en => wr_en(i), 
							dout => dout(((8 * (i + 1)) - 1) downto (8 * i)),
							doutB => doutB(((8 * (i + 1)) - 1) downto (8 * i)) 
						); 
						
	end generate sram_block;

end architecture raws;
