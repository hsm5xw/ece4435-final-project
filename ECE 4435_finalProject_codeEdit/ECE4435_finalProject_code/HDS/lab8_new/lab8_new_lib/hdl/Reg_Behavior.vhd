--
-- VHDL Architecture lab8_new_lib.Reg.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 12:18:44 03/28/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Reg IS
    GENERIC(size: positive := 16);
    PORT( d: IN std_logic_vector (size-1 downto 0);                   -- input
          q: OUT std_logic_vector (size-1 downto 0) := (others=>'0'); -- output
          clock, e: IN std_logic); -- clock, enable
END ENTITY Reg;

ARCHITECTURE Behavior OF Reg IS
    BEGIN
        PROCESS(clock)
        BEGIN
            IF(rising_edge(clock) and e='1') THEN
                q <= d;
            END IF;
        END PROCESS;
END ARCHITECTURE Behavior;
