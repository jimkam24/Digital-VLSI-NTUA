library ieee;

use ieee.std_logic_1164.all;

entity full_adder is 
    port(
        in_1 : in std_logic; 
        in_2 : in std_logic;
        c_in : in std_logic;
        total_sum : out std_logic;
        c_out : out std_logic
    );
end entity;

-- structural architecture
architecture full_adder_arch of full_adder is

    signal sub_sum : std_logic;
    signal c_out_1 : std_logic;
    signal c_out_2 : std_logic;

    component half_adder is
        port(
        a : in std_logic;
        b : in std_logic;
        sum : out std_logic;
        carry : out std_logic
        );
     end component;
     
     begin
        
        u1: half_adder port map
            (a => in_1,
            b => in_2,
            sum => sub_sum,
            carry => c_out_1
         );
         
         u2: half_adder port map
            (a => c_in,
            b => sub_sum,
            sum => total_sum,
            carry => c_out_2
         );
         
         c_out <= c_out_1 or c_out_2;
         
end full_adder_arch;

