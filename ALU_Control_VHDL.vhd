----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 08:07:36 PM
-- Design Name: 
-- Module Name: ALU_Control_VHDL - Behavioral
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
entity ALU_Control_VHDL is
    Port ( ALU_Control : out STD_LOGIC_VECTOR (2 downto 0); -- output to the ALU to determine wich operation has to be executed
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0); -- input coming from control unit
           ALU_Funct : in STD_LOGIC_VECTOR (2 downto 0)); -- taking the last three bits of R-format instruction(operand is zero)
end ALU_Control_VHDL;

architecture Behavioral of ALU_Control_VHDL is -- architecture declaration: specifying the behaviour of this sub-module
begin
process(ALUOp,ALU_Funct)
begin
case ALUOp is --switch case to determine what has to be given to the output port, based on the 'ALUOp'
when "000" => 
 ALU_Control <= ALU_Funct(2 downto 0);
when "001" => 
 ALU_Control <= "001";
when "010" => 
 ALU_Control <= "100";
when "011" => 
 ALU_Control <= "000";
 when "100"=>
 ALU_Control <= "010";
when others => ALU_Control <= "000";
end case;
end process;
end Behavioral;
