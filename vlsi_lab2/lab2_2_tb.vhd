library ieee;

use ieee.std_logic_1164.all;

entity full_adder_tb is 
end full_adder_tb;

architecture full_adder_tb_arch of full_adder_tb is 

component full_adder
        port(
        in_1 : in std_logic;
        in_2 : in std_logic;
        c_in : in std_logic;
        total_sum : out std_logic;
        c_out : out std_logic
    );
end component;

-- stimulus signals 

signal test_in_1   : std_logic;
signal test_in_2 : std_logic;
signal test_cin : std_logic; 
signal test_sum : std_logic;
signal test_cout : std_logic;

begin 

uut: full_adder
    port map(
        in_1 => test_in_1,
        in_2 => test_in_2,
        total_sum => test_sum,
        c_in => test_cin,
        c_out => test_cout
    );
    
 testing : process
 
 begin 
 
    test_in_1 <= '0';
    test_in_2 <= '0';
    test_cin <= '0';
    wait for 100 ns;
    
    test_in_1 <= '0';
    test_in_2 <= '0';
    test_cin <= '1';
    wait for 100 ns;
    
    test_in_1 <= '0';
    test_in_2 <= '1';
    test_cin <= '0';
    wait for 100 ns;
    
    test_in_1 <= '0';
    test_in_2 <= '1';
    test_cin <= '1';
    wait for 100 ns;    
    
    test_in_1 <= '1';
    test_in_2 <= '0';
    test_cin <= '0';
    wait for 100 ns;      
    
    test_in_1 <= '1';
    test_in_2 <= '0';
    test_cin <= '1';
    wait for 100 ns;  
    
    test_in_1 <= '1';
    test_in_2 <= '1';
    test_cin <= '0';
    wait for 100 ns;
    
    test_in_1 <= '1';
    test_in_2 <= '1';
    test_cin <= '1';
    wait for 100 ns;
   
end process;
end full_adder_tb_arch;