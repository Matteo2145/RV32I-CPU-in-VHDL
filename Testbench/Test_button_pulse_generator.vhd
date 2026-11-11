----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2026 14:10:09
-- Design Name: 
-- Module Name: Test_button_pulse_generator - Behavioral
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

entity Test_button_pulse_generator is
--  Port ( );
end Test_button_pulse_generator;

architecture Behavioral of Test_button_pulse_generator is

    signal clk       :   STD_LOGIC; -- Clock di sistema (100 MHz)
    signal rst       :   STD_LOGIC; -- Reset asincrono
    signal btn_in    :   STD_LOGIC; -- Pulsante fisico della Nexys
    signal pulse_out :  STD_LOGIC; 
    signal sim_running : boolean :=true;
begin

    g1: entity work.button_pulse_generator port map (clk=>clk, rst=>rst, btn_in=>btn_in, pulse_out=>pulse_out);
    process_clk: process is
        begin
            while sim_running loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
        wait;
        
    end process process_clk;
    
    button_pulse: process is
    begin
        rst<='1';
        wait for 20 ns;
        btn_in<='1';
        wait for 20ns;
        btn_in<='0';
        wait for 50 ns;
        btn_in<='1';
        wait for 50 ns;
        btn_in<='0';
        wait for 10ns;
        btn_in<='1';
        wait for 10 ns;
        btn_in<='0';
        wait for 10 ns;
        btn_in<='1'; 
        wait for 50 ns;
        btn_in<='0';
        
        
        
        sim_running<=false;
        wait;
    end process button_pulse;

end Behavioral;
