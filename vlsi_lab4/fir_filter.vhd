library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fir_filter is
    port (
        clk : in std_logic;
        rst : in std_logic;
        valid_in : in std_logic;
        x : in std_logic_vector(8-1 downto 0);
        valid_out : out std_logic;
        y : out std_logic_vector(15 + 3  downto 0)
    );
end fir_filter;
    
architecture structural of fir_filter is

component control_unit is
    Port ( 
           clk            : in STD_LOGIC;
           rst            : in STD_LOGIC;
           valid_in       : in STD_LOGIC;
           rom_address    : out STD_LOGIC_VECTOR (2 downto 0);
           ram_address    : out STD_LOGIC_VECTOR (2 downto 0);
           mac_init       : out STD_LOGIC
        );
end component;

component mlab_rom is 
	 generic (
		coeff_width : integer :=8  				--- width of coefficients (bits)
	 );
    Port ( clk : in  STD_LOGIC;
           en : in  STD_LOGIC;				--- operation enable
           rom_address : in  STD_LOGIC_VECTOR (2 downto 0);			-- memory address
           rom_out : out  STD_LOGIC_VECTOR (coeff_width-1 downto 0));	-- output data
end component;

component mlab_ram is
	 generic (
		data_width : integer :=8  				--- width of data (bits)
	 );
    port (clk  : in std_logic;
          rst : in std_logic;
          we   : in std_logic;						--- memory write enable
          en   : in std_logic;				--- operation enable
          ram_address : in std_logic_vector(2 downto 0);			-- memory address
          ram_in   : in std_logic_vector(data_width-1 downto 0);		-- input data
          ram_out   : out std_logic_vector(data_width-1 downto 0));		-- output data
end component;      

component mac is 
    Port ( 
           clk  : in STD_LOGIC;
           rom_out    : in STD_LOGIC_VECTOR (7 downto 0);
           ram_out    : in STD_LOGIC_VECTOR (7 downto 0);
           mac_init   : in STD_LOGIC;
        --in order to avoid overflow we need 2N + log(N) bits   
           y_out      : out STD_LOGIC_VECTOR (15 + 3  downto 0)
        );
end component;

signal rom_addr, ram_addr : std_logic_vector(3-1 downto 0);
signal en : std_logic := '0';
signal rom_out, ram_out : std_logic_vector(8-1 downto 0);
signal mac_init, out_check : std_logic;
signal counter : std_logic_vector(4-1 downto 0) := "0000";
signal suppress_first : std_logic := '1';
signal y_temp : std_logic_vector(15+3 downto 0);

begin

control : control_unit port map(
    clk => clk,
    rst => rst,
    valid_in => valid_in,
    rom_address => rom_addr,
    ram_address => ram_addr,
    mac_init => mac_init
);

rom : mlab_rom port map(
    clk => clk,
    en => en,
    rom_address => rom_addr,
    rom_out => rom_out
);

ram : mlab_ram port map(
    clk => clk,
    rst => rst,
    we => valid_in,
    en => en,
    ram_address => ram_addr,
    ram_in => x,
    ram_out => ram_out
);

multac : mac port map(
    clk => clk,
    rom_out => rom_out,
    ram_out => ram_out,
    mac_init => mac_init,
    y_out => y_temp
);    

process(rst, clk, valid_in) begin

if (rst = '1') then
    counter <= "0000";
    en <= '0';
    valid_out <= '0';
     suppress_first <= '1';

elsif (clk'event and clk = '1') then
    counter <= counter + 1;
end if;

if (valid_in'event and valid_in = '1') then
    counter <= "0000";
    en <= '1';
end if;

 if (en = '1' and counter = "0001") then
     if (suppress_first = '1') then
         valid_out <= '0';
         suppress_first <= '0';
     end if;
 end if;

if (counter = "1001") then
    en <= '0';
end if;

--if () then
--    y <= y_out;
--end if;

if ((rom_addr(0) = '0') and (rom_addr(1) = '0') and (rom_addr(2) = '0') and (suppress_first = '0')) then
    valid_out <= '1';
end if;

if (valid_in = '1' or counter = "1000") then
    valid_out <= '0';
end if;
--valid_out <= (not rom_addr(0)) and (not rom_addr(1)) and (not rom_addr(2)) and en and (not suppress_first);

if ((rom_addr(0) = '0') and (rom_addr(1) = '0') and (rom_addr(2) = '0') and (suppress_first = '0') and en = '1') then
    y <= y_temp;
end if;

end process;

end structural;