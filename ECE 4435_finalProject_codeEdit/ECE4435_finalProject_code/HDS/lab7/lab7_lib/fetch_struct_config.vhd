-- Generation properties:
--   Format              : hierarchical
--   Generic mappings    : exclude
--   Leaf-level entities : direct binding
--   Regular libraries   : use library name
--   View name           : include
--   
LIBRARY lab7_lib;
CONFIGURATION fetch_struct_config OF fetch IS
   FOR struct
      FOR ALL : Fetch_FSM
         USE ENTITY lab7_lib.Fetch_FSM(FSM);
      END FOR;
   END FOR;
END fetch_struct_config;
