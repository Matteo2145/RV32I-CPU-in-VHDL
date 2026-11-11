----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2026 09:00:37
-- Design Name: 
-- Module Name: decode - Behavioral
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

--Decode the instruction given by the Instruction_Memory
entity decode is
  Port (instruction: in STD_LOGIC_VECTOR(31 downto 0);
        clk: in STD_LOGIC;
        op_class: out STD_LOGIC_VECTOR(4 downto 0);
        alu_opcode, cond_opcode: out STD_LOGIC_VECTOR(2 downto 0);
        a,b: out STD_LOGIC;
        f7: out STD_LOGIC;
        reg_enable: in STD_LOGIC
        
    );
end decode;

architecture Behavioral of decode is
   signal sign_op_class: STD_LOGIC_VECTOR (4 downto 0);
   signal sign_alu_op, sign_cond_op: STD_LOGIC_VECTOR (2 downto 0);
   signal sign_a, sign_b, sign_f7: STD_LOGIC;
   --signal function3: STD_LOGIC_VECTOR(2 downto 0);
    --signal    function7:  STD_LOGIC_VECTOR(6 downto 0);
    --signal    opcode:  STD_LOGIC_VECTOR(6 downto 0);
 --One-Hot encoding for operation class
   constant CLASS_J : std_logic_vector(4 downto 0) := "10000";
   constant CLASS_B : std_logic_vector(4 downto 0) := "01000";
   constant CLASS_L : std_logic_vector(4 downto 0) := "00100";
   constant CLASS_S : std_logic_vector(4 downto 0) := "00010";
   constant CLASS_O : std_logic_vector(4 downto 0) := "00001";
   constant CLASS_NONE : std_logic_vector(4 downto 0) := "00000";
   
    
    

begin
    
    --function3<=instruction(14 downto 12);
    --function7<=instruction(31 downto 25);
    --opcode<=instruction(6 downto 0);
    
    --selection of op_class (O,S,L,B,J) based on the opcode using one-hot encoding
   process(instruction) --combinatory process
   begin
   --initialization
    sign_f7<='0';
    sign_op_class<=CLASS_NONE; --default value
    sign_alu_op<=(others=>'0');
    sign_cond_op<=(others=>'0');
    sign_a<='0'; sign_b<='0';
    
  
        case instruction(6 downto 2) is -- Usiamo 5 bit dell'opcode direttamente
            -- BRANCHES (Opcode: 11000xx -> 11000)
            when "11000" =>
                sign_op_class <= CLASS_B;
                sign_a <= '0';
                sign_b <= '0';
                sign_cond_op <= instruction(14 downto 12); -- function3
                sign_alu_op <= "000";

            -- LOAD (Opcode: 00000xx -> 00000)
            when "00000" =>
                sign_op_class <= CLASS_L;
                sign_a <= '1';
                sign_b <= '0';
                sign_alu_op <= "000";
                sign_cond_op <= "111";

            -- STORE (Opcode: 01000xx -> 01000)
            when "01000" =>
                sign_op_class <= CLASS_S;
                sign_a <= '1';
                sign_b <= '0';
                sign_alu_op <= "000";
                sign_cond_op <= "111";

            -- JAL / JALR (Opcode: 11011 o 11001)
            when "11011" | "11001" =>
                sign_op_class <= CLASS_J;
                sign_a <= '0';
                sign_b <= '0';
                sign_alu_op <= "000";
                sign_cond_op <= "111";

            -- OP-IMM (Opcode: 00100)
            when "00100" =>
                sign_op_class <= CLASS_O;
                sign_a <= '1'; -- opcode(4) è 0
                sign_b <= '0'; -- opcode(5) è 0, ma forziamo la logica op-imm
                sign_cond_op <= "111";
                sign_alu_op <= instruction(14 downto 12);
                
            when "00101" => --AUIPC
                sign_op_class <=CLASS_O;
                sign_a<='0'; --select curr_pc
                sign_b<='0'; --select immediate
                sign_alu_op<="000"; --forcing an ADD operation
                sign_cond_op <= "111"; --no condition
                
            -- OP Registro-Registro (Opcode: 01100)
            when "01100" =>
                sign_op_class <= CLASS_O;
                sign_a <= '1'; 
                sign_b <= '1'; 
                sign_cond_op <= "111";
                sign_alu_op <= instruction(14 downto 12);
                sign_f7 <= instruction(30); -- Bit 5 di function7

            when others =>
                sign_op_class <= CLASS_NONE;
        end case;
    
    
   end process;
    
    
    process (clk) 
    begin
        if rising_edge(clk) then
            if reg_enable='1' then   
                op_class<=sign_op_class;
                alu_opcode<=sign_alu_op;
                cond_opcode<=sign_cond_op;
                a<=sign_a;
                b<=sign_b;
                f7<=sign_f7; --use this bit in order to distinguish between different operations
            end if;
                
        end if;
    end process;
    

end Behavioral;
