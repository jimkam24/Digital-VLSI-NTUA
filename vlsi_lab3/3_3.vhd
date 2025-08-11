library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity systolic_multiplier_4bits is
    Port ( 
            clk : in std_logic;
            a : in std_logic_vector(4-1 downto 0);
            b: in std_logic_vector(4-1 downto 0);
            p : out std_logic_vector(8-1 downto 0)
        );

end systolic_multiplier_4bits;

architecture structural of systolic_multiplier_4bits is

    -- Full Adder Star Component 
    component full_adder_star is
    Port ( 
            clk : in STD_LOGIC;
            a : in STD_LOGIC;
            b: in STD_LOGIC;
            cin : in STD_LOGIC;
            sin : in STD_LOGIC;
            sout : out STD_LOGIC;
            cout : out STD_LOGIC;
            a_out : out STD_LOGIC;
            b_out : out STD_LOGIC
        );
    end component;
    
     signal p5, p4, p44, p3, p33, p333, p2, p22, p222, p2222, p22222 : std_logic;
    signal p1, p11, p111, p1111, p11111, p1_6, p1_7, p0, p00, p000, p0000, p00000, p0_6, p0_7, p0_8, p0_9 : std_logic;
    signal a1,  a2, a22, a3, a33, a333 : std_logic;
    signal b1, b11, b2, b22, b222, b2222, b3, b33, b333, b3333, b33333, b3_6 : std_logic;
    
    -- signals for every level
    
    signal a_temp_0, a_temp_1, a_temp_2, a_temp_3 : std_logic_vector(4-1 downto 0);
    signal b_temp_0, b_temp_1, b_temp_2, b_temp_3 : std_logic_vector(4-1 downto 0);
    signal s_temp_0, s_temp_1, s_temp_2, s_temp_3 : std_logic_vector(4-1 downto 0);
    signal c_temp_0, c_temp_1, c_temp_2, c_temp_3 : std_logic_vector(4-1 downto 0);
    signal carry0_3, carry1_3, carry2_3 : std_logic;
    
    begin 
    
    fas1: full_adder_star port map(
        clk => clk,
        a => a(0),
        b => b(0),
        cin => '0',
        sin => '0',
        sout => s_temp_0(0),
        cout => c_temp_0(0),
        a_out => a_temp_0(0),
        b_out => b_temp_0(0)
        );
        
        fas2: full_adder_star port map(
        clk => clk,
        a => a1,
        b => b_temp_0(0),
        cin => c_temp_0(0),
        sin => '0',
        sout => s_temp_0(1),
        cout => c_temp_0(1),
        a_out => a_temp_0(1),
        b_out => b_temp_0(1)
        );
        
        fas3_1: full_adder_star port map(
        clk => clk,
        a => a2,
        b => b_temp_0(1),
        cin => c_temp_0(1),
        sin => '0',
        sout => s_temp_0(2),
        cout => c_temp_0(2),
        a_out => a_temp_0(2),
        b_out => b_temp_0(2)
        );
        
        fas3_2: full_adder_star port map(
        clk => clk,
        a => a_temp_0(0),
        b => b1,
        cin => '0',
        sin => s_temp_0(1),
        sout => s_temp_1(0),
        cout => c_temp_1(0),
        a_out => a_temp_1(0),
        b_out => b_temp_1(0)
        );
        
        fas4_1: full_adder_star port map(
        clk => clk,
        a => a3,
        b => b_temp_0(2),
        cin => c_temp_0(2),
        sin => '0',
        sout => s_temp_0(3),
        cout => c_temp_0(3),
        a_out => a_temp_0(3),
        b_out => b_temp_0(3)
        );
        
        
        fas4_2: full_adder_star port map(
        clk => clk,
        a => a_temp_0(1),
        b => b_temp_1(0),
        cin => c_temp_1(0),
        sin => s_temp_0(2),
        sout => s_temp_1(1),
        cout => c_temp_1(1),
        a_out => a_temp_1(1),
        b_out => b_temp_1(1)
        );
        
        fas5_1: full_adder_star port map(
        clk => clk,
        a => a_temp_0(2),
        b => b_temp_1(1),
        cin => c_temp_1(1),
        sin => s_temp_0(3),
        sout => s_temp_1(2),
        cout => c_temp_1(2),
        a_out => a_temp_1(2),
        b_out => b_temp_1(2)
        );
        
        fas5_2: full_adder_star port map(
        clk => clk,
        a => a_temp_1(0),
        b => b2,
        cin => '0',
        sin => s_temp_1(1),
        sout => s_temp_2(0),
        cout => c_temp_2(0),
        a_out => a_temp_2(0),
        b_out => b_temp_2(0)
        );
        
        fas6_1: full_adder_star port map(
        clk => clk,
        a => a_temp_0(3),
        b => b_temp_1(2),
        cin => c_temp_1(2),
        sin => carry0_3,
        sout => s_temp_1(3),
        cout => c_temp_1(3),
        a_out => a_temp_1(3),
        b_out => b_temp_1(3)
        );
        

        
        fas6_2: full_adder_star port map(
        clk => clk,
        a => a_temp_1(1),
        b => b_temp_2(0),
        cin => c_temp_2(0),
        sin => s_temp_1(2),
        sout => s_temp_2(1),
        cout => c_temp_2(1),
        a_out => a_temp_2(1),
        b_out => b_temp_2(1)
        );
        
        fas7_1: full_adder_star port map(
        clk => clk,
        a => a_temp_1(2),
        b => b_temp_2(1),
        cin => c_temp_2(1),
        sin => s_temp_1(3),
        sout => s_temp_2(2),
        cout => c_temp_2(2),
        a_out => a_temp_2(2),
        b_out => b_temp_2(2)
        );
        
        fas7_2: full_adder_star port map(
        clk => clk,
        a => a_temp_2(0),
        b => b3,
        cin => '0',
        sin => s_temp_2(1),
        sout => s_temp_3(0),
        cout => c_temp_3(0),
        a_out => a_temp_3(0),
        b_out => b_temp_3(0)
        );
        
        fas8_1: full_adder_star port map(
        clk => clk,
        a => a_temp_1(3),
        b => b_temp_2(2),
        cin => c_temp_2(2),
        sin => carry1_3,
        sout => s_temp_2(3),
        cout => c_temp_2(3),
        a_out => a_temp_2(3),
        b_out => b_temp_2(3)
        );
        

        
        fas8_2: full_adder_star port map(
        clk => clk,
        a => a_temp_2(1),
        b => b_temp_3(0),
        cin => c_temp_3(0),
        sin => s_temp_2(2),
        sout => s_temp_3(1),
        cout => c_temp_3(1),
        a_out => a_temp_3(1),
        b_out => b_temp_3(1)
        );
        
        fas9: full_adder_star port map(
        clk => clk,
        a => a_temp_2(2),
        b => b_temp_3(1),
        cin => c_temp_3(1),
        sin => s_temp_2(3),
        sout => s_temp_3(2),
        cout => c_temp_3(2),
        a_out => a_temp_3(2),
        b_out => b_temp_3(2)
        );
        
        fas10: full_adder_star port map(
        clk => clk,
        a => a_temp_2(3),
        b => b_temp_3(2),
        cin => c_temp_3(2),
        sin => carry2_3,
        sout => s_temp_3(3),
        cout => c_temp_3(3),
        a_out => a_temp_3(3),
        b_out => b_temp_3(3)
        );
        
    process (clk)
    begin
        if rising_edge(clk) then

        p5 <= s_temp_3(2);
        p4 <= p44;
        p44 <= s_temp_3(1);
        p3 <= p33;
        p33 <= p333;
        p333 <= s_temp_3(0);
        p2 <= p22;
        p22 <= p222;
        p222 <= p2222;
        p2222 <= p22222;
        p22222 <= s_temp_2(0);
        p1 <= p11;
        p11 <= p111;
        p111 <= p1111;
        p1111 <= p11111;
        p11111 <= p1_6;
        p1_6 <= p1_7;
        p1_7 <= s_temp_1(0);
        p0 <= p00;
        p00 <= p000;
        p000 <= p0000;
        p0000 <= p00000;
        p00000 <= p0_6;
        p0_6 <= p0_7;
        p0_7 <= p0_8;
        p0_8 <= p0_9;
        p0_9 <= s_temp_0(0);
        
        a3 <= a33;
        a33 <= a333;
        a333 <= a(3);
        a2 <= a22;
        a22 <= a(2);
        a1 <= a(1);
       
        b3 <= b33;
        b33 <= b333;
        b333 <= b3333;
        b3333 <= b33333;
        b33333 <= b3_6;
        b3_6 <= b(3);
        b2 <= b22;
        b22 <= b222;
        b222 <= b2222;
        b2222 <= b(2);
        b1 <= b11;  
        b11 <= b(1);
        
        carry0_3 <= c_temp_0(3);
        carry1_3 <= c_temp_1(3);
        carry2_3 <= c_temp_2(3); 
        end if;
    end process;
    p <= c_temp_3(3) & s_temp_3(3) & p5 & p4 & p3 & p2 & p1 & p0;
end structural;