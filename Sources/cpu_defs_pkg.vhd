library ieee;
use ieee.std_logic_1164.all;

package cpu_defs_pkg is
    -- Metti qui la definizione dell'enumerato
    type stato is (IFETCH, ID, EX, MEM, WB);
end package cpu_defs_pkg;
