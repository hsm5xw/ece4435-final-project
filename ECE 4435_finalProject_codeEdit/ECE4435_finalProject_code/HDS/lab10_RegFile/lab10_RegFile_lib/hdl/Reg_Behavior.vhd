--
-- VHDL Architecture lab10_RegFile_lib.Reg.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 22:38:44 04/ 8/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Reg IS
    GENERIC(size: positive := 16);
    PORT( d: IN std_logic_vector (size-1 downto 0);
          q: OUT std_logic_vector (size-1 downto 0) := (others=>'0');
          c,e: IN std_logic);
END ENTITY Reg;

ARCHITECTURE Behavior OF Reg IS
    BEGIN
        PROCESS(c)
        BEGIN
            IF(rising_edge(c) and e='1') THEN
                q <= d;
            END IF;
        END PROCESS;
END ARCHITECTURE Behavior;
