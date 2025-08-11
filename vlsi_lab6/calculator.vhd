library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.math_utils.all;
use ieee.math_real.all;


entity calculator is

generic(
    constant bits: natural := 8;
    constant N: natural := 8
);

  Port (
    clk : in std_logic;
    rst : in std_logic;
    row, col :  std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
    p00, p01, p02, p10, p11, p12, p20, p21, p22 : in std_logic_vector(bits-1 downto 0);
    R : out std_logic_vector(bits-1 downto 0);
    G : out std_logic_vector(bits-1 downto 0);
    B : out std_logic_vector(bits-1 downto 0)
  );
end calculator;



architecture Behavioral of calculator is

begin

calculation: process(rst, clk)

begin

if (rst = '0') then 

    R <= (others => '0');
    G <= (others => '0');
    B <= (others => '0');
end if;

if rising_edge(clk) then 

-- if pixel is green (type ii)
if (row(0) = '0' and col(0) = '0') then
    R <= std_logic_vector(resize(shift_right(unsigned("0" & p01) + unsigned("0" & p21), 1), bits));
    G <= p11;
    B <= std_logic_vector(resize(shift_right(unsigned("0" & p10) + unsigned("0" & p12), 1), bits));

-- if pixel is blue
elsif (row(0) = '0' and col(0) = '1') then
    R <= std_logic_vector(resize(
        shift_right(unsigned("00" & p00) + unsigned("00" & p02) + unsigned("00" & p20) + unsigned("00" & p22), 2),
        bits));
    G <= std_logic_vector(resize(
        shift_right(unsigned("00" & p10) + unsigned("00" & p12) + unsigned("00" & p01) + unsigned("00" & p21), 2),
        bits));
    B <= p11;

-- if pixel is red
elsif (row(0) = '1' and col(0) = '0') then
    R <= p11;
    G <= std_logic_vector(resize(
        shift_right(unsigned("00" & p10) + unsigned("00" & p12) + unsigned("00" & p01) + unsigned("00" & p21), 2),
        bits));
    B <= std_logic_vector(resize(
        shift_right(unsigned("00" & p00) + unsigned("00" & p02) + unsigned("00" & p20) + unsigned("00" & p22), 2),
        bits));
-- if pixel is green (type i)
else -- row(0) = '1' and col(0) = '1'
    R <= std_logic_vector(resize(shift_right(unsigned("0" & p10) + unsigned("0" & p12), 1), bits));
    G <= p11;
    B <= std_logic_vector(resize(shift_right(unsigned("0" & p01) + unsigned("0" & p21), 1), bits));

end if;
end if;

end process;


end Behavioral;