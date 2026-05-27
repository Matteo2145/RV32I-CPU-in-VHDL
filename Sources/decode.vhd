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
        f7: out STD_LOGIC
        
    );
end decode;

architecture Behavioral of decode is
   signal sign_op_class: STD_LOGIC_VECTOR (4 downto 0);
   signal sign_alu_op, sign_cond_op: STD_LOGIC_VECTOR (2 downto 0);
   signal sign_a, sign_b, sign_f7: STD_LOGIC;
   signal function3: STD_LOGIC_VECTOR(2 downto 0);
    signal    function7:  STD_LOGIC_VECTOR(6 downto 0);
    signal    opcode:  STD_LOGIC_VECTOR(6 downto 0);
   --One-Hot encoding for operation class
   constant CLASS_J : std_logic_vector(4 downto 0) := "10000";
   constant CLASS_B : std_logic_vector(4 downto 0) := "01000";
   constant CLASS_L : std_logic_vector(4 downto 0) := "00100";
   constant CLASS_S : std_logic_vector(4 downto 0) := "00010";
   constant CLASS_O : std_logic_vector(4 downto 0) := "00001";
   constant CLASS_NONE : std_logic_vector(4 downto 0) := "00000";
   
    
    

begin
    sign_f7<='0';
    function3<=instruction(14 downto 12);
    function7<=instruction(31 downto 25);
    opcode<=instruction(6 downto 0);
    
    --selection of op_class (O,S,L,B,J) based on the opcode using one-hot encoding
   process(opcode, function3, function7,sign_op_class, instruction) --combinatory process
   begin
   --initialization
    sign_op_class<=CLASS_NONE; --default value
    sign_alu_op<=(others=>'0');
    sign_cond_op<=(others=>'0');
    sign_a<='0'; sign_b<='0';
    
    if(instruction=x"00000000") then sign_op_class<=CLASS_NONE;
    else
        case opcode(4 downto 2) is
            when "000"=>
                case opcode(6 downto 5) is
                    when "00"=> sign_op_class<=CLASS_L;
                    when "01"=> sign_op_class<=CLASS_S;
                    when "11"=> sign_op_class<=CLASS_B;
                    when others => 
                                sign_op_class <= CLASS_NONE;
                end case;
            when "011"=> if (opcode(6 downto 5)="11") then sign_op_class<=CLASS_J; 
                        end if;
            when "100"=>
                case opcode(6 downto 5) is
                    when "00"=> sign_op_class<=CLASS_O; --Op-Imm
                    when "01"=> sign_op_class<=CLASS_O; --Op with two source reg
                    when others => 
                                sign_op_class <= CLASS_NONE;
                end case; 
            when others => 
            sign_op_class <= CLASS_NONE; --Invalid class
        end case;
    end if;
    --select the output values based on the instruction type
    case sign_op_class is
        --BRANCHES
        when CLASS_B=>  sign_a<='0'; --select curr_pc in ALU
            sign_b<='0'; --select immediate in ALU
            sign_cond_op<=function3;
            sign_alu_op<="000";
        when CLASS_L => sign_a<='1';
            sign_b<='0';
            sign_alu_op<="000"; --ADD
            sign_cond_op<="111"; --Invalid Cond_op;
        when CLASS_S => sign_a<='1';
            sign_b<='0';
            sign_alu_op<="000"; --ADD
            sign_cond_op<="111"; --Invalid Cond_op; 
         
        when CLASS_J=> sign_a<='0';
            sign_b<='0';
            sign_alu_op<="000"; --ADD (to calculate new address)
            sign_cond_op<="111";  --Invalid Cond_op   
            
        when CLASS_O=> 
            sign_a<=opcode(4);
            sign_b<=opcode(5);
            
            sign_cond_op<="111"; --invalid Cond_op
            
            if (sign_b='0') then --Op-Imm
                sign_alu_op<=function3;
            elsif (sign_b='1') then --Op
                sign_alu_op<=function3;
                
                
                sign_f7<=function7(5); --only in case of reg-reg operations
            end if;
            
            when others=> sign_alu_op<=(others=>'0');
                    sign_cond_op<=(others=>'0');
                    sign_a<='0'; sign_b<='0';
    end case;
    
   end process;
    
    
    process (clk) 
    begin
        if rising_edge(clk) then
            op_class<=sign_op_class;
            alu_opcode<=sign_alu_op;
            cond_opcode<=sign_cond_op;
            a<=sign_a;
            b<=sign_b;
            f7<=sign_f7; --use this bit in order to distinguish between different operations
        end if;
    
    
    end process;
    

end Behavioral;
