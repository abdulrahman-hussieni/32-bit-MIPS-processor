library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity execute is
    generic(
        nbits : positive := 32
    );
    port(
        clk          : in  std_logic;

        -- Control Unit Inputs (From Decode/Pipeline Reg)
        RegWriteD    : in  std_logic;
        MemtoRegD    : in  std_logic;
        MemWriteD    : in  std_logic;
        ALUControlD  : in  std_logic_vector(3 downto 0);
        ALUSrcD      : in  std_logic;
        RegDstD      : in  std_logic_vector(1 downto 0);

        -- Control Unit Outputs (To Memory/Pipeline Reg)
        RegWriteE    : out std_logic;
        MemtoRegE    : out std_logic;
        MemWriteE    : out std_logic;

        -- ALU Outputs
        ZeroE        : out std_logic;
        AluOutE      : out std_logic_vector(31 downto 0);

        -- Register File Inputs
        RD1D         : in  std_logic_vector(31 downto 0);
        RD2D         : in  std_logic_vector(31 downto 0);

        -- Register Addressing Inputs
        RtD          : in  std_logic_vector(4 downto 0);
        RdD          : in  std_logic_vector(4 downto 0);
        
        -- Data to Store (passed to Memory stage)
        WriteDataE   : out std_logic_vector(31 downto 0);

        -- Sign Extend Input
        SignImmD     : in  std_logic_vector(nbits-1 downto 0);
        
        -- Destination Register Output
        WriteRegE    : out std_logic_vector(4 downto 0);
        
        -- System Signals
        reset        : in  std_logic;

        -- Data Passthrough
        DataD        : in  std_logic_vector(nbits-1 downto 0);
        DataE        : out std_logic_vector(nbits-1 downto 0)
    );
end execute;

architecture execute_arc of execute is
    
    -- ALU Signals
    signal SrcAE       : std_logic_vector(31 downto 0);
    signal SrcBE       : std_logic_vector(31 downto 0);
    signal AluControlE : std_logic_vector(2 downto 0); 
    signal IGNORE      : std_logic;

    -- Component Declaration
    component ALU is
        generic(
            W  : natural := 32; 
            Cw : natural := 6 -- TODO: Our ALU uses smaller opcodes! We need to refactor this!
        );
        port(
            SrcA       : in  std_logic_vector(W-1 downto 0);
            SrcB       : in  std_logic_vector(W-1 downto 0);
            AluControl : in  std_logic_vector(3 downto 0);
            AluResult  : out std_logic_vector(W-1 downto 0);
            Zero       : out std_logic;
            Overflow   : out std_logic;
            CarryOut   : out std_logic
        );
    end component;

begin

    ---------
    -- ALU -- 
    ---------
    
    -- [Source A Selection]
    -- Currently hardwired to Register Read Data 1
    SrcAE <= RD1D;
    
    -- [Source B Selection]
    -- Selects between Register Read Data 2 and Immediate value
    -- Original Comment: "This could be a Mux, but I am a rebel."
    SrcBE <= RD2D when ALUSrcD = '0' else SignImmD; 

    -- ALU Instantiation
    -- Ignoring the last two signals: Overflow and CarryOut
    alu_0: ALU port map(
        SrcA       => SrcAE,
        SrcB       => SrcBE,
        AluControl => ALUControlD,
        AluResult  => AluOutE,
        Zero       => ZeroE,
        Overflow   => IGNORE,
        CarryOut   => IGNORE
    );

    -------------------
    -- Pipeline Flow --
    -------------------
    
    -- Pass Read Data 2 to the next stage (for Store instructions)
    WriteDataE <= RD2D;
    
    -- [Destination Register Mux]
    -- Selects destination register index (Rt vs Rd)
    -- If RegDst is "00", use Rt; otherwise use Rd.
    WriteRegE  <= RtD when RegDstD = "00" else RdD; 
    
    -- Pass Control Signal
    RegWriteE  <= RegWriteD;

    -- Memory Control Signals Passthrough
    MemtoRegE  <= MemtoRegD;
    MemWriteE  <= MemWriteD;

    -- Data Passthrough
    DataE      <= DataD;

end execute_arc;