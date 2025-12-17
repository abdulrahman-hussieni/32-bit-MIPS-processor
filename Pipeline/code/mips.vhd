library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity mips is 
	generic(
		nbits : positive := 32
	);
	port(
		Instruction : in std_logic_vector(nbits -1 downto 0);
		Data		: in std_logic_vector(nbits -1 downto 0);
		clk 		: in std_logic;
		reset		: in std_logic;
		PCF			: out std_logic_vector(nbits -1 downto 0);
		ALUOutM		: out std_logic_vector(nbits -1 downto 0);
		WriteDataM	: out std_logic_vector(nbits -1 downto 0);
		MemWriteM	: out std_logic
	);
end mips;
  
architecture arc_mips of mips is

component fetch is
	generic(
		nbits	: positive	:= 32
	);
	port(
		Jump		: in std_logic;
        StallF      : in std_logic; -- Modified Port
		Instruction  : in std_logic_vector(nbits-1 downto 0);
		InstructionF : out std_logic_vector(nbits-1 downto 0);
		PCBranchD	: in std_logic_vector(nbits-1 downto 0);
		PCJump28D	: in std_logic_vector(nbits-5 downto 0);
		PCSrcD		: in std_logic;
		FPCPlus4	: out std_logic_vector(nbits-1 downto 0);
		PCFF		: out std_logic_vector(nbits-1 downto 0);
		clk			: in std_logic;
		reset		: in std_logic;
		Data		: in std_logic_vector(nbits-1 downto 0);
		DataF		: out std_logic_vector(nbits-1 downto 0)
	);
end component;	

component decode is
	generic(
		nbits	: positive	:= 32
	);
	port(
		clk			: in std_logic;
		InstrD		: in std_logic_vector(nbits-1 downto 0);
		PCPlus4F	: in std_logic_vector(nbits-1 downto 0);
		RegWriteW	: in std_logic;
		WriteRegW	: in std_logic_vector(4 downto 0); 
		ResultW		: in std_logic_vector(nbits-1 downto 0);
		RD1D		: out std_logic_vector(nbits-1 downto 0);
		RD2D		: out std_logic_vector(nbits-1 downto 0);
		RtD			: out std_logic_vector(4 downto 0);
		RdD			: out std_logic_vector(4 downto 0);
		SignImmD	: out std_logic_vector(nbits-1 downto 0);
		RegWriteD	: out std_logic;
		MemtoRegD	: out std_logic;
		MemWriteD	: out std_logic;
		ALUControlD	: out std_logic_vector (3 downto 0);
		ALUSrcD		: out std_logic;
		RegDstD		: out std_logic_vector(1 downto 0);
		JumpD		: out std_logic;
		JalD		: out std_logic;
		PCSrcD		: out std_logic;
		PCBranchD	: out std_logic_vector(nbits-1 downto 0);
		PCJump28D 	: out std_logic_vector(nbits-5 downto 0);
		reset		: in std_logic;
		DataF		: in std_logic_vector(nbits-1 downto 0);
		DataD		: out std_logic_vector(nbits-1 downto 0)
	);
end component;	

component execute is
	generic(
		nbits	: positive	:= 32
	);
	port(
		clk		: in std_logic;
		RegWriteD	: in std_logic;
		MemtoRegD	: in std_logic;
		MemWriteD	: in std_logic;
		ALUControlD	: in std_logic_vector(3 downto 0);
		ALUSrcD		: in std_logic;
		RegDstD		: in std_logic_vector(1 downto 0);
		RegWriteE	: out std_logic;
		MemtoRegE	: out std_logic;
		MemWriteE	: out std_logic;
		ZeroE		: out std_logic;
		AluOutE		: out std_logic_vector(31 downto 0);
		RD1D		: in std_logic_vector(31 downto 0);
		RD2D		: in std_logic_vector(31 downto 0);
		RtD			: in std_logic_vector(4 downto 0);
		RdD			: in std_logic_vector(4 downto 0);
		WriteDataE	: out std_logic_vector(31 downto 0);
		SignImmD	: in std_logic_vector(nbits-1 downto 0);
		WriteRegE	: out std_logic_vector(4 downto 0);
		reset		: in std_logic;
		DataD		: in std_logic_vector(nbits-1 downto 0);
		DataE		: out std_logic_vector(nbits-1 downto 0)
	);
end component;

component memory is
	generic(
		nbits	: positive	:= 32
	);
	port(
		clk			: in std_logic;
		RegWriteE	: in std_logic;
		MemtoRegE	: in std_logic;
		MemWriteE	: in std_logic;
		MemWriteM	: out std_logic;
		RegWriteM	: out std_logic;
		MemtoRegM	: out std_logic;
		ZeroE		: in std_logic;
		AluOutE		: in std_logic_vector(31 downto 0);
		AluOutM		: out std_logic_vector(31 downto 0);
		WriteDataE	: in std_logic_vector(31 downto 0);
		WriteRegE	: in std_logic_vector(4 downto 0);
		WriteRegM	: out std_logic_vector(4 downto 0);
		ReadDataM	: out std_logic_vector(31 downto 0);
		Data		: in std_logic_vector(31 downto 0);
		WriteDataM	: out std_logic_vector(31 downto 0);
		reset		: in std_logic
	);
end component;

component writeback is
	generic(
		nbits	: positive	:= 32
	);
	port(
		clk			: in std_logic;
		RegWriteM	: in std_logic;
		MemtoRegM	: in std_logic;
		RegWriteW	: out std_logic;
		AluOutM		: in std_logic_vector(31 downto 0);
		ResultW		: out std_logic_vector(31 downto 0);
		WriteRegM	: in std_logic_vector(4 downto 0);
		WriteRegW	: out std_logic_vector(4 downto 0);
		ReadDataM	: in std_logic_vector(31 downto 0);
		reset		: in std_logic
	);
end component;

-- Hazard Unit Component
component hazard_unit is
    port(
        RsD, RtD, RtE : in std_logic_vector(4 downto 0);
        MemToRegE     : in std_logic;
        StallF, StallD, FlushE : out std_logic
    );
end component;

-----------------------------------------------------------

--- HAZARD SIGNALS ---
signal StallF, StallD, FlushE : std_logic;
signal RsD_Internal, RtD_Internal : std_logic_vector(4 downto 0);

--- FETCH ---
signal F_InstructionF	: std_logic_vector(nbits-1 downto 0);
signal Jump_F			: std_logic;
signal PCBranchD_F		: std_logic_vector(nbits-1 downto 0);
signal PCJump28D_F		: std_logic_vector(nbits-5 downto 0);
signal PCSrcD_F			: std_logic;
signal F_FPCPlus4		: std_logic_vector(nbits-1 downto 0);
signal F_PCFF			: std_logic_vector(nbits-1 downto 0);
signal F_DataF			: std_logic_vector(nbits-1 downto 0);

--- DECODE ---
signal InstructionF_D 	: std_logic_vector(nbits-1 downto 0);
signal PCPlus4F_D		: std_logic_vector(nbits-1 downto 0);
signal RegWriteW_D		: std_logic;
signal WriteRegW_D		: std_logic_vector(4 downto 0);
signal ResultW_D		: std_logic_vector(nbits-1 downto 0);
signal DataF_D			: std_logic_vector(nbits-1 downto 0);

signal D_RD1D			: std_logic_vector(nbits-1 downto 0);
signal D_RD2D			: std_logic_vector(nbits-1 downto 0);
signal D_RtD			: std_logic_vector(4 downto 0);
signal D_RdD			: std_logic_vector(4 downto 0);
signal D_SignImmD		: std_logic_vector(nbits-1 downto 0);
signal D_RegWriteD		: std_logic;
signal D_MemtoRegD		: std_logic;
signal D_MemWriteD		: std_logic;
signal D_ALUControlD	: std_logic_vector (3 downto 0);
signal D_ALUSrcD		: std_logic;
signal D_RegDstD		: std_logic_vector(1 downto 0);
signal D_JumpD			: std_logic;
signal D_JalD			: std_logic;
signal D_PCSrcD			: std_logic;
signal D_PCBranchD		: std_logic_vector(nbits-1 downto 0);
signal D_PCJump28D		: std_logic_vector(nbits-5 downto 0);
signal D_DataD			: std_logic_vector(nbits-1 downto 0);

--- EXECUTE ----
signal RegWriteD_E		: std_logic;
signal MemtoRegD_E		: std_logic;
signal MemWriteD_E		: std_logic;
signal ALUControlD_E	: std_logic_vector(3 downto 0);
signal ALUSrcD_E		: std_logic;
signal RegDstD_E		: std_logic_vector(1 downto 0);
signal RD1D_E			: std_logic_vector(31 downto 0);
signal RD2D_E			: std_logic_vector(31 downto 0);
signal RtD_E			: std_logic_vector(4 downto 0);
signal RdD_E			: std_logic_vector(4 downto 0);
signal SignImmD_E		: std_logic_vector(nbits-1 downto 0);
signal DataD_E			: std_logic_vector(nbits-1 downto 0);

signal E_RegWriteE		: std_logic;
signal E_MemtoRegE		: std_logic;
signal E_MemWriteE		: std_logic;
signal E_ZeroE			: std_logic;
signal E_AluOutE		: std_logic_vector(31 downto 0);
signal E_WriteDataE		: std_logic_vector(31 downto 0);
signal E_WriteRegE		: std_logic_vector(4 downto 0);
signal E_DataE			: std_logic_vector(nbits-1 downto 0);

--- MEMORY ---
signal RegWriteE_M	: std_logic;
signal MemtoRegE_M	: std_logic;
signal MemWriteE_M	: std_logic;
signal M_MemWriteM	: std_logic;
signal M_RegWriteM	: std_logic;
signal M_MemtoRegM	: std_logic;
signal ZeroE_M		: std_logic;
signal AluOutE_M	: std_logic_vector(31 downto 0);
signal M_AluOutM	: std_logic_vector(31 downto 0);
signal WriteDataE_M	: std_logic_vector(31 downto 0);
signal WriteRegE_M	: std_logic_vector(4 downto 0);
signal M_WriteRegM	: std_logic_vector(4 downto 0);
signal M_ReadDataM	: std_logic_vector(31 downto 0);
signal Data_M		: std_logic_vector(31 downto 0);
signal M_WriteDataM	: std_logic_vector(31 downto 0);
signal DataE_M		: std_logic_vector(31 downto 0);

-- WRITEBACK ---
signal RegWriteM_W	: std_logic;
signal MemtoRegM_W	: std_logic;
signal W_RegWriteW	: std_logic;
signal AluOutM_W	: std_logic_vector(31 downto 0);
signal W_ResultW	: std_logic_vector(31 downto 0);
signal WriteRegM_W	: std_logic_vector(4 downto 0);
signal W_WriteRegW	: std_logic_vector(4 downto 0);
signal ReadDataM_W	: std_logic_vector(31 downto 0);


begin

    -- Extraction of Rs and Rt from Instruction at Decode Stage
    RsD_Internal <= InstructionF_D(25 downto 21);
    RtD_Internal <= InstructionF_D(20 downto 16);

    -- Hazard Unit Instantiation
    hazard_unit_0: hazard_unit port map(
        RsD       => RsD_Internal,
        RtD       => RtD_Internal,
        RtE       => E_WriteRegE,  -- Correct: Target reg from Execute stage
        MemToRegE => E_MemtoRegE,  -- Correct: MemRead signal from Execute stage
        StallF    => StallF,
        StallD    => StallD,
        FlushE    => FlushE
    );

	fetch_0: Fetch port map(Jump_F, StallF, Instruction, F_InstructionF, PCBranchD_F, PCJump28D_F, PCSrcD_F, F_FPCPlus4, F_PCFF, clk, reset, Data, F_DataF);
	decode_0: Decode port map(clk, InstructionF_D, PCPlus4F_D, RegWriteW_D, WriteRegW_D, ResultW_D, D_RD1D, D_RD2D, D_RtD, D_RdD, D_SignImmD, D_RegWriteD, D_MemtoRegD, D_MemWriteD, D_ALUControlD, D_ALUSrcD, D_RegDstD, D_JumpD, D_JalD, D_PCSrcD, D_PCBranchD, D_PCJump28D, reset, DataF_D, D_DataD);
	execute_0: Execute port map(clk, RegWriteD_E, MemtoRegD_E, MemWriteD_E, ALUControlD_E, ALUSrcD_E, RegDstD_E, E_RegWriteE, E_MemtoRegE, E_MemWriteE, E_ZeroE, E_AluOutE, RD1D_E, RD2D_E, RtD_E, RdD_E, E_WriteDataE, SignImmD_E, E_WriteRegE, reset, DataD_E, E_DataE);
	memory_0: Memory port map(clk, RegWriteE_M, MemtoRegE_M, MemWriteE_M, M_MemWriteM, M_RegWriteM, M_MemtoRegM, ZeroE_M, AluOutE_M, M_AluOutM, WriteDataE_M, WriteRegE_M, M_WriteRegM, M_ReadDataM, DataE_M, M_WriteDataM, reset);
	writeback_0: Writeback port map(clk, RegWriteM_W, MemtoRegM_W, W_RegWriteW, AluOutM_W, W_ResultW, WriteRegM_W, W_WriteRegW, ReadDataM_W, reset);

	--  ⁄œÌ· «·‹ Process ·Ì‘„· Reset
	process(clk, reset) -- ·«ÕŸ ≈÷«›… reset Â‰« ›Ì «·Õ”«”Ì…
	begin 
        -- 1. ‘—ÿ «· ’›Ì— (Reset Logic)
        if reset = '1' then
            --  ’›Ì— ≈‘«—«  «· Õﬂ„ ›Ì ﬂ· «·„—«Õ· ·„‰⁄ «·‹ Unknown values
            -- Fetch -> Decode
            InstructionF_D <= (others => '0');
            PCPlus4F_D     <= (others => '0');
            DataF_D        <= (others => '0');
            
            -- Decode -> Execute
            RegWriteD_E    <= '0';
            MemtoRegD_E    <= '0';
            MemWriteD_E    <= '0';
            ALUControlD_E  <= (others => '0');
            ALUSrcD_E      <= '0';
            RegDstD_E      <= "00";
            RD1D_E         <= (others => '0');
            RD2D_E         <= (others => '0');
            RtD_E          <= (others => '0');
            RdD_E          <= (others => '0');
            SignImmD_E     <= (others => '0');
            DataD_E        <= (others => '0');

            -- Execute -> Memory
            RegWriteE_M    <= '0';
            MemtoRegE_M    <= '0';
            MemWriteE_M    <= '0';
            ZeroE_M        <= '0';
            AluOutE_M      <= (others => '0');
            WriteDataE_M   <= (others => '0');
            WriteRegE_M    <= (others => '0');
            DataE_M        <= (others => '0');

            -- Memory -> Writeback
            RegWriteM_W    <= '0';
            MemtoRegM_W    <= '0';
            AluOutM_W      <= (others => '0');
            WriteRegM_W    <= (others => '0');
            ReadDataM_W    <= (others => '0');
            
            -- Outputs
            PCF            <= (others => '0');
            
        -- 2. «·‘€· «·ÿ»Ì⁄Ì (Rising Edge)
		elsif clk'EVENT and clk = '1' then
		
			-- TO FETCH (Feedback signals)
			PCBranchD_F <= D_PCBranchD;
			PCJump28D_F <= D_PCJump28D;
			PCSrcD_F 	<= D_PCSrcD;
			Jump_F 		<= D_JumpD;

			-- TO DECODE (IF/ID Pipeline Register)
            if StallD = '0' then
                InstructionF_D	<= F_InstructionF;
                PCPlus4F_D		<= F_FPCPlus4;
                DataF_D			<= F_DataF;
            end if;

            -- Feedback from WB
			RegWriteW_D		<= W_RegWriteW;
			WriteRegW_D		<= W_WriteRegW;
			ResultW_D		<= W_ResultW;

			-- TO EXECUTE (ID/EX Pipeline Register)
            if FlushE = '1' then
                RegWriteD_E		<= '0';
                MemtoRegD_E		<= '0';
                MemWriteD_E		<= '0';
                ALUControlD_E	<= (others => '0');
                ALUSrcD_E		<= '0';
                RegDstD_E		<= "00";
                -- »ﬁÌ… «·≈‘«—«  „‘ „Â„   ’›— ·√‰ «· Õﬂ„ ’›—
            else
                RegWriteD_E		<= D_RegWriteD;
                MemtoRegD_E		<= D_MemtoRegD;
                MemWriteD_E		<= D_MemWriteD;
                ALUControlD_E	<= D_ALUControlD;
                ALUSrcD_E		<= D_ALUSrcD;
                RegDstD_E		<= D_RegDstD;
            end if;

            -- ‰ﬁ· «·œ« « ⁄«œÌ
			RD1D_E			<= D_RD1D;
			RD2D_E			<= D_RD2D;
			RtD_E			<= D_RtD;
			RdD_E			<= D_RdD;
			SignImmD_E		<= D_SignImmD;
			DataD_E			<= D_DataD;

			-- TO MEMORY (EX/MEM Pipeline Register)
			RegWriteE_M		<= E_RegWriteE; 
			MemtoRegE_M		<= E_MemtoRegE;
			MemWriteE_M		<= E_MemWriteE;
			ZeroE_M			<= E_ZeroE;
			AluOutE_M		<= E_AluOutE;
			WriteDataE_M	<= E_WriteDataE;
			WriteRegE_M		<= E_WriteRegE;
			DataE_M			<= E_DataE;

			-- TO WRITEBACK (MEM/WB Pipeline Register)
			RegWriteM_W 	<= M_RegWriteM;
			MemtoRegM_W		<= M_MemtoRegM;
			AluOutM_W 		<= M_AluOutM;
			WriteRegM_W		<= M_WriteRegM;
			ReadDataM_W		<= M_ReadDataM;

			-- TO MIPS (Outputs)
			WriteDataM	<= M_WriteDataM;
			PCF 		<= F_PCFF;
			ALUOutM		<= M_AluOutM;
			MemWriteM	<= M_MemWriteM;

		end if;
	end process;

end;