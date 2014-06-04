-- Generation properties:
--   Format              : hierarchical
--   Generic mappings    : exclude
--   Leaf-level entities : direct binding
--   Regular libraries   : use library name
--   View name           : include
--   
LIBRARY lab10_RegFile_lib;
CONFIGURATION RegReadWrite_Mixed_config OF RegReadWrite IS
   FOR Mixed
      FOR ALL : Reg
         USE ENTITY lab10_RegFile_lib.Reg(Behavior);
      END FOR;
   END FOR;
END RegReadWrite_Mixed_config;
