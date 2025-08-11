library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity fir_filter is

    port (

        clk        : in std_logic;
        rst        : in std_logic;
        valid_in   : in std_logic;
        x          : in std_logic_vector(7 downto 0);
        valid_out  : out std_logic;
        y          : out std_logic_vector(18 downto 0)

    );

end fir_filter;



architecture structural of fir_filter is



component control_unit is

    Port ( 
        clk         : in STD_LOGIC;
        rst         : in STD_LOGIC;
        valid_in    : in STD_LOGIC;
        rom_address : out STD_LOGIC_VECTOR (2 downto 0);
        ram_address : out STD_LOGIC_VECTOR (2 downto 0);
        mac_init    : out STD_LOGIC;
        mac_en      : out STD_LOGIC;
        done        : out STD_LOGIC

    );

end component;



component mlab_rom is 

    generic ( coeff_width : integer := 8 );

    Port (

        clk         : in  STD_LOGIC;
        en          : in  STD_LOGIC;
        rom_address : in  STD_LOGIC_VECTOR (2 downto 0);
        rom_out     : out STD_LOGIC_VECTOR (7 downto 0)

    );

end component;



component mlab_ram is

    generic ( data_width : integer := 8 );

    port (
        clk         : in std_logic;
        rst         : in std_logic;
        we          : in std_logic;
        en          : in std_logic;
        ram_address : in std_logic_vector(2 downto 0);
        ram_in      : in std_logic_vector(7 downto 0);
        ram_out     : out std_logic_vector(7 downto 0)
    );

end component;



component mac is 

    Port ( 
        clk      : in STD_LOGIC;
        mac_en   : in STD_LOGIC;
        mac_init : in STD_LOGIC;
        rom_out  : in STD_LOGIC_VECTOR (7 downto 0);
        ram_out  : in STD_LOGIC_VECTOR (7 downto 0);
        y_out    : out STD_LOGIC_VECTOR (18 downto 0)

    );

end component;



signal rom_addr, ram_addr : std_logic_vector(2 downto 0);
signal rom_out, ram_out   : std_logic_vector(7 downto 0);
signal mac_init, mac_en   : std_logic;
signal done               : std_logic;
signal y_temp             : std_logic_vector(18 downto 0);
signal valid_out_latched  : std_logic := '0';
signal write_enable, valid_in_reg       : std_logic := '0';


begin



    control : control_unit port map(
        clk         => clk,
        rst         => rst,
        valid_in    => write_enable,
        rom_address => rom_addr,
        ram_address => ram_addr,
        mac_init    => mac_init,
        mac_en      => mac_en,
        done        => done
    );


    rom : mlab_rom port map(
        clk         => clk,
        en          => '1',
        rom_address => rom_addr,
        rom_out     => rom_out
    );



    ram : mlab_ram port map(
        clk         => clk,
        rst         => rst,
        we          => write_enable,
        en          => mac_en,
        ram_address => ram_addr,
        ram_in      => x,
        ram_out     => ram_out
    );



    multac : mac port map(
        clk      => clk,
        mac_en   => mac_en,
        mac_init => mac_init,
        rom_out  => rom_out,
        ram_out  => ram_out,
        y_out    => y_temp
    );



    process(clk, rst)
    begin
        if rst = '1' then
            valid_out <= '0';
            valid_out_latched <= '0';
            y <= (others => '0');
        elsif rising_edge(clk) then
            valid_in_reg <= valid_in;
--            if valid_in = '1' and valid_in_reg = '0' then
--                write_enable <= '1';
--            else 
--                write_enable <= '0';
--            end if;
            
            if done = '1' then
                y <= y_temp;
                valid_out <= '1';
                valid_out_latched <= '1';
--          elsif valid_in_reg = '0' and valid_out_latched = '1' then (previous version)
            elsif write_enable = '1' and valid_out_latched = '1' then
                valid_out <= '0';
                valid_out_latched <= '0';
            end if;
        end if;
        
        write_enable <= valid_in and (not valid_in_reg);
        
        
    end process;



end structural;