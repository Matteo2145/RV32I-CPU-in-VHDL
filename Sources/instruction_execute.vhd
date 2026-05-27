----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 13:13:27
-- Design Name: 
-- Module Name: instruction_execute - Behavioral
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

entity instruction_execute is
  Port (rs1_value, rs2_value, curr_pc, immediate: in STD_LOGIC_VECTOR(31 downto 0);
        cond_opcode, alu_opcode: in STD_LOGIC_VECTOR(2 downto 0);
        a,b,f7,clk: in STD_LOGIC;
        branch_cond: out STD_LOGIC;
        alu_pre_result, alu_result: out STD_LOGIC_VECTOR(31 downto 0)
   );
end instruction_execute;

architecture Behavioral of instruction_execute is



begin

    COMP: entity work.comp port map (rs1_value=>rs1_value, rs2_value=>rs2_value, cond_opcode=>cond_opcode,
            clk=>clk, branch_cond=>branch_cond);
    ALU: entity work.ALU port map (curr_pc=>curr_pc, rs1_value=>rs1_value, rs2_value=>rs2_value,
            immediate=>immediate, a=>a, b=>b, alu_opcode=>alu_opcode, clk=>clk, alu_result=>alu_result,
            alu_pre_result=>alu_pre_result, f7=>f7);        




end Behavioral;
