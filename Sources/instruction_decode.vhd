----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2026 14:14:43
-- Design Name: 
-- Module Name: instruction_decode - Behavioral
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

entity instruction_decode is
  Port ( instruction, rd_value: in STD_LOGIC_VECTOR(31 downto 0);
        clk, rd_write_en: in STD_LOGIC;
        rs1_value, rs2_value, immediate: out STD_LOGIC_VECTOR(31 downto 0);
        op_class: out STD_LOGIC_VECTOR(4 downto 0);
        alu_opcode, cond_opcode: out STD_LOGIC_VECTOR(2 downto 0); 
        a,b,f7: out STD_LOGIC   
  );
end instruction_decode;

architecture Behavioral of instruction_decode is

    
begin

    Register_File: entity work.Register_file port map (rd=>instruction(11 downto 7), rs1=>instruction(19 downto 15),
        rs2=>instruction(24 downto 20), we=>rd_write_en, clk=>clk, rd_value=>rd_value,rs1_value=>rs1_value,
        rs2_value=>rs2_value);
    Decode: entity work.decode port map (instruction=>instruction,clk=>clk, op_class=>op_class, alu_opcode=>alu_opcode, a=>a, b=>b, 
        cond_opcode=>cond_opcode,f7=>f7);
        
    Sign_Extension: entity work.sign_extension port map (instruction=>instruction, immediate=>immediate, clk=>clk);
    



end Behavioral;
