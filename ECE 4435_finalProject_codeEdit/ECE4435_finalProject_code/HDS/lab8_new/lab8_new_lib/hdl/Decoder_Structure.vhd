--
-- VHDL Architecture lab8_new_lib.Decoder.Structure
--
-- Created:
--          by - Hong.UNKNOWN (HSM)
--          at - 12:10:03 03/28/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Decode_stage IS
  
  GENERIC( n:           POSITIVE := 24;       -- control output length
           n_toExecute: POSITIVE := 16        -- control output length, sent to the execute stage
         ); 
  
  PORT( inst, pcval:        IN std_logic_vector(15 downto 0);     -- from Fetch Stage
    
        A0, A1:             OUT std_logic_vector(3 downto 0);     -- To Register File
        RD0, RD1:           IN std_logic_vector(15 downto 0);     -- From Register File
        
        L, R:               OUT std_logic_vector(15 downto 0);    -- To Execute Stage
        Control:            OUT std_logic_vector(n_toExecute-1 downto 0);
        
        Dest:               OUT std_logic_vector(3 downto 0);    
        Extra:              OUT std_logic_vector(15 downto 0);
        decode_pcval_out:   OUT std_logic_vector(15 downto 0); 
        
        dependsOn_op1:      OUT std_logic;    -- whether the decoded instruction depends on the Register corresponding to operand 1
        dependsOn_op2:      OUT std_logic;    -- whether the decoded instruction depends on the Register corresponding to operand 2
        RegWrite_current:   OUT std_logic;    -- Register WriteBack enable value for the current instruction decoded
        
        clock:              IN  std_logic;
        stall:              IN  std_logic;
        jump:               IN  std_logic;
        can_move_on:        IN  std_logic
        );
        
END ENTITY Decode_stage;

--
ARCHITECTURE Structure OF Decode_stage IS

  -- IR (Instruction Register)
  SIGNAL IR_Out: std_logic_vector(15 downto 0);

  -- pcval (program counter Register)
  SIGNAL pcval_Out: std_logic_vector(15 downto 0);

  -- ALU ROM
  SIGNAL ALU_ROM_Out: std_logic_vector(n-1 downto 0);
  
  -- Decode ROM
  SIGNAL Decode_ROM_Out: std_logic_vector(n-1 downto 0);
  
  -- Choose_ROM_MUX
  SIGNAL Choose_ROM_MUX_Out: std_logic_vector(n-1 downto 0);
  SIGNAL Intermediate_Control: std_logic_vector(n-1 downto 0);
  
  -- A0 MUX
  SIGNAL A0_MUX_Control: std_logic;        		      -- 1 bit MUX control
  SIGNAL A0_MUX_Out: std_logic_vector(3 downto 0); -- 4 bit out
  
  -- L MUX
  SIGNAL L_MUX_Control: std_logic_vector(1 downto 0); -- 2 bit MUX control
  
  SIGNAL L_MUX_In_0: std_logic_vector(15 downto 0);
  SIGNAL L_MUX_In_1: std_logic_vector(15 downto 0);
  SIGNAL L_MUX_In_2: std_logic_vector(15 downto 0);
  SIGNAL L_MUX_In_3: std_logic_vector(15 downto 0);
  
  -- R MUX
  SIGNAL R_MUX_Control: std_logic_vector(1 downto 0); -- 2 bit MUX control
  
  SIGNAL R_MUX_In_0: std_logic_vector(15 downto 0);
  SIGNAL R_MUX_In_1: std_logic_vector(15 downto 0);
  SIGNAL R_MUX_In_2: std_logic_vector(15 downto 0);
  SIGNAL R_MUX_In_3: std_logic_vector(15 downto 0);
  
  -- Dest MUX
  SIGNAL fourteen_signal: std_logic_vector(3 downto 0) := "1110";
  SIGNAL Dest_MUX_Out:    std_logic_vector(3 downto 0);
  
  
  -- **************** MISC ***********************
  SIGNAL IS_ALUShiftOp: std_logic;
  SIGNAL IS_SUB_Control: std_logic;
  SIGNAL load_enable: std_logic;
  
  
BEGIN
  
  load_enable <= ( not( stall ) ) and can_move_on;
  
  -- IR (Instruction Register)
  IR_Register: ENTITY work.Reg(Behavior)
    GENERIC MAP(size=> 16) 
    PORT MAP(d=>inst, q=>IR_Out, clock=> clock, e=> load_enable );
  
  -- pcval (program counter Register)
  pcval_Register: ENTITY work.Reg(Behavior)
    GENERIC MAP(size=> 16)
    PORT MAP(d=>pcval, q=>pcval_Out, clock=>clock, e=> load_enable);
  
             
  -- ALU Decode ROM
  ALU_ROM1: ENTITY work.ALU_ROM(Behavior)
      GENERIC MAP(output_length=> n)
      PORT MAP(inst => IR_Out, ALU_ROM_Out => ALU_ROM_Out );
  
  -- Decode ROM (opcode)
  Decode_ROM1: ENTITY work.Decode_ROM(Behavior)
      GENERIC MAP(output_length=> n)
      PORT MAP(inst=> IR_Out, Decode_ROM_Out=> Decode_ROM_Out);
 
   -- ********* Decide whether to use ALU_ROM or Decode_ROM
  IS_ALUShiftOp <= '1' when IR_Out(15 downto 13) = "101" 
                   else '0';
 
  Choose_ROM_MUX: ENTITY work.SimpleMux2(Behavior)
    GENERIC MAP(width=> n)
    PORT MAP(Data_In_0 => Decode_ROM_Out, Data_In_1 => ALU_ROM_Out, mux_control => Is_ALUShiftOp,
             Data_Out  => Choose_ROM_MUX_Out);
             
  -- ********** CONTROL OUTPUT COMING OUT !!!!!!!!           
  Intermediate_Control <= (others => '0') when (stall = '1' or jump = '1') -- send a 'nop' if stall or jump is detected
                           else Choose_ROM_MUX_Out;                        
                          
  -- A0 MUX
  A0_MUX_Control <= Intermediate_Control(4);  -- **************************************************************************
  
  A0_MUX: ENTITY work.SimpleMux2(Behavior)
    GENERIC MAP(width=>4) -- 4 bit
    PORT MAP(Data_In_0 => IR_Out(8 downto 5), Data_In_1 => IR_Out(12 downto 9), mux_control => A0_MUX_Control,
             Data_Out  => A0);
             
  -- A1
  A1 <= IR_Out(12 downto 9);             
  
  -- L MUX
  L_MUX_In_0 <= RD0;
  L_MUX_In_1 <= ( 7 downto 0 => IR_Out(7) ) & IR_Out(7 downto 0);
  L_MUX_In_2 <= IR_Out(7 downto 0) & RD1(7 downto 0) ; 
  L_MUX_In_3 <= RD1;
  
  L_MUX_Control <= Intermediate_Control(3 downto 2); -- *********************************************************************
  
  L_MUX: ENTITY work.SimpleMux4(Behavior)
    GENERIC MAP(width=>16) -- 16 bit
    PORT MAP(Data_In_0 => L_MUX_In_0, Data_In_1 => L_MUX_In_1, Data_In_2 => L_MUX_In_2, Data_In_3 => L_MUX_In_3, mux_control => L_MUX_Control,
             Data_Out  => L);
          
   -- R MUX       
  R_MUX_In_0 <= (10 downto 0 => '0') & IR_Out(4 downto 0);
  
  R_In_1_MUX: ENTITY work.SimpleMux2(Behavior)
    GENERIC MAP(width=> 16) -- 16 bit
    PORT MAP(Data_In_0 => RD1, Data_In_1 => RD0, mux_control => Intermediate_Control(23),  -- IS_SUB_Control
             Data_Out  => R_MUX_In_1);
  
  R_MUX_In_2 <= ( 7 downto 0 => IR_Out(7) ) & IR_Out(7 downto 0);
  R_MUX_In_3 <= pcval_out;
  
  R_MUX_Control <= Intermediate_Control(1 downto 0);  -- **********************************************************************
             
  R_MUX: ENTITY work.SimpleMux4(Behavior)
    GENERIC MAP(width=>16) -- 16 bit
    PORT MAP(Data_In_0 => R_MUX_In_0 , Data_In_1 => R_MUX_In_1, Data_In_2 => R_MUX_In_2, Data_In_3 => R_MUX_In_3, mux_control => R_MUX_Control,
             Data_Out  => R);
    
   -- Dest MUX
  Dest_MUX: ENTITY work.SimpleMux2(Behavior)
    GENERIC MAP(width=> 4) -- 4 bit
    PORT MAP(Data_In_0 => IR_Out(12 downto 9), Data_In_1 => fourteen_signal, mux_control => Intermediate_Control(16), -- ***** IS_JAL
             Data_Out  => Dest_MUX_Out); 
   
  Dest <= Dest_MUX_Out;           
   
  -- Extra
  Extra <= RD1;   
   
  -- pcval_out
  decode_pcval_out <= pcval_out;
  
  -- Outputs to Register Tracker
  dependsOn_op1    <= Intermediate_Control(22);
  dependsOn_op2    <= Intermediate_Control(21);
  RegWrite_current <= Intermediate_Control(20);
   
  -- Control
  Control <= Intermediate_Control(20 downto 5); -- **********************************************************************
  
END ARCHITECTURE Structure;

