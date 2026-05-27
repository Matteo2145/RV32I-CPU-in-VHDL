----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 11:13:07
-- Design Name: 
-- Module Name: test_FSM - Behavioral
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

entity test_FSM is
--  Port ( );
end test_FSM;

architecture Behavioral of test_FSM is
    
   signal clk,res:  STD_LOGIC;
   signal     op_class:  STD_LOGIC_VECTOR(4 downto 0);   --OP, LD, ST, B, J  
   signal     pc_load, rd_write_en, mem_we:  STD_LOGIC;
   signal sim_running : boolean := true; -- used to stop the clock

    constant CLASS_J : std_logic_vector(4 downto 0) := "10000";
    constant CLASS_B : std_logic_vector(4 downto 0) := "01000";
    constant CLASS_L : std_logic_vector(4 downto 0) := "00100";
    constant CLASS_S : std_logic_vector(4 downto 0) := "00010";
    constant CLASS_O : std_logic_vector(4 downto 0) := "00001";
    constant CLASS_NONE : std_logic_vector(4 downto 0) := "00000";

begin
    
    g1: entity work.CPU_FSM port map (clk=>clk, res=>res, op_class=>op_class, pc_load=>pc_load, rd_write_en=>rd_write_en,
        mem_we=>mem_we);
        
    clk_process : process is
    begin
        while sim_running loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process clk_process;

    FSM_process: process is 
    begin
        res<='1';
        op_class<="00000";
        wait for 25 ns;
        res<='0';
        wait for 20 ns;
        op_class<=CLASS_L;
        wait for 50 ns;
        op_class<=CLASS_S;
        wait for 40 ns;
        op_class<=CLASS_B;
        wait for 30 ns;
        op_class<=CLASS_J;
        wait for 40 ns;
        op_class<=CLASS_O;
        wait for 40 ns;
        sim_running<=false;
        wait;
    end process;
    
    


end Behavioral;
