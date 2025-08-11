library ieee;

use ieee.std_logic_1164.all;

entity bcd_full_adder is
    Port(
        a_vec : in std_logic_vector (3 downto 0);
        b_vec : in std_logic_vector (3 downto 0);
        cin : in std_logic;
        sum : out std_logic_vector (3 downto 0);
        cout : out std_logic
        );
end bcd_full_adder;


-- structural architecture
architecture Structural of bcd_full_adder is

    signal sum1: std_logic_vector (3 downto 0);
    signal cout1: std_logic;
    signal cout2 : std_logic;
    signal and1 : std_logic;
    signal and2 : std_logic;
    signal or1 : std_logic;
    signal add_in : std_logic_vector (3 downto 0);



    component parallel_4bit_adder is 
    port(
        a_vec : in std_logic_vector(3 downto 0); 
        b_vec : in std_logic_vector(3 downto 0);
        c_1 : in std_logic;
        sum_4 : out std_logic_vector(3 downto 0);
        carry_5 : out std_logic
    );
    end component;
     
     begin
        
        u1: parallel_4bit_adder port map
        (
            a_vec => a_vec,
            b_vec => b_vec,
            c_1 => cin,
            carry_5 => cout1,
            sum_4 => sum1

        );

        and1 <= sum1(3) and sum1(2);
        and2 <= sum1(3) and sum1(1);
        or1 <= cout1 or and1 or and2;
        add_in <= '0' & or1 & or1 & '0';

        u2: parallel_4bit_adder port map
        (
            a_vec => sum1,
            b_vec => add_in,
            c_1 => '0',
            carry_5 => cout2,
            sum_4 => sum

        );

        cout <= or1;
         
end Structural;

