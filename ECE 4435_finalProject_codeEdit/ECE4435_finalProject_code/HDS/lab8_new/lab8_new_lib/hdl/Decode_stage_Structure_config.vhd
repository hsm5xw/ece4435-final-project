-- Generation properties:
--   Format              : hierarchical
--   Generic mappings    : exclude
--   Leaf-level entities : direct binding
--   Regular libraries   : use library name
--   View name           : include
--   
LIBRARY lab8_new_lib;
CONFIGURATION Decode_stage_Structure_config OF Decode_stage IS
   FOR Structure
      FOR ALL : ALU_ROM
         USE ENTITY lab8_new_lib.ALU_ROM(Behavior);
      END FOR;
      FOR ALL : Decode_ROM
         USE ENTITY lab8_new_lib.Decode_ROM(Behavior);
      END FOR;
      FOR ALL : Reg
         USE ENTITY lab8_new_lib.Reg(Behavior);
      END FOR;
      FOR ALL : SimpleMux2
         USE ENTITY lab8_new_lib.SimpleMux2(Behavior);
      END FOR;
      FOR ALL : SimpleMux3
         USE ENTITY lab8_new_lib.SimpleMux3(Behavior);
      END FOR;
      FOR ALL : SimpleMux4
         USE ENTITY lab8_new_lib.SimpleMux4(Behavior);
      END FOR;
   END FOR;
END Decode_stage_Structure_config;
