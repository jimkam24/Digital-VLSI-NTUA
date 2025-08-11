library ieee;

use ieee.std_logic_1164.all;

entity half_adder is

    port(
        a : in std_logic;
        b : in std_logic;
        sum : out std_logic;
        carry : out std_logic
    );
end half_adder;

-- dataflow
architecture half_adder_arch of half_adder is
begin
    sum <= a xor b;
    carry <= a and b;

end half_adder_arch;