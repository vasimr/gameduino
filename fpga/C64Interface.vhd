library ieee;     
use ieee.std_logic_1164.all;

-- Implementation of a C64 expansion port interface

entity C64Interface is
	port(
	-- internal interface signals
  	signal clk : in std_logic;
  	signal raddr : out std_logic_vector(15 downto 0);   -- read address
  	signal waddr : out std_logic_vector(15 downto 0);   -- write address
 	signal data_w: out std_logic_vector(7 downto 0);
 	signal data_r:  in std_logic_vector(7 downto 0);
 	signal we : out std_logic;
  	signal re : out std_logic;
  	signal mem_clk : out std_logic;
	-- IO signals
	signal paddr : in std_logic_vector(15 downto 0); -- input address
	signal pdata  : inout std_logic_vector(7 downto 0); -- data bus
	signal pRnW : in std_logic; -- Read / nWrite signal
	signal pBA : in std_logic; -- Bus available signal
	signal pnROMH : in std_logic; -- nROMH signal
	signal pnROML : in std_logic; -- nROML signal
	signal pnGAME : in std_logic; -- nGAME signal
	signal pnEXROM : in std_logic; -- nEXROM signal
	signal pnIO1 : in std_logic; -- nIO1 signal
	signal pnIO2 : in std_logic; -- nIO2 signal
	signal pnRST : in std_logic; -- nReset signal
	signal pDOTCLK : in std_logic; -- DOT CLK input
	signal pPHI2 : in std_logic;	-- Phase 2 system clock 
	signal pnDMA : out std_logic; -- nDMA signal
	signal pnIRQ : out std_logic -- nIRQ signal
	);
end entity C64Interface;

architecture RTL of C64Interface is
	signal ren : std_logic := '0';
	signal wen : std_logic := '0';
	signal oe : std_logic := '0';
begin
	-- set the DMA and IRQ signals to high to disable
	pnDMA <= '1';
	pnIRQ <= '1';

	-- From what I understand, we want the following truthtable for Wen and Ren are 1
	--    PAddress      ROMH      ROML    EXROM    GAME    Internal Address
	--   $8000-$9FFF	0	1	1   OR	1 	$0000-$1FFF
	--   $A000-$BFFF	1	0	1	0	$2000-$3FFF	
	--   $E000-$FFFF	1	0	0	1	$2000-$3FFF

	sel_proc : process( pAddr, pnROMH, pnROML, pnEXROM, pnGAME, pBA, pRnW, ren) is
		variable r1 : std_logic := '0';
		variable r2 : std_logic := '0';
		variable r3 : std_logic := '0';
		variable lowSel : std_logic := '0';
		variable hiSel : std_logic := '0';
	begin
		--  $8000-$9FFF
		if( pAddr(15 downto 13) = "100" ) then
			r1 := '1';
		else
			r1 := '0';
		end if;
		-- $A000-$BFFF
		if( pAddr(15 downto 13) = "101" ) then
			r2 := '1';
		else
			r2 := '0';
		end if;
		-- $E000-$FFFF
		if( pAddr(15 downto 13) = "111" ) then
			r3 := '1';
		else
			r3 := '0';
		end if;
		
		lowSel := (NOT pnROML) AND (pnROMH) AND ( (NOT pnEXROM) OR (NOT pnGAME) ) AND r1;
		hiSel := (pnROML) AND (NOT pnROMH) AND ( ( (NOT pnEXROM) AND pnGAME AND r2) OR (pnEXROM AND (NOT pnGAME) AND r3) ); 
		ren <= (lowSel OR hiSel) AND pRnW;
		oe <= (NOT pBA) AND ren;
		wen <= (lowSel OR hiSel) AND (NOT pRnW);
	end process sel_proc;

	mem_clk <= clk;
	raddr <= "00" & paddr(13 downto 0);
	waddr <= "00" & paddr(13 downto 0);
	we <= wen;
	re <= ren;

	data_w <= pdata;
	
	-- tri-state process
	tri_proc : process( oe, data_r ) is
	begin
		if( oe = '1' ) then
			pdata <= data_r;
		else
			pdata <= (others => 'Z');
		end if;
	end process tri_proc;
	

end architecture RTL;