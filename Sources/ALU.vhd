----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2026 09:50:05
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: toni
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

entity ALU is
 Port ( 
    curr_pc: in STD_LOGIC_VECTOR(31 downto 0);
    rs1_value, rs2_value, immediate: IN STD_LOGIC_VECTOR(31 downto 0);
    a,b,f7,clk:in STD_LOGIC; --f7 is the 5th bit of function7, used to distinguish between SUB and SLT
    alu_opcode: in STD_LOGIC_VECTOR(2 downto 0);
    alu_result, alu_pre_result: out STD_LOGIC_VECTOR(31 downto 0);
    reg_enable: in std_logic
  );
end ALU;

architecture Behavioral of ALU is

    signal sig_1, sig_2, sig_alu_pre_result: STD_LOGIC_VECTOR(31 downto 0);
    -- Internal 4-bit ALU operation selector (Combines funct3 + modification flag)
    signal alu_ctrl : STD_LOGIC_VECTOR(3 downto 0);
    signal shamt : integer range 0 to 31; --save the shift amount (maximum a shift of 31 (5 bits))
    

begin
    
    sig_1<=curr_pc when (a='0') else rs1_value;
    sig_2<=immediate when (b='0') else rs2_value;
    shamt <= to_integer(unsigned(sig_2(4 downto 0))); --taking the 5 LSB of immediate (provided by sign extension)
    
    process(alu_opcode, f7, b)
    begin
        if (alu_opcode = "000" and f7 = '1' and b = '1') then
            alu_ctrl <= "1000"; -- SUB 
        elsif (alu_opcode = "101" and f7 = '1') then
            alu_ctrl <= "1101"; -- SRA / SRAI (Shift Right Arithmetic)
        else
            alu_ctrl <= '0' & alu_opcode; -- ADD/ADDI, SLL/SLLI, SRL/SRLI, SLT, SLTU, XOR, OR, AND
        end if;
    end process;
    
    process (sig_1, sig_2, alu_ctrl, shamt) is
    begin
        case alu_ctrl is
            when "0000" => --ADD, ADDI, AUIPC
                            sig_alu_pre_result<=STD_LOGIC_VECTOR(signed(sig_1)+signed(sig_2));
            
            when "1000"=> --SUB
                sig_alu_pre_result<=STD_LOGIC_VECTOR(signed(sig_1) - signed(sig_2)); 
            when "0010"=> --SLT,SLTI
                if (signed(sig_1) < signed(sig_2)) then
                    sig_alu_pre_result <= x"00000001";
                else 
                    sig_alu_pre_result <= x"00000000";
                end if;
            when "0011"=>
                if (unsigned(sig_1) < unsigned(sig_2)) then
                    sig_alu_pre_result <= x"00000001";
                else 
                    sig_alu_pre_result <= x"00000000";
                end if;   
            when "0100"=> --XOR, XORI
                sig_alu_pre_result<=sig_1 xor sig_2;
                
            when "0110"=> --OR,ORI
                sig_alu_pre_result<=sig_1 or sig_2;
            when "0111"=> --AND,ANDI
                sig_alu_pre_result<=sig_1 and sig_2;
          
             when "0001" => -- SLL / SLLI (Shift Left Logical)
                sig_alu_pre_result <= STD_LOGIC_VECTOR(shift_left(unsigned(sig_1), shamt));
                
            when "0101" => -- SRL / SRLI (Shift Right Logical)
                sig_alu_pre_result <= STD_LOGIC_VECTOR(shift_right(unsigned(sig_1), shamt));
                
            when "1101" => -- SRA / SRAI (Shift Right Arithmetic)
                --sig_alu_pre_result <= STD_LOGIC_VECTOR(shift_right(signed(sig_1), shamt));     
                  sig_alu_pre_result <= std_logic_vector(unsigned(shift_right(signed(sig_1), shamt))); --Conversione sicura  
                
                
                
            
            when others=> sig_alu_pre_result<=(others=>'0');
                    
                
        end case;
        
       
    end process;
    
    --alu_pre_result<=sig_alu_pre_result;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if reg_enable='1' then
                alu_result<=sig_alu_pre_result;
                alu_pre_result<=sig_alu_pre_result;
            end if;
        end if;
    end process;
    
    
end Behavioral;
