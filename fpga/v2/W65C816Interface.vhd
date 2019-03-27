library ieee;     
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
-- Implementation of a W65C816 MOS 6502 CPU interface
--   Current assumptions: 
--	- External bus clock is 1/4 of the internal GD clock (i.e. 12.5 MHz)
--	- The chip select signal is asserted (CS = 1) at the start of a transaction, and is held until completion
--	- After chip select asserted, the interface will assert a clock stretch signal to prevent the CPU from transitioning early
--	- To prevent glitching, the bus, address, and rw signals will be latched on the second clock of the inteface (@50MHz) after the CS is asserted
--	- The address, write data, and commands will be sent to the intenral bus on the 2nd cycle.
--	- The read data will be latched on the 2nd cycle, and be made availble to the external bus on the 3rd cycle
--	- the clock stretch signal will be de-asserted during the 4rd cycle

-- Timing:
--	GD_CLK ____|---|___|---|___|---|___|---|___|---|_
--	CPUCLK __|-------------|___________|-------------
--	pCS    __|-------------------------|_____________
--	SEQ    <000><001   ><010   ><011   ><100    >
--	CSTRCH __|-------------------------|_____________
--	BUSDA  xxxxxxxxxxxxxxxxxxxxx<RDATA >xxxxxxxxxxxxx
--	ADDRL  xxxxx<ADDR                           >
--	WDATA  xxxxx<WDATA                          >
--      RDATA  xxxxxxxxxxxxx<RDATA                  >
--	WrSig  _____________|-----|______________________
--	RdSig  _____________|-----|______________________

entity W65C816Interface is
	port(
	-- internal interface signals
  	signal clk : in std_logic;
	signal rst : in std_logic;
  	signal raddr : out std_logic_vector(15 downto 0);   -- read address
  	signal waddr : out std_logic_vector(15 downto 0);   -- write address
 	signal data_w: out std_logic_vector(7 downto 0);
 	signal data_r:  in std_logic_vector(7 downto 0);
 	signal we : out std_logic;
  	signal re : out std_logic;
  	signal mem_clk : out std_logic;
	-- IO signals
	signal paddr : in std_logic_vector(14 downto 0); -- input address
	signal pdata  : inout std_logic_vector(7 downto 0); -- data bus
	signal pRnW : in std_logic; -- Read / nWrite signal
	signal pCS : in std_logic; -- Chip-select signal
	signal pCStretch : out std_logic -- Clock stretch signal
	);
end entity W65C816Interface;

architecture RTL of W65C816Interface is

	signal sequenceCt, sequenceCt_C : std_logic_vector(2 downto 0) := (others => '0');
	signal AddrL, AddrL_C : std_logic_vector(14 downto 0) := (others => '0');
	signal wrDataL, wrDataL_C : std_logic_vector(7 downto 0) := (others => '0');
	signal rdDataL, rdDataL_C : std_logic_vector(7 downto 0) := (others => '0');
	signal rwSig, rwSig_C : std_logic_vector(1 downto 0) := (others => '0'); -- [wr | rd]

	signal OEsig : std_logic := '0';
begin
	
	-- link the clock
	mem_clk <= clk;
	
	-- clock process
	clk_proc : process( clk, rst ) is
	begin
		if( rst = '1' ) then
			sequenceCt <= (others => '0');
			rwSig <= (others => '0');
			wrDataL <= (others => '0');
			rdDataL <= (others => '0');
			AddrL <= (others => '0');
		elsif( rising_edge(clk) ) then
			sequenceCt <= sequenceCt_C;
			rwSig <= rwSig_C;
			wrDataL <= wrDataL_C;
			rdDataL <= rdDataL_C;
			AddrL <= AddrL_C;
		end if;
	end process clk_proc;

	-- sequencer process
	seq_proc : process( sequenceCt, pCS ) is
	begin
		if( pCS = '1' ) then
			sequenceCt_C <= std_logic_vector( unsigned(sequenceCt) + 1 );
		else
			sequenceCt_C <= (others => '0');
		end if;

		-- hold process
		case( sequenceCt ) is
		when "000" =>
			pCStretch <= pCS;
		when "001" | "010" |"011" =>
			pCStretch <= '1';
		when "100" | "101" | "110" | "111" =>
			pCStretch <= '0';
		when others =>
			pCStretch <= '0';
		end case;
	end process seq_proc;

	-- interface latch process
	ltch_proc : process( sequenceCt, pRnW, pdata, paddr, pCS ) is
	begin
		
		-- defaults (hold the latch)
		rwSig_C <= rwSig;
		wrDataL_C <= wrDataL;
		rdDataL_C <= rdDataL;
		AddrL_C <= AddrL;

		case( sequenceCt ) is
		when "001" =>
			if( pCS = '1' ) then
				rwSig_C <= NOT pRnW & pRnW;
				AddrL_C <= paddr;
				wrDataL_C <= pdata;
			end if;
		when "010" =>
			rwSig_C <= (others => '0');
			rdDataL_C <= data_r;
		when others =>
		end case;
	end process ltch_proc;

	-- output enable signal
	OEsig <= pRnW AND pCS;
	
	-- high impedance process
	z_proc : process( OEsig, rdDataL ) is
	begin
		if( OEsig = '1' ) then
			pdata <=  rdDataL;
		else
			pdata <= (others => 'Z');
		end if;
	end process;

	-- connect the GD interface
	data_w <= wrDataL;
	raddr <= '0' & AddrL;
	waddr <= '0' & AddrL;
	we <= rwSig(1);
	re <= rwSig(0);
	

end architecture RTL;