----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2026 11:42:46
-- Design Name: 
-- Module Name: PC_Memory - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_Memory is
Port ( pc_in: in STD_LOGIC_VECTOR(11 downto 0);
       load_en, rst: in STD_LOGIC;
       clk_pc: in STD_LOGIC;
       pc_out: out STD_LOGIC_VECTOR(11 downto 0) :=(others=>'0')
    );
end PC_Memory;

architecture Behavioral of PC_Memory is
    
    signal pc: STD_LOGIC_VECTOR(11 downto 0):=(others=>'0');
    
begin
    
    pc_out<=pc;
    process(clk_pc) begin
        
        
            
        
       if rising_edge(clk_pc) then
            if (rst = '1') then
                pc <= (others => '0'); -- Synchronous Reset
            elsif (load_en = '1') then
                pc <= pc_in;           -- Load the new PC
            end if;
        end if;    
    end process;



end Behavioral;
