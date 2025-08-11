library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity count3_up_down_mod_tb is
end entity;

architecture tb of count3_up_down_mod_tb is
    component count3_up_down_mod is
        port (
            clk : in std_logic;
            resetn : in std_logic;
            count_en: in std_logic;
            mod_count : in std_logic_vector(2 downto 0);
            sum : out std_logic_vector(2 downto 0);
            cout : out std_logic
        );
    end component;


    -- inputs 
    signal clk: std_logic;
    signal resetn :  std_logic := '1';
    signal count_en : std_logic := '1';
    signal mod_count : std_logic_vector(2 downto 0) := "101";
    
    -- outputs 
    signal sum : std_logic_vector(2 downto 0);
    signal cout : std_logic;   
    
    constant CLOCK_PERIOD : time := 100 ns;

begin
    DUT: count3_up_down_mod
        port map(
            clk => clk, 
            resetn => resetn,
            count_en => count_en,
            mod_count => mod_count,
            sum => sum,
            cout => cout
    );

    process
    begin
        
        
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;

        
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;

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
