library ieee;     
use ieee.std_logic_1164.all;

entity ParallelInterface is
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
	signal pwe : in std_logic; -- write enable signal
	signal poe : in std_logic -- output enable signal
	);
end entity ParallelInterface;

architecture RTL of ParallelInterface is
begin
	mem_clk <= clk;
	raddr <= paddr;
	waddr <= paddr;
	we <= pwe;
	re <= poe;

	data_w <= pdata;
	
	-- tri-state process
	tri_proc : process( poe ) is
	begin
		if( poe = '1' ) then
			pdata <= data_r;
		else
			pdata <= (others => 'Z');
		end if;
	end process tri_proc;
	

end architecture RTL;