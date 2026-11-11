----------------------------------------------------------------------------------
-- Module Name: Top_Debouncer - Behavioral
-- Description: top level per Nexys4 DDR.
--   - DATA (BTNR) passa dal debouncer e accende OP_DATA (LED15) finche' e' premuto
--   - ogni pressione (fronte di salita del segnale ripulito) incrementa un
--     contatore decimale 0..9999, mostrato sulle 4 cifre a destra del display
--   - RST (BTNC) azzera il contatore
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_Debouncer is
  generic (
    CLK_FREQ_HZ  : integer := 100_000_000;
    DEBOUNCE_MS  : integer := 10;
    -- 2^17 cicli a 100 MHz = 1,3 ms per giro completo delle 4 cifre (~760 Hz)
    REFRESH_BITS : integer := 17
  );
  port (
    CLK     : in  std_logic;
    DATA    : in  std_logic;                      -- pulsante da contare
    RST     : in  std_logic;                      -- azzera il contatore
    OP_DATA : out std_logic;                      -- LED: pulsante premuto
    SEG     : out std_logic_vector(6 downto 0);   -- CG..CA, attivi bassi
    DP      : out std_logic;                      -- punto decimale, attivo basso
    AN      : out std_logic_vector(7 downto 0)    -- anodi, attivi bassi
  );
end Top_Debouncer;

architecture Behavioral of Top_Debouncer is
  --type digit_array is array (0 to 3) of unsigned(3 downto 0);

  signal btn_db, btn_prev : std_logic := '0';
  signal rst0, rst1       : std_logic := '0';
  signal digits           : unsigned(15 downto 0) := (others =>'0');  -- BCD, 0 = unita'
  signal refresh          : unsigned(REFRESH_BITS - 1 downto 0) := (others => '0');
  signal sel              : integer range 0 to 3;
  signal cur_digit        : unsigned(3 downto 0);
  signal blank            : std_logic;
begin
  ------------------------------------------------------------------ debouncer
  u_db : entity work.Debouncer
    generic map (CLK_FREQ_HZ => CLK_FREQ_HZ, DEBOUNCE_MS => DEBOUNCE_MS)
    port map (CLK => CLK, DATA => DATA, OP_DATA => btn_db);

  OP_DATA <= btn_db;

  ------------------------------------------------------------------ contatore
  process(CLK) begin
    if rising_edge(CLK) then
      -- reset sincronizzato
      rst0 <= RST;
      rst1 <= rst0;

      btn_prev <= btn_db; --Debouncer's output

      if rst1 = '1' then 
        digits <= (others =>'0');
      elsif btn_db = '1' and btn_prev = '0' then   -- una sola volta per pressione
        if digits=x"ffff" then
            digits<=(others=>'0');
        else       
            digits<=digits+1;
        end if;
        
      end if;
    end if;
  end process;

  ------------------------------------------------------------------ multiplexing
  process(CLK) begin
    if rising_edge(CLK) then
      refresh <= refresh + 1;
    end if;
  end process;

  sel       <= to_integer(refresh(REFRESH_BITS - 1 downto REFRESH_BITS - 2));
  
  with sel select
    cur_digit <= digits(3 downto 0) when 0,
                 digits(7 downto 4) when 1,
                  digits(11 downto 8) when 2,
                 digits(15 downto 12) when 3,
                 "0000" when others;
    
    

  -- spegne gli zeri iniziali (mostra "7" invece di "0007"); la cifra delle unita' e' sempre accesa
  blank <= '1' when (sel = 3 and digits(15 downto 12) = "0000") or
                    (sel = 2 and digits(15 downto 12) = "0000" and digits(11 downto 8) = "0000") or
                    (sel = 1 and digits(15 downto 12) = "0000" and digits(11 downto 8) = "0000" and 
                    digits(7 downto 4) = "0000")
           else '0';

  -- un solo anodo attivo (basso) alla volta; le 4 cifre a sinistra restano spente
  process(sel, blank)
  begin
    AN <= (others => '1');
    if blank = '0' then
      AN(sel) <= '0';
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
