LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

entity RegLine16 is 
generic ( 	
	constant INIT_V : std_logic_vector(15 downto 0) := (others => '0') 
); 
port( 	
	signal clock : in std_logic; 
	signal din : in std_logic_vector(15 downto 0);
	signal wr_en : in std_logic_vector (1 downto 0); 
	signal dout : out std_logic_vector(15 downto 0)
); 
end entity RegLine16;

architecture RTL of RegLine16 is 

	signal regV, regV_C : std_logic_vector(15 downto 0) := INIT_V;

begin 

	-- clock process
	clk_proc : process(clock) is
	begin
		if( rising_edge(clock) ) then
			regV <= regV_C;
		end if;
	end process clk_proc;


	write_proc : process( din, wr_en, regV ) is
	begin
		for I in 0 to 1 loop
			if( wr_en(i) = '1' ) then
				regV_C((i+1)*8-1 downto i*8) <=  din((i+1)*8-1 downto i*8);
			else
				regV_C((i+1)*8-1 downto i*8) <=  regV((i+1)*8-1 downto i*8);
			end if;
		end loop;
	end process write_proc;
	
	
	-- connect the output
	dout <= regV;
	
end architecture RTL;

