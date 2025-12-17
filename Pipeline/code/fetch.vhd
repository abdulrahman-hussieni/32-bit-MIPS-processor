library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity fetch is
    generic(
        nbits : positive := 32
    );
    port(
        -- Control Unit Signals
        Jump         : in  std_logic;
        StallF       : in  std_logic; -- NEW INPUT: Stall Signal

        -- Instruction Memory Interface
        Instruction  : in  std_logic_vector(nbits-1 downto 0); 
        InstructionF : out std_logic_vector(nbits-1 downto 0);
        
        -- Decode Stage Interface
        PCBranchD    : in  std_logic_vector(nbits-1 downto 0);
        PCJump28D    : in  std_logic_vector(nbits-5 downto 0);
        PCSrcD       : in  std_logic;
        
        -- Outputs to Decode Stage
        FPCPlus4     : out std_logic_vector(nbits-1 downto 0);
        PCFF         : out std_logic_vector(nbits-1 downto 0);
        
        -- System Signals
        clk          : in  std_logic;
        reset        : in  std_logic;

        -- Data Passthrough
        Data         : in  std_logic_vector(nbits-1 downto 0);
        DataF        : out std_logic_vector(nbits-1 downto 0)
    );
end fetch;

architecture fetch_arc of fetch is

    component mux2 is
        generic(
            nbits : positive := 32
        );
        port(
            d0, d1 : in  std_logic_vector(nbits-1 downto 0);
            s      : in  std_logic;
            y      : out std_logic_vector(nbits-1 downto 0)
        );
    end component;

    -- Internal Signals
    signal PC        : std_logic_vector(nbits-1 downto 0);
    signal PCLinha   : std_logic_vector(nbits-1 downto 0);
    signal PCPlus4   : std_logic_vector(nbits-1 downto 0);
    signal PCAux     : std_logic_vector(nbits-1 downto 0);
    signal PCJump32  : std_logic_vector(nbits-1 downto 0);

begin

    -- [Jump Address Calculation]
    PCJump32 <= PCPlus4(31 downto 28) & PCJump28D; 

    -- [Next Sequential Address]
    PCPlus4  <= PC + 4; 

    -- [Program Counter Register with Stall Logic]
    process(clk, reset)
    begin
        if reset = '1' then
            PC <= (others => '0');
        elsif rising_edge(clk) then
            -- Only update PC if StallF is NOT active
            if StallF = '0' then
                PC <= PCLinha;
            end if;
        end if;
    end process;

    -- [Branch Mux]
    beq: mux2 
        port map(
            d0 => PCPlus4, 
            d1 => PCBranchD, 
            s  => PCSrcD, 
            y  => PCAux
        );

    -- [Jump Mux]
    jumpMux: mux2 
        port map(
            d0 => PCAux, 
            d1 => PCJump32, 
            s  => Jump, 
            y  => PCLinha
        );

    -- [Output Assignments]
    PCFF         <= PC;
    InstructionF <= Instruction;
    FPCPlus4     <= PCPlus4;
    DataF        <= Data;
    
end fetch_arc;