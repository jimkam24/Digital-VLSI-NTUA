library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pipelined_adder is
    Port ( clk  : in STD_LOGIC;
           a    : in STD_LOGIC_VECTOR (3 downto 0);
           b    : in STD_LOGIC_VECTOR (3 downto 0);
           cin  : in STD_LOGIC;
           sum  : out STD_LOGIC_VECTOR (3 downto 0);
           cout : out STD_LOGIC);
end pipelined_adder;

architecture Behavioral of pipelined_adder is
   
    signal temp_sum: std_logic_vector(3 downto 0);
    signal carry : std_logic_vector(3 downto 0);       

    -- Pipeline Registers
    signal a_reg0, a_reg11, a_reg1, a_reg222, a_reg22, a_reg2, a_reg3333, a_reg333, a_reg33, a_reg3 : std_logic;
    signal b_reg0, b_reg11, b_reg1, b_reg222, b_reg22, b_reg2, b_reg3333, b_reg333, b_reg33, b_reg3 : std_logic;
    signal sum_reg_0000, sum_reg_000, sum_reg_00, sum_reg_0 , sum_reg_111, sum_reg_11, sum_reg_1, sum_reg_22, sum_reg_2, sum_reg_3 : std_logic;

    --Carry signals
    signal cout_reg0, cout_reg1, cout_reg2, cout_reg3 : std_logic;

    signal cin_0 : std_logic;

    -- Full Adder Component
    component full_adder is
        Port ( a    : in STD_LOGIC;
               b    : in STD_LOGIC;
               cin  : in STD_LOGIC;
               sum  : out STD_LOGIC;
               cout : out STD_LOGIC);
    end component;

begin
    -- **Pipeline Registers for input**
    process (clk)
    begin
        if rising_edge(clk) then
            cin_0 <= cin;
            a_reg0 <= a(0);
            b_reg0 <= b(0);
            a_reg11 <= a(1);
            b_reg11 <= b(1);
            a_reg222 <= a(2);
            b_reg222 <= b(2);
            a_reg3333 <= a(3);
            b_reg3333 <= b(3);

            a_reg1 <= a_reg11;
            b_reg1 <= b_reg11;
            a_reg22 <= a_reg222;
            b_reg22 <= b_reg222;
            a_reg333 <= a_reg3333;
            b_reg333 <= b_reg3333;
            sum_reg_0000 <= temp_sum(0);
            cout_reg0 <= carry(0);

            a_reg2 <= a_reg22;
            b_reg2 <= b_reg22;
            a_reg33 <= a_reg333;
            b_reg33 <= b_reg333;
            sum_reg_000 <= sum_reg_0000;
            sum_reg_111 <= temp_sum(1);
            cout_reg1 <= carry(1);

            
            a_reg3 <= a_reg33;
            b_reg3 <= b_reg33;
            sum_reg_00 <= sum_reg_000;
            sum_reg_11 <= sum_reg_111;
            sum_reg_22 <= temp_sum(2);
            cout_reg2 <= carry(2);

            sum_reg_0 <= sum_reg_00;
            sum_reg_1 <= sum_reg_11;
            sum_reg_2 <= sum_reg_22;
            sum_reg_3 <= temp_sum(3);
            cout_reg3 <= carry(3);
        end if;
    end process;

    -- FAs
    fa0: full_adder port map (
        a    => a_reg0,
        b    => b_reg0,
        cin  => cin_0,
        sum  => temp_sum(0),
        cout => carry(0)
    );

    fa1: full_adder port map (
        a    => a_reg1,
        b    => b_reg1,
        cin  => cout_reg0,
        sum  => temp_sum(1),
        cout => carry(1)
    );

    fa2: full_adder port map (
        a    => a_reg2,
        b    => b_reg2,
        cin  => cout_reg1,
        sum  => temp_sum(2),
        cout => carry(2)
    );

    fa3: full_adder port map (
        a    => a_reg3,
        b    => b_reg3,
        cin  => cout_reg2,
        sum  => temp_sum(3),
        cout => carry(3)
    );
    -- **Final Output**
    sum  <= sum_reg_3 & sum_reg_2 & sum_reg_1 & sum_reg_0;
    cout <= cout_reg3;

end Behavioral;
