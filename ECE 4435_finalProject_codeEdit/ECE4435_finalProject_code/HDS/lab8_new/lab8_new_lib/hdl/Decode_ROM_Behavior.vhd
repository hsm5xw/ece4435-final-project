--
-- VHDL Architecture lab8_new_lib.Decode_ROM.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 14:18:05 03/28/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
--
-- VHDL Architecture lab_8_lib.ROM.synth
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 10:44:11 03/28/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Decode_ROM IS
  GENERIC( output_length: POSITIVE := 24);           -- output length n
  PORT(    inst: IN STD_LOGIC_VECTOR(15 downto 0);   -- 16-bit input
           Decode_ROM_Out: OUT STD_LOGIC_VECTOR(output_length-1 downto 0));
END ENTITY Decode_ROM;

--
ARCHITECTURE Behavior OF Decode_ROM IS

SIGNAL Testing_opcode: std_logic_vector(2 downto 0);

BEGIN
  PROCESS(ALL) 
    VARIABLE Decode_ROM_opcode: std_logic_vector(2 downto 0) := (OTHERS => '0');  -- 3 bit opcode( bit 15-13 )
  
  BEGIN
    
    Decode_ROM_opcode := inst(15 downto 13);
    Testing_opcode <= Decode_ROM_opcode;
    
    CASE  Decode_ROM_opcode IS
      
        -- LD  
        when "001" => Decode_ROM_Out <= 
                                        "0"  &                            -- Extra Decode Control (from error fixes bit 23)
                                        "10" &                            -- Register Tracker Control (op1, op2) (bit 22-21)
                                        "1" &                             -- Write Back Register Control (bit 20)
                                        "1"  & "0" &                      -- Memory Stage Control (bits 19-18), 2 bit
                                        "0" & "0" & "00" &                -- Additional Execute Control (bits 17-14), 4bit    
                                        "0" & "1001" & "00" & "0" & "0" & -- Execute Control (bits 13-5), 9-bit
                                        "0" & "00" & "00";                -- Decode Control (bits 4-0), 5-bit

        
        -- ST
        when "010" => Decode_ROM_Out <= 
                                        "0"  &                            -- Extra Decode Control (from error fixes)
                                        "01" &                            -- Register Tracker Control (op1, op2) 
                                        "0" &                             -- Write Back Register Control
                                        "0"  & "1" &                      -- Memory Stage Control 
                                        "0" & "0" & "00" &                -- Additional Execute Control 
                                        "0" & "1001" & "00" & "0" & "0" & -- Execute Control 
                                        "0" & "00" & "00";                -- Decode Control 

        
        -- MOV
        when "011" => Decode_ROM_Out <= 
                                        "0"  &                            -- Extra Decode Control (from error fixes)
                                        "10" &                            -- Register Tracker Control (op1, op2) 
                                        "1" &                             -- Write Back Register Control
                                        "0"  & "0" &                      -- Memory Stage Control 
                                        "0" & "0" & "00" &                -- Additional Execute Control 
                                        "1" & "1111" & "00" & "0" & "0" & -- Execute Control 
                                        "0" & "00" & "00";                -- Decode Control 

        
        -- LIL, LIH
        when "100" => 
                      if( inst(8) = '0') then
                          Decode_ROM_Out <=                           
                                              "0"  &                            -- Extra Decode Control (from error fixes)
                                              "00" &                            -- Register Tracker Control (op1, op2) 
                                              "1" &                             -- Write Back Register Control
                                              "0"  & "0" &                      -- Memory Stage Control                      
                                              "0" & "0" & "00" &                -- Additional Execute Control 
                                              "1" & "1111" & "00" & "0" & "0" & -- Execute Control 
                                              "0" & "01" & "00";                -- Decode Control 

                      elsif( inst(8) = '1') then
                           Decode_ROM_Out <=  
                                              "0"  &                            -- Extra Decode Control (from error fixes)
                                              "01" &                            -- Register Tracker Control (op1, op2) 
                                              "1" &                             -- Write Back Register Control
                                              "0"  & "0" &                      -- Memory Stage Control 
                                              "0" & "0" & "00" &                -- Additional Execute Control 
                                              "1" & "1111" & "00" & "0" & "0" & -- Execute Control 
                                              "0" & "10" & "00";                -- Decode Control 
                    
                      end if;  

        -- JMP, JAL
        when "110" => 
                      if( inst(8) = '0') then
                          Decode_ROM_Out <=     
                                              "0"  &                            -- Extra Decode Control (from error fixes)                       
                                              "10" &                            -- Register Tracker Control (op1, op2) 
                                              "0" &                             -- Write Back Register Control
                                              "0"  & "0" &                      -- Memory Stage Control 
                                              "1" & "0" & "00" &                -- Additional Execute Control 
                                              "0" & "1001" & "00" & "0" & "0" & -- Execute Control 
                                              "1" & "00" & "10";                -- Decode Control 

                      elsif( inst(8) = '1') then
                           Decode_ROM_Out <=  
                                              "0"  &                            -- Extra Decode Control (from error fixes)
                                              "10" &                            -- Register Tracker Control (op1, op2) 
                                              "1" &                             -- Write Back Register Control
                                              "0"  & "0" &                      -- Memory Stage Control   
                                              "1" & "1" & "00" &                -- Additional Execute Control
                                              "0" & "1001" & "00" & "0" & "0" & -- Execute Control 
                                              "1" & "00" & "10";                -- Decode Control 
               
                      end if;  
         
        -- Branches
        when "111" => 
                      -- BR
                      if( inst(12 downto 9) = "0000" ) then    
                          Decode_ROM_Out <=       
                                            "0"  &                              -- Extra Decode Control (from error fixes)
                                            "00" &                              -- Register Tracker Control (op1, op2) 
                                            "0" &                               -- Write Back Register Control
                                            "0"  & "0" &                        -- Memory Stage Control        
                                            "1" & "0" & "00" &                  -- Additional Execute Control 
                                            "0" & "1001" & "00" & "0" &  "1" &  -- Execute Control 
                                            "0" & "01" & "11";                  -- Decode Control 
                                            
                      -- BC, BO, BN, BZ                 
                      else Decode_ROM_Out <=       
                                            "0"  &                              -- Extra Decode Control (from error fixes)
                                            "00" &                              -- Register Tracker Control (op1, op2) 
                                            "0" &                               -- Write Back Register Control
                                            "0"  & "0" &                        -- Memory Stage Control        
                                            "0" & "0" & "00" &                  -- Additional Execute Control 
                                            "0" & "1001" & "00" & "0" &  "1" &  -- Execute Control 
                                            "0" & "01" & "11";                  -- Decode Control 
                                        
                      end if;
          
        -- NOP
        when "000" => Decode_ROM_Out <= 
                                        "0"  &                                   -- Extra Decode Control (from error fixes)
                                        "00" &                                   -- Register Tracker Control (op1, op2)
                                        "0" &                                    -- Write Back Register Control
                                        "0"  & "0" &                             -- Memory Stage Control      
                                        "0" & "0" & "00" &                       -- Additional Execute Control   
                                        "0" & "0000" & "00" & "0" & "0" &        -- Execute Control 
                                        "0" & "00" & "00";                       -- Decode Control 
   
        
        when others => Decode_ROM_Out <= (OTHERS => 'X'); -- ignore otherwise  
    
    END CASE;
  
  END PROCESS;
  
END ARCHITECTURE Behavior;

