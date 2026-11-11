----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2026 15:04:37
-- Design Name: 
-- Module Name: instruction_fetch - Behavioral
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

entity instruction_fetch is
    Port (  pc_in: in STD_LOGIC_VECTOR(11 downto 0);
            clk, pc_load, rst: in STD_LOGIC; --pc_load controlled by FSM
            dina: in STD_LOGIC_VECTOR (31 downto 0);
            wea: in STD_LOGIC_VECTOR(0 downto 0); --controlled by FSM, enables writing in Instruction Memory
            next_pc,curr_pc: out STD_LOGIC_VECTOR(11 downto 0);
            instruction: out STD_LOGIC_VECTOR(31 downto 0)
            
            );
end instruction_fetch;

architecture Behavioral of instruction_fetch is
    
    signal pc_out: STD_LOGIC_VECTOR (11 downto 0); --output of the PC_MEM
    signal addra: STD_LOGIC_VECTOR(9 downto 0);-- -- <=pc(11 down to 2)
    
begin

    PC_MEM: entity work.PC_Memory port map (pc_in =>pc_in, pc_out=>pc_out, load_en=>pc_load, clk_pc=>clk, rst=>rst );
    PC_adder: entity work.pc_adder port map (pc_in_adder=>pc_out, pc_out_adder=>next_pc);
    Instruction_MEM: entity work.instruction_memory port map (addra=>addra, wea=>wea,
     dina=>dina, clka=>clk, douta=>instruction); 
    curr_pc<=pc_out;
    addra<=pc_out(11 downto 2);
    
end Behavioral;
