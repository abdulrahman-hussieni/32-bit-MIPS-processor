			  library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux2 is
    generic(
        nbits : positive := 32
    );
    port(
        -- Data Inputs
        d0 : in  STD_LOGIC_VECTOR(nbits-1 downto 0); -- Selected when s = '0'
        d1 : in  STD_LOGIC_VECTOR(nbits-1 downto 0); -- Selected when s = '1'
        
        -- Selector Signal
        s  : in  STD_LOGIC;
        
        -- Data Output
        y  : out STD_LOGIC_VECTOR(nbits-1 downto 0)
    );
end mux2;

architecture synth of mux2 is
begin

    -- [Multiplexer Logic]
    -- Conditional Signal Assignment (Behavioral Description)
    -- If Selector (s) is High ('1'), output d1.
    -- Otherwise (s is '0' or X/Z), output d0.
    y <= d1 when s = '1' else d0;

end synth;