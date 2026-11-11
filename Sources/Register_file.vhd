----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2026 12:28:21
-- Design Name: 
-- Module Name: Register_file - Behavioral
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

entity Register_file is
 Port (rd,rs1,rs2: in STD_LOGIC_VECTOR (4 downto 0);
        we, clk: in STD_LOGIC;
        rd_value: in STD_LOGIC_VECTOR(31 downto 0):=(others=>'0');
        rs1_value, rs2_value: out STD_LOGIC_VECTOR (31 downto 0):=(others=>'0');
        reg_enable:in STD_LOGIC
         );
end Register_file;


architecture Behavioral of Register_file is
    signal a: STD_LOGIC_VECTOR(4 downto 0);
    type reg_type is array (0 to 31)of std_logic_vector (31 downto 0);
    signal REG : reg_type :=(
    (10)=>x"00000000", --REG[10]=10
    others => (others=>'0'));
    
    
begin
    
    
        a<=rd when we='1' else rs1;
        --REG(0)<=x"00000000"; --x0 is always<=0
        
    -- rs1_value <= (others => '0') when rs1_addr = "00000" else RAM(to_integer(unsigned(rs1_addr)));   
    
    process(clk) begin
        if rising_edge(clk) then
            if (reg_enable='1') then
                if(we='0') then --read in register memory              
                     if(a="00000") then
                        rs1_value<=(others=>'0');
                     else rs1_value<=REG(to_integer(unsigned(a)));
                     end if;
                     
                elsif(we='1') then --write in register memory
                     if(a/="00000") then
                        REG(to_integer(unsigned(a)))<=rd_value;
                     end if;
                end if;
                
                if(rs2="00000") then 
                        rs2_value<=(others=>'0');
                else rs2_value<=REG(to_integer(unsigned(rs2)));
                end if;
            end if;
            
        end if;
    end process;

end Behavioral;
