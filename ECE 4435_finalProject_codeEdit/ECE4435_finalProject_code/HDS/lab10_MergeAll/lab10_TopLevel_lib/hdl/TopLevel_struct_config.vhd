-- Generation properties:
--   Format              : hierarchical
--   Generic mappings    : exclude
--   Leaf-level entities : direct binding
--   Regular libraries   : use library name
--   View name           : include
--   
LIBRARY lab10_RegFile_lib;
LIBRARY lab10_WriteBack_Stage_lib;
LIBRARY lab10_memory_stage_lib;
LIBRARY lab11_MemoryArbiter_lib;
LIBRARY lab11_RegisterTracker_lib;
LIBRARY lab12_Memory_lib;
LIBRARY lab7_lib;
LIBRARY lab8_new_lib;
LIBRARY lab9_new_lib;
CONFIGURATION TopLevel_struct_config OF TopLevel IS
   FOR struct
      FOR ALL : Decode_stage
         USE CONFIGURATION lab8_new_lib.Decode_stage_Structure_config;
      END FOR;
      FOR ALL : MemoryArbiter
         USE ENTITY lab11_MemoryArbiter_lib.MemoryArbiter(struct);
      END FOR;
      FOR ALL : RegisterFile
         USE CONFIGURATION lab10_RegFile_lib.RegisterFile_Structure_config;
      END FOR;
      FOR ALL : RegisterFile_Tracker
         USE CONFIGURATION lab11_RegisterTracker_lib.RegisterFile_Tracker_Structure_config;
      END FOR;
      FOR ALL : SRAM
         USE ENTITY lab12_Memory_lib.SRAM(behavior);
      END FOR;
      FOR ALL : execute_stage
         USE CONFIGURATION lab9_new_lib.execute_stage_struct_config;
      END FOR;
      FOR ALL : fetch_stage
         USE CONFIGURATION lab7_lib.fetch_stage_struct_config;
      END FOR;
      FOR ALL : lab10_WriteBack_Stage
         USE ENTITY lab10_WriteBack_Stage_lib.lab10_WriteBack_Stage(struct);
      END FOR;
      FOR ALL : memory_stage
         USE ENTITY lab10_memory_stage_lib.memory_stage(struct);
      END FOR;
   END FOR;
END TopLevel_struct_config;
