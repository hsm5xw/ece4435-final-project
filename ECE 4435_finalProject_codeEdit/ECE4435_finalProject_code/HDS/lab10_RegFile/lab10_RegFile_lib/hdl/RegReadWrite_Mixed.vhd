--
-- VHDL Architecture lab10_RegFile_lib.RegReadWrite.Mixed
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 07:16:57 04/ 9/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY RegReadWrite IS
    GENERIC( size: positive := 16);
    PORT( D: IN std_logic_vector(size-1 downto 0);        -- Write Data
          Q0, Q1: OUT std_logic_vector(size-1 downto 0 ); -- Data read outputs
          read0, read1: IN std_logic;                     -- read select
          c,load: IN std_logic);                          -- clock, load enable

END ENTITY RegReadWrite;

ARCHITECTURE Mixed Of RegReadWrite IS
    SIGNAL QVAL: std_logic_vector(size-1 downto 0);
    CONSTANT HiZ: std_logic_vector(size-1 downto 0) := (others => 'Z');

    BEGIN
        STORE: ENTITY work.Reg(Behavior)
            GENERIC MAP(size => size)
            PORT MAP(d=>D, q=> QVAL, c=>c, e=>load);
        
        Q0 <= QVAL WHEN read0 ='1' ELSE HiZ;
        Q1 <= QVAL WHEN read1 ='1' ELSE HiZ;
        
END ARCHITECTURE; 



