library ieee;

use ieee.std_logic_1164.all;

entity bcd_full_adder_tb is 
end bcd_full_adder_tb;

architecture bcd_full_adder_tb_arch of bcd_full_adder_tb is 

component bcd_full_adder is
    Port(
        a_vec : in std_logic_vector (3 downto 0);
        b_vec : in std_logic_vector (3 downto 0);
        cin : in std_logic;
        sum : out std_logic_vector (3 downto 0);
        cout : out std_logic
        );
end component;


-- stimulus signals 


signal test_a   : std_logic_vector(3 downto 0);
signal test_b : std_logic_vector(3 downto 0);
signal test_cin : std_logic; 
signal test_sum : std_logic_vector(3 downto 0);
signal test_cout : std_logic;

begin 

uut: bcd_full_adder
    port map(
        a_vec => test_a,
        b_vec => test_b,
        sum => test_sum,
        cin => test_cin,
        cout => test_cout
    );
    
    testing : process
 
    begin 
 
        test_a <= "0000";
        test_b <= "0000";
        test_cin <= '0';
        wait for 100 ns;
        
        test_a <= "0000";
        test_b <= "0000";
        test_cin  <= '1';
        wait for 100 ns;    
        
        test_a <= "0001";
        test_b <= "0000";
        test_cin <= '1';
        wait for 100 ns;
            
        test_a <= "0010";
        test_b <= "0100";
        test_cin <= '1';
        wait for 100 ns;
        
            
        test_a <= "0010";
        test_b <= "0010";
        test_cin <= '1';
        wait for 100 ns;
        
            
        test_a <= "1000";
        test_b <= "1000";
        test_cin  <= '1';
        wait for 100 ns;
        
        test_a <= "1010";
        test_b <= "1010";
        test_cin <= '0';
        wait for 100 ns;
        
            
        test_a <= "1010";
        test_b <= "1010";
        test_cin <= '1';
        wait for 100 ns;
        
            
        test_a <= "0111";
        test_b <= "0111";
        test_cin <= '1';
        wait for 100 ns;

        test_a <= "1100";
        test_b <= "1100";
        test_cin <= '1';
        wait for 100 ns;    
    
        
    
   
    end process;
end bcd_full_adder_tb_arch;