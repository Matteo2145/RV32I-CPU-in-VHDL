----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 13:58:01
-- Design Name: 
-- Module Name: memory_write_back - Behavioral
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

entity memory_write_back is
  Port (branch_cond, mem_we, clk: in STD_LOGIC;
        next_pc, alu_result, alu_pre_result, rs2_value: in STD_LOGIC_VECTOR(31 downto 0);
        op_class: in STD_LOGIC_VECTOR(4 downto 0);
        pc_out,rd_value: out STD_LOGIC_VECTOR(31 downto 0);
        reg_enable: in std_logic
         );
end memory_write_back;

architecture Behavioral of memory_write_back is

    signal addra: STD_LOGIC_VECTOR (11 downto 0);
    signal wea: STD_LOGIC;
    signal mem_out: STD_LOGIC_VECTOR (31 downto 0);
    constant CLASS_J : std_logic_vector(4 downto 0) := "10000";
    constant CLASS_B : std_logic_vector(4 downto 0) := "01000";
    constant CLASS_L : std_logic_vector(4 downto 0) := "00100";
    constant CLASS_S : std_logic_vector(4 downto 0) := "00010";
    constant CLASS_O : std_logic_vector(4 downto 0) := "00001";
    constant CLASS_NONE : std_logic_vector(4 downto 0) := "00000";
begin

    DATA_MEMORY: entity work.data_memory port map ( addra=>alu_pre_result(13 downto 2), dina=>rs2_value, wea=>wea,
                clk=>clk, douta=>mem_out, reg_enable=>reg_enable);    
               
    wea<= (mem_we and op_class(1)); -- Store: "00010" one-hot encoding
    
    
    process (branch_cond, next_pc, alu_result, op_class, mem_out) is
    begin
        -- defualt values
        pc_out   <= (others => '0'); 
        rd_value <= (others => '0');
        
        case op_class is
            when (CLASS_J)=> pc_out<=alu_result; rd_value<=next_pc;
            when (CLASS_B)=> rd_value<=(others=>'0');
                if (branch_cond='1') then --Branch taken
                    pc_out<= alu_result;
                else 
                    pc_out<=next_pc;
                end if;
            when CLASS_O | CLASS_S | CLASS_L =>
                pc_out<=next_pc;
                if (op_class=CLASS_O) then 
                    rd_value<=alu_result;
                elsif(op_class=CLASS_L) then
                    rd_value<=mem_out;
                else rd_value<=(others=>'0');
                end if;
                
            when others => pc_out<=(others=>'0'); rd_value<=(others=>'0');
        end case;
    end process;    

end Behavioral;
