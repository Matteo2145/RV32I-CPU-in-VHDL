----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2026 14:47:43
-- Design Name: 
-- Module Name: test_instruction_memory - Behavioral
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

entity test_instruction_memory is

end test_instruction_memory;

architecture simple of test_instruction_memory is
    signal  addr : std_logic_vector (9 downto 0);
    signal dout, din : std_logic_vector (31 downto 0);
    signal clk : std_logic:='0';
    signal we : std_logic_vector (0 downto 0);
    signal sim_running : boolean := true; -- used to stop the clock
begin
    
    g1 : entity work.instruction_memory port map (addra => addr, douta => dout, dina => din,
     clka => clk, wea => we); 

clk_process : process is
begin
    while sim_running loop
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end loop;
    wait;
end process clk_process;

memory: process is
 begin
    --initial state
    we<="0";
    addr<=(others=>'0');
    din<=(others=>'0');
    wait for 50 ns;
    --prepare data
    din<=x"000000FF";
    addr<="0000001000";
    wait for 20 ns;
    --enable to write
    we<="1";
    wait for 40 ns;
    --stop writing
    we<="0";
    wait for 40 ns;
    sim_running <= false; --stop the simulation
    wait;
    
end process memory;

   
   
   
end simple;
