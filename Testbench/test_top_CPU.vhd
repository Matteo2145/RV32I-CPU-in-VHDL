----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.05.2026 08:14:06
-- Design Name: 
-- Module Name: test_top_CPU - Behavioral
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
use work.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_top_CPU is
--  Port ( );
end test_top_CPU;

architecture Behavioral of test_top_CPU is

    signal clk,rst: STD_LOGIC;
    signal sim_running: boolean :=true; 

begin
    
    g1: entity work.top_CPU port map (clk=>clk, rst=>rst);

    clk_process : process is
    begin
        while sim_running loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process clk_process;
    
    top_CPU: process is
    begin
        
        rst<='1';
        wait for 20 ns;
        rst<='0';
        wait for 1000 ns;
        
        
        
        
    end process top_CPU;


end Behavioral;
