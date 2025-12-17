																	   library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity decode is
    generic(
        nbits : positive := 32
    );
    port(
        clk          : in  std_logic;

        -- Instruction Input
        InstrD       : in  std_logic_vector(nbits-1 downto 0); -- The instruction fetched

        -- PC Interface
        PCPlus4F     : in  std_logic_vector(nbits-1 downto 0); -- PC+4 from Fetch stage

        -- Register File Write Interface (Inputs from Writeback Stage)     
        RegWriteW    : in  std_logic;                          -- Write Enable
        WriteRegW    : in  std_logic_vector(4 downto 0);       -- Register Address to write to
        ResultW      : in  std_logic_vector(nbits-1 downto 0); -- Data to write

        -- Register File Read Outputs
        RD1D         : out std_logic_vector(nbits-1 downto 0); -- Data from Register 1
        RD2D         : out std_logic_vector(nbits-1 downto 0); -- Data from Register 2
        RtD          : out std_logic_vector(4 downto 0);       -- Target Register Address (Rt)
        RdD          : out std_logic_vector(4 downto 0);       -- Destination Register Address (Rd)

        -- Sign Extension
        SignImmD     : out std_logic_vector(nbits-1 downto 0); -- 32-bit Extended Immediate

        -- Control Unit Outputs
        RegWriteD    : out std_logic;
        MemtoRegD    : out std_logic;
        MemWriteD    : out std_logic;
        ALUControlD  : out std_logic_vector(3 downto 0);
        ALUSrcD      : out std_logic;
        RegDstD      : out std_logic_vector(1 downto 0);
        JumpD        : out std_logic;
        JalD         : out std_logic;

        -- Branch / Control Flow Outputs
        PCSrcD       : out std_logic;                          -- Branch Decision Signal
        PCBranchD    : out std_logic_vector(nbits-1 downto 0); -- Calculated Branch Target Address
        PCJump28D    : out std_logic_vector(nbits-5 downto 0); -- Shifted Jump Target bits
        
        -- System Signals
        reset        : in  std_logic;

        -- Data Passthrough
        DataF        : in  std_logic_vector(nbits-1 downto 0); -- Input Data
        DataD        : out std_logic_vector(nbits-1 downto 0)  -- Output Data
    );
end decode; 
    
architecture decode_arc of decode is

    -- Signals required to connect the Register File
    signal A1      : std_logic_vector(4 downto 0);       -- Read Address 1
    signal A2      : std_logic_vector(4 downto 0);       -- Read Address 2
    signal A3      : std_logic_vector(4 downto 0);       -- Write Address
    signal WD3     : std_logic_vector(nbits-1 downto 0); -- Write Data
    signal We3     : std_logic;                          -- Write Enable

    -- Internal Signals
    signal SignImm : std_logic_vector(nbits-1 downto 0);
    signal BranchD : std_logic;                          -- Branch signal from CU
    signal EqualD  : std_logic;                          -- Comparator result (RD1 == RD2)
    signal RD1     : std_logic_vector(nbits-1 downto 0); -- Internal RD1
    signal RD2     : std_logic_vector(nbits-1 downto 0); -- Internal RD2

    -- Control Unit Signals
    signal Op      : std_logic_vector(5 downto 0);
    signal Funct   : std_logic_vector(5 downto 0);

    -- Component Declarations
    component RF is
        generic(
            W : natural := 32
        );
        port(
            A1    : in  std_logic_vector(4 downto 0);
            A2    : in  std_logic_vector(4 downto 0); 
            A3    : in  std_logic_vector(4 downto 0); 
            WD3   : in  std_logic_vector(W-1 downto 0); 
            clk   : in  std_logic;
            We3   : in  std_logic; 
            RD1   : out std_logic_vector(W-1 downto 0); 
            RD2   : out std_logic_vector(W-1 downto 0);
            reset : in  std_logic
        );
    end component;

    component CU is
        port(
            Op          : in  std_logic_vector(5 downto 0);
            Funct       : in  std_logic_vector(5 downto 0);
            RegWrite    : out std_logic;
            MemtoReg    : out std_logic;
            MemWrite    : out std_logic;
            ALUControl  : out std_logic_vector(3 downto 0);
            ALUSrc      : out std_logic;
            RegDst      : out std_logic_vector(1 downto 0);
            Branch      : out std_logic;
            Jump        : out std_logic;
            Jal         : out std_logic
        );
    end component;

begin
    
    ------------------  
    -- Control Unit -- 
    ------------------
    Op    <= InstrD(31 downto 26);
    Funct <= InstrD(5 downto 0);

    cu_0: CU port map(
        Op          => Op,
        Funct       => Funct,
        RegWrite    => RegWriteD,
        MemtoReg    => MemtoRegD,
        MemWrite    => MemWriteD,
        ALUControl  => ALUControlD,
        ALUSrc      => ALUSrcD,
        RegDst      => RegDstD,
        Branch      => BranchD,
        Jump        => JumpD,
        Jal         => JalD
    );

    -------------------
    -- Register File --
    -------------------
    -- Setup inputs for RF
    A1  <= InstrD(25 downto 21); -- Rs
    A2  <= InstrD(20 downto 16); -- Rt
    A3  <= WriteRegW;            -- Destination register from WB stage
    WD3 <= ResultW;              -- Data from WB stage
    We3 <= RegWriteW;            -- Write Enable from WB stage
    
    DataD <= DataF;

    -- Instantiation of Register File
    rf_0: RF port map (
        A1    => A1,
        A2    => A2,
        A3    => A3,
        WD3   => WD3,
        clk   => clk,
        We3   => We3,
        RD1   => RD1,
        RD2   => RD2, 
        reset => reset
    );

    -- [Early Branch Resolution]
    -- Check for equality in the Decode stage.
    EqualD <= '1' when RD1 = RD2 else '0';
    
    -- Branch decision: Taken if Branch instruction AND operands are equal.
    PCSrcD <= BranchD and EqualD; 

    -- Output Register values
    RD1D <= RD1;
    RD2D <= RD2;

    -- [Sign Extension]
    -- Extends 16-bit immediate to 32-bit. 
    -- If MSB (InstrD[15]) is 0, pad with 0s; if 1, pad with 1s.
    SignImm  <= "0000000000000000" & InstrD(15 downto 0) when InstrD(15) = '0' 
           else "1111111111111111" & InstrD(15 downto 0);
           
    SignImmD <= SignImm;

    -- [Branch Target Calculation]
    -- Target = PC + 4 + (SignImm << 2)
    -- Logic: Takes lower 30 bits of SignImm and appends "00" to simulate shift left 2.
    PCBranchD <= (SignImm(29 downto 0) & "00") + PCPlus4F;
    
    -- [Jump Target Calculation]
    -- Target = PC[31:28] (handled in Fetch) | (Instr[25:0] << 2)
    -- Here we just prepare the 28 bits (26 bits + "00").
    PCJump28D <= InstrD(25 downto 0) & "00";

    -- Passthrough of Register Addresses for Hazard/Forwarding Units
    RtD <= InstrD(20 downto 16);
    RdD <= InstrD(15 downto 11);

end decode_arc;