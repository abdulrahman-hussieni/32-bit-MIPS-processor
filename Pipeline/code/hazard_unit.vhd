library ieee;
use ieee.std_logic_1164.all;

entity hazard_unit is
    port(
        -- Inputs from Decode Stage (Instruction currently being decoded)
        RsD : in std_logic_vector(4 downto 0);
        RtD : in std_logic_vector(4 downto 0);

        -- Inputs from Execute Stage (Previous Instruction)
        RtE       : in std_logic_vector(4 downto 0); -- Target Register of Load
        MemToRegE : in std_logic;                    -- Check if instruction is LW

        -- Outputs to Control Pipeline
        StallF : out std_logic; -- Freeze PC
        StallD : out std_logic; -- Freeze IF/ID Register
        FlushE : out std_logic  -- Insert NOP in Execute (Clear Control Signals)
    );
end hazard_unit;

architecture behaviors of hazard_unit is
    signal lwstall : std_logic;
begin

    -- [Load-Use Hazard Detection Logic]
    process(RsD, RtD, RtE, MemToRegE)
    begin
        if (MemToRegE = '1') and ((RtE = RsD) or (RtE = RtD)) then
            lwstall <= '1';
        else
            lwstall <= '0';
        end if;
    end process;

    -- Outputs
    StallF <= lwstall; 
    StallD <= lwstall;
    FlushE <= lwstall; 

end behaviors;