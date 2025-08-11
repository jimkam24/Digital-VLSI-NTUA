library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity full_adder is
    Port ( 
            a : in STD_LOGIC;
            b: in STD_LOGIC;
            cin : in STD_LOGIC;
            sum : out STD_LOGIC;
            cout : out STD_LOGIC
        );

end full_adder;

architecture behavioral of full_adder is

    signal input: std_logic_vector(2 downto 0);

    begin
        input <= a & b & cin;
        process (input)
        begin
        
        ---for SUM
        if (input = "001" or input = "010" or input = "100" or input = "111") then
        sum <= '1';
        ---single inverted commas used for assigning to one bit
        else
        sum <= '0';
        end if;
        
        ---for CARRY
        if (input = "011" or input = "101" or input = "110" or input = "111") then
        cout <= '1';
        else
        cout <= '0';
        end if;
        
        end process;
end behavioral;