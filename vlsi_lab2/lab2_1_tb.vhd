library ieee;

use ieee.std_logic_1164.all;

entity half_adder_tb is 
end half_adder_tb;

architecture half_adder_tb_arch of half_adder_tb is 

component half_adder
        port(
        a : in std_logic;
        b : in std_logic;
        sum : out std_logic;
        carry : out std_logic
    );
end component;

-- stimulus signals 

signal test_a   : std_logic;
signal test_b : std_logic; 
signal test_sum : std_logic;
signal test_carry : std_logic;

begin 

uut: half_adder
    port map(
        a => test_a,
        b => test_b,
        sum => test_sum,
        carry => test_carry
    );
    
 testing : process
 
 begin 
 
    test_a <= '0';
    test_b <= '0';
    wait for 100 ns;
    
    test_a <= '1';
    test_b <= '0';
    wait for 100 ns;
    
    test_a <= '0';
    test_b <= '1';
    wait for 100 ns;
    
    test_a <= '1';
    test_b <= '1';
    wait for 100 ns;
   
end process;
end half_adder_tb_arch;