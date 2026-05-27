----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 14:39:11
-- Design Name: 
-- Module Name: top_CPU - Behavioral
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

entity top_CPU is
  Port ( clk,rst: in STD_LOGIC;
        led_debug: out STD_LOGIC_VECTOR (15 downto 0));
end top_CPU;

architecture Behavioral of top_CPU is

    signal pc_in, next_pc_if, curr_pc_if: STD_LOGIC_VECTOR(11 downto 0):=(others=>'0');
    signal instruction, dina_ireg, rd_value, immediate, rs1_value, rs2_value, next_pc_32, curr_pc_32: STD_LOGIC_VECTOR(31 downto 0);
    signal alu_pre_result, alu_result, pc_out: STD_LOGIC_VECTOR (31 downto 0);
    signal pc_load, rd_write_en,a ,b, f7,branch_cond, mem_we: STD_LOGIC;
    signal wea_ireg: STD_LOGIC_VECTOR(0 downto 0);
    signal op_class: STD_LOGIC_VECTOR(4 downto 0);
    signal cond_opcode, alu_opcode: STD_LOGIC_VECTOR(2 downto 0);
    
    

begin

    INSTRUCTION_FETCH: entity work.instruction_fetch port map (pc_in=>pc_in, pc_load=>pc_load, clk=>clk, dina=>dina_ireg,
        next_pc=>next_pc_if, curr_pc=>curr_pc_if, instruction=>instruction, rst=>rst, wea=>wea_ireg);

    INSTRUCTION_DECODE: entity work.instruction_decode port map (instruction=>instruction, rd_write_en=>rd_write_en, 
        rd_value=>rd_value, op_class=>op_class, clk=>clk, alu_opcode=>alu_opcode, a=>a, b=>b,
        cond_opcode=> cond_opcode, immediate=>immediate, rs1_value=>rs1_value, rs2_value=>rs2_value, f7=>f7);

    INSTRUCTION_EXECUTE: entity work.instruction_execute port map (rs1_value=>rs1_value, rs2_value=>rs2_value,
        cond_opcode=>cond_opcode, curr_pc=>curr_pc_32, a=>a, b=>b, immediate=>immediate, alu_opcode=>alu_opcode, 
        clk=>clk, branch_cond=>branch_cond, alu_pre_result=>alu_pre_result, alu_result=>alu_result, f7=>f7);
    MEMORY_WRITE_BACK: entity work.memory_write_back port map (branch_cond=>branch_cond, next_pc=>next_pc_32,
        alu_result=>alu_result, op_class=>op_class, alu_pre_result=>alu_pre_result, rs2_value=>rs2_value,
        mem_we=>mem_we, clk=>clk, pc_out=>pc_out, rd_value=>rd_value);
        
   CPU_FSM: entity work.CPU_FSM port map (clk=>clk, res=>rst, op_class=>op_class, pc_load=>pc_load,
            rd_write_en=>rd_write_en, mem_we=>mem_we); 
    
    next_pc_32 <= std_logic_vector(resize(signed(next_pc_if), 32));
    curr_pc_32 <= std_logic_vector(resize(signed(curr_pc_if), 32));
    pc_in<=pc_out(11 downto 0);
    led_debug <= pc_out(15 downto 0); 
    
end Behavioral;
