library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity full_adder_star_tb is
end entity;

architecture tb of full_adder_star_tb is
    component full_adder_star is
    Port ( 
            clk : in STD_LOGIC;
            a : in STD_LOGIC;
            b: in STD_LOGIC;
            cin : in STD_LOGIC;
            sin : in STD_LOGIC;
            sout : out STD_LOGIC;
            cout : out STD_LOGIC;
            a_out : out STD_LOGIC;
            b_out : out STD_LOGIC
        );
    end component;

    signal clk, a, b, cin, sin : std_logic;
    signal sout, cout, a_out, b_out : std_logic;

    constant CLOCK_PERIOD : time := 10 ns;


begin
    uut: full_adder_star port map(
            clk => clk,
            a => a,
            b => b,
            cin => cin,
            sin => sin,
            sout => sout,
            cout => cout,
            a_out => a_out,
            b_out =>b_out
    );
    
    

    -- Stimulus Process: Check all possible inputs
    STIMULUS: process
    begin
        for i in 0 to 1 loop
            for j in 0 to 1 loop
                for k in 0 to 1 loop
                    for l in 0 to 1 loop
                        a   <= std_logic(to_unsigned(i, 1)(0));
                        b   <= std_logic(to_unsigned(j, 1)(0));
                        cin <= std_logic(to_unsigned(k, 1)(0));
                        sin <= std_logic(to_unsigned(l, 1)(0));
    
                    wait for CLOCK_PERIOD; -- Wait for next clock cycle
                    end loop;
                end loop;
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
