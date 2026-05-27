----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2026 13:44:26
-- Design Name: 
-- Module Name: test_Register_file - Behavioral
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

entity test_Register_file is
--  Port ( );
end test_Register_file;

architecture Behavioral of test_Register_file is
    signal rd,rs1,rs2: STD_LOGIC_VECTOR(4 downto 0);
    signal clk,we: STD_LOGIC;
    signal rd_value, rs1_value, rs2_value: STD_LOGIC_VECTOR (31 downto 0);
    signal sim_running : boolean := true; -- used to stop the clock
begin

    g1: entity work.Register_file port map (rd=>rd, rs1=>rs1, rs2=>rs2, clk=>clk, 
        we=>we, rd_value=>rd_value, rs1_value=>rs1_value, rs2_value=>rs2_value);

clk_process : process is
    begin
    while sim_running loop
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end loop;
    wait;
end process clk_process;


reg_process: process is
begin
    we<='0';
    rd<=(others=>'0');
    rs1<=(others=>'0');
    rs2<=(others=>'0');
    wait for 20 ns;
    rd<="00001"; 
    we<='1';
    rd_value<=x"0000000a";
    wait for 30 ns;
    we<='0';
    rs2<="00001";
    wait for 30 ns;
    we<='1';
    rd<="00010";
    rd_value<=x"0000000f";
    wait for 30 ns;
    we<='0';
    rs1<="00001";
    rs2<="00010";
    wait for 40 ns;
   
    
    sim_running<=false;
    wait;
end process reg_process;

end Behavioral;
