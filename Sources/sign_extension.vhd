----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2026 09:00:37
-- Design Name: 
-- Module Name: sign_extension - Behavioral
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

entity sign_extension is
Port ( 
    instruction: in STD_LOGIC_VECTOR(31 downto 0);
    immediate: out STD_LOGIC_VECTOR(31 downto 0);
    clk: in STD_LOGIC
);
end sign_extension;

architecture Behavioral of sign_extension is
    alias opcode : STD_LOGIC_VECTOR(6 downto 0) is instruction(6 downto 0);
    signal imm: STD_LOGIC_VECTOR(31 downto 0);
begin

    process(instruction) is
    begin
        case opcode is
            -- I-type: ADDI, SLTI, ORI, XORI, ANDI, SLLI, SRLI, SRAI, Loads, JALR
            when "0010011" | "0000011" | "1100111" =>
                imm <= (31 downto 12 => instruction(31)) & instruction(31 downto 20);

            -- S-type: Store (SB, SH, SW)
            when "0100011" =>
                imm <= (31 downto 12 => instruction(31)) & instruction(31 downto 25) & instruction(11 downto 7);

            -- B-type: Branch (BEQ, BNE, BLT, BGE, ...)
            -- Bit zero is always 0, immediate is multiplied by 2 (shifted)
            when "1100011" =>
                imm <= (31 downto 12 => instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';

            -- U-type: LUI, AUIPC
            -- immediate in the upper 20 bits, others are zero
            when "0110111" | "0010111" =>
                imm <= instruction(31 downto 12) & x"000";

            -- J-type: JAL
            -- bit zero is always 0. Bit 20 of the immediate is bit 31 of the instruction
            when "1101111" =>
                imm <= (31 downto 20 => instruction(31)) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';

            -- Default: null value (ex. R-type doesn't use immediate)
            when others =>
                imm <= (others => '0');
        end case;
    end process;
    
    process (clk) is
    begin
    if rising_edge(clk) then
        immediate<=imm;
    end if;
    end process;
    
    
end Behavioral;
