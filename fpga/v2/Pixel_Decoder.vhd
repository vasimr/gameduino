library ieee;     
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


entity PixelDecoder is
	port(
	-- internal interface signals
  	signal PAL_Color : in std_logic_vector(15 downto 0);  -- input color data
	signal CHR_X     : in std_logic_vector(1 downto 0);   -- character x-position
	signal color_select : out std_logic_vector(3 downto 0) -- output color selection
	);
end entity PixelDecoder;

architecture RTL of PixelDecoder is

begin
	
	process(CHR_X, PAL_COLOR) is
	begin
		case(CHR_X) is
		when "10" => -- 2
			color_select <= PAL_Color(15 downto 12);
		when "11" => -- 3
			color_select <= PAL_Color(11 downto 8);
		when "00" => -- 0
			color_select <= PAL_Color(7 downto 4);
		when "01" => -- 1
			color_select <= PAL_Color(3 downto 0);
		when others =>
			color_select <= PAL_Color(7 downto 4);
		end case;
	end process;


end architecture RTL;