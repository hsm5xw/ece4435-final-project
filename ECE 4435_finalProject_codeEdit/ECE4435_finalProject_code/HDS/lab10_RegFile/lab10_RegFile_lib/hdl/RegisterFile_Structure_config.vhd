-- Generation properties:
--   Format              : hierarchical
--   Generic mappings    : exclude
--   Leaf-level entities : direct binding
--   Regular libraries   : use library name
--   View name           : include
--   
LIBRARY lab10_RegFile_lib;
CONFIGURATION RegisterFile_Structure_config OF RegisterFile IS
   FOR Structure
      FOR ALL : Decoder
         USE ENTITY lab10_RegFile_lib.Decoder(Behavior);
      END FOR;
      FOR RegArray
         FOR ALL : RegReadWrite
            USE CONFIGURATION lab10_RegFile_lib.RegReadWrite_Mixed_config;
         END FOR;
      END FOR;
   END FOR;
END RegisterFile_Structure_config;
