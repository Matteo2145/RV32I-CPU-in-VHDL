library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity button_pulse_generator is
    Port (
        clk       : in  STD_LOGIC; -- Clock di sistema (100 MHz)
        rst       : in  STD_LOGIC; -- Reset asincrono
        btn_in    : in  STD_LOGIC; -- Pulsante fisico della Nexys
        pulse_out : out STD_LOGIC  -- Impulso di 1 ciclo di clock per la CPU
       
    );
end button_pulse_generator;

architecture Behavioral of button_pulse_generator is

    -- 1. Segnali per il Debouncer (Filtro a conteggio)
    -- 100 MHz = 10ns per ciclo. Per filtrare 10ms servono 1.000.000 di cicli.
    -- 2^20 = 1.048.576 (circa 10.5 ms), usiamo un contatore a 20 bit.
    signal counter     : unsigned(19 downto 0) := (others => '0');
    signal btn_debounced : STD_LOGIC := '0';
    
    -- Sincronizzatori per evitare metastabilità
    signal btn_sync_0  : STD_LOGIC := '0';
    signal btn_sync_1  : STD_LOGIC := '0';

    -- 2. Segnali per l'Edge Detector
    signal btn_debounced_delay : STD_LOGIC := '0';

begin

    -- Processo di sincronizzazione e antirimbalzo
    process(clk, rst)
    begin
        if rst = '1' then
            btn_sync_0    <= '0';
            btn_sync_1    <= '0';
            btn_debounced <= '0';
            counter       <= (others => '0');
        elsif rising_edge(clk) then
            -- Doppia flip-flop per sincronizzare il pulsante esterno con il clock interno
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;

            -- Se il pulsante cambia stato rispetto al valore filtrato attuale
            if (btn_sync_1 /= btn_debounced) then
                counter <= counter + 1;
                -- Se il contatore si satura, il nuovo stato è stabile --(others => '1')
                if counter ="11111111111111111111"  then
                    btn_debounced <= btn_sync_1;
                    counter <= (others => '0');
                end if;
            else
                counter <= (others => '0'); -- Reset contatore se il segnale torna al valore stabile
            end if;
        end if;
    end process;

    -- Processo di Edge Detection (Rilevatore di fronte di salita)
    process(clk, rst)
    begin
        if rst = '1' then
            btn_debounced_delay <= '0';
        elsif rising_edge(clk) then
            btn_debounced_delay <= btn_debounced;
        end if;
       
       
    end process;

    -- L'impulso è alto SOLO nel ciclo di clock in cui il bottone passa da '0' a '1'
    pulse_out <= btn_debounced and (not btn_debounced_delay);
    
    
end Behavioral;
