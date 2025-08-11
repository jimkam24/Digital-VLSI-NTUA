library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity count3_up_down_mod is
    port( 
        clk: in std_logic;
        resetn: in std_logic;
        count_en : in std_logic;
        mod_count : in std_logic_vector(2 downto 0):= "101";
        sum : out std_logic_vector(2 downto 0);
        cout : out std_logic

        );
end count3_up_down_mod;

architecture rtl of count3_up_down_mod is
    signal count: std_logic_vector(2 downto 0):= "000";

begin
    process(clk, resetn)
    begin
        
        if resetn='0' then
            -- �?�?δικας για την πε�?ίπτωση του reset (ενε�?γ�? χαμηλά)
            count <= (others=>'0');

        elsif clk'event and clk='1' then
            -- Χ�?ήση case για πε�?ίπτωση up/down
                if count_en='1' then
                -- �?έτ�?ηση μ�?νο αν count_en = 1
                    if count/=mod_count then 
                        count<=count+1;
                    else
                        count <= "000";
                    end if;
                end if;                 
        end if;
    end process;
    -- Ανάθεση τιμ�?ν στα σήματα εξ�?δου

    sum <= count;
    cout <= '1' when count=7 and count_en='1' else '0';
end rtl;
