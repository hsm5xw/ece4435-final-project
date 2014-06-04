--
-- VHDL Architecture lab10_RegFile_lib.Decoder.Behavior
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 23:12:41 04/ 8/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;

ENTITY Decoder IS
    GENERIC( size: positive := 4);  -- 16 registers available
    PORT( sel: IN std_logic_vector(size-1 downto 0) := (others=>'0');
          onehot: OUT std_logic_vector( (2**size)-1 downto 0 );
          enable: IN std_logic);
          
END ENTITY Decoder;

ARCHITECTURE Behavior OF Decoder IS
  BEGIN
    PROCESS(sel, enable)
      VARIABLE selection: natural;
      VARIABLE result: std_logic_vector( (2**size)-1 downto 0 );
      CONSTANT zero: std_logic_vector( (2**size)-1 downto 0 ) := (others=> '0');
    
      BEGIN
        result := zero;
        IF(enable = '1') THEN
          selection := to_integer( ieee.numeric_std.unsigned(sel) );
          result(selection) := '1';
        END IF;
        onehot <= result;
    END PROCESS;
END ARCHITECTURE Behavior;

