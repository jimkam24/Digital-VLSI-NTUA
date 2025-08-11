library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_pipelined_adder is
end tb_pipelined_adder;

architecture tb of tb_pipelined_adder is
    component pipelined_adder
        Port ( clk  : in STD_LOGIC;
               a    : in STD_LOGIC_VECTOR (3 downto 0);
               b    : in STD_LOGIC_VECTOR (3 downto 0);
               cin  : in STD_LOGIC;
               sum  : out STD_LOGIC_VECTOR (3 downto 0);
               cout : out STD_LOGIC);
    end component;

    -- Signals
    signal clk  : STD_LOGIC := '0';
    signal a    : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal b    : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal cin  : STD_LOGIC := '0';
    signal sum  : STD_LOGIC_VECTOR (3 downto 0);
    signal cout : STD_LOGIC;

    -- Clock period definition
    constant CLOCK_PERIOD : time := 10 ns;


begin
    -- Instantiate the Unit Under Test (UUT)
    uut: pipelined_adder port map (
        clk  => clk,
        a    => a,
        b    => b,
        cin  => cin,
        sum  => sum,
        cout => cout
    );


    -- Stimulus Process: Check all possible inputs
    STIMULUS: process
    begin
        -- Iterate through all possible values of a, b, cin (256 cases)
        for i in 0 to 15 loop
            for j in 0 to 15 loop
                for k in 0 to 1 loop
                    a   <= std_logic_vector(to_unsigned(i, 4));
                    b   <= std_logic_vector(to_unsigned(j, 4));
                    cin <= std_logic(to_unsigned(k, 1)(0));

                    wait for CLOCK_PERIOD; -- Wait for next clock cycle
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
