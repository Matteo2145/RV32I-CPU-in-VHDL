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
        douta: out STD_LOGIC_VECTOR(31 downto 0);
        reg_enable: in STD_LOGIC
    );
end instruction_memory;

architecture Behavioral of instruction_memory is
    
    type ram_type is array (0 to 1023)of std_logic_vector (31 downto 0);
    signal RAM : ram_type :=(
    0=>x"00000517", --auipc operation
    1=>x"03050513",
    2=>x"00000793",
    3=>x"00500693",
    4=>x"00052703",
    5=>x"00F70733",
    6=>x"00178793",
    7=>x"00E52023",
    8=>x"00450513",
    9=>x"FED796E3", 
    10=>x"00008067",
    --0 =>x"00000793",
    --1=>x"3e800693",
    --2=>x"00052703",
    --3=>x"00f70733",
    --4=>x"00e52023",
    --5=>x"00178793",
    --6=>x"00450513",
    --7=>x"fed796e3",
    --0=>x"00850713",
    --1=>x"00052783",
    --2=>x"00450513",
    --3=>x"00578793",
    --4=>x"fef52e23",
    --5=>x"fee518e3",
    --6=>x"00a00793",
    --7=>x"00f5a223",
    --8=>x"00008067",
    others => (others=>'0'));
    
    --forcing Vicado to use dedicated RAM blocks
    attribute ram_style : string;
    attribute ram_style of RAM : signal is "block";
    
begin
    
    process(clka) begin
        
            if rising_edge(clka) then
                if reg_enable='1' then
                    douta <= RAM(to_integer(unsigned (addra )));
                    if (wea="1") then 
                        RAM(to_integer(unsigned (addra)))<=dina;
                    end if;
                end if;
            end if;
    end process;  
end Behavioral;
