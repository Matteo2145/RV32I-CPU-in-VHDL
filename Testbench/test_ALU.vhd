----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 11:25:25
-- Design Name: 
-- Module Name: test_ALU - Behavioral
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

entity test_ALU is
--  Port ( );
end test_ALU;

architecture Behavioral of test_ALU is
    signal curr_pc, rs1_value, immediate, rs2_value, alu_pre_result, alu_result: STD_LOGIC_VECTOR(31 downto 0);
    signal a,b,clk,f7: STD_LOGIC;
    signal alu_opcode: STD_LOGIC_VECTOR(2 downto 0);
    signal sim_running : boolean := true; -- used to stop the clock
    
begin
    
    g1: entity work.ALU port map (curr_pc=>curr_pc, rs1_value=>rs1_value, immediate=>immediate,
        rs2_value=>rs2_value, alu_pre_result=>alu_pre_result, alu_result=>alu_result, a=>a, b=>b, clk=>clk,
        alu_opcode=>alu_opcode,f7=>f7);
    
    clk_process : process is
    begin
    while sim_running loop
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end loop;
    wait;
    end process clk_process;
    
    ALU_process : process is
    
    begin
    rs1_value<=(others=>'0');
    rs2_value<=(others=>'0');
    curr_pc<=(others=>'0');
    immediate<=(others=>'0');
    a<='0';
    b<='0';
    alu_opcode<="011";
    wait for 20 ns;
    alu_opcode<="000";
    curr_pc<=x"0000000c"; --12
    immediate<=x"FFFFFFF6"; -- -10;
    wait for 20 ns;
    a<='1';
    b<='1';
    alu_opcode<="111"; --AND
    rs1_value<=x"FFFFFFFF";
    rs2_value<=x"FFFFFFFF";
    wait for 40 ns;
    alu_opcode<="110"; --OR
    wait for 40 ns;
    alu_opcode<="100"; --EXOR
    wait for 40 ns;
    rs2_value<=x"FFFFFFF0";
    wait for 40 ns;
    alu_opcode<="000";
    rs1_value<=x"7FFFFFFF";
    rs2_value<=x"7FFFFFFF";
    sim_running<=false;
    wait;
    end process ALU_process;


end Behavioral;
