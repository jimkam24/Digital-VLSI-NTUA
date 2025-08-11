library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.TEXTIO.ALL;

entity tb_debayering2 is
end tb_debayering2;

architecture behavior of tb_debayering2 is

    -- Constants matching your DUT
    constant bits       : natural := 8;
    constant N          : natural := 4;
    constant FIFO_DEPTH : natural := 1024;
    constant clk_period : time    := 10 ns;

    -- DUT signals
    signal clk           : std_logic := '0';
    signal rst           : std_logic := '0';
    signal new_image     : std_logic := '0';
    signal valid_in      : std_logic := '0';
    signal pixel         : std_logic_vector(bits-1 downto 0) := (others => '0');
    signal image_finished: std_logic;
    signal valid_out     : std_logic;
    signal R, G, B       : std_logic_vector(bits-1 downto 0);

    -- TextIO file handles
    file pixel_file : TEXT open READ_MODE is "/home/jimkam/VivaldoProjects/dvlsi2021_lab5/input_pixels.txt";
    file rgb_file   : TEXT open WRITE_MODE is "/home/jimkam/VivaldoProjects/dvlsi2021_lab5/output_pixels_vivado.txt";


begin
  

  -- Clock generator
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  -- Instantiate DUT
  uut: entity work.debayering
    generic map (
      bits       => bits,
      N          => N,
      FIFO_DEPTH => FIFO_DEPTH
    )
    port map (
      clk            => clk,
      rst            => rst,
      new_image      => new_image,
      valid_in       => valid_in,
      pixel          => pixel,
      image_finished => image_finished,
      valid_out      => valid_out,
      R              => R,
      G              => G,
      B              => B
    );

  -- Stimulus and file I/O
  stim_proc: process
    variable line_in  : LINE;
    variable pix_val  : integer;
    variable line_out : LINE;
    variable read_count : integer := 0;
  begin
    -- 1) Reset
    rst <= '0';
    wait for 2*clk_period;
    rst <= '1';
    wait for clk_period;

    -- 2) Signal start of new image
    new_image <= '1';
    wait for clk_period;
    new_image <= '0';
    
    valid_in <= '1';
    wait for clk_period;
    

        -- Main loop: run until the DUT itself tells us it's done
    while image_finished = '0' loop
    
      -- Feed a pixel if we still have one, else deassert valid_in
      if not endfile(pixel_file) then
        readline(pixel_file, line_in);
        read(line_in, pix_val);
        pixel    <= std_logic_vector(to_unsigned(pix_val, bits));
        valid_in <= '1';
      else
        valid_in <= '0';
      end if;
    
      -- Apply on the next rising edge
      wait until rising_edge(clk);
    
      -- Capture any valid output
      if valid_out = '1' then
        write(line_out, integer'image(to_integer(unsigned(R))));
        write(line_out, string'(", "));
        write(line_out, integer'image(to_integer(unsigned(G))));
        write(line_out, string'(", "));
        write(line_out, integer'image(to_integer(unsigned(B))));
        writeline(rgb_file, line_out);
      end if;
    
    end loop;
    
    
    


    -- 5) Finish
    wait for 5*clk_period;
    report "Testbench complete" severity note;
    wait;
  end process;

end behavior;