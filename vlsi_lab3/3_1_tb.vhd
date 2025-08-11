library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity full_adder_tb is
end entity;

architecture tb of full_adder_tb is
    component full_adder is
    Port ( 
            a : in STD_LOGIC;
            b: in STD_LOGIC;
            cin : in STD_LOGIC;
            sum : out STD_LOGIC;
            cout : out STD_LOGIC
        );
    end component;

    signal a, b, cin: std_logic;
    signal sum,cout: std_logic;

    constant CLOCK_PERIOD : time := 10 ns;


begin
    uut: full_adder port map(
        a => a,
        b => b,
        cin => cin,
        sum => sum,
        cout => cout
    );

    process 
    begin 
        a <= '0';
        b <= '0';
        cin <= '0';
        wait for CLOCK_PERIOD;
        
        a <= '0';
        b <= '0';
        cin <= '1';
        wait for CLOCK_PERIOD;
        
        a <= '0';
        b <= '1';
        cin <= '0';
        wait for CLOCK_PERIOD;
        
        a <= '0';
        b <= '1';
        cin <= '1';
        wait for CLOCK_PERIOD;
        
        a <= '1';
        b <= '0';
        cin <= '0';
        wait for CLOCK_PERIOD;
        
        a <= '1';
        b <= '0';
        cin <= '1';
        wait for CLOCK_PERIOD;
        
        a <= '1';
        b <= '1';
        cin <= '0';
        wait for CLOCK_PERIOD;
        
        a <= '1';
        b <= '1';
        cin <= '1';
        wait for CLOCK_PERIOD;
        
        wait;
    end process;

end tb;
