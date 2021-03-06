--
-- VHDL Architecture lab11_RegisterTracker_lib.Reg.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 12:27:15 04/18/2014
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
          c,e, reset: IN std_logic);
END ENTITY Reg;

ARCHITECTURE Behavior OF Reg IS
    BEGIN
        PROCESS(c)
        BEGIN
            IF(rising_edge(c)) THEN
                IF(reset = '1') THEN
                  q <= (others=>'0');
                ELSIF(e = '1') THEN
                  q <= d;
                END IF;
            END IF;
        END PROCESS;
END ARCHITECTURE Behavior;

