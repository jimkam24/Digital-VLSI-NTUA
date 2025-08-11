library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity systolic_multiplier_4bits_tb is
end entity;

architecture tb of systolic_multiplier_4bits_tb is
    component systolic_multiplier_4bits is
    Port ( 
            clk : in std_logic;
            a : in std_logic_vector(4-1 downto 0);
            b: in std_logic_vector(4-1 downto 0);
            p : out std_logic_vector(8-1 downto 0)
        );
    end component;

    signal clk : std_logic;
    signal a, b : std_logic_vector(4-1 downto 0);
    signal p : std_logic_vector(8-1 downto 0);

    constant CLOCK_PERIOD : time := 10 ns;


begin
    uut: systolic_multiplier_4bits port map(
            clk => clk,
            a => a,
            b => b,
            p => p
    );
    
    

    -- Stimulus Process: Check all possible inputs
    STIMULUS: process
    begin
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                a   <= std_logic_vector(to_unsigned(i, 4));
                b   <= std_logic_vector(to_unsigned(j, 4));
    
                    wait for CLOCK_PERIOD; -- Wait for next clock cycle
            end loop;
        end loop;

        -- Stop simulation after all test cases
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

end tb;
