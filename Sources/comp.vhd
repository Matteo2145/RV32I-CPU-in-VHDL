----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 09:50:05
-- Design Name: 
-- Module Name: comp - Behavioral
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

entity comp is
  Port (rs1_value, rs2_value: in STD_LOGIC_VECTOR(31 downto 0);
        cond_opcode: in STD_LOGIC_VECTOR(2 downto 0);
        branch_cond: out STD_LOGIC;
        clk: in STD_LOGIC;
        reg_enable: in std_logic
        );
end comp;

architecture Behavioral of comp is

     signal sig_branch_cond: STD_LOGIC;
     signal sig_eq, sig_lt: STD_LOGIC;
     signal sig_bltu: STD_LOGIC;
     constant EQ : std_logic_vector(2 downto 0) := "000";
     constant NEQ : std_logic_vector(2 downto 0) := "001";
     constant LT : std_logic_vector(2 downto 0) := "100";
     constant GE : std_logic_vector(2 downto 0) := "101";
     constant BLTU: std_logic_vector(2 downto 0) :="110";
     constant BGEU: std_logic_vector(2 downto 0):="111";

begin

    
    
      
        sig_eq <= '1' when (rs1_value = rs2_value) else '0';
        sig_lt <= '1' when (signed(rs1_value) < signed(rs2_value)) else '0'; 
        sig_bltu<='1' when (unsigned(rs1_value)<unsigned(rs2_value)) else '0';
            
    process(cond_opcode,sig_eq, sig_lt,sig_bltu) 
    begin
        case cond_opcode is
         when EQ=> 
                sig_branch_cond<=sig_eq;
         when NEQ=> 
                sig_branch_cond<=not sig_eq;
         when LT=> 
                sig_branch_cond<= sig_lt;
         when GE=>  
                sig_branch_cond<= not sig_lt;
        when BLTU=>
                sig_branch_cond<=sig_bltu;
        when BGEU=>
                sig_branch_cond<=not sig_bltu;
         when others=>
            sig_branch_cond<='0';
        end case;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if reg_enable='1' then
                branch_cond<=sig_branch_cond;
            end if;
        end if;     
    end process;

end Behavioral;
