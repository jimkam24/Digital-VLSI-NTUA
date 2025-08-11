library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fir_filter_tb is
end fir_filter_tb;

architecture behavior of fir_filter_tb is
    
    component fir_filter
        port (
            clk : in std_logic;
            rst : in std_logic;
            valid_in : in std_logic;
            x : in std_logic_vector(7 downto 0);
            valid_out : out std_logic;
            y : out std_logic_vector(18 downto 0)
        );
    end component;
    
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal valid_in  : std_logic := '0';
    signal x         : std_logic_vector(8-1 downto 0) := (others => '0');
    signal valid_out : std_logic;
    signal y         : std_logic_vector(15+3 downto 0);
    
    type input_type is array (16-1 downto 0) of std_logic_vector (8-1 downto 0);                 
    signal input : input_type:= (    "00111111", "10100010", "01111100", "11100001",
    "10001001", "01001011", "11010110", "00101110",
    "11110101", "00010011", "10011010", "01101101",
    "11000111", "01011000", "00000001", "10111110");    
    
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    uut: fir_filter port map (
        clk => clk,
        rst => rst,
        valid_in => valid_in,
        x => x,
        valid_out => valid_out,
        y => y
    );

    clk_process : process
    begin
        while now < 10 ms loop  -- simulation for 5 ms
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;
    
stim_process : process
begin
    -- Reset sequence
    rst <= '1';
    valid_in <= '0';
    wait for 20 ns;
    rst <= '0';
    wait for 20 ns;

    -- input every 8 cycles
    for i in 0 to 15 loop
        valid_in <= '1';  
        x <= input(i); 
        wait for 10 ns; 

        valid_in <= '0';  
        wait for 70 ns; 
    end loop;
    
    wait for 20 ns;
    -- reset again
    rst <= '1';
    valid_in <= '0';
    wait for 20 ns;
    rst <= '0';
    wait for 20 ns;
    
    -- try to input without valid in
    
    for i in 0 to 3 loop  
        x <= input(i); 
        wait for 10 ns; 

        valid_in <= '0';  
        wait for 70 ns; 
    end loop;

    -- calculate again 
    
    for i in 0 to 15 loop
        valid_in <= '1';  
        x <= input(i); 
        wait for 10 ns; 

        valid_in <= '0';  
        wait for 70 ns; 
    end loop;    
    
    
    wait;
end process;

    
end behavior;