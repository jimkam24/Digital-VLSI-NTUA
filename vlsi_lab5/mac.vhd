library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mac is
    Port ( 
        clk      : in  STD_LOGIC;
        mac_en   : in  STD_LOGIC;
        mac_init : in  STD_LOGIC;
        rom_out  : in  STD_LOGIC_VECTOR(7 downto 0);
        ram_out  : in  STD_LOGIC_VECTOR(7 downto 0);
        y_out    : out STD_LOGIC_VECTOR(18 downto 0)
    );
end entity;

architecture behavioral of mac is
    signal a : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if mac_en = '1' then
                if mac_init = '1' then
                    a <= std_logic_vector(
                            resize(unsigned(rom_out) * unsigned(ram_out), a'length)
                         );
                else
                    a <= std_logic_vector(
                            resize(unsigned(a), a'length) +
                            resize(unsigned(rom_out) * unsigned(ram_out), a'length)
                         );
                end if;
            end if;
        end if;
    end process;

    y_out <= a;
end architecture;