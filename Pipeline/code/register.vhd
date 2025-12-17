library ieee;
use ieee.std_logic_1164.all;

entity hazard_unit is
	port(
		-- Inputs from Decode Stage (Current Instruction)
		RsD : in std_logic_vector(4 downto 0);
		RtD : in std_logic_vector(4 downto 0);

		-- Inputs from Execute Stage (Previous Instruction)
		RtE       : in std_logic_vector(4 downto 0);
		MemToRegE : in std_logic; -- '1' indicates LW instruction

		-- Outputs to Control Pipeline
		StallF : out std_logic; -- Freeze PC
		StallD : out std_logic; -- Freeze IF/ID Register
		FlushE : out std_logic  -- Insert Bubble in ID/EX
	);
end hazard_unit;

architecture behavior of hazard_unit is
	signal lwstall : std_logic;
begin

	-- [Load-Use Hazard Detection]
	-- If the instruction in Execute is LW (MemToRegE = 1)
	-- AND its destination (RtE) matches one of the sources in Decode (RsD or RtD)
	process(RsD, RtD, RtE, MemToRegE)
	begin
		if (MemToRegE = '1') and ((RtE = RsD) or (RtE = RtD)) then
			lwstall <= '1';
		else
			lwstall <= '0';
		end if;
	end process;

	-- Assign outputs
	StallF <= lwstall;
	StallD <= lwstall;
	FlushE <= lwstall;

end behavior;