library ieee; 
--use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity RF is generic(W : natural := 32); 
	port(
		A1	: in std_logic_vector(4 downto 0);
		A2	: in std_logic_vector(4 downto 0); 
		A3	: in std_logic_vector(4 downto 0); 
		WD3	: in std_logic_vector(W-1 downto 0); 
		clk	: in std_logic;
		We3	: in std_logic; 

		RD1	: out std_logic_vector(W-1 downto 0); 
		RD2	: out std_logic_vector(W-1 downto 0);
		reset : in std_logic
	);

	type RegisterFile is array(W-1 downto 0) of std_logic_vector(W-1 downto 0);

	signal RegFile: RegisterFile;

end RF;

architecture arc of RF is begin
	

	process(A1, A2)
	begin 

		-- In RD1 we place the content of A1, same with RD2 and A2
-- By lab definition, the first position must always be 000...

		if (conv_integer(A1) = 0) then
			RD1 <= conv_std_logic_vector(0, W); -- 000..
		else 
			RD1 <= RegFile(conv_integer(A1));
		end if;
		
		if (conv_integer(A2) = 0) then
			RD2 <= conv_std_logic_vector(0, W); -- 000..
		else 
			RD2 <= RegFile(conv_integer(A2));
		end if;

	end process;

	process(clk, We3, A3, WD3)
	begin 
		if clk'EVENT and clk = '1' then
			if reset = '1' then
				RegFile(0) <= "00000000000000000000000000000100";
				RegFile(1) <= "00000000000000000000000000000101";
				RegFile(2) <= "00000000000000000000000000000111";
				RegFile(3) <= "00000000000000000000000000001000";

			end if;
		end if;

		-- WRITE
		-- O conteudo de WD3 escrevemos em A3, se estivermos com We3 (Enable) e rising clock
		if clk'EVENT and clk = '1' and We3 = '1' then
			RegFile(conv_integer(A3)) <= WD3;
		end if;
	end process;

end;
