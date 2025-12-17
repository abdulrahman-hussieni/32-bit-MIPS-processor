library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity writeback is
    generic(
        nbits : positive := 32
    );
    port(
        clk         : in  std_logic;

        -- Control Unit Inputs (From Memory Stage)
        RegWriteM   : in  std_logic;
        MemtoRegM   : in  std_logic;
        
        -- Control Unit Outputs (To Decode/RegFile)
        RegWriteW   : out std_logic;

        -- ALU Result (From Memory Stage)
        AluOutM     : in  std_logic_vector(31 downto 0);
        
        -- Final Result (To Decode/RegFile Write Data)
        ResultW     : out std_logic_vector(31 downto 0);

        -- Destination Register Index (From Memory Stage)
        WriteRegM   : in  std_logic_vector(4 downto 0);
        
        -- Destination Register Index (To Decode/RegFile)
        WriteRegW   : out std_logic_vector(4 downto 0);

        -- Memory Read Data
        ReadDataM   : in  std_logic_vector(31 downto 0);
        
        -- System Signals
        reset       : in  std_logic
    );
end writeback;

architecture writeback_arc of writeback is

begin

    -- [Control Signal Passthrough]
    -- Pass the Write Enable signal back to the Decode stage (Register File)
    RegWriteW <= RegWriteM;
    
    -- [Destination Register Passthrough]
    -- Pass the target register address back to the Decode stage
    WriteRegW <= WriteRegM; 

    -- [Result Selection Mux]
    -- Selects the data to write back to the register file.
    -- If MemtoReg is '0', choose ALU Result.
    -- If MemtoReg is '1', choose Data read from Memory (Load instruction).
    ResultW   <= AluOutM when MemtoRegM = '0' else ReadDataM; 

end writeback_arc;