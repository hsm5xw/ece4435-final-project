--
-- VHDL Architecture lab8_new_lib.SimpleMux2.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 15:07:21 03/28/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY SimpleMux2 IS
  
  GENERIC(width: POSITIVE := 16);
  PORT( Data_In_0, Data_In_1: IN std_logic_vector(width-1 downto 0);
        Data_Out: OUT std_logic_vector(width-1 downto 0);
        mux_control: IN std_logic);
END ENTITY SimpleMux2;

--
ARCHITECTURE Behavior OF SimpleMux2 IS
BEGIN
  PROCESS(Data_In_0, Data_In_1, mux_control) 
  BEGIN
      IF(mux_control = '0') THEN
        Data_Out <= Data_In_0;
        
      ELSIF(mux_control = '1') THEN
        Data_Out <= Data_In_1;
        
      ELSE
        Data_Out <= (others=>'X');
        
      END IF;
  END PROCESS;
END ARCHITECTURE Behavior;
