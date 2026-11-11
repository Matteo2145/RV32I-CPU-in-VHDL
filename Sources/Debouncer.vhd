----------------------------------------------------------------------------------
-- Module Name: Debouncer - Behavioral
-- Description: debouncer a contatore. L'uscita cambia solo quando l'ingresso
--              resta stabile per DEBOUNCE_MS millisecondi (sia in salita che
--              in discesa). Ingresso sincronizzato con 2 flip-flop.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Debouncer is
  generic (
    CLK_FREQ_HZ : integer := 100_000_000;  -- frequenza del clock
    DEBOUNCE_MS : integer := 10            -- tempo di stabilita' richiesto in millisecondi
  );
  port (
    CLK     : in  std_logic;
    DATA    : in  std_logic;
    OP_DATA : out std_logic
  );
end Debouncer;

architecture Behavioral of Debouncer is
  constant MAX_COUNT : integer := (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;

  signal sync0, sync1 : std_logic := '0';   -- sincronizzatore
  signal stable       : std_logic := '0';   -- uscita registrata
  signal count        : integer range 0 to MAX_COUNT := 0;
begin
  process(CLK)
  begin
    if rising_edge(CLK) then
      -- 1) sincronizzazione a 2 stadi
      sync0 <= DATA;
      sync1 <= sync0;

      -- 2) debounce: conta finche' l'ingresso e' diverso dall'uscita
      if sync1 = stable then
        count <= 0;                       -- nessun cambiamento: reset
      elsif count = MAX_COUNT - 1 then
        stable <= sync1;                  -- stabile abbastanza a lungo: accetta
        count  <= 0;
      else
        count <= count + 1;
      end if;
    end if;
  end process;

  OP_DATA <= stable;
end Behavioral;
