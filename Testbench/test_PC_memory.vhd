----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2026 11:03:28
-- Design Name: 
-- Module Name: test_PC_memory - Behavioral
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

entity test_PC_memory is
--  Port ( );
end test_PC_memory;

architecture Behavioral of test_PC_memory is
    signal  pc_in: STD_LOGIC_VECTOR(11 downto 0);
    signal  load_en: STD_LOGIC;
    signal  clk_pc: STD_LOGIC;
    signal  pc: STD_LOGIC_VECTOR(11 downto 0);
    signal sim_running : boolean := true; -- used to stop the clock
begin

    g1: entity work.PC_memory port map (pc_in => pc_in, load_en =>load_en,
    clk_pc=>clk_pc, pc=>pc
     );

    clk_process: process is
        begin
            while sim_running loop
                clk_pc <= '0'; wait for 5 ns;
                clk_pc <= '1'; wait for 5 ns;
            end loop;
        wait;
    end process clk_process;
    
    pc_process: process is
        begin
            load_en<='0';
            wait for 40 ns;
            load_en<='1';
            pc_in<="000000000100";
            wait for 20 ns;
            pc_in<=(3=>'1', others=>'0');
            sim_running<=false;
            wait;
    end process pc_process;   

end Behavioral;
