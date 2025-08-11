library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package math_utils is
    function log2ceil(n : natural) return natural;
end package;

package body math_utils is
    function log2ceil(n : natural) return natural is
        variable result : natural := 0;
        variable val : natural := n - 1;
    begin
        while val > 0 loop
            result := result + 1;
            val := val / 2;
        end loop;
        return result;
    end function;
end package body;
