----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 08:07:36 PM
-- Design Name: 
-- Module Name: control_unit_VHDL - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- enitity declaration: defining the the input and output ports of this sub-module  
entity control_unit_VHDL is
    Port ( opcode : in STD_LOGIC_VECTOR (5 downto 0); -- first six bits of the instruction
           reset : in STD_LOGIC; -- reset signal
           -- signals send to data memory,ALU,ALU control,register file,... 
           reg_dst : out STD_LOGIC_VECTOR (1 downto 0);
           mem_to_reg : out STD_LOGIC_VECTOR (1 downto 0);
           alu_op : out STD_LOGIC_VECTOR (2 downto 0);
           jump : out STD_LOGIC;
           branch : out STD_LOGIC;
           mem_read : out STD_LOGIC;
           mem_write : out STD_LOGIC;
           alu_src : out STD_LOGIC;
           reg_write : out STD_LOGIC;
           sign_or_zero : out STD_LOGIC);
end control_unit_VHDL;

architecture Behavioral of control_unit_VHDL is -- architecture declaration: specifying the behaviour of this sub-module
begin
process(reset,opcode)
begin
 if(reset = '1') then -- when reset is '1' we want to restore the signals
   reg_dst <= "00";
   mem_to_reg <= "00";
   alu_op <= "000";
   jump <= '0';
   branch <= '0';
   mem_read <= '0';
   mem_write <= '0';
   alu_src <= '0';
   reg_write <= '0';
   sign_or_zero <= '1';
 else -- if it is not the case we put the signals to '1' based on the different possible opcodes
 case opcode is
  when "000000" => -- add
    reg_dst <= "01";
    mem_to_reg <= "00";
    alu_op <= "000";
    jump <= '0';
    branch <= '0';
    mem_read <= '0';
    mem_write <= '0';
    alu_src <= '0';
    reg_write <= '1';
    sign_or_zero <= '1';
  when "000001" => -- sliu
   reg_dst <= "00";
   mem_to_reg <= "00";
   alu_op <= "010";
   jump <= '0';
   branch <= '0';
   mem_read <= '0';
   mem_write <= '0';
   alu_src <= '1';
   reg_write <= '1';
   sign_or_zero <= '0';
  when "000010" => -- j
   reg_dst <= "00";
   mem_to_reg <= "00";
   alu_op <= "000";
   jump <= '1';
   branch <= '0';
   mem_read <= '0';
   mem_write <= '0';
   alu_src <= '0';
   reg_write <= '0';
   sign_or_zero <= '1';
 when "000011" =>-- jal
   reg_dst <= "10";
   mem_to_reg <= "10";
   alu_op <= "000";
   jump <= '1';
   branch <=  '0';
   mem_read <=  '0';
   mem_write <=  '0';
   alu_src <= '0';
   reg_write <=  '1';
   sign_or_zero <= '1';
 when "000100" =>-- lw
   reg_dst <= "00";
   mem_to_reg <= "01";
   alu_op <= "011";
   jump <= '0';
   branch <= '0';
   mem_read <= '1';
   mem_write <= '0';
   alu_src <= '1';
   reg_write <= '1';
   sign_or_zero <= '1';
 when "000101" => -- sw
   reg_dst <= "00";
   mem_to_reg <= "00";
   alu_op <= "011";
   jump <= '0';
   branch <= '0';
   mem_read <= '0';
   mem_write <= '1';
   alu_src <= '1';
   reg_write <= '0';
   sign_or_zero <= '1';
 when "000110" => -- beq
   reg_dst <= "00";
   mem_to_reg <= "00";
   alu_op <= "001";
   jump <= '0';
   branch <= '1';
   mem_read <= '0';
   mem_write <= '0';
   alu_src <= '0';
   reg_write <= '0';
   sign_or_zero <= '1';
 when "000111" =>-- addi
   reg_dst <= "00";
   mem_to_reg <= "00";
   alu_op <= "011";
   jump <= '0';
   branch <= '0';
   mem_read <= '0';
   mem_write <= '0';
   alu_src <= '1';
   reg_write <= '1';
   sign_or_zero <= '1';
when "001000" => -- andi
    reg_dst <= "00";
    mem_to_reg <= "00";
    alu_op <= "100";
    jump <='0';
    branch <= '0';
    mem_read <='0';
    mem_write <='0';
    alu_src <= '1';
    reg_write <= '1';
    sign_or_zero <= '1';
 when "001001" => -- bne
    reg_dst <= "00";
    mem_to_reg <= "00";
    alu_op <= "001";
    jump <= '0';
    branch <= '1';
    mem_read <= '0';
    mem_write <= '0';
    alu_src <= '0';
    reg_write <= '0';
    sign_or_zero <= '1';
 when others =>   
    reg_dst <= "01";
    mem_to_reg <= "00";
    alu_op <= "000";
    jump <= '0';
    branch <= '0';
    mem_read <= '0';
    mem_write <= '0';
    alu_src <= '0';
    reg_write <= '1';
    sign_or_zero <= '1';
 end case;
 end if;
end process;

end Behavioral;
