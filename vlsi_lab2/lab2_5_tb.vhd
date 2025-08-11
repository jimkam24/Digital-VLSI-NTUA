library ieee;

use ieee.std_logic_1164.all;

entity bcd_4bit_parallel_adder_tb is 
end bcd_4bit_parallel_adder_tb;

architecture  bcd_4bit_parallel_adder_tb_arch of bcd_4bit_parallel_adder_tb is 

component bcd_4bit_parallel_adder is
    Port(
        a_vec : in std_logic_vector (15 downto 0);
        b_vec : in std_logic_vector (15 downto 0);
        cin : in std_logic;
        sum : out std_logic_vector (15 downto 0);
        cout : out std_logic
        );
end component;


-- stimulus signals 

signal test_a   : std_logic_vector(15 downto 0);
signal test_b : std_logic_vector(15 downto 0);
signal test_cin : std_logic; 
signal test_sum : std_logic_vector(15 downto 0);
signal test_cout : std_logic;

begin 

uut: bcd_4bit_parallel_adder
    port map(
        a_vec => test_a,
        b_vec => test_b,
        sum => test_sum,
        cin => test_cin,
        cout => test_cout
    );
    
    testing : process
 
    begin 
 
        test_a <= x"0000";
        test_b <= x"0000";
        test_cin <= '0';
        wait for 100 ns;
        
        test_a <= x"0000";
        test_b <= x"0000";
        test_cin  <= '1';
        wait for 100 ns;    
        
        test_a <= x"0001";
        test_b <= x"0000";
        test_cin <= '1';
        wait for 100 ns;
            
        test_a <= x"0001";
        test_b <= x"0002";
        test_cin <= '1';
        wait for 100 ns;
        
            
        test_a <= x"0007";
        test_b <= x"0003";
        test_cin <= '1';
        wait for 100 ns;
        
            
        test_a <= x"0010";
        test_b <= x"0001";
        test_cin  <= '1';
        wait for 100 ns;
        
        test_a <= x"0010";
        test_b <= x"0010";
        test_cin <= '0';
        wait for 100 ns;
        
            
        test_a <= x"1000";
        test_b <= x"0002";
        test_cin <= '1';
        wait for 100 ns;
        
            
        test_a <= x"0010";
        test_b <= x"0100";
        test_cin <= '1';
        wait for 100 ns;

        test_a <= x"1000";
        test_b <= x"0100";
        test_cin <= '1';
        wait for 100 ns;    
   
    end process;
end bcd_4bit_parallel_adder_tb_arch;