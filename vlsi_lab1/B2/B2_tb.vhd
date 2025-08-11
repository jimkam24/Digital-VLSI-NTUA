library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg4_tb is
end entity;

architecture tb of shift_reg4_tb is
    component shift_reg4 is
        port (
            clk, rst, en, pl, dir : in std_logic;
            din : in std_logic_vector(3 downto 0);
            si : in std_logic;
            so : out std_logic
        );
    end component;

    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal en    : std_logic := '0';
    signal pl    : std_logic := '0';
    signal dir   : std_logic := '0';
    signal din   : std_logic_vector(3 downto 0) := (others => '0');
    signal si    : std_logic := '0';
    signal so    : std_logic;

    constant CLOCK_PERIOD : time := 10 ns;

begin
    DUT: shift_reg4
        port map (
            clk => clk,
            rst => rst,
            en  => en,
            pl  => pl,
            dir => dir,
            din => din,
            si  => si,
            so  => so
        );



    STIMULUS: process
    begin
        -- Apply reset
        rst <= '0';
        wait for CLOCK_PERIOD;
        rst <= '1';
        wait for CLOCK_PERIOD;

        -- Load parallel data
        pl <= '1';
        din <= "1010";
        wait for CLOCK_PERIOD;
        pl <= '0';
        wait for CLOCK_PERIOD;

        -- Right shift with serial input '1'
        en <= '1';
        dir <= '1';
        si <= '1';
        wait for CLOCK_PERIOD;
        si <= '0';
        wait for CLOCK_PERIOD;

        -- Left shift with serial input '0'
        dir <= '0';
        si <= '0';
        wait for CLOCK_PERIOD;
        si <= '1';
        wait for CLOCK_PERIOD;
        
        -- Disable shifting
        en <= '0';
        wait for CLOCK_PERIOD;

        wait;
    end process;

    GEN_CLK: process
    begin
        while true loop
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
    end process;

end architecture;