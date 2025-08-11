library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mac is
    Port ( 
           clk  : in STD_LOGIC;
           rom_out    : in STD_LOGIC_VECTOR (7 downto 0);
           ram_out    : in STD_LOGIC_VECTOR (7 downto 0);
           mac_init   : in STD_LOGIC;
        --in order to avoid overflow we need 2N + log(N) bits   
           y_out      : out STD_LOGIC_VECTOR (15 + 3  downto 0)
        );
end entity;

architecture behavioral of mac is
    signal a: std_logic_vector(15+3 downto 0);
    begin
        process (clk)
        begin
        if (clk'event and clk = '1') then
            if(mac_init = '1') then
                a <=  EXT(rom_out * ram_out, a'LENGTH);
            else
                a <= a + EXT(rom_out * ram_out, a'LENGTH);
            end if;
        end if;
        end process;
y_out <= a;
end behavioral;
