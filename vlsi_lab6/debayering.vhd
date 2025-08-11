library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity debayering is
    generic(
        constant bits: natural := 8;
        constant N: natural := 8;
        FIFO_DEPTH : natural := 1024  -- πρόσθεσέ το

    );
    port( 
        clk : in std_logic;
        rst : in std_logic;
        new_image : in std_logic;
        valid_in : in std_logic;
        pixel : in std_logic_vector(bits-1 downto 0);
        image_finished : out std_logic;
        valid_out : out std_logic;
        R : out std_logic_vector(bits-1 downto 0);
        G : out std_logic_vector(bits-1 downto 0);
        B : out std_logic_vector(bits-1 downto 0)
    );
end debayering;

architecture Behavioral of debayering is

    constant FLUSH_TIME : natural := 2*N + 2;
    constant TOTAL_TIME : natural := N*N + FLUSH_TIME;

    -- Internal signals
    signal s2p_p00, s2p_p01, s2p_p02 : std_logic_vector(bits-1 downto 0);
    signal s2p_p10, s2p_p11, s2p_p12 : std_logic_vector(bits-1 downto 0);
    signal s2p_p20, s2p_p21, s2p_p22 : std_logic_vector(bits-1 downto 0);
    signal row_counter, col_counter : std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');
    signal cycles_counter : std_logic_vector(integer(ceil(log2(real(N*N+2*N+2))))-1 downto 0) := (others => '0');
    signal row_count_prev, col_count_prev: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0) := (others => '0');

    -- FSM states
    type state_type is (IDLE, RECEIVING, FLUSHING, DONE);
    signal state, next_state : state_type;

    -- Components
    component serial2parallel is
        generic (
            bits : natural := 8;
            N : natural := 8
        );
        port (
            clk : in std_logic;
            rst : in std_logic;
            pixel_in : in std_logic_vector(bits-1 downto 0);
            valid_in : in std_logic;
            new_image : in std_logic;
            row : in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
            col : in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
            counter : in std_logic_vector(integer(ceil(log2(real(N*N+2*N+2))))-1 downto 0);
            p00, p01, p02 : out std_logic_vector(bits-1 downto 0);
            p10, p11, p12 : out std_logic_vector(bits-1 downto 0);
            p20, p21, p22 : out std_logic_vector(bits-1 downto 0)
        );
    end component;

    component calculator is
        generic (
            bits : natural := 8;
            N : natural := 8
        );
        port (
            clk : in std_logic;
            rst : in std_logic;
            row : in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
            col : in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
            p00, p01, p02, p10, p11, p12, p20, p21, p22 : in std_logic_vector(bits-1 downto 0);
            R : out std_logic_vector(bits-1 downto 0);
            G : out std_logic_vector(bits-1 downto 0);
            B : out std_logic_vector(bits-1 downto 0)
        );
    end component;

begin
    
    row_col_prev: process(clk, rst)
    begin
        if rst = '0' then
            row_count_prev <= (others => '0');
            col_count_prev <= (others => '0');
        elsif rising_edge(clk) then
            if valid_in='1' or unsigned(cycles_counter) >= N*N then
                row_count_prev <= row_counter;
                col_count_prev <= col_counter;
            end if;
        end if;
    end process;

    -- FSM state register
    process(clk, rst)
    begin
        if rst = '0' then
            state <= IDLE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- FSM next state logic
    process(state, new_image, valid_in, cycles_counter)
    begin
        case state is
            when IDLE =>
                if valid_in = '1' then
                    next_state <= RECEIVING;
                else
                    next_state <= IDLE;
                end if;

            when RECEIVING =>
                if unsigned(cycles_counter) = N*N-1 then
                    next_state <= FLUSHING;
                else
                    next_state <= RECEIVING;
                end if;

            when FLUSHING =>
                if unsigned(cycles_counter) = TOTAL_TIME then
                    next_state <= DONE;
                else
                    next_state <= FLUSHING;
                end if;

            when DONE =>
                next_state <= IDLE;

            when others =>
                next_state <= IDLE;
        end case;
    end process;

    -- Counters
    process(clk, rst)
    begin
        if rst = '0' then
            cycles_counter <= (others => '0');
--            cycles_counter(0) <= '1';
            row_counter <= (others => '0');
            col_counter <= (others => '0');
        elsif rising_edge(clk) then
            if (state = RECEIVING or state = FLUSHING or state = IDLE) then
                if valid_in = '1' or state = FLUSHING then
                    cycles_counter <= std_logic_vector(unsigned(cycles_counter) + 1);
                    
                    --peiramatiko
                    if unsigned(cycles_counter) > 2*N  then

                        if unsigned(col_counter) = N-1 then
                            col_counter <= (others => '0');
                            row_counter <= std_logic_vector(unsigned(row_counter) + 1);
                        else
                            col_counter <= std_logic_vector(unsigned(col_counter) + 1);
                        end if;
                    end if;
                end if;
            else
                cycles_counter <= (others => '0');
--                cycles_counter(0) <= '1';

                row_counter <= (others => '0');
                col_counter <= (others => '0');
            end if;
        end if;
    end process;

    valid_out <= '1' when (state = RECEIVING or state = FLUSHING) and unsigned(cycles_counter) > 2*N+2 else '0';
    image_finished <= '1' when (state = DONE or (state = FLUSHING and unsigned(cycles_counter)>TOTAL_TIME-1 )) else '0';

    -- Instantiation
    serial_to_parallel_inst : serial2parallel
        generic map (bits => bits, N => N)
        port map (
            clk => clk,
            rst => rst,
            pixel_in => pixel,
            valid_in => valid_in,
            new_image => new_image,
            row => row_count_prev,
            col => col_count_prev,
            counter => cycles_counter,
            p00 => s2p_p00,
            p01 => s2p_p01,
            p02 => s2p_p02,
            p10 => s2p_p10,
            p11 => s2p_p11,
            p12 => s2p_p12,
            p20 => s2p_p20,
            p21 => s2p_p21,
            p22 => s2p_p22
        );

    calculator_inst : calculator
        generic map (bits => bits, N => N)
        port map (
            clk => clk,
            rst => rst,
            row => row_count_prev,
            col => col_count_prev,
            p00 => s2p_p00,
            p01 => s2p_p01,
            p02 => s2p_p02,
            p10 => s2p_p10,
            p11 => s2p_p11,
            p12 => s2p_p12,
            p20 => s2p_p20,
            p21 => s2p_p21,
            p22 => s2p_p22,
            R => R,
            G => G,
            B => B
        );

end Behavioral;