library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity count3_up_down_tb is
end entity;

architecture tb of count3_up_down_tb is
    component count3_up_down is
        port (
            clk : in std_logic;
            resetn : in std_logic;
            count_en: in std_logic;
            up_down : in std_logic;
            sum : out std_logic_vector(2 downto 0);
            cout : out std_logic
        );
    end component;


    -- inputs 
    signal clk: std_logic;
    signal up_down : std_logic;
    signal resetn :  std_logic := '1';
    signal count_en : std_logic := '1';
    -- outputs 
    signal sum : std_logic_vector(2 downto 0);
    signal cout : std_logic;   
    
    constant CLOCK_PERIOD : time := 100 ns;

begin
    DUT: count3_up_down 
        port map(
            clk => clk, 
            resetn => resetn,
            count_en => count_en,
            up_down => up_down,
            sum => sum,
            cout => cout
    );

    process
    begin
        up_down <= '1';
        
        
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;
        wait for CLOCK_PERIOD;

        up_down <= '0';
        
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
