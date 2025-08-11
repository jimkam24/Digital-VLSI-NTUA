library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_debayering is
end tb_debayering;

architecture behavior of tb_debayering is

    -- Constants
    constant bits : natural := 8;
    constant N : natural := 4;
    constant FIFO_DEPTH : natural := 1024;

    -- Signals
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal new_image : std_logic := '0';
    signal valid_in : std_logic := '0';
    signal pixel : std_logic_vector(bits-1 downto 0) := (others => '0');

    signal image_finished : std_logic;
    signal valid_out : std_logic;
    signal R, G, B : std_logic_vector(bits-1 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;
 
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.debayering
        generic map (
            bits => bits,
            N => N,
            FIFO_DEPTH => FIFO_DEPTH
        )
        port map (
            clk => clk,
            rst => rst,
            new_image => new_image,
            valid_in => valid_in,
            pixel => pixel,
            image_finished => image_finished,
            valid_out => valid_out,
            R => R,
            G => G,
            B => B
        );

    -- Clock process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
        variable cnt : integer := 0;
        type pixel_array is array (0 to 15) of integer;
        constant pixel_values : pixel_array := (
            10, 20, 30, 40,
            50, 60, 70, 80,
            90, 100, 110, 120,
            130, 140, 150, 160
        );
    begin
        -- Reset
        rst <= '0';
        wait for 20 ns;
        rst <= '1';
        wait for clk_period;
        
--        wait until rising_edge(clk); -> this causes problems
        -- Start new image
        new_image <= '1';
        wait for clk_period;
        new_image <= '0';
        
--        valid_in <= '1';
--        wait for clk_period;

        -- Feed in pixels
        for i in 0 to 15 loop
            valid_in <= '1';
            pixel <= std_logic_vector(to_unsigned(pixel_values(i), bits));
            wait for CLK_PERIOD;  -- Wait for half a clock period
            
--            valid_in <= '0';
--            wait for 10*CLK_PERIOD;
            
            cnt := cnt + 1;
        end loop;

        -- After image data, stop valid_in
        valid_in <= '0';

        -- Wait for flushing and done
        wait until image_finished = '1';

        -- Wait a bit more to observe results
        wait for 100 ns;

        -- Finish simulation
        wait;
    end process;

end behavior;
