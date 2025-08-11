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
           mac_init       : out STD_LOGIC;
           mac_en         : out STD_LOGIC;
           done           : out STD_LOGIC
        );
end entity;

architecture behavioral of control_unit is
    signal up_counter     : std_logic_vector(2 downto 0) := "000";
    signal en             : std_logic := '0';
    signal valid_in_reg   : std_logic := '0';
    signal done_reg, done_reg_2       : std_logic := '0';
begin
    process (clk, rst)
    begin
        if rst = '1' then
            up_counter    <= "000";
            mac_init      <= '0';
            done_reg      <= '0';
            en            <= '0';
            valid_in_reg  <= '0';

        elsif rising_edge(clk) then
            valid_in_reg <= valid_in;

            -- Start MAC on rising edge of valid_in
            if valid_in = '1' and valid_in_reg = '0' then
                en <= '1';
                up_counter <= "000";
            end if;

            if en = '1' then
                mac_en <= '1';
                if up_counter = "000" then
                    mac_init <= '1';  -- Start accumulation
                else
                    mac_init <= '0';
                end if;

                if up_counter = "111" then
                    en <= '0';        -- Stop after 8 cycles
                    done_reg <= '1';  -- Pulse done
                else
                    done_reg <= '0';
                end if;
                
--                if done_reg = '1' then
--                    done_reg_2 <= '1';
--                else
--                    done_reg_2 <= '0';
--                end if; 

                up_counter <= up_counter + 1;
            else
                mac_init <= '0';
                done_reg <= '0';
                mac_en <= '0';
            end if;             
        done_reg_2 <= done_reg;
        end if;
    end process;
    rom_address <= up_counter;
    ram_address <= up_counter;
    done        <= done_reg_2;
end behavioral;