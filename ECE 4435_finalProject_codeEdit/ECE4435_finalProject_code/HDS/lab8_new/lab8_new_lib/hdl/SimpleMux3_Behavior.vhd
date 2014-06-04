--
-- VHDL Architecture lab8_new_lib.SimpleMux3.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 15:08:24 03/28/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY SimpleMux3 IS
  
  GENERIC(width: POSITIVE := 16);
  PORT( Data_In_0, Data_In_1, Data_In_2: IN std_logic_vector(width-1 downto 0);
        Data_Out: OUT std_logic_vector(width-1 downto 0);
        mux_control: IN std_logic_vector(1 downto 0) );
END ENTITY SimpleMux3;

--
ARCHITECTURE Behavior OF SimpleMux3 IS
BEGIN
  PROCESS(all) 
  BEGIN
    
      CASE mux_control IS
        when "00" =>   Data_Out <= Data_In_0;
        when "01" =>   Data_Out <= Data_In_1;
        when "10" =>   Data_Out <= Data_In_2;  
        when others => Data_Out <= (others=>'X');
      END CASE;
      
  END PROCESS;
END ARCHITECTURE Behavior;
