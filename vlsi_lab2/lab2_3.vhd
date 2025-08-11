library ieee;

use ieee.std_logic_1164.all;

entity parallel_4bit_adder is 
    port(
        a_vec : in std_logic_vector(4-1 downto 0); 
        b_vec : in std_logic_vector(4-1 downto 0);
        c_1 : in std_logic;
        sum_4 : out std_logic_vector(4-1 downto 0);
        carry_5 : out std_logic
    );
end entity;

-- structural architecture
architecture parallel_4bit_adder_arch of parallel_4bit_adder is

    signal c_2 : std_logic;
    signal c_3 : std_logic;
    signal c_4 : std_logic;


    component full_adder is
    port(
        in_1 : in std_logic; 
        in_2 : in std_logic;
        c_in : in std_logic;
        total_sum : out std_logic;
        c_out : out std_logic
    );
     end component;
     
     begin
        
        u1: full_adder port map
            (in_1 => a_vec(0),
            in_2 => b_vec(0),
            c_in => c_1,
            total_sum => sum_4(0),
            c_out => c_2
         );
         
        u2: full_adder port map
            (in_1 => a_vec(1),
            in_2 => b_vec(1),
            c_in => c_2,
            total_sum => sum_4(1),
            c_out => c_3
         );
         
          u3: full_adder port map
            (in_1 => a_vec(2),
            in_2 => b_vec(2),
            c_in => c_3,
            total_sum => sum_4(2),
            c_out => c_4
         );
         
         u4: full_adder port map
            (in_1 => a_vec(3),
            in_2 => b_vec(3),
            c_in => c_4,
            total_sum => sum_4(3),
            c_out => carry_5
         );         
end parallel_4bit_adder_arch;

