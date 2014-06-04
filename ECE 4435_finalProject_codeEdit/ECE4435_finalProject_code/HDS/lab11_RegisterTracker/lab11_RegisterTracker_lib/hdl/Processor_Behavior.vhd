--
-- VHDL Architecture lab11_RegisterTracker_lib.Processor.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 15:43:22 04/19/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;

ENTITY Processor IS
    GENERIC( addr_size: positive := 4);
    PORT(    operand1_Addr:     IN std_logic_vector(addr_size-1 downto 0) := (others=>'0');
             operand2_Addr:     IN std_logic_vector(addr_size-1 downto 0) := (others=>'0');
    
             reserve_Addr:      IN std_logic_vector(addr_size-1 downto 0) := (others=>'0');
             clear_Addr:        IN std_logic_vector(addr_size-1 downto 0) := (others=>'0');
             
             dependsOn_op1:     In std_logic := '0'; -- whether the current instruction depends on Register value corresponding to operand 1
             dependsOn_op2:     In std_logic := '0'; -- whether the current instruction depends on Register value corresponding to operand 2
             
             RegWrite_current:  IN std_logic := '0'; -- Register writeback enable signal from the previous instruction (from WriteBack stage)
             RegWrite_previous: IN std_logic := '0'; -- Register writeback enable signal from the current instruction  (from Decode stage)
             
             Register_Out:      IN std_logic_vector(15 downto 0) := (others=>'0') ; -- values coming out of the Register
             reset:             IN std_logic := '0';
             
             decode_pcval_out:  IN std_logic_vector(15 DOWNTO 0);
             
             -- *************** OUTPUTS **************************************************************
             decode_pcval_out_TrackerOut:  OUT std_logic_vector(15 DOWNTO 0);
                    
             can_move_on:       OUT std_logic;
             Register_In:       OUT std_logic_vector(15 downto 0) -- input to be fed to the Register
          ); 
END ENTITY Processor;

--
ARCHITECTURE Behavior OF Processor IS
  
  BEGIN
    p1: PROCESS(all)

      CONSTANT ALL_ZERO:          std_logic_vector(15 downto 0) := (others=>'0');
      CONSTANT ALL_ONE:           std_logic_vector(15 downto 0) := (others=>'1');
  
      VARIABLE result_op1:        std_logic_vector(15 downto 0); -- one-hot representation of operand 1's Register
      VARIABLE result_op2:        std_logic_vector(15 downto 0); -- one-hot representation of operand 2's Register
      VARIABLE result_clear:      std_logic_vector(15 downto 0); -- one-hot representation of the Register to clean (coming out from the Write Back stage)
      VARIABLE result_reserve:    std_logic_vector(15 downto 0); -- one-hot representation of the Register to reserve (for the Destination Register)
    
      VARIABLE selection_op1:     natural;                       -- integer representations, likewise
      VARIABLE selection_op2:     natural;
      VARIABLE selection_clear:   natural;
      VARIABLE selection_reserve: natural;
    
      VARIABLE upcoming_op1:      std_logic;                     -- upcoming reservation status bit for operand 1's Register
      VARIABLE upcoming_op2:      std_logic;                     -- upcoming reservation status bit for operand 2's Register
    
      VARIABLE can_move_on_var:  std_logic := '1';
      VARIABLE Register_Out_var: std_logic_vector(15 downto 0);
      VARIABLE Register_In_var:  std_logic_vector(15 downto 0);
      
      VARIABLE decode_pcval_out_TrackerOut_var : std_logic_vector(15 downto 0); -- &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    
      BEGIN
        Register_Out_var  := Register_Out;             -- *** currently saved Register values
        Register_In_var   := Register_Out;             -- *** currently saved Register values
      
        decode_pcval_out_TrackerOut_var := decode_pcval_out;
      
        selection_op1     := to_integer( ieee.numeric_std.unsigned(operand1_Addr) );
        selection_op2     := to_integer( ieee.numeric_std.unsigned(operand2_Addr) );
     
        -- If the Register for operand 1 is the same as Register to be cleared from Write-Back signal
        IF( (selection_op1 = selection_clear) and  (RegWrite_previous = '1') ) THEN
            upcoming_op1 := '1';                                
        ELSE
            upcoming_op1  := Register_Out(selection_op1);  -- upcoming status value for operand 1's Register             
        END IF;
 
        -- If the Register for operand 2 is the same as Register to be cleared from Write-Back signal        
        IF( (selection_op2 = selection_clear) and (RegWrite_previous = '1')  ) THEN
            upcoming_op2 := '1';                                      
        ELSE
            upcoming_op2  := Register_Out(selection_op2); -- upcoming status value for operand 2's Register      
        END IF;
      
        -- Preprare bit masking for the clear Address
        result_clear                        := ALL_ONE;  -- pre-set all bits to 1
        selection_clear                     := to_integer( ieee.numeric_std.unsigned(clear_Addr) );
        
        IF( RegWrite_previous = '1') THEN                
            result_clear(selection_clear)   := '0';      -- clear the reserved bit for previous instruction's destination
        END IF;
        
        -- Prepare bit masking for the reserve Address
        result_reserve                      := ALL_ZERO; -- pre-set all bits to 0            
        selection_reserve                   := to_integer( ieee.numeric_std.unsigned(reserve_Addr) );
        
        IF( RegWrite_current = '1') THEN                  
            result_reserve(selection_reserve) := '1';    -- set a reserved bit for current instuction's destination
        END IF;
        
        -- Override the upcoming reservation status to 0 if the Register values are not needed in the instruction 
        IF( dependsOn_op1 /= '1')  THEN
              upcoming_op1 := '0';
        END IF;    
        
        IF( dependsOn_op2 /= '1') THEN
              upcoming_op2 := '0';
        END IF;    
        
        -- If the Registers for both of the operands have not been reserved    
        IF( (upcoming_op1 = '0') and (upcoming_op2 = '0') ) THEN
 
            can_move_on_var := '1';                                 -- can proceed with the next instruction
            Register_In_var := Register_Out_var AND result_clear;   -- *** clear the status bit corresponding to the clear Address (FIRST)       
            Register_In_var := Register_In_var  OR result_reserve;  -- *** reserve the status bit for the Destination Address      (SECOND)     
              
        ELSE  
            can_move_on_var := '0';                                 -- stall
            Register_In_var := Register_Out_var AND result_clear;   -- *** clear the status bit corresponding to the clear Address
            
        END IF;
      
        -- If reset is enabled
        IF( reset = '1') THEN
              can_move_on_var := '1';
              Register_In_var := (others=>'0');  
        END IF;
      
        -- Finalize outputs
        decode_pcval_out_TrackerOut <= decode_pcval_out_TrackerOut_var;
        
        can_move_on <= can_move_on_var;
        Register_In <= Register_In_var;
      
    END PROCESS p1;
    
END ARCHITECTURE Behavior;

