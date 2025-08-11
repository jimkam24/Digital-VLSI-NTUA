library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.math_utils.all;
use ieee.math_real.all;

entity serial2parallel is
    generic (
        bits : natural := 8;
        N : natural := 8
    );
    Port (
        clk  : in std_logic;
        rst  : in std_logic;
        pixel_in : in std_logic_vector(bits-1 downto 0);
        valid_in : in std_logic;
        new_image : in std_logic;
        row, col :  std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
        counter :  in std_logic_vector(integer(ceil(log2(real(N*N+2*N+2))))-1 downto 0);
        p00, p01, p02 : out std_logic_vector(bits-1 downto 0);
        p10, p11, p12 : out std_logic_vector(bits-1 downto 0);
        p20, p21, p22 : out std_logic_vector(bits-1 downto 0)
    );
end serial2parallel;

architecture Behavioral of serial2parallel is

component fifo_generator_0
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END component;

signal dff00, dff01, dff02, dff10, dff11, dff12, dff20, dff21, dff22 : std_logic_vector(7 downto 0) := (others => '0');

-- signals for fifo
signal wen0, wen1, wen2, ren0, ren1, ren2 : std_logic := '0';
signal full0, full1, full2, empty0, empty1, empty2  : std_logic;
signal din0, f0_to_f1, f1_to_f2, dout2      : std_logic_vector(7 downto 0);
signal reset_reverse : std_logic;

begin

reset_reverse <= not rst;

fifo0: fifo_generator_0
    port map (
        clk     => clk,
        srst    => reset_reverse,
        din     => pixel_in,
        wr_en   => wen0,
        rd_en   => ren0,
        dout    => f0_to_f1,
        full    => full0,
        empty   => empty0
    );
    
    fifo1: fifo_generator_0
    port map (
        clk     => clk,
        srst    => reset_reverse,
        din     => f0_to_f1,
        wr_en   => wen1,
        rd_en   => ren1,
        dout    => f1_to_f2,
        full    => full1,
        empty   => empty1
    );
    
    
    fifo2: fifo_generator_0
    port map (
        clk     => clk,
        srst    => reset_reverse,
        din     => f1_to_f2,
        wr_en   => wen2,
        rd_en   => ren2,
        dout    => dout2,
        full    => full2,
        empty   => empty2
    );
    
    
s2p: process(rst, clk)
begin
if (rst = '0') then
    dff00 <= (others => '0');
    dff01 <= (others => '0');
    dff02 <= (others => '0');
    dff10 <= (others => '0');
    dff11 <= (others => '0');
    dff12 <= (others => '0');
    dff20 <= (others => '0');
    dff21 <= (others => '0');
    dff22 <= (others => '0');
    wen0 <= '0';
    wen1 <= '0';
    wen2 <= '0';
    ren0 <= '0';
    ren1 <= '0';
    ren2 <= '0';


elsif rising_edge(clk) then 

   -- write pixel to FIFO0 always if valid_in
    if new_image = '1' or valid_in = '1' then
        wen0 <= '1';
    else
        wen0 <= '0';
    end if;
    
    -- read from FIFO0 if enough pixels have been stored
    if unsigned(counter) >= N-1 then
        if valid_in = '1' or unsigned(counter) >= N*N then
            ren0 <= '1';
        else 
            ren0 <= '0';
        end if;
    end if;
    
    -- write to FIFO1
    if unsigned(counter) >= N-1 then
        if valid_in = '1' or unsigned(counter) >= N*N then
            wen1 <= '1';
        else
            wen1 <= '0';
        end if;
    end if;
    
    -- read from FIFO1
    if unsigned(counter) >= 2*N-1 then
        if valid_in = '1' or unsigned(counter) >= N*N then
            ren1 <= '1';
        else
            ren1 <= '0';
        end if;
    end if;
    
    -- write to FIFO2
    if unsigned(counter) >= 2*N-1 then
        if valid_in = '1' or unsigned(counter) >= N*N then
            wen2 <= '1';
        else
            wen2 <= '0';
        end if;
    end if;
    
    -- read from FIFO2
    if unsigned(counter) >= 3*N-1 then
        if valid_in = '1' or unsigned(counter) >= N*N then
            ren2 <= '1';
        else 
            ren2 <= '0';
        end if;
    end if;

    -- shift DFFs when new pixel comes or while flushing
    if valid_in = '1' or unsigned(counter) >= N*N then
        dff02 <= dff01;
        dff01 <= dff00;
        dff00 <= f0_to_f1;
        dff12 <= dff11;
        dff11 <= dff10;
        dff10 <= f1_to_f2;
        dff22 <= dff21;
        dff21 <= dff20;
        dff20 <= dout2;
    end if;
    
    


end if;

end process;

-- map the dff values to the pixel values

-- top?row neighbors (row=0) are invalid
p00 <= dff22 when unsigned(col) > 0  and unsigned(row) > 0      else (others => '0');
p01 <= dff21 when                  unsigned(row) > 0      else (others => '0');
p02 <= dff20 when unsigned(col) < N-1 and unsigned(row) > 0      else (others => '0');

-- middle?row neighbors are always in -bounds horizontally
p10 <= dff12 when unsigned(col) > 0                           else (others => '0');
p11 <= dff11;  -- center always valid
p12 <= dff10 when unsigned(col) < N-1                         else (others => '0');

-- bottom?row neighbors (row=N-1) are invalid
p20 <= dff02 when unsigned(col) > 0  and unsigned(row) < N-1  else (others => '0');
p21 <= dff01 when                  unsigned(row) < N-1  else (others => '0');
p22 <= dff00 when unsigned(col) < N-1 and unsigned(row) < N-1  else (others => '0');


end Behavioral;
