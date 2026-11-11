----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2026 09:29:06
-- Design Name: 
-- Module Name: Display - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display is

generic (
    REFRESH_BITS : integer := 17
  );

Port(    
    clk     : in  std_logic;
    pc    : in  std_logic_vector(11 downto 0);    -- Valore di PC da mostrare sul display
    --rst     : in  std_logic;                      -- azzera il contatore
    SEG     : out std_logic_vector(6 downto 0);   -- CG..CA, attivi bassi
    DP      : out std_logic;                      -- punto decimale, attivo basso
    AN      : out std_logic_vector(7 downto 0)    -- anodi, attivi bassi
    );
end Display;

architecture Behavioral of Display is
       
       -- signal rst0, rst1       : std_logic := '0';
        signal digits           : unsigned(11 downto 0):= (others =>'0');  -- BCD, 0 = unita'
        signal refresh          : unsigned(REFRESH_BITS - 1 downto 0) := (others => '0');
        signal sel              : integer range 0 to 3;
        signal cur_digit        : unsigned(3 downto 0);
        signal blank            : std_logic;
        
        
begin

    digits<=unsigned(pc);


    ------------------------------------------------------------------ multiplexing
  process(CLK) begin
    if rising_edge(CLK) then
      refresh <= refresh + 1;
    end if;
  end process;

  sel       <= to_integer(refresh(REFRESH_BITS - 1 downto REFRESH_BITS - 2));
  
--  with sel select
--    cur_digit <= digits(3 downto 0) when 0,
--                 digits(7 downto 4) when 1,
--                  digits(11 downto 8) when 2,
                 
--                 "0000" when others;
    
  -- Selezione della cifra corrente e gestione del quarto stato (quando sel = 3)
    process(sel, digits)
    begin
        case sel is
            when 0 => cur_digit <= digits(3 downto 0);   -- Unità (Hex 1a cifra)
            when 1 => cur_digit <= digits(7 downto 4);   -- Decine (Hex 2a cifra)
            when 2 => cur_digit <= digits(11 downto 8);  -- Centinaia (Hex 3a cifra)
            when others => cur_digit <= "0000";          -- Stato di riposo (quarto display/inattivo)
        end case;
    end process;  

  -- spegne gli zeri iniziali (mostra "7" invece di "0007"); la cifra delle unita' e' sempre accesa
--  blank <= '1' when (sel=3) or
--                    (sel = 2 and digits(11 downto 8) = "0000") or
--                    (sel = 1 and digits(11 downto 8) = "0000" and 
--                    digits(7 downto 4) = "0000")
--           else '0';

-- Logica Blank corretta per spegnere gli zeri iniziali non significativi
    process(sel, digits)
    begin
        blank <= '0';
        if sel = 2 and digits(11 downto 8) = "0000" then
            blank <= '1'; -- Spegne la terza cifra se è zero
        elsif sel = 1 and digits(11 downto 8) = "0000" and digits(7 downto 4) = "0000" then
            blank <= '1'; -- Spegne la seconda cifra se sia la seconda che la terza sono zero
        elsif sel = 3 then
            blank <= '1'; -- Il quarto stato della scansione a 2 bit rimane sempre spento
        end if;
    end process;

  -- un solo anodo attivo (basso) alla volta; le 4 cifre a sinistra restano spente
  process(sel, blank)
  begin
    AN <= (others => '1');
    if blank = '0' then
      case sel is
                when 0 => AN(0) <= '0'; -- Attiva il primo display a destra
                when 1 => AN(1) <= '0'; -- Attiva il secondo display
                when 2 => AN(2) <= '0'; -- Attiva il terzo display
                when others => AN <= (others => '1');
            end case;
    end if;
  end process;

  ------------------------------------------------------------------ decoder 7 segmenti
  -- SEG(6..0) = CG CF CE CD CC CB CA, attivi bassi ('0' = segmento acceso)
  with cur_digit select
    SEG <= "1000000" when "0000", --0
           "1111001" when "0001", --1
           "0100100" when "0010", --2
           "0110000" when "0011", --3
           "0011001" when "0100", --4
           "0010010" when "0101", --5
           "0000010" when "0110", --6
           "1111000" when "0111", --7 
           "0000000" when "1000", --8
           "0010000" when "1001", --9
           "0001000" when "1010", --A
           "0000011" when "1011", --B
           "1000110" when "1100", --C
           "0100001" when "1101", --D
           "0000110" when "1110", --E
           "0001110" when "1111", --F
           "1111111" when others; 

  DP <= '1';   -- punto decimale spento

end Behavioral;
