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
		when "00" =>
			color_select <= PAL_Color(15 downto 12);
		when "01" =>
			color_select <= PAL_Color(11 downto 8);
		when "10" =>
			color_select <= PAL_Color(7 downto 4);
		when others =>
			color_select <= PAL_Color(3 downto 0);
		end case;
	end process;


end architecture RTL;