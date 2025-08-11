library IEEE;
use IEEE.std_logic_1164.all;

entity decoder_3_to_8_dataflow is 
    port(
        enc : in std_logic_vector(3-1 downto 0);
        dec : out std_logic_vector(8-1 downto 0)
    );
end decoder_3_to_8_dataflow;

architecture dataflow_arch of decoder_3_to_8_dataflow is

begin
    dec(7) <= enc(2) and enc(1) and enc(0);
    dec(6) <= enc(2) and enc(1) and (not enc(0));
    dec(5) <= enc(2) and (not enc(1)) and enc(0);
    dec(4) <= enc(2) and (not enc(1)) and (not enc(0));
    dec(3) <= (not enc(2)) and enc(1) and enc(0);
    dec(2) <= (not enc(2)) and enc(1) and (not enc(0));
    dec(1) <= (not enc(2)) and (not enc(1)) and enc(0);
    dec(0) <=  (not enc(2)) and (not enc(1)) and (not enc(0));
    
end dataflow_arch;