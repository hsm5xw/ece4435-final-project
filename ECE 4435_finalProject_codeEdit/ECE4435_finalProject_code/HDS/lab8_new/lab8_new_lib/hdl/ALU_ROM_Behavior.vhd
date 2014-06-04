--
-- VHDL Architecture lab8_new_lib.ALU_ROM.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 14:20:24 03/28/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ALU_ROM IS
  GENERIC( output_length: POSITIVE := 24);           -- output length n
  
  PORT(   inst: IN STD_LOGIC_VECTOR(15 downto 0);     -- input instruction
          ALU_ROM_Out: OUT STD_LOGIC_VECTOR(output_length-1 downto 0));
          
END ENTITY ALU_ROM;

--
ARCHITECTURE Behavior of ALU_ROM IS
 
    SIGNAL isShift: std_logic := '0'; 
    SIGNAL alu_opcode: std_logic_vector(2 downto 0) := (OTHERS => '0');
    
  BEGIN  
  PROCESS(ALL)
  
  BEGIN
    
    isShift <= inst(3);
    alu_opcode <= inst(2 downto 0); 
    
    -- ALU operations
    if( isShift = '0' ) then 
      
      CASE alu_opcode IS
      
        -- ADD (0)  -- refering to inst 3-0 bits
        when "000" => ALU_ROM_Out <=  
                                     "0"  &                               -- Extra Decode Control (from error fixes bit 23)                                
                                     "11" &                               -- Register Tracker Control (op1, op2) (bit 22-21)
                                     "1"  &                               -- Write Back Register control  (1 bit)
                                     "0"  & "0" &                         -- Memory Stage Control (bits 19-18) (2 bit)
                                     "0" & "0" & "11" &                   -- Additional Execute Control (bits 17-14), 4 bit                                
                                     "0" & "1001" & "00" & "0" & "0" &    -- Execute Control (bits 13-5), 9-bit
                                     "0" & "00" & "01";                   -- Decode Control (bits 4-0), 5-bit
                                     
        -- ADC (1)
        when "001" => ALU_ROM_Out <=                                     
                                      "0"  &                              -- Extra Decode Control (from error fixes bit 23) 
                                      "11" &                              -- Register Tracker Control (op1, op2) 
                                      "1" &                               -- Write Back Register Control
                                      "0"  & "0" &                        -- Memory Stage Control
                                      "0" & "0" & "11" &                  -- Additional Execute Control
                                      "0" & "1001" & "01" & "0" & "0" &   -- Execute Stage Control
                                      "0" & "00" & "01";                  -- Decode Stage Control 
                                      
                                      
        
        -- SUB (2)
        when "010" => ALU_ROM_Out <=                                  
                                     "1"  &                               -- Extra Decode Control (from error fixes bit 23) 
                                     "11" &                               -- Register Tracker Control (op1, op2) 
                                     "1" &                                -- Write Back Register Control
                                     "0"  & "0" &                         -- Memory Stage Control
                                     "0" & "0" & "11" &                   -- Additional Execute Control
                                     "0" & "0110" & "10" & "0" & "0" &    -- Execution Stage Control
                                     "0" & "11" & "01";                   -- Decode Stage Control
                                     
                                     
          
        -- SBC (3)
        when "011" => ALU_ROM_Out <=                                 
                                     "1"  &                               -- Extra Decode Control (from error fixes bit 23) 
                                     "11" &                               -- Register Tracker Control (op1, op2) 
                                     "1" &                                -- Write Back Register Control
                                     "0"  & "0" &                         -- Memory Stage Control
                                     "0" & "0" & "11" &                   -- Additional Execute Control
                                     "0" & "0110" & "11" & "0" & "0" &    -- Execution Stage Control
                                     "0" & "11" & "01";                   -- Decode Stage Control
                                     
                                     
        
        -- AND (4)
        when "100" => ALU_ROM_Out <=                                    
                                     "0"  &                               -- Extra Decode Control (from error fixes bit 23) 
                                     "11" &                               -- Register Tracker Control (op1, op2) 
                                     "1" &                                -- Write Back Register Control
                                     "0"  & "0" &                         -- Memory Stage Control
                                     "0" & "0" & "00" &                   -- Additional Execute Control
                                     "1" & "1110" & "00" & "0" & "0" &    -- Execution Stage
                                     "0" & "00" & "01";                   -- Decode Stage Control
                                     
        
        -- OR (5)
        when "101" => ALU_ROM_Out <=                                    
                                     "0"  &                               -- Extra Decode Control (from error fixes bit 23) 
                                     "11" &                               -- Register Tracker Control (op1, op2) 
                                     "1" &                                -- Write Back Register Control 
                                     "0"  & "0" &                         -- Memory Stage Control
                                     "0" & "0" & "00" &                   -- Additional Execute Control  
                                     "1" & "1011" & "00" & "0" & "0" &    -- Execution Stage
                                     "0" & "00" & "01";                   -- Decode Stage Control
                                        
          
        -- XOR (6)
        when "110" => ALU_ROM_Out <=                                     
                                     "0"  &                               -- Extra Decode Control (from error fixes bit 23) 
                                     "11" &                               -- Register Tracker Control (op1, op2) 
                                     "1" &                                -- Write Back Register Control
                                     "0"  & "0" &                         -- Memory Stage Control
                                     "0" & "0" & "00" &                   -- Additional Execute Control
                                     "1" & "1001" & "00" & "0" & "0" &    -- Execution
                                     "0" & "00" & "01";                   -- Decode Stage Control
 
                                     
        
        -- NOT (7)
        when "111" => ALU_ROM_Out <=                                    
                                     "0"  &                              -- Extra Decode Control (from error fixes bit 23) 
                                     "10" &                              -- Register Tracker Control (op1, op2) 
                                     "1" &                               -- Write Back Register Control                                     
                                     "0"  & "0" &                        -- Memory Stage Control
                                     "0" & "0" & "00" &                  -- Additional Execute Control
                                     "1" & "0000" & "00" & "0" & "0" &   -- Execution Stage 
                                     "0" & "00" & "01";                  -- Decode Stage Control

                                     
        
        -- ERROR
        when others => ALU_ROM_Out <= (OTHERS => 'X');   
          
      END CASE;  
  
    -- Shift operations
    elsif( isShift = '1') then
    
      CASE alu_opcode IS
        
          -- SL (8)         
          when "000" => ALU_ROM_Out <=                                                
                                          "0"  &                              -- Extra Decode Control (from error fixes bit 23) 
                                          "10" &                              -- Register Tracker Control (op1, op2) 
                                          "1" &                               -- Write Back Register Control
                                          "0"  & "0" &                        -- Memory Stage Control
                                          "0" & "0" & "00" &                  -- Additional Execute Control
                                          "0" & "1000" & "00" & "1" & "0" &   -- Execution Stage
                                          "0" & "00" & "00";                  -- Decode Stage
                                          
        
          -- SRL (9)         
          when "001" => ALU_ROM_Out <=                                          
                                          "0"  &                              -- Extra Decode Control (from error fixes bit 23) 
                                          "10" &                              -- Register Tracker Control (op1, op2) 
                                          "1" &                               -- Write Back Register Control
                                          "0"  & "0" &                        -- Memory Stage Control
                                          "0" & "0" & "00"  &                 -- Additional Execute Control
                                          "0" & "1001" & "00" & "1" & "0" &   -- Execution Stage
                                          "0" & "00" & "00";                  -- Decode Stage

        
          -- SRA (10)  
          when "010" => ALU_ROM_Out <=                                        
                                          "0"  &                              -- Extra Decode Control (from error fixes bit 23) 
                                          "10" &                              -- Register Tracker Control (op1, op2) 
                                          "1" &                               -- Write Back Register Control         
                                          "0"  & "0" &                        -- Memory Stage Control
                                          "0" & "0" & "00"  &                 -- Additional Execute Control
                                          "0" & "1010" & "00" & "1" & "0" &   -- Execution Stage
                                          "0" & "00" & "00";                  -- Decode Stage

        
        -- RRA (14)   -- **** comment: they're weird  
        when "110" => ALU_ROM_Out   <=                                            
                                          "0"  &                              -- Extra Decode Control (from error fixes bit 23) 
                                          "10" &                              -- Register Tracker Control (op1, op2) 
                                          "1" &                               -- Write Back Register Control
                                          "0"  & "0" &                        -- Memory Stage Control
                                          "0" & "0" & "10"  &                 -- Additional Execute Control
                                          "0" & "1110" & "00" & "1" & "0" &   -- Execution Stage 
                                          "0" & "00" & "00";                  -- Decode Stage

        
        -- RR  (13)   
        when "101" => ALU_ROM_Out   <=                                               
                                          "0"  &                              -- Extra Decode Control (from error fixes bit 23) 
                                          "10" &                              -- Register Tracker Control (op1, op2) 
                                          "1" &                               -- Write Back Register Control 
                                          "0"  & "0" &                        -- Memory Stage Control
                                          "0" & "0" & "10" &                  -- Additional Execute Control
                                          "0" & "1101" & "00" & "1" & "0" &   -- Execution Stage
                                          "0" & "00" & "00";                  -- Decode Stage

        
        -- RL (12)       
        when "100" => ALU_ROM_Out   <= 
                                          "0"  &                              -- Extra Decode Control (from error fixes bit 23) 
                                          "10" &                              -- Register Tracker Control (op1, op2)              
                                          "1" &                               -- Write Back Register Control      
                                          "0"  & "0" &                        -- Memory Stage Control
                                          "0" & "0" & "10"  &                 -- Additional Execute Control
                                          "0" & "1100" & "00" & "1" & "0" &   -- Execution Stage
                                          "0" & "00" & "00";                  -- Decode Stage
 
      
        -- ERROR
        when others => ALU_ROM_Out <= (OTHERS => 'X');  
        
    END CASE;
  end if;  
  
  END PROCESS;
  
END ARCHITECTURE Behavior;


