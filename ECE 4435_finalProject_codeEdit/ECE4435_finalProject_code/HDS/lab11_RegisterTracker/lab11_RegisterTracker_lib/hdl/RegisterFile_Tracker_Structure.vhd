--
-- VHDL Architecture lab11_RegisterTracker_lib.RegisterFile_Tracker.Structure
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 12:48:59 04/18/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY RegisterFile_Tracker IS
  GENERIC(RegWidth  :   positive := 16;   -- The number of bits in each register
          addr_size :   positive := 4);   -- Select a register. Can select up to 2^RegSel ReadWrite Registers
  
  PORT (  ReadAddr_0, ReadAddr_1 :        IN  std_logic_vector(addr_size-1 DOWNTO 0);    -- Read Data Addresses for operand 1 and 2's Registers          
          Mark_WriteAddr :                IN  std_logic_vector(addr_size-1 DOWNTO 0);    -- Write Data Address for Destination Register
          Clear_WriteAddr :               IN  std_logic_vector(addr_size-1 DOWNTO 0);    -- Write Data Address for Register to be cleared (from Write-Back stage
              
          dependsOn_op1:                  In std_logic; -- whethere the current instruction depends on Register value corresponding to operand 1
          dependsOn_op2:                  In std_logic; -- whethere the current instruction depends on Register value corresponding to operand 2
             
          RegWrite_current:               IN std_logic; -- Register writeback enable signal from the previous instruction (from WriteBack stage)
          RegWrite_previous:              IN std_logic; -- Register writeback enable signal from the current instruction  (from Decode stage)
                      
          clock,reset:                    IN std_logic;
          decode_pcval_out:               IN std_logic_vector(RegWidth-1 DOWNTO 0); -- for debugging &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
          
          decode_pcval_out_TrackerOut:    OUT std_logic_vector(RegWidth-1 DOWNTO 0); -- for debugging &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
          
          can_move_on:                    OUT std_logic    -- true  if the CPU can move on to execute the next instruction
                                                           -- false if it needs to stall the pipeline
        );
          
END ENTITY RegisterFile_Tracker;

--
ARCHITECTURE Structure OF RegisterFile_Tracker IS
  
  SIGNAL Register_In:  std_logic_vector(RegWidth-1 downto 0) := (others=>'0');
  SIGNAL Register_Out: std_logic_vector(Regwidth-1 downto 0);
  
  BEGIN   
    
    Tracker_Register: ENTITY work.Reg(Behavior)
      GENERIC MAP(size=>RegWidth)
      PORT MAP( d=> Register_In,  -- Register input
                q=> Register_Out, -- Register output
                c=> clock,        -- clock
                e=> '1',          -- enable
                reset=> reset     -- reset
              );
                
    Tracker_Processor: ENTITY work.Processor(Behavior)
      GENERIC MAP(addr_size=> addr_size)
      
      PORT MAP(   
                  -- ********** INPUTS **************
                  operand1_Addr => ReadAddr_0,
                  operand2_Addr => ReadAddr_1,
                  
                  reserve_Addr  => Mark_WriteAddr,
                  clear_Addr    => Clear_WriteAddr,
                
                  dependsOn_op1 => dependsOn_op1,
                  dependsOn_op2 => dependsOn_op2,   
             
                  RegWrite_current  => RegWrite_current, 
                  RegWrite_previous => RegWrite_previous, 
                            
                  Register_Out  => Register_Out,    -- values coming out of the Register
                  reset         => reset,
                  
                  decode_pcval_out => decode_pcval_out,                       -- for debugging &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                  
                  -- ************ Outputs ************
                  decode_pcval_out_TrackerOut => decode_pcval_out_TrackerOut, -- for debugging &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            
                  can_move_on   => can_move_on ,
                  Register_In   => Register_In      -- input to be fed to the Register
              );            

END ARCHITECTURE Structure;



