library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is
    Port ( 
           clk            : in STD_LOGIC;
           rst            : in STD_LOGIC;
           valid_in       : in STD_LOGIC;
           rom_address    : out STD_LOGIC_VECTOR (2 downto 0);
           ram_address    : out STD_LOGIC_VECTOR (2 downto 0);
           mac_init       : out STD_LOGIC
        );
end entity;

architecture behavioral of control_unit is
    signal up_counter: std_logic_vector(2 downto 0);
    signal en : STD_LOGIC;
    begin
        process (clk, rst, valid_in)
        begin
        if (rst = '1') then
            up_counter <= "000";
            mac_init <= '0';
            en <= '0';
        elsif (clk'event and clk = '1') then
            if(en = '1') then
                up_counter <= up_counter +1;
                if(up_counter = "000") then
                    mac_init <= '1';
                else
                    mac_init <= '0';
                end if;
                if up_counter = "111" then
                    en <= '0';  -- <-- this line stops the MAC after 8 cycles
                end if;
            end if;
        end if;
        if(valid_in'event and valid_in = '1') then
            en <= '1';
            up_counter <= "000";
        end if;
        ram_address <= up_counter;
        rom_address <= up_counter;
        end process;

end behavioral;