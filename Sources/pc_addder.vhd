----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2026 08:47:52
-- Design Name: 
-- Module Name: pc_addder - Behavioral
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

entity pc_adder is
 Port ( pc_in_adder: in STD_LOGIC_VECTOR(11 downto 0);
        pc_out_adder: out STD_LOGIC_VECToR(11 downto 0)
         );
end pc_adder;

architecture Behavioral of pc_adder is
    
begin
    process (pc_in_adder)
    begin
    pc_out_adder<=(others=>'0');
    pc_out_adder <= STD_LOGIC_VECTOR(unsigned(pc_in_adder)+4);
    end process;
end Behavioral;
