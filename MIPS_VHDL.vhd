----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 08:07:36 PM
-- Design Name: 
-- Module Name: MIPS_VHDL - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- importing the necessary libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- enitity declaration: defining the the input and output ports of the top-module
entity MIPS_VHDL is
    Port ( clk : in STD_LOGIC; -- clock that triggers the logic
           reset : in STD_LOGIC; -- the reset signal for the different sub-modules
           pc_out : out STD_LOGIC_VECTOR (31 downto 0); -- output of the top-module, the current program counter
           alu_result : out STD_LOGIC_VECTOR (31 downto 0)); -- output of the top-module, the result of the ALU operation
end MIPS_VHDL;

architecture Behavioral of MIPS_VHDL is

 signal pc_current: std_logic_vector(31 downto 0); -- signal that keeps track which intruction is being executed
 signal pc_next,pc2: std_logic_vector(31 downto 0); -- signal that keeps track wich instruction will be excuted next
 signal instr: std_logic_vector(31 downto 0); -- signal containig the 32 bit instruction 
 signal reg_dst,mem_to_reg: std_logic_vector(1 downto 0); -- signals for the control unit
 signal jump,branch,mem_read,mem_write,alu_src,reg_write: std_logic;
 signal reg_write_dest: std_logic_vector(4 downto 0); -- location of register in the register file in wich the data will be written
 signal reg_write_data: std_logic_vector(31 downto 0); -- data that has to be put inside the 'write register'
 signal reg_read_addr_1: std_logic_vector(4 downto 0); -- location of the first register in the register file in wich we read the content
 signal reg_read_data_1: std_logic_vector(31 downto 0); -- content read from the first register 
 signal reg_read_addr_2: std_logic_vector(4 downto 0); -- location of the second register in the register file in wich we read the content
 signal reg_read_data_2: std_logic_vector(31 downto 0); -- content read from the second register
 signal sign_ext_im,read_data2,zero_ext_im,imm_ext: std_logic_vector(31 downto 0); -- second operand for the ALU
 signal shamt: std_logic_vector(4 downto 0); -- amount of shifts in case of a shift operation
 signal JRControl: std_logic; -- indicates if it is a jump instruction
 signal ALU_Control,alu_op: std_logic_vector(2 downto 0); -- output from the ALU control
 signal ALU_out: std_logic_vector(31 downto 0); -- result of the ALU
 signal zero_flag: std_logic; -- for indicating if the result of the operation is zero
 signal im_shift_2, PC_j, PC_beq, PC_4beq, PC_4bne, PC_4beqj,PC_jr: std_logic_vector(31 downto 0); -- keeps track of the instruction to be executed after the branch
 signal beq_control,bne_control: std_logic; -- indicates of it is beq or bne instruction
 signal jump_shift_2: std_logic_vector(27 downto 0); -- signal for determining the adress where we will have to jump, in case of a jump instruction
 signal mem_read_data: std_logic_vector(31 downto 0); -- data read from the specified adress in the data memory
 signal no_sign_ext: std_logic_vector(31 downto 0); -- immadiate value in two's complement
 signal sign_or_zero: std_logic; -- signal indicating if we have to extend with the MSB of the adress or immediate value in case of I-format instruction
 signal tmp1: std_logic_vector(15 downto 0);
begin
-- PC of the MIPS Processor in VHDL
process(clk,reset)
begin 
 if(reset='1') then  -- if reset has been pressed go back to first instruction
  pc_current <= x"00000000";
 elsif(rising_edge(clk)) then -- Process triggered on rising edge of the clock
  pc_current <= pc_next; -- assigning to the signal the 'position' of the next intruction to be executed
 end if;
end process;
-- PC + 2 
  pc2 <= pc_current + x"00000004"; -- calulating the postion of the next instruction: adding 4 because it is byte adressed and a full instruction is 32 bit
  
-- instruction memory of the MIPS Processor in VHDL: importing the sub-module 'data memory'
Instruction_Memory: entity work.Instruction_Memory_VHDL 
        port map -- assigning the signals to the input and output ports
       (
        pc=> pc_current,
        instruction => instr -- signal 'instr' receives the value at output port of this sub-module
        );
-- jump shift left 2
 jump_shift_2 <= instr(25 downto 0) & "00"; -- in case of jump type instruction, getting the bits representing the target adress
 
 
-- control unit of the MIPS Processor in VHDL: importing the sub-module 'ALU control'
control: entity work.control_unit_VHDL
   port map -- assigning the signals to the input and output ports
   (reset => reset,
    opcode => instr(31 downto 26),
    reg_dst => reg_dst,
    mem_to_reg => mem_to_reg,
    alu_op => alu_op,
    jump => jump,
    branch => branch,
    mem_read => mem_read,
    mem_write => mem_write,
    alu_src => alu_src,
    reg_write => reg_write,
    sign_or_zero => sign_or_zero
    );
-- multiplexer regdest: to determine wich bits represent the register where data has to be written // it depends on the type of the format: R, I or J
  reg_write_dest <= "11111" when  reg_dst= "10" else
        instr(15 downto 11) when  reg_dst= "01" else -- R-format instruction
        instr(20 downto 16); -- I-format instruction
        
-- register file instantiation of the MIPS Processor in VHDL: bits representing the source registers, same for the different types of instructions
 reg_read_addr_1 <= instr(25 downto 21);
 reg_read_addr_2 <= instr(20 downto 16);
 
  -- register file of the MIPS Processor in VHDL: importing the sub-module 'register file'
register_file: entity work.register_file_VHDL
 port map -- assigning the signals to the input and output ports
 (
 clk => clk,
 rst => reset,
 reg_write_en => reg_write,
 reg_write_dest => reg_write_dest,
 reg_write_data => reg_write_data,
 reg_read_addr_1 => reg_read_addr_1,
 reg_read_data_1 => reg_read_data_1,
 reg_read_addr_2 => reg_read_addr_2,
 reg_read_data_2 => reg_read_data_2
 );
-- sign extend: exetending the number of bits to 32 for the immediate value or adress in an I-format instruction
 tmp1 <= (others => instr(15)); -- duplicating the MSB
 sign_ext_im <=  tmp1 & instr(15 downto 0); -- doing the sign extension
 zero_ext_im <= "0000000000000000"& instr(15 downto 0); -- exentding with zeros
 imm_ext <= sign_ext_im when sign_or_zero='1' else zero_ext_im; -- determining if we have to extend with the MSB or with zeros based on the signal 'sign_or_zero' coming from the control unit
-- JR control unit of the MIPS Processor in VHDL
 JRControl <= '1' when ((alu_op="000") and (instr(3 downto 0)="001000")) else '0'; -- checking if the instruction is a jump instruction
 
-- ALU control unit of the MIPS Processor in VHDL: importing the sub-module 'ALU control unit'
ALUControl: entity work.ALU_Control_VHDL port map -- assigning the signals to the input and output ports
  (
   ALUOp => alu_op,
   ALU_Funct => instr(2 downto 0),
   ALU_Control => ALU_Control
   );
   
-- multiplexer alu_src: to determine if the second operand is a register (for R-format instruction) or immediate value (for I-format instruction)
 read_data2 <= imm_ext when alu_src='1' else reg_read_data_2;
 shamt <= instr(10 downto 6); -- getting the amount of shifts in case of a R-instruction
 
-- ALU unit of the MIPS Processor in VHDL: importing the sub-module 'ALU'
alu: entity work.ALU_VHDL port map -- assigning the signals to the input and output ports
  (
   a => reg_read_data_1,
   b => read_data2,
   SHAMT => shamt,
   alu_control => ALU_Control,
   alu_result => ALU_out,
   zero => zero_flag
   );
-----------------------------------------------------------------------------------------------------

-- In this part the next instruction to be executed is determined base on the type instruction
 im_shift_2 <= imm_ext(29 downto 0) & "00";
 no_sign_ext <= (not im_shift_2) + x"00000001";
-- PC beq add
 PC_beq <= (pc2 - no_sign_ext) when im_shift_2(31) = '1' else (pc2 +im_shift_2);
-- beq control
   beq_control <= branch and zero_flag;
-- PC_beq
   PC_4beq <= PC_beq when beq_control='1' and instr(31 downto 26) = "000110"  else pc2;
-- bne control
    bne_control <= branch and not zero_flag;
-- PC_bne
    PC_4bne <= PC_beq when bne_control = '1' and instr(31 downto 26) = "001001"  else PC_4beq;
-- PC_j
 PC_j <= pc2(31 downto 28) & jump_shift_2;
-- PC_4beqj
 PC_4beqj <= PC_j when jump = '1' else  PC_4bne;
-- PC_jr
 PC_jr <= reg_read_data_1;
-- PC_next
 pc_next <= PC_jr when (JRControl='1') else PC_4beqj;
 -------------------------------------------------------------------------------------------------------
 
-- data memory of the MIPS Processor in VHDL: importing the sub-module 'data memory'
data_memory: entity work.Data_Memory_VHDL port map  -- assigning the signals to the input and output ports
  (
  clk => clk,
  mem_access_addr => ALU_out,
  mem_write_data => reg_read_data_2,
  mem_write_en => mem_write,
  mem_read => mem_read,
  mem_read_data => mem_read_data
  );
-- write back of the MIPS Processor in VHDL
 reg_write_data <= pc2 when (mem_to_reg = "10") else
       mem_read_data when (mem_to_reg = "01") else ALU_out;
-- output
 pc_out <= pc_current;
 alu_result <= ALU_out;

end Behavioral;
