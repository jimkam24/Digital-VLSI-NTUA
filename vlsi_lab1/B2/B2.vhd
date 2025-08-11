library IEEE;
use IEEE.std_logic_1164.all;

entity shift_reg4 is
    port (
        clk, rst, en, pl, dir : in std_logic;
        din : in std_logic_vector(3 downto 0);
        si : in std_logic;
        so : out std_logic
        -- q : out std_logic_vector(3 downto 0)
    );
end shift_reg4;

architecture rtl of shift_reg4 is
    signal dff : std_logic_vector(3 downto 0);

begin
    process (clk, rst)
    begin
        if rst = '0' then
            dff <= (others => '0');
        elsif rising_edge(clk) then
            if pl = '1' then
                dff <= din;
            elsif en = '1' then
                if dir = '1' then -- Right Shift
                    dff <= si & dff(3 downto 1);
                    so <=dff(0);
                else -- Left Shift
                    dff <= dff(2 downto 0) & si;
                    so <=dff(3);
                end if;
            end if;
        end if;
    end process;
    

end rtl;
