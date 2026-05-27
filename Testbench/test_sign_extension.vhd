----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2026 14:05:44
-- Design Name: 
-- Module Name: test_sign_extension - Behavioral
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

entity test_sign_extension is
--  Port ( );
end test_sign_extension;

architecture Behavioral of test_sign_extension is
    signal instruction, immediate: STD_LOGIC_VECTOR(31 downto 0);
    signal clk: STD_LOGIC;
    signal sim_running : boolean := true; -- used to stop the clock
begin

    g1: entity work.sign_extension port map (immediate=>immediate, instruction=>instruction, clk=>clk);
    
    clk_process : process is
    begin
    while sim_running loop
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end loop;
    wait;
end process clk_process;

sign_extension_process : process is
    begin
    instruction<=x"00000793"; --Li a5,0
    wait for 30 ns; 
    instruction<=x"3e800693"; --li a3,1000
    wait for 30 ns;
    instruction<=x"00052703"; --lw a4,0(a0)
    wait for 30 ns;
    instruction<=x"00f70733"; --add a4,a4,a5;
    wait for 30ns;
    instruction<=x"00e52023"; --sw a4,0a4
    wait for 30ns;  
    instruction<=x"00178793"; --addi a5,a5,1    
    wait for 30ns;
    instruction<=x"00450513"; --addi a0,a0,4
    wait for 30ns;
    instruction<=x"fed796e3"; --bne a5,a3,loop(-20)
    wait for 30ns;
    instruction<=x"01c00aef"; --jal x21, +28
    wait for 30 ns;
    sim_running<=false;
    wait;
end process sign_extension_process;
    
    
    
    
end Behavioral;
