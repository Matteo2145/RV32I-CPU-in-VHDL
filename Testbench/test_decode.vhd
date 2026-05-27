----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2026 10:31:41
-- Design Name: 
-- Module Name: test_decode - Behavioral
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

entity test_decode is
--  Port ( );
end test_decode;

architecture Behavioral of test_decode is
    signal instruction: STD_LOGIC_VECTOR (31 downto 0);
    signal function3: STD_LOGIC_VECTOR (2 downto 0);
    signal function7, opcode: STD_LOGIC_VECTOR(6 downto 0);
    signal op_class: STD_LOGIC_VECTOR(4 downto 0);
    signal clk,a,b: STD_LOGIC;
    signal alu_opcode,cond_opcode: STD_LOGIC_VECTOR(2 downto 0);
    signal sim_running : boolean := true; -- used to stop the clock
   
    
begin

    g1: entity work.decode port map (function3=>function3, function7=>function7, opcode=>opcode,
        op_class=>op_class, a=>a, b=>b, alu_opcode=>alu_opcode, cond_opcode=>cond_opcode, 
        clk=>clk);
        
    function3<=instruction(14 downto 12);
    function7<=instruction(31 downto 25); 
    opcode<=instruction(6 downto 0); 
       
      
clk_process : process is
    begin
    while sim_running loop
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end loop;
    wait;
end process clk_process;

decode_process : process is
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
end process decode_process;





end Behavioral;
