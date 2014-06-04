--
-- VHDL Architecture lab7_lib.Fetch_FSM.FSM
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 23:19:07 03/20/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Fetch_FSM IS

  PORT(clock, reset: IN std_logic;
       mdelay, stall, jump, int: IN std_logic;
       control_bus: OUT std_logic_vector( 6 downto 0 ) );  -- 7 bit control output
       
END ENTITY Fetch_FSM;

--
ARCHITECTURE FSM OF Fetch_FSM IS
  TYPE   statetype IS (S0, S1, S2);      -- reset, interrupt, normal fetch
  SIGNAL present_state: statetype := S0; 
  SIGNAL next_state: statetype;

  
BEGIN
  
  -- 1. state transition
  PROCESS(clock)                                 
  BEGIN
   
    IF(reset='1') THEN
        present_state <= S0;        
    ELSIF( rising_edge(clock) ) THEN
        present_state <= next_state;
    END If;
    
  END PROCESS;
   
  -- Priority: reset, jump, int, stall or  mdelay  
  
  -- 2. next state logic
  
  PROCESS(present_state, reset, int)
  BEGIN
          
    CASE present_state IS  
      -- Reset State
      WHEN S0 => 
          if (reset = '1') 	              then next_state <= S0;  
				  elsif(jump='0' and int = '1') 	 then next_state <= S1; 
				  else 					                           next_state <= S2;
				  end if;
	  
      -- Interrupt State             
      WHEN S1 => 
          if (reset = '1') 	              then next_state <= S0;
				  elsif(jump='0' and int = '1') 	 then next_state <= S1;
				  else 					                           next_state <= S2;
				  end if;
	 	  
      -- Normal Fetch State
      WHEN S2 => 
          if (reset = '1') 	              then next_state <= S0;
				  elsif(jump='0' and int = '1') 	 then next_state <= S1;
				  else 					                           next_state <= S2;
				  end if;
				 
      -- otherwise
      WHEN others => 
          next_state <= S0;
    END CASE;
    
  END PROCESS;

  
  -- 3. output logic

  PROCESS(all)
  
    -- *** Control Signals *** --
    VARIABLE PC_MUX_Control : std_logic_vector(1 downto 0) := "00";		   -- control for MUX before PC
    VARIABLE PC_load_Control: std_logic := '1';					                	   -- control for PC load
    VARIABLE maddr_MUX_Control: std_logic_vector(1 downto 0) := "00";   -- control for 'maddr' output
    VARIABLE inst_MUX_Control: std_logic_vector(1 downto 0) := "01";    -- control for MUX before 'inst' output
  
  BEGIN

    CASE present_state IS     
      -- Reset state (reset)
      WHEN S0 => 
				  PC_MUX_Control := "00";              	 -- address of first instruction from memory
				  PC_load_Control := '1';             	  -- load
				  maddr_MUX_Control := "00";       	    	-- memory address 0
          inst_MUX_Control := "01";  		  	       -- No op
				 			 
      -- Interrupt State (int)      
      WHEN S1 => 
				  PC_MUX_Control := "00";              	 -- address of instruction from memory address 1
				  PC_load_Control := '1';              	 -- load
				  maddr_MUX_Control := "01";       	  	  -- memory address 1
				  inst_MUX_Control := "10";  		  	       -- Special Instruction for Interrupt
				 				 
      -- Normal Fetch State
      WHEN S2 => 
				 if(jump = '1') then
					   PC_MUX_Control    := "01";			         -- jump address
					   PC_load_Control   := '1';		           -- load
					   maddr_MUX_Control := "10";		          -- pc value
					   inst_MUX_Control  := "01";			         -- No op
					
				 elsif( (stall = '1') or (mdelay  = '1') ) then
					   PC_MUX_Control    := "10";			         -- new pc value
					   PC_load_Control   := '0';		           -- disable load
					   maddr_MUX_Control := "10";			         -- pc value
					   inst_MUX_Control  := "01";			         -- No Op
				
				 else
					   PC_MUX_Control    := "10";			         -- new pc value
					   PC_load_Control   := '1';			          -- load
					   maddr_MUX_Control := "10";			         -- pc value
					   inst_MUX_Control  := "00";			         -- new instruction
				
				 end if;
				
	  -- Otherwise (Reset)
      WHEN others => 
				 PC_MUX_Control := "00";                -- address of first instruction from memory
				 PC_load_Control := '1';                -- load
				 maddr_MUX_Control := "00";     	       -- memory address 0
         inst_MUX_Control := "01";  		          -- No op

    END CASE;
    
    control_bus <=     PC_MUX_Control    &      -- 2 bit
					             PC_load_Control   &      -- 1 bit
					             maddr_MUX_Control &      -- 2 bit
					             inst_MUX_Control;	       -- 2 bit
					  
	
  END PROCESS;


END ARCHITECTURE FSM;



