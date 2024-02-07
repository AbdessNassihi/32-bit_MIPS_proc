----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 08:07:36 PM
-- Design Name: 
-- Module Name: register_file_VHDL - Behavioral
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


-- enitity declaration: defining the the input and output ports of this sub-module
entity register_file_VHDL is
    Port ( clk : in STD_LOGIC; -- clock that triggers the logic
           rst : in STD_LOGIC; -- reset signal
           reg_write_en : in STD_LOGIC; -- indicates if we have to write the data to the 'write register'
           reg_write_dest : in STD_LOGIC_VECTOR (4 downto 0); -- the register 'number' where the data has to be written
           reg_write_data : in STD_LOGIC_VECTOR (31 downto 0);  -- data that will be put inside the 'write register'
           reg_read_addr_1 : in STD_LOGIC_VECTOR (4 downto 0); -- the first register 'number' where the data will be read from
           reg_read_data_1 : out STD_LOGIC_VECTOR (31 downto 0); -- content of the first register
           reg_read_addr_2 : in STD_LOGIC_VECTOR (4 downto 0); -- the second register 'number' where the data will be read from
           reg_read_data_2 : out STD_LOGIC_VECTOR (31 downto 0)); -- content of the second register
end register_file_VHDL;

architecture Behavioral of register_file_VHDL is -- architecture declaration: specifying the behaviour of this sub-module
type reg_type is array (0 to 31 ) of std_logic_vector (31 downto 0);  -- type defining the register file, wich has 32 register of 32 bits
signal reg_array: reg_type; -- signal of the type 'reg_type' that represents the register file
begin
 process(clk,rst) 
 begin
 if(rst='1') then -- 'clearing' the content of the registers when rst is '1'
   reg_array(0) <= x"00000001";
   reg_array(1) <= x"00000002";
   reg_array(2) <= x"00000003";
   reg_array(3) <= x"00000004";
   reg_array(4) <= x"00000005";
   reg_array(5) <= x"00000006";
   reg_array(6) <= x"00000007";
   reg_array(7) <= x"00000008";
   reg_array(8) <= x"00000009";
   reg_array(9) <= x"0000000A";
   reg_array(10) <= x"0000000B";
   reg_array(11) <= x"0000000C";
   reg_array(12) <= x"0000000D";
   reg_array(13) <= x"0000000E";
   reg_array(14) <= x"0000000F";
   reg_array(15) <= x"00000010";
   reg_array(16) <= x"00000011";
   reg_array(17) <= x"00000012";
   reg_array(18) <= x"00000013";
   reg_array(19) <= x"00000014";
   reg_array(20) <= x"00000015";
   reg_array(21) <= x"00000016";
   reg_array(22) <= x"00000017";
   reg_array(23) <= x"00000018";
   reg_array(24) <= x"00000019";
   reg_array(25) <= x"0000001A";
   reg_array(26) <= x"0000001B";
   reg_array(27) <= x"0000001C";
   reg_array(28) <= x"0000001D";
   reg_array(29) <= x"0000001E";
   reg_array(30) <= x"0000001F";
   reg_array(31) <= x"00000020";
 elsif(rising_edge(clk)) then -- process triggered on rising edge of the clock
   if(reg_write_en='1') then -- when the instruction includes the writing of the result to the 'write regster'
    reg_array(to_integer(unsigned(reg_write_dest))) <= reg_write_data; -- writing the data to the correct register in the register file
   end if;
 end if;
 end process;
-- assigning the content of the first register to the output port variable after checking if it is not the first register wich is typically the 'zero register'
 reg_read_data_1 <= x"00000000" when reg_read_addr_1 = "00000" else reg_array(to_integer(unsigned(reg_read_addr_1)));
  -- assigning the content of the second register to the output port variable after checking if it is not the first register wich is typically the 'zero register'
 reg_read_data_2 <= x"00000000" when reg_read_addr_2 = "00000" else reg_array(to_integer(unsigned(reg_read_addr_2)));

end Behavioral;
