----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2026 11:42:46
-- Design Name: 
-- Module Name: Instruction_Memory - Behavioral
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
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_memory is
    port(
        addra: in STD_LOGIC_VECTOR(9 downto 0);
        wea: in STD_LOGIC_VECTOR(0 downto 0);
        dina: in STD_LOGIC_VECTOR(31 downto 0);
        clka: in STD_LOGIC;
        --rst: in STD_LOGIC;
        douta: out STD_LOGIC_VECTOR(31 downto 0)
    );
end instruction_memory;

architecture Behavioral of instruction_memory is
    
    type ram_type is array (0 to 1023)of std_logic_vector (31 downto 0);
    signal RAM : ram_type :=(
    0=>x"00000517", -- auipc   a0, 0x0
    1=>x"03050513", -- addi    a0, a0, 48
    2=>x"00000793", -- li      a5, 0
    3=>x"00500693", -- li      a3, 5
    4=>x"00052703", -- lw      a4, 0(a0)
    5=>x"00F70733", -- add     a4, a4, a5
    6=>x"00178793", -- addi    a5, a5, 1
    7=>x"00E52023", -- sw      a4, 0(a0)
    8=>x"00450513", -- addi    a0, a0, 4
    9=>x"FED796E3", -- bne     a5, a3, pc - 20
    10=>x"00008067",-- ret
    
    others => (others=>'0'));
    
    --forcing Vicado to use dedicated RAM blocks
    attribute ram_style : string;
    attribute ram_style of RAM : signal is "block";
    
begin
    
    process(clka) begin
        
            if rising_edge(clka) then
                --Read first
                douta <= RAM(to_integer(unsigned (addra )));
                if (wea="1") then 
                    RAM(to_integer(unsigned (addra)))<=dina;
                end if;
 
        end if;
    end process;  
end Behavioral;
