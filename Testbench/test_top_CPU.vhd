----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.05.2026 08:14:06
-- Design Name: 
-- Module Name: test_top_CPU - Behavioral
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
use work.all;
use work.cpu_defs_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- Fondamentale per hwrite (scrittura hex)
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_top_CPU is
--  Port ( );
end test_top_CPU;

architecture Behavioral of test_top_CPU is



    signal clk,rst: STD_LOGIC;
    signal sim_running: boolean :=true; 
    signal reg_enable: std_logic;
    
    constant refresh_bits: integer:=4;
    
    constant CLASS_J : std_logic_vector(4 downto 0) := "10000";
    constant CLASS_B : std_logic_vector(4 downto 0) := "01000";
    constant CLASS_L : std_logic_vector(4 downto 0) := "00100";
    constant CLASS_S : std_logic_vector(4 downto 0) := "00010";
    constant CLASS_O : std_logic_vector(4 downto 0) := "00001";
    constant CLASS_NONE : std_logic_vector(4 downto 0) := "00000";
    
    procedure cycles(num : natural) is
    begin
      for i in 1 to num loop
        wait until falling_edge(clk);
      end loop;
    end procedure;
    
    begin
    
        g1: entity work.top_CPU generic map (REFRESH_BITS => refresh_bits)  -- <--- Cambia da 17 a 4 solo qui!
         port map (clk=>clk, rst=>rst, reg_enable=>reg_enable );
        
        
        
        
        clk_process : process is
        begin
            while sim_running loop
                clk <= '0'; wait for 5 ns;
                clk <= '1'; wait for 5 ns;
            end loop;
            wait;
        end process clk_process;
    
        top_CPU: process is
        begin
            
            rst<='1';
            reg_enable<='0';
            wait for 20 ns;
            rst<='0';
            wait for 10 ns;
            for i in 1 to 100 loop
                reg_enable<='1'; cycles(1);
                reg_enable<='0'; cycles(1);
            end loop;
            
            wait;
            sim_running<=false;
            
            
            
        end process top_CPU;
    
    --Processo per creare un file log contenente gli accessi ai registri e alla data memory
    
    process (clk)
        file log_file: text open write_mode is "cpu_vivado_trace.log";
        variable line_out: line;
        variable pc_temp  : std_logic_vector(11 downto 0);
        variable state_temp: stato;
        variable instruction_temp: std_logic_vector(31 downto 0);
        variable op_class_temp: STD_LOGIC_VECTOR(4 downto 0);
        variable rd_value_temp: STD_LOGIC_VECTOR(31 downto 0);
        variable addra_temp: STD_LOGIC_VECTOR(31 downto 0); --Address Data Memeory
        variable dina_temp:STD_LOGIC_VECTOR(31 downto 0); --Input Data Memory
        variable immediate_temp:STD_LOGIC_VECTOR(31 downto 0); --sign extended immediate
    begin
        pc_temp := <<signal .test_top_CPU.g1.curr_pc_if : std_logic_vector(11 downto 0)>>;
        state_temp :=<<signal .test_top_CPU.g1.CPU_FSM.present_state: stato>>;
        instruction_temp :=<<signal .test_top_CPU.g1.INSTRUCTION_FETCH.instruction: std_logic_vector(31 downto 0)>>;
        op_class_temp :=<<signal .test_top_CPU.g1.CPU_FSM.op_class: std_logic_vector(4 downto 0)>>;
        rd_value_temp :=<<signal .test_top_CPU.g1.MEMORY_WRITE_BACK.rd_value: std_logic_vector(31 downto 0)>>;
        addra_temp :=<<signal .test_top_CPU.g1.MEMORY_WRITE_BACK.alu_pre_result: STD_LOGIC_VECTOR(31 downto 0)>>;
        dina_temp :=<<signal .test_top_CPU.g1.MEMORY_WRITE_BACK.DATA_MEMORY.dina: STD_LOGIC_VECTOR(31 downto 0)>>;
        immediate_temp :=<<signal .test_top_CPU.g1.INSTRUCTION_DECODE.Sign_Extension.immediate: STD_LOGIC_VECTOR(31 downto 0)>>;
        
        
        if rising_edge(clk) then  
            case op_class_temp is
                when CLASS_O => -- Reg-Reg and Reg-Imm operations
                    if state_temp=WB then  
                        write(line_out, string'("core   0: 0x"));
                        hwrite(line_out, pc_temp); 
                        write(line_out, string'(" (0x"));
                        hwrite(line_out, instruction_temp);
                        write(line_out, string'(") x"));
                        write(line_out, integer'image(to_integer(unsigned(instruction_temp(11 downto 7))))); --Indirizzo rd
                        write(line_out, string'(" 0x"));
                        hwrite(line_out, rd_value_temp);
                        writeline(log_file, line_out);
                    end if;
                    
                    when CLASS_L => -- LOAD Operations
                    if state_temp=WB then  
                        write(line_out, string'("core   0: 0x"));
                        hwrite(line_out, pc_temp); 
                        write(line_out, string'(" (0x"));
                        hwrite(line_out, instruction_temp);
                        write(line_out, string'(") x"));
                        write(line_out, integer'image(to_integer(unsigned(instruction_temp(11 downto 7))))); --Indirizzo rd
                        write(line_out, string'(" 0x"));
                        hwrite(line_out, immediate_temp);
                        write(line_out, string'(" mem 0x"));
                        hwrite(line_out, addra_temp);
                        writeline(log_file, line_out);
                    end if;
                    
                    when CLASS_S => -- STORE Operations
                    if state_temp=MEM then  
                        write(line_out, string'("core   0: 0x"));
                        hwrite(line_out, pc_temp); 
                        write(line_out, string'(" (0x"));
                        hwrite(line_out, instruction_temp);
                        write(line_out, string'(") mem 0x"));
                        hwrite(line_out, addra_temp);
                        write(line_out, string'(" 0x"));
                        hwrite(line_out, dina_temp);
                        writeline(log_file, line_out);
                    end if;
                    
                    when CLASS_B => -- BRANCH Operations
                    if state_temp=MEM then  
                        write(line_out, string'("core   0: 0x"));
                        hwrite(line_out, pc_temp); 
                        write(line_out, string'(" (0x"));
                        hwrite(line_out, instruction_temp);
                        write(line_out, string'(")"));
                        writeline(log_file, line_out);
                    end if;
                    
                
                    
                when others=> write(line_out, string'("Error: Unknown Class Operation"));
                              writeline(log_file, line_out);
            end case;
        end if;
     end process;
    

end Behavioral;
