library IEEE;

use IEEE.std_logic_1164.all;

entity decoder_3_to_8_tb_behavioral is
end decoder_3_to_8_tb_behavioral;

architecture decoder_3_to_8_tb_behavioral_arch of decoder_3_to_8_tb_behavioral is

component decoder_3_to_8_behavioral

port(
    enc : in std_logic_vector(3-1 downto 0);
    dec : out std_logic_vector(8-1 downto 0)
);

end component;

-- stimulus signals
signal test_enc : std_logic_vector(3-1 downto 0);
signal test_dec : std_logic_vector(8-1 downto 0);

begin

uut: decoder_3_to_8_behavioral
    port map(
        enc => test_enc,
        dec => test_dec
    );        

testing: process

begin   
    test_enc <= "000";
    wait for 10 ns;
    
    test_enc <= "001";
    wait for 10 ns;
    
    test_enc <= "010";
    wait for 10 ns;
    
    test_enc <= "011";
    wait for 10 ns;

    test_enc <= "100";
    wait for 10 ns;

    test_enc <= "101";
    wait for 10 ns;
    
    test_enc <= "110";
    wait for 10 ns;
    
    test_enc <= "111";
    wait for 10 ns;
    
end process;
    
end decoder_3_to_8_tb_behavioral_arch;

