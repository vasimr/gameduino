library ieee;     
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
-- Implementation of a C64 expansion port interface

entity sid8580_State is
	port(
	-- internal interface signals
  	signal clk : in std_logic;
	signal ce_1m : in std_logic;
	signal f_st_out : in std_logic_vector( 7 downto 0);
	signal f_p_t_out : in std_logic_vector( 7 downto 0);
	signal f_ps_out : in std_logic_vector( 7 downto 0);
	signal f_pst_out : in std_logic_vector( 7 downto 0);
	signal sawtooth0 : in std_logic_vector( 11 downto 0);
	signal sawtooth1 : in std_logic_vector( 11 downto 0);
	signal sawtooth2 : in std_logic_vector( 11 downto 0);
	signal triangle0 : in std_logic_vector( 11 downto 0);
	signal triangle1 : in std_logic_vector( 11 downto 0);
	signal triangle2 : in std_logic_vector( 11 downto 0);
	signal f_triangle : out std_logic_vector( 11 downto 0);
	signal f_sawtooth : out std_logic_vector( 11 downto 0);
	signal st_out0  : out std_logic_vector( 7 downto 0);
	signal st_out1  : out std_logic_vector( 7 downto 0);
	signal st_out2  : out std_logic_vector( 7 downto 0);
	signal p_t_out0 : out std_logic_vector( 7 downto 0);
	signal p_t_out1 : out std_logic_vector( 7 downto 0);
	signal p_t_out2 : out std_logic_vector( 7 downto 0);
	signal ps_out0 : out std_logic_vector( 7 downto 0);
	signal ps_out1 : out std_logic_vector( 7 downto 0);
	signal ps_out2 : out std_logic_vector( 7 downto 0);
	signal pst_out0 : out std_logic_vector( 7 downto 0);
	signal pst_out1 : out std_logic_vector( 7 downto 0);
	signal pst_out2 : out std_logic_vector( 7 downto 0)
	);
end entity sid8580_State;

architecture RTL of sid8580_State is
	signal state : std_logic_vector(3 downto 0);
	signal f_sawtooth_C, f_sawtoothT : std_logic_vector( 11 downto 0);
	signal f_triangle_C, f_triangleT : std_logic_vector( 11 downto 0);
	signal st_out0_C, st_out0T : std_logic_vector( 7 downto 0);
	signal p_t_out0_C, p_t_out0T : std_logic_vector( 7 downto 0);
	signal ps_out0_C, ps_out0T : std_logic_vector( 7 downto 0);
	signal pst_out0_C, pst_out0T : std_logic_vector( 7 downto 0);

	signal st_out1_C, st_out1T : std_logic_vector( 7 downto 0);
	signal p_t_out1_C, p_t_out1T : std_logic_vector( 7 downto 0);
	signal ps_out1_C, ps_out1T : std_logic_vector( 7 downto 0);
	signal pst_out1_C, pst_out1T : std_logic_vector( 7 downto 0);

	signal st_out2_C, st_out2T : std_logic_vector( 7 downto 0);
	signal p_t_out2_C, p_t_out2T : std_logic_vector( 7 downto 0);
	signal ps_out2_C, ps_out2T : std_logic_vector( 7 downto 0);
	signal pst_out2_C, pst_out2T : std_logic_vector( 7 downto 0);
begin


	clk_proc : process(clk) is
	begin
		if(rising_edge(clk)) then
			if( state /= "0000" ) then
				if( ce_1m = '1' ) then
					state <= "0000";
				else
					state <= std_logic_vector( unsigned(state) + 1);
				end if;
				f_sawtoothT <= f_sawtooth_C;
				f_triangleT <= f_triangle_C;
				
				st_out0T <= st_out0_C;
				p_t_out0T <= p_t_out0_C;
				ps_out0T <= ps_out0_C;
				pst_out0T <= pst_out0_C;

				st_out1T <= st_out1_C;
				p_t_out1T <= p_t_out1_C;
				ps_out1T <= ps_out1_C;
				pst_out1T <= pst_out1_C;

				st_out2T <= st_out2_C;
				p_t_out2T <= p_t_out2_C;
				ps_out2T <= ps_out2_C;
				pst_out2T <= pst_out2_C;

			end if;
		end if;
	end process clk_proc;

	f_sawtooth <= f_sawtoothT;
	f_triangle <= f_triangleT;

	st_out0 <= st_out0T;
	p_t_out0 <= p_t_out0T;
	ps_out0 <= ps_out0T;
	pst_out0 <= pst_out0T;

	st_out1 <= st_out1T;
	p_t_out1 <= p_t_out1T;
	ps_out1 <= ps_out1T;
	pst_out1 <= pst_out1T;

	st_out2 <= st_out2T;
	p_t_out2 <= p_t_out2T;
	ps_out2 <= ps_out2T;
	pst_out2 <= pst_out2T;

	state_proc : process(state) is
	begin

		f_sawtooth_C <= f_sawtoothT;
		f_triangle_C <= f_triangleT;

		st_out0_C <= st_out0T;
		p_t_out0_C <= p_t_out0T;
		ps_out0_C <= ps_out0T;
		pst_out0_C <= pst_out0T;

		st_out1_C <= st_out1T;
		p_t_out1_C <= p_t_out1T;
		ps_out1_C <= ps_out1T;
		pst_out1_C <= pst_out1T;

		st_out2_C <= st_out2T;
		p_t_out2_C <= p_t_out2T;
		ps_out2_C <= ps_out2T;
		pst_out2_C <= pst_out2T;

		case( state ) is
		when X"1" =>
			f_sawtooth <= sawtooth0;
			f_triangle <= triangle0;
		when X"5" =>
			f_sawtooth <= sawtooth1;
			f_triangle <= triangle1;
		when X"9" =>
			f_sawtooth <= sawtooth2;
			f_triangle <= triangle2;
		when X"3" =>
			st_out0_C <= f_st_out;
			p_t_out0_C <= f_p_t_out;
			ps_out0_C <= f_ps_out;
			pst_out0_C <= f_pst_out;
		when X"7" =>
			st_out1_C <= f_st_out;
			p_t_out1_C <= f_p_t_out;
			ps_out1_C <= f_ps_out;
			pst_out1_C <= f_pst_out;
		when X"B" =>
			st_out2_C <= f_st_out;
			p_t_out2_C <= f_p_t_out;
			ps_out2_C <= f_ps_out;
			pst_out2_C <= f_pst_out;
		when others =>
		end case;

	end process state_proc;

--wire [3:0] state;
--always @(posedge clk) 
--
--	
--	if(~state) begin 
--		if(ce_1m)
--			state <= 3'b000;
--		else
--			state <= state + 1;
--	end
--	case(state)
--		1,5,9: begin
--			f_sawtooth <= sawtooth[state[3:2]];
--			f_triangle <= triangle[state[3:2]];
--		end
--	endcase
--	case(state)
--		3,7,11: begin
--			_st_out[state[3:2]] <= f__st_out;
--			p_t_out[state[3:2]] <= f_p_t_out;
--			ps__out[state[3:2]] <= f_ps__out;
--			pst_out[state[3:2]] <= f_pst_out;
--		end
--	endcase
--end


end architecture RTL;