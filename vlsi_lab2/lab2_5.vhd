library ieee;

use ieee.std_logic_1164.all;

entity bcd_4bit_parallel_adder is
    Port(
        a_vec : in std_logic_vector (15 downto 0);
        b_vec : in std_logic_vector (15 downto 0);
        cin : in std_logic;
        sum : out std_logic_vector (15 downto 0);
        cout : out std_logic
        );
end bcd_4bit_parallel_adder;


-- structural architecture
architecture Structural of bcd_4bit_parallel_adder is

    signal cout1 : std_logic;
    signal cout2 : std_logic;
    signal cout3 : std_logic;


    component bcd_full_adder is 
    port(
        a_vec : in std_logic_vector(3 downto 0); 
        b_vec : in std_logic_vector(3 downto 0);
        cin : in std_logic;
        sum : out std_logic_vector(3 downto 0);
        cout : out std_logic
    );
    end component;
     
     begin
        
        u1: bcd_full_adder port map
        (
            a_vec => a_vec(3 downto 0),
            b_vec => b_vec(3 downto 0),
            cin => cin,
            cout => cout1,
            sum => sum(3 downto 0)

        );

        u2: bcd_full_adder port map
        (
            a_vec => a_vec(7 downto 4),
            b_vec => b_vec(7 downto 4),
            cin => cout1,
            cout => cout2,
            sum => sum(7 downto 4)

        );

        u3: bcd_full_adder port map
        (
            a_vec => a_vec(11 downto 8),
            b_vec => b_vec(11 downto 8),
            cin => cout2,
            cout => cout3,
            sum => sum(11 downto 8)

        );

        u4: bcd_full_adder port map
        (
            a_vec => a_vec(15 downto 12),
            b_vec => b_vec(15 downto 12),
            cin => cout3,
            cout => cout,
            sum => sum(15 downto 12)

        );
         
end Structural;