----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2026 10:16:31
-- Design Name: 
-- Module Name: CPU_FSM - Behavioral
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
use work.cpu_defs_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU_FSM is
  Port ( clk,res: in STD_LOGIC;
        op_class: in STD_LOGIC_VECTOR(4 downto 0);   --OP, LD, ST, B, J  
        pc_load, rd_write_en, mem_we: out STD_LOGIC
        );
end CPU_FSM;

architecture Behavioral of CPU_FSM is
    
    constant CLASS_J : std_logic_vector(4 downto 0) := "10000";
    constant CLASS_B : std_logic_vector(4 downto 0) := "01000";
    constant CLASS_L : std_logic_vector(4 downto 0) := "00100";
    constant CLASS_S : std_logic_vector(4 downto 0) := "00010";
    constant CLASS_O : std_logic_vector(4 downto 0) := "00001";
    constant CLASS_NONE : std_logic_vector(4 downto 0) := "00000";
    
   
    signal present_state, next_state : stato;
    
    
    
    
    
begin

    seq: process (clk)
    begin
            
            if rising_edge(clk) then
                if res='1' then 
                    present_state<=IFETCH;
                else present_state<=next_state;
                end if;
                
        end if;        
     end process seq;
    
    future: process (present_state, op_class) is
    begin
        
        next_state  <= IFETCH; --Default values
        pc_load     <= '0';
        rd_write_en <= '0';
        mem_we      <= '0';
        
        case present_state is
            when  IFETCH => 
                next_state<=ID; 
            when  ID => next_state<=EX;
                            
            
            when  EX => 
                if(op_class=CLASS_O or op_class=CLASS_J) then next_state<=WB;
                elsif (op_class=CLASS_B) then next_state<=MEM; 
                elsif (op_class=CLASS_L or op_class=CLASS_S) then next_state<=MEM;
                end if;
            
            when  MEM =>    if (op_class=CLASS_L) then next_state<=WB;
                            elsif (op_class=CLASS_S) then next_state<=IFETCH; mem_we<='1'; pc_load<='1';
                            elsif (op_class=CLASS_B) then next_state<=IFETCH; pc_load<='1';
                            else next_state<=IFETCH;
                            end if;
            
            when  WB => next_state<=IFETCH; rd_write_en<='1'; pc_load<='1';
            when others => next_state<= IFETCH;        
        end case;
    end process future;
    
end Behavioral;
