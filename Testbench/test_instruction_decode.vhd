----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2026 14:36:37
-- Design Name: 
-- Module Name: test_instruction_decode - Behavioral
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

entity test_instruction_decode is
--  Port ( );
end test_instruction_decode;

architecture Behavioral of test_instruction_decode is
    signal instruction, immediate, rs1_value, rs2_value, rd_value: STD_LOGIC_VECTOR(31 downto 0);
    signal clk,rd_write_en,a,b: STD_LOGIC;
    signal op_class: STD_LOGIC_VECTOR(4 downto 0);
    signal alu_opcode, cond_opcode: STD_LOGIC_VECTOR(2 downto 0);
    signal sim_running : boolean := true; -- used to stop the clock
begin
    
    g1: entity work.instruction_decode port map (instruction=>instruction, immediate=>immediate, rs1_value=>rs1_value,
        rs2_value=>rs2_value, rd_value=>rd_value, clk=>clk, rd_write_en=>rd_write_en, a=>a, b=>b,
        op_class=>op_class, alu_opcode=>alu_opcode, cond_opcode=>cond_opcode);

clk_process : process is
    begin
    while sim_running loop
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end loop;
    wait;
end process clk_process;

instruction_decode_process: process is
    begin
    rd_write_en<='0';
    rd_value<=(others=>'0');
    instruction<=(others=>'0');
    wait for 20 ns;
    rd_write_en<='1';
    rd_value<=(others=>'0');
    instruction<=x"00000793"; --Li a5,0
    wait for 30 ns; 
    rd_value<=x"000003e8";
    instruction<=x"3e800693"; --li a3,1000
    wait for 30 ns;
    rd_write_en<='0';
   instruction<=x"fed796e3"; --bne a5,a3,loop(-20); we can reathe value in a3
                            --it should be 1000;
    wait for 30ns;
    
    
    
    
    sim_running<=false;
    wait;
end process instruction_decode_process;




end Behavioral;
