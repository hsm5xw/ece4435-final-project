--
-- VHDL Architecture lab10_RegFile_lib.RegisterFile.Structure
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 07:18:21 04/ 9/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY RegisterFile IS
  GENERIC(RegWidth : positive := 16;  -- The number of bits in each register
          RegSel :   positive := 4);  -- Select a register. Can select up to 2^RegSel ReadWrite Registers
  
  PORT (  ReadAddr_0, ReadAddr_1 :  IN  std_logic_vector(RegSel-1 DOWNTO 0);    -- Read Data Address
          RD0, RD1 :                OUT std_logic_vector(RegWidth-1 DOWNTO 0);  -- Read Data Outputs
          
          WriteAddr :               IN std_logic_vector(RegSel-1 DOWNTO 0);     -- Write Data Address
          WD :                      IN std_logic_vector(RegWidth-1 DOWNTO 0);   -- Write Data Input
          
          clock, write_enable :     IN std_logic    
        );
          
END ENTITY RegisterFile;

--
ARCHITECTURE Structure OF RegisterFile IS
  -- One-hot Decoder Selects
  SIGNAL RegRead_0, RegRead_1: std_logic_vector((2**RegSel)-1 downto 0 );
  SIGNAL RegWrite:             std_logic_vector((2**RegSel)-1 downto 0 );
  
  -- Read Outputs
  SIGNAL RegOut_0, RegOut_1:   std_logic_vector(RegWidth-1 downto 0 ); 
  
  BEGIN
    -- Read Decoder for reading the first operand
    ReadDecode_0: ENTITY work.Decoder(Behavior)
      GENERIC MAP(size=> RegSel)
      PORT MAP( sel=> ReadAddr_0, onehot=> RegRead_0, enable=> '1');
    
    -- Read Decoder for reading the second operand  
    ReadDecode_1: ENTITY work.Decoder(Behavior)
      GENERIC MAP(size=> RegSel)
      PORT MAP( sel=> ReadAddr_1, onehot=> RegRead_1, enable=> '1');  
    
    -- Write Decoder  
    WriteDecode: ENTITY work.Decoder(Behavior)
      GENERIC MAP(size=> RegSel)
      PORT MAP( sel=> WriteAddr, onehot=> RegWrite, enable=> write_enable);
        
    -- Instantiate an array of ReadWrite Registers         
    RegArray: FOR i in 0 to ((2**RegSel)-1) GENERATE
        SIGNAL WE: std_logic;
      
      BEGIN
        WE <= (RegWrite(i) and write_enable);
        
        RegI: ENTITY work.RegReadWrite(mixed)
          GENERIC MAP(size=>RegWidth)
          PORT MAP( D=> WD,                                   -- Write Data
                    Q0=> RegOut_0, Q1=> RegOut_1,             -- Intermediate Read Outputs
                    c=>clock, 
                    load=> WE,                                -- Write Select
                    read0=>RegRead_0(i), read1=>RegRead_1(i)  -- Read  Select
                  );
    END GENERATE RegArray;
    
    RD0<= RegOut_0;
    RD1<= RegOut_1;
    
END ARCHITECTURE Structure;

