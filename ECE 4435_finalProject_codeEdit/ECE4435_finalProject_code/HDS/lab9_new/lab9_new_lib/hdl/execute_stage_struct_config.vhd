-- Generation properties:
--   Format              : hierarchical
--   Generic mappings    : exclude
--   Leaf-level entities : direct binding
--   Regular libraries   : use library name
--   View name           : include
--   
LIBRARY lab9_new_lib;
CONFIGURATION execute_stage_struct_config OF execute_stage IS
   FOR struct
      FOR ALL : mini_ALU
         USE ENTITY lab9_new_lib.mini_ALU(struct);
      END FOR;
      FOR ALL : mini_Shifter
         USE ENTITY lab9_new_lib.mini_Shifter(Behavior);
      END FOR;
   END FOR;
END execute_stage_struct_config;
