--
-- VHDL Architecture lab9_new_lib.mini_Shifter.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 10:59:42 04/21/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY mini_Shifter IS
  
  PORT( 
        shifter_In:       IN std_logic_vector(15 downto 0);   -- input 
        shift_operation:  IN std_logic_vector(3 downto 0);    -- shift operation
        
        shifter_Out:      OUT std_logic_vector(15 downto 0);  -- Output
        
        from_Carry_CCR:   IN std_logic;                       -- value from the Carry CCR (Condition Code Register)
        to_Carry_CCR:     OUT std_logic                       -- value to be stored in the Carry CCR
      );
END ENTITY mini_Shifter;

--
ARCHITECTURE Behavior OF mini_Shifter IS
BEGIN
  
  PROCESS(all)
  
       variable bit_Copy     : std_logic;                         -- 1 bit variable
       variable vector_Copy  : std_logic_vector(14 downto 0);     -- 1 bit shorter than the shifter input
       
       variable shifter_Out_var  : std_logic_vector(15 downto 0);
       variable to_Carry_CCR_var : std_logic := '0';
      
  BEGIN
    
    CASE shift_operation IS
        
        -- SL
        when "1000" => 
                        bit_Copy          := '0';
                        vector_Copy       := shifter_In(14 downto 0);
                        
                        shifter_Out_var   := vector_Copy & bit_Copy;  -- left shift  
                        to_Carry_CCR_var  := from_Carry_CCR;          -- condition code not changed
                      
        -- SRL
        when "1001" =>
                        bit_Copy          := '0';
                        vector_Copy       := shifter_In(15 downto 1);
  
                        shifter_Out_var   := bit_Copy & vector_Copy;  -- right shift (logical)
                        to_Carry_CCR_var  := from_Carry_CCR;          -- condition code not changed                      
        -- SRA
        when "1010" =>
                        bit_Copy          := shifter_In(15);
                        vector_Copy       := shifter_In(15 downto 1);
  
                        shifter_Out_var   := bit_Copy & vector_Copy;  -- right shift (arithmetic)
                        to_Carry_CCR_var  := from_Carry_CCR;          -- condition code not changed     
        -- RRA
        when "1110" =>
                        to_Carry_CCR_var  := shifter_In(0);           -- * copy the least significant bit
                        bit_Copy          := shifter_In(15);          -- * copy the most significant bit
                        vector_Copy       := shifter_In(15 downto 1);
                          
                        shifter_Out_var   := bit_Copy & vector_Copy;

        -- RR
        when "1101" =>
                        to_Carry_CCR_var  := shifter_In(0);           -- * copy the least significant bit
                        bit_Copy          := from_Carry_CCR;          -- * copy the carry condition bit
                        vector_Copy       := shifter_In(15 downto 1);
                        
                        shifter_Out_var   := bit_Copy & vector_Copy;  -- right shift
                         
        -- RL
        when "1100" =>
                        bit_Copy          := from_Carry_CCR;          -- * copy the carry condition bit 
                        to_Carry_CCR_var  := shifter_In(15);          -- * copy the most significant bit
                        vector_Copy       := shifter_In(14 downto 0); 
                        
                        shifter_Out_var   := vector_Copy & bit_Copy;
                        
        -- others
        when others =>  shifter_Out_var   := shifter_In;              -- do nothing
                        to_Carry_CCR_var  := from_Carry_CCR;          -- condition code not changed
         
    END CASE;  
    
    shifter_Out  <= shifter_Out_var;
    to_Carry_CCR <= to_Carry_CCR_var;
    
  END PROCESS;  
  
END ARCHITECTURE Behavior;

