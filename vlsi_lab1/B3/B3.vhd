library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity count3_up_down is
    port( 
        clk: in std_logic;
        resetn: in std_logic;
        count_en : in std_logic;
        up_down : in std_logic;
        sum : out std_logic_vector(2 downto 0);
        cout : out std_logic
        );
end count3_up_down;

architecture rtl of count3_up_down is
    signal count: std_logic_vector(2 downto 0):= "000";

begin
    process(clk, resetn)
    begin
        if resetn='0' then
            -- �?�?δικας για την πε�?ίπτωση του reset (ενε�?γ�? χαμηλά)
            count <= (others=>'0');
        elsif clk'event and clk='1' then
            -- Χ�?ήση case για πε�?ίπτωση up/down
            case(up_down) is
                when '1' =>
                    if count_en='1' then
                    -- �?έτ�?ηση μ�?νο αν count_en = 1
                        count<=count+1;
                    end if;
                when others =>
                    if count_en='1' then
                    -- �?έτ�?ηση μ�?νο αν count_en = 1
                        count<=count-1;
                    end if;  
            end case;                    
        end if;
    end process;
    -- Ανάθεση τιμ�?ν στα σήματα εξ�?δου

    sum <= count;
    cout <= '1' when count=7 and count_en='1' else '0';
end rtl;
