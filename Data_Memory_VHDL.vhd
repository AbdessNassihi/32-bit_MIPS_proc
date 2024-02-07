----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2023 08:07:36 PM
-- Design Name: 
-- Module Name: Data_Memory_VHDL - Behavioral
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
entity Data_Memory_VHDL is
    Port ( 
           clk: in std_logic; -- clock that triggers the logic
           mem_access_addr : in STD_LOGIC_VECTOR (31 downto 0); -- adress in the data memory where we want to read or write
           mem_write_data : in STD_LOGIC_VECTOR (31 downto 0); -- data that we want to store at the specified adress in the memory
           mem_write_en : in STD_LOGIC; -- indicates whether it is a read or write operation
           mem_read : in STD_LOGIC;
           mem_read_data : out STD_LOGIC_VECTOR (31 downto 0)); -- data read from the specified adress, typically for a load instruction
end Data_Memory_VHDL;

architecture Behavioral of Data_Memory_VHDL is -- architecture declaration: specifying the behaviour of this sub-module
--signal i: integer;
signal ram_addr: std_logic_vector(12 downto 0); -- this signal represents the adress in the data memory(like index)
--type data_mem is array (0 to 32767 ) of std_logic_vector (7 downto 0);
type data_mem is array (0 to 8191 ) of std_logic_vector (31 downto 0); -- type defining the data memory
signal RAM: data_mem :=( 0 => x"00000004", others => (others=>'0')); -- signal of the type 'data_mem' that represents the data memory, it is also initialized with all zeros withe exception of the first one

begin

 ram_addr <= mem_access_addr(14 downto 2); -- assigning the adress kept in 'mem_acces_addr' to the signal 'ram_addr'
 process(clk)
 begin
  if(rising_edge(clk)) then -- Process triggered on rising edge of the clock
  if (mem_write_en='1') then -- checking if it is a write operation
  RAM(to_integer(unsigned(ram_addr))) <= mem_write_data; -- writing the data kept in 'mem_write_data' at the adress 'ram_addr'
  end if;
  end if;
 end process;
   mem_read_data <= RAM(to_integer(unsigned(ram_addr))) when (mem_read='1') else x"00000000"; -- Output the data from RAM when it is a read operation, else output four times '0000'

end Behavioral;