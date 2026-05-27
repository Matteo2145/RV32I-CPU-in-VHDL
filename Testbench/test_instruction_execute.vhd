----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 13:27:26
-- Design Name: 
-- Module Name: test_instruction_execute - Behavioral
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

entity test_instruction_execute is
--  Port ( );
end test_instruction_execute;

architecture Behavioral of test_instruction_execute is
   signal rs1_value, rs2_value, curr_pc, immediate:  STD_LOGIC_VECTOR(31 downto 0);
   signal     cond_opcode, alu_opcode:  STD_LOGIC_VECTOR(2 downto 0);
   signal    a,b,clk:  STD_LOGIC;
   signal     branch_cond:  STD_LOGIC;
   signal     alu_pre_result, alu_result:  STD_LOGIC_VECTOR(31 downto 0);
   signal sim_running : boolean := true; -- used to stop the clock
   
   
begin
    Instruction_Execute: entity work.instruction_execute port map (curr_pc=>curr_pc, rs1_value=>rs1_value, rs2_value=>rs2_value,
            immediate=>immediate, a=>a, b=>b, alu_opcode=>alu_opcode, clk=>clk, alu_result=>alu_result,
            alu_pre_result=>alu_pre_result, cond_opcode=>cond_opcode, branch_cond=>branch_cond);
    
    
    clk_process : process is
    begin
    while sim_running loop
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end loop;
    wait;
    end process clk_process;

    execute_process : process is 
    begin
    rs1_value<=(others=>'0');
    rs2_value<=(others=>'0');
    immediate<=(others=>'0');
    curr_pc<=(others=>'0');
    cond_opcode<="111";
    alu_opcode<="011";
    a<='0';
    b<='0';
    wait for 20 ns;-----------------------
    rs1_value<=x"0FFFFFFF";
    cond_opcode<="000"; --EQ
    wait for 40 ns;
    cond_opcode<="101"; --GE
    wait for 40 ns;
    alu_opcode<="000"; --ADD
    a<='1';
    b<='1';
    wait for 40 ns;    
    rs1_value<=x"0000F0FF";
    rs2_value<=x"00000F00";
    alu_opcode<="010";
    wait for 40 ns;
    alu_opcode<="110";
    sim_running<=false;
    wait;
    end process execute_process;

end Behavioral;
