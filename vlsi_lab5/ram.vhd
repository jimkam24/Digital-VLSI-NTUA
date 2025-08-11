library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mlab_ram is
	 generic (
		data_width : integer :=8  				--- width of data (bits)
	 );
    port (clk  : in std_logic;
          we   : in std_logic;						--- memory write enable
          en   : in std_logic;				--- operation enable
          rst : in std_logic;
          ram_address : in std_logic_vector(2 downto 0);			-- memory address
          ram_in   : in std_logic_vector(data_width-1 downto 0);		-- input data
          ram_out   : out std_logic_vector(data_width-1 downto 0));		-- output data
end mlab_ram;

architecture Behavioral of mlab_ram is

    type ram_type is array (7 downto 0) of std_logic_vector (data_width-1 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
    signal ram_out_reg : std_logic_vector(data_width-1 downto 0);
	 
begin


    process (clk)
    begin
    
        if (rst = '1') then
            for i in 0 to 7 loop
                RAM(i) <= "00000000";
            end loop;
        end if;
        if clk'event and clk = '1' then
            if en = '1' or we = '1' then
                if we = '1' then				-- write operation
                    RAM(0) <= ram_in;
                    for i in 1 to 7 loop
                        RAM(i) <= RAM(i-1);
                    end loop;
                    ram_out <= ram_in;
                else						-- read operation
                    ram_out <= RAM(conv_integer(ram_address));
                end if;
            end if;
        end if;
    end process;


end Behavioral;