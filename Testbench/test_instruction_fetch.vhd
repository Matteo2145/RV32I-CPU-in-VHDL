----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2026 09:30:21
-- Design Name: 
-- Module Name: test_instruction_fetch - Behavioral
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

entity test_instruction_fetch is
--  Port ( );
end test_instruction_fetch;

architecture Behavioral of test_instruction_fetch is
    signal pc_in, next_pc, curr_pc: STD_LOGIC_VECTOR (11 downto 0);
    signal clk,pc_load, rst: STD_LOGIC;
    signal wea: STD_LOGIC_VECTOR(0 downto 0);
    signal instruction, dina: STD_LOGIC_VECTOR(31 downto 0);
    signal sim_running : boolean := true; -- used to stop the clock
    --signal next_to_in: STD_LOGIC_VECTOR (11 downto 0):=(others=>'0');
begin

    g1: entity work.instruction_fetch port map (pc_in=>pc_in, next_pc=>next_pc, curr_pc=>curr_pc,
        clk=>clk, pc_load=>pc_load, wea=>wea, instruction=>instruction, dina=>dina, rst=>rst);
    pc_in<=next_pc;  
 clk_process : process is
begin

    while sim_running loop
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end loop;
    wait;
end process clk_process;

instr_fetch : process is
begin
    --initialization
    rst<='1';
    pc_load<='0';
    
    wea<="0";
    dina<=(others=>'0');
    
    
    wait for 25 ns;
    rst<='0';
    pc_load<='1';
    wait for 10 ns;
    pc_load<='0'; 
    wait for 20 ns;
    pc_load<='1';
    wait for 10 ns;
    pc_load<='0'; 
    wait for 20 ns;
    sim_running<=false;
    wait;
    
end process instr_fetch;

    


   

end Behavioral;
