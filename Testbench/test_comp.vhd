----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 11:25:25
-- Design Name: 
-- Module Name: test_comp - Behavioral
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

entity test_comp is
--  Port ( );
end test_comp;

architecture Behavioral of test_comp is
    signal rs1_value,rs2_value: STD_LOGIC_VECTOR(31 downto 0);
    signal cond_opcode: STD_LOGIC_VECTOR (2 downto 0);
    signal clk, branch_cond: STD_LOGIC;
    signal sim_running : boolean := true; -- used to stop the clock
    
begin
    
    g1: entity work.comp port map (rs1_value=>rs1_value, rs2_value=> rs2_value, clk=>clk,
             cond_opcode=>cond_opcode, branch_cond=>branch_cond);
    
    clk_process : process is
    begin
    while sim_running loop
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end loop;
    wait;
    end process clk_process;
    
    comp_process: process is
    begin 
    rs1_value<=(others=>'0');
    rs2_value<=(others=>'0');
    cond_opcode<="111";
    wait for 20 ns;
    cond_opcode<="000";
    wait for 20 ns;
    rs1_value<=x"00000001";
    wait for 20 ns;
    cond_opcode<="001";
    wait for 20 ns;
    rs2_value<=x"00040000";
    cond_opcode<="100";
    wait for 20 ns;
    cond_opcode<="101";
    sim_running<=false;
    wait;
    end process comp_process;
    

end Behavioral;
