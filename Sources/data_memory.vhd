----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 13:58:01
-- Design Name: 
-- Module Name: data_memory - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
  Port (addra: in STD_LOGIC_VECTOR(11 downto 0);
        dina: in STD_LOGIC_VECTOR(31 downto 0);
        wea,clk: in STD_LOGIC;
        douta: out STD_LOGIC_VECTOR(31 downto 0)
   );
end data_memory;

architecture Behavioral of data_memory is
    type data_type is array (0 to 4095)of std_logic_vector (31 downto 0);
    signal DATA : data_type :=(
    1=>x"00000064", --MEM[10]=100;
    
    
    others => (others=>'0'));
  
    
    
    
begin
    
   
    
    process (clk)
    begin
        if rising_edge(clk) then
             douta<=(others=>'0');
            if (wea='1') then
                DATA(to_integer(unsigned(addra)))<=dina;
                
            elsif (wea='0') then
                douta<=DATA(to_integer(unsigned(addra)));
            end if;
        end if;
    end process;
    
    
end Behavioral;
