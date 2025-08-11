library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity full_adder_star is
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

end full_adder_star;

architecture structural of full_adder_star is

    -- Full Adder Component
    component full_adder is
        Port ( a    : in STD_LOGIC;
               b    : in STD_LOGIC;
               cin  : in STD_LOGIC;
               sum  : out STD_LOGIC;
               cout : out STD_LOGIC);
    end component;
    
        signal b_in : std_logic;
        signal temp_sout, temp_cout, temp_aout : std_logic; 
    
        
    begin   
        b_in <= a and b;
        
        fa: full_adder port map (
        a    => sin,
        b    => b_in,
        cin  => cin,
        sum  => temp_sout,
        cout => temp_cout
        );
        process (clk)
            begin 
                if rising_edge(clk)  then
                    sout <= temp_sout;
                    cout <= temp_cout;
                    b_out <= b;
                    a_out <= temp_aout;
                    temp_aout <= a;
                end if;
    
        end process;
end structural;