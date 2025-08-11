library ieee;

use ieee.std_logic_1164.all;

entity parallel_4bit_adder_tb is 
end parallel_4bit_adder_tb;

architecture parallel_4bit_adder_tb_arch of parallel_4bit_adder_tb is 

component parallel_4bit_adder
    port(
        a_vec : in std_logic_vector(4-1 downto 0); 
        b_vec : in std_logic_vector(4-1 downto 0);
        c_1 : in std_logic;
        sum_4 : out std_logic_vector(4-1 downto 0);
        carry_5 : out std_logic
    );
end component;

-- stimulus signals 

signal test_a   : std_logic_vector(4-1 downto 0);
signal test_b : std_logic_vector(4-1 downto 0);
signal test_c1 : std_logic; 
signal test_sum4 : std_logic_vector(4-1 downto 0);
signal test_c5 : std_logic;

begin 

uut: parallel_4bit_adder
    port map(
        a_vec => test_a,
        b_vec => test_b,
        sum_4 => test_sum4,
        c_1 => test_c1,
        carry_5 => test_c5
    );
    
 testing : process
 
 begin 
 
    test_a <= "0000";
    test_b <= "0000";
    test_c1 <= '0';
    wait for 100 ns;
    
    test_a <= "0000";
    test_b <= "0000";
    test_c1 <= '1';
    wait for 100 ns;    
    
    test_a <= "0001";
    test_b <= "0000";
    test_c1 <= '1';
    wait for 100 ns;
        
    test_a <= "0010";
    test_b <= "0100";
    test_c1 <= '1';
    wait for 100 ns;
    
        
    test_a <= "0010";
    test_b <= "0010";
    test_c1 <= '1';
    wait for 100 ns;
    
        
    test_a <= "1000";
    test_b <= "1000";
    test_c1 <= '1';
    wait for 100 ns;
    
    test_a <= "1010";
    test_b <= "1010";
    test_c1 <= '0';
    wait for 100 ns;
    
        
    test_a <= "1010";
    test_b <= "1010";
    test_c1 <= '1';
    wait for 100 ns;
    
        
    test_a <= "0111";
    test_b <= "0111";
    test_c1 <= '1';
    wait for 100 ns;

    test_a <= "1100";
    test_b <= "1100";
    test_c1 <= '1';
    wait for 100 ns;    
 
    
    
   
end process;
end parallel_4bit_adder_tb_arch;