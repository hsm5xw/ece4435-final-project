-- Generation properties:
--   Format              : hierarchical
--   Generic mappings    : exclude
--   Leaf-level entities : direct binding
--   Regular libraries   : use library name
--   View name           : include
--   
LIBRARY lab11_RegisterTracker_lib;
CONFIGURATION RegisterFile_Tracker_Structure_config OF RegisterFile_Tracker IS
   FOR Structure
      FOR ALL : Processor
         USE ENTITY lab11_RegisterTracker_lib.Processor(Behavior);
      END FOR;
      FOR ALL : Reg
         USE ENTITY lab11_RegisterTracker_lib.Reg(Behavior);
      END FOR;
   END FOR;
END RegisterFile_Tracker_Structure_config;
