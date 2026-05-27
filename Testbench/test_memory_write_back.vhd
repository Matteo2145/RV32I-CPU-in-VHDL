----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 15:06:17
-- Design Name: 
-- Module Name: test_memory_write_back - Behavioral
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

entity test_memory_write_back is
--  Port ( );
end test_memory_write_back;

architecture Behavioral of test_memory_write_back is
    signal branch_cond, mem_we, clk:  STD_LOGIC;
    signal   next_pc, alu_result, alu_pre_result, rs2_value:  STD_LOGIC_VECTOR(31 downto 0);
    signal  op_class:  STD_LOGIC_VECTOR(4 downto 0);
    signal  pc_out,rd_value:  STD_LOGIC_VECTOR(31 downto 0);
    signal sim_running : boolean := true; -- used to stop the clock
    
    constant CLASS_J : std_logic_vector(4 downto 0) := "10000";
    constant CLASS_B : std_logic_vector(4 downto 0) := "01000";
    constant CLASS_L : std_logic_vector(4 downto 0) := "00100";
    constant CLASS_S : std_logic_vector(4 downto 0) := "00010";
    constant CLASS_O : std_logic_vector(4 downto 0) := "00001";
    constant CLASS_NONE : std_logic_vector(4 downto 0) := "00000";
    
begin
    
    MEMORY_WRITE_BACK: entity work.memory_write_back port map (branch_cond=>branch_cond, next_pc=>next_pc,
        alu_result=>alu_result, op_class=>op_class, alu_pre_result=>alu_pre_result, rs2_value=>rs2_value,
        mem_we=>mem_we, clk=>clk, pc_out=>pc_out, rd_value=>rd_value);
        
    clk_process : process is
    begin
        while sim_running loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
        wait;
    end process clk_process;
    
    memory_process : process is
    begin
        branch_cond<='0';
        next_pc<=(others=>'0');
        alu_result<=(others=>'0');
        op_class<=(others=>'0');
        alu_pre_result<=(others=>'0');
        rs2_value<=(others=>'0');
        mem_we<='0';
        wait for 20 ns;
        op_class<=CLASS_S;
        mem_we<='1';
        alu_pre_result<=x"00000010"; --16
        alu_result<=x"00000010"; --16
        rs2_value<=x"00000014"; --20
        wait for 30 ns;
        op_class<=CLASS_O;
        mem_we<='0';
        
        rs2_value<=x"00000008"; --8
        next_pc<=x"0000000a"; --10
        wait for 30 ns;
        
        op_class<=CLASS_B;
        branch_cond<='1';
        wait for 30 ns;
        branch_cond<='0';
        
        sim_running<=false;
        wait;       
    end process memory_process; 
    
end Behavioral;
