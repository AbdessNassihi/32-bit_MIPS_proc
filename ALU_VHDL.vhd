----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 08:07:36 PM
-- Design Name: 
-- Module Name: ALU_VHDL - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


-- enitity declaration: defining the the input and output ports of this sub-module
entity ALU_VHDL is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0); -- first operand
           b : in STD_LOGIC_VECTOR (31 downto 0); -- second operand
           alu_control : in STD_LOGIC_VECTOR (2 downto 0); -- signal comming from the ALU_CONTROL that tells wich instruction has to be executed
           SHAMT : in std_logic_vector(4 downto 0); --  give the amount of shifts for shift operations
           alu_result : out STD_LOGIC_VECTOR (31 downto 0); -- result of the ALU operation
           zero : out STD_LOGIC); -- Zero Flag, used for the branch instructions
end ALU_VHDL;

architecture Behavioral of ALU_VHDL is -- architecture declaration: specifying the behaviour of this sub-module
signal result: std_logic_vector(31 downto 0); -- signal that will contain the result of the ALU operation

begin
process(alu_control,a,b)
variable product: std_logic_vector(63 downto 0);
begin
 case alu_control is  -- switch case to determine wich operation has to be executed, based on the 'alu_control'
 when "000" =>
  result <= a + b; -- add
 when "001" =>
  result <= a - b; -- sub
 when "010" => 
  result <= a and b; -- and
 when "011" =>
  result <= a or b; -- or
 when "100" => -- slt
  if (a<b) then
   result <= x"00000001";
  else 
   result <= x"00000000";
  end if;
  when "101" => -- mult
    product := (others => '0');
    product:= a * b;
    result <= product(31 downto 0);
  when "110" => -- xor
    result <= a xor b;
  when "111" => -- sll
    result <=  std_logic_vector(shift_left(unsigned(a), TO_INTEGER(unsigned(SHAMT))));
  when others =>
    result <= a + b;  
  end case;
end process;
  zero <= '1' when result=x"00000000" else '0'; -- sets the zero flag to one if the result is 0
  alu_result <= result; -- assigning the result to the output port variable 'alu_result'
end Behavioral;
