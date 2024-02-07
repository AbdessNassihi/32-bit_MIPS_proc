----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 08:07:36 PM
-- Design Name: 
-- Module Name: Instruction_Memory_VHDL - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- enitity declaration: defining the the input and output ports of the top-module
entity Instruction_Memory_VHDL is
    Port ( pc : in STD_LOGIC_VECTOR (31 downto 0); -- register that keeps track which intruction is being executed
           instruction : out STD_LOGIC_VECTOR (31 downto 0)); -- 32 bit instruction
end Instruction_Memory_VHDL;



architecture Behavioral of Instruction_Memory_VHDL is -- architecture declaration: specifying the behaviour of this sub-module
signal rom_addr: std_logic_vector(3 downto 0); -- signal for selecting the instruction to be executed


-- faculteit berekenen

-- lw $2,0($0)
-- addi $0,$3,1
-- addi $0,$1,1
-- LOOP: mul $1,$1,$3
-- addi $3,$3,1
-- bne $2,$3,LOOP
-- mul $1,$1,$3
-- sw $0, 0($1)

 type ROM_type is array (0 to 15 ) of std_logic_vector(31 downto 0); -- type representing the instruction memory
 constant rom_data: ROM_type:=( -- instructions to be executed
   "00010000000000100000000000000000",
   "00011100000000110000000000000001",
   "00011100000000010000000000000001",
   "00000000001000110000100000000101",
   "00011100011000110000000000000001",
   "00100100010000111111111111111101",
   "00000000001000110000100000000101",
   "00010100000000010000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000"
  );
begin

 rom_addr <= pc(5 downto 2); -- assigning the value of the program counter to 'rom_addr'
  instruction <= rom_data(to_integer(unsigned(rom_addr))) when pc < x"00000040" else x"00000000"; -- selecting the instruction based on the content of the program counter

end Behavioral;