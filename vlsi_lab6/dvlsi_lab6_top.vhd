library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dvlsi2021_lab5_top is
  port (
    -- DDR / PS fixed-IO
    DDR_cas_n         : inout STD_LOGIC;
    DDR_cke           : inout STD_LOGIC;
    DDR_ck_n          : inout STD_LOGIC;
    DDR_ck_p          : inout STD_LOGIC;
    DDR_cs_n          : inout STD_LOGIC;
    DDR_reset_n       : inout STD_LOGIC;
    DDR_odt           : inout STD_LOGIC;
    DDR_ras_n         : inout STD_LOGIC;
    DDR_we_n          : inout STD_LOGIC;
    DDR_ba            : inout STD_LOGIC_VECTOR(2 downto 0);
    DDR_addr          : inout STD_LOGIC_VECTOR(14 downto 0);
    DDR_dm            : inout STD_LOGIC_VECTOR(3 downto 0);
    DDR_dq            : inout STD_LOGIC_VECTOR(31 downto 0);
    DDR_dqs_n         : inout STD_LOGIC_VECTOR(3 downto 0);
    DDR_dqs_p         : inout STD_LOGIC_VECTOR(3 downto 0);
    FIXED_IO_mio      : inout STD_LOGIC_VECTOR(53 downto 0);
    FIXED_IO_ddr_vrn  : inout STD_LOGIC;
    FIXED_IO_ddr_vrp  : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk   : inout STD_LOGIC;
    FIXED_IO_ps_porb  : inout STD_LOGIC
  );
end entity dvlsi2021_lab5_top;

architecture arch of dvlsi2021_lab5_top is

  ----------------------------------------------------------------------------
  -- Component declarations

  component design_1_wrapper is
    port (
      -- DDR / fixed IO
      DDR_cas_n         : inout STD_LOGIC;
      DDR_cke           : inout STD_LOGIC;
      DDR_ck_n          : inout STD_LOGIC;
      DDR_ck_p          : inout STD_LOGIC;
      DDR_cs_n          : inout STD_LOGIC;
      DDR_reset_n       : inout STD_LOGIC;
      DDR_odt           : inout STD_LOGIC;
      DDR_ras_n         : inout STD_LOGIC;
      DDR_we_n          : inout STD_LOGIC;
      DDR_ba            : inout STD_LOGIC_VECTOR(2 downto 0);
      DDR_addr          : inout STD_LOGIC_VECTOR(14 downto 0);
      DDR_dm            : inout STD_LOGIC_VECTOR(3 downto 0);
      DDR_dq            : inout STD_LOGIC_VECTOR(31 downto 0);
      DDR_dqs_n         : inout STD_LOGIC_VECTOR(3 downto 0);
      DDR_dqs_p         : inout STD_LOGIC_VECTOR(3 downto 0);
      FIXED_IO_mio      : inout STD_LOGIC_VECTOR(53 downto 0);
      FIXED_IO_ddr_vrn  : inout STD_LOGIC;
      FIXED_IO_ddr_vrp  : inout STD_LOGIC;
      FIXED_IO_ps_srstb : inout STD_LOGIC;
      FIXED_IO_ps_clk   : inout STD_LOGIC;
      FIXED_IO_ps_porb  : inout STD_LOGIC;

      -- PL common
      ACLK      : out STD_LOGIC;
      ARESETN   : out STD_LOGIC_VECTOR(0 to 0);

      -- PS?PL DMA (Master?Slave AXIS)
      M_AXIS_TO_ACCELERATOR_tdata  : out STD_LOGIC_VECTOR(7 downto 0);
      M_AXIS_TO_ACCELERATOR_tkeep  : out STD_LOGIC_VECTOR(0 to 0);
      M_AXIS_TO_ACCELERATOR_tlast  : out STD_LOGIC;
      M_AXIS_TO_ACCELERATOR_tready : in  STD_LOGIC;
      M_AXIS_TO_ACCELERATOR_tvalid : out STD_LOGIC;

      -- PL?PS DMA (Master?Slave AXIS)
      S_AXIS_S2MM_FROM_ACCELERATOR_tdata  : in  STD_LOGIC_VECTOR(31 downto 0);
      S_AXIS_S2MM_FROM_ACCELERATOR_tkeep  : in  STD_LOGIC_VECTOR(3 downto 0);
      S_AXIS_S2MM_FROM_ACCELERATOR_tlast  : in  STD_LOGIC;
      S_AXIS_S2MM_FROM_ACCELERATOR_tready : out STD_LOGIC;
      S_AXIS_S2MM_FROM_ACCELERATOR_tvalid : in  STD_LOGIC
    );
  end component;

  component debayering is
    generic(
      constant bits      : natural := 8;
      constant N         : natural := 128;
      constant FIFO_DEPTH: natural := 1024
    );
    port(
      clk            : in  std_logic;
      rst            : in  std_logic;
      new_image      : in  std_logic;
      valid_in       : in  std_logic;
      pixel          : in  std_logic_vector(bits-1 downto 0);
      valid_out      : out std_logic;
      image_finished : out std_logic;
      R              : out std_logic_vector(bits-1 downto 0);
      G              : out std_logic_vector(bits-1 downto 0);
      B              : out std_logic_vector(bits-1 downto 0)
    );
  end component;


  ----------------------------------------------------------------------------
  -- Signals

  -- Clock / reset
  signal aclk    : std_logic;
  signal aresetn : std_logic_vector(0 to 0);

  -- PS?PL AXIS
  signal pixel     : std_logic_vector(7 downto 0);
  signal valid_in  : std_logic;
  signal ready     : std_logic := '1';  -- always accept from PS-DMA
  signal pixel_buffer : std_logic_vector(8-1 downto 0);

  -- Frame-start marker
  signal state        : std_logic := '0';
  signal valid_in_d1  : std_logic := '0';
  signal new_image    : std_logic;

  -- Debayer core I/O
  signal valid_out      : std_logic;
  signal image_finished : std_logic;
  signal R, G, B        : std_logic_vector(7 downto 0);

  -- PL?PS AXIS payload
  signal data_out : std_logic_vector(31 downto 0);
  signal s2mm_ready : std_logic := '1';

begin

  ----------------------------------------------------------------------------
  -- 1) Processing_System (PS?PL DMA) instantiation

  PROCESSING_SYSTEM_INSTANCE : design_1_wrapper
    port map (
      -- DDR / fixed-IO
      DDR_cas_n         => DDR_cas_n,
      DDR_cke           => DDR_cke,
      DDR_ck_n          => DDR_ck_n,
      DDR_ck_p          => DDR_ck_p,
      DDR_cs_n          => DDR_cs_n,
      DDR_reset_n       => DDR_reset_n,
      DDR_odt           => DDR_odt,
      DDR_ras_n         => DDR_ras_n,
      DDR_we_n          => DDR_we_n,
      DDR_ba            => DDR_ba,
      DDR_addr          => DDR_addr,
      DDR_dm            => DDR_dm,
      DDR_dq            => DDR_dq,
      DDR_dqs_n         => DDR_dqs_n,
      DDR_dqs_p         => DDR_dqs_p,
      FIXED_IO_mio      => FIXED_IO_mio,
      FIXED_IO_ddr_vrn  => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp  => FIXED_IO_ddr_vrp,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      FIXED_IO_ps_clk   => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb  => FIXED_IO_ps_porb,

      -- PL common
      ACLK      => aclk,
      ARESETN   => aresetn,

      -- PS?PL AXI-Stream (Master?Slave)
      M_AXIS_TO_ACCELERATOR_tdata  => pixel,
      M_AXIS_TO_ACCELERATOR_tkeep  => open,        -- unused
      M_AXIS_TO_ACCELERATOR_tlast  => open,        -- we generate new_image
      M_AXIS_TO_ACCELERATOR_tvalid => valid_in,
      M_AXIS_TO_ACCELERATOR_tready => ready,

      -- PL?PS AXI-Stream (Master?Slave)
      S_AXIS_S2MM_FROM_ACCELERATOR_tdata  => data_out,
      S_AXIS_S2MM_FROM_ACCELERATOR_tkeep  => "1111",
      S_AXIS_S2MM_FROM_ACCELERATOR_tlast  => image_finished,
      S_AXIS_S2MM_FROM_ACCELERATOR_tvalid => valid_out,
      S_AXIS_S2MM_FROM_ACCELERATOR_tready => s2mm_ready
    );


  ----------------------------------------------------------------------------
  -- 2) Simple FSM to pulse new_image on the first valid pixel

  -- latch valid_in to detect rising edge
  process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn(0) = '0' then
        valid_in_d1 <= '0';
      else
        valid_in_d1 <= valid_in;
      end if;
    end if;
  end process;

  -- state: '0' = waiting for frame, '1' = in-frame
  process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn(0) = '0' then
        state <= '0';
      elsif (valid_in = '1' and valid_in_d1 = '0') then
        -- first 1 of a burst
        state <= '1';
      elsif image_finished = '1' then
        -- frame done
        state <= '0';
      end if;
    
    pixel_buffer <= pixel;  
      
    end if;
  end process;

  new_image <= '1' when (state = '0' and valid_in = '1' and valid_in_d1 = '0') else '0';


  ----------------------------------------------------------------------------
  -- 3) Debayer core instantiation

  debayering_inst : debayering
    generic map (
      bits       => 8,
      N          => 128,
      FIFO_DEPTH => 1024
    )
    port map (
      clk            => aclk,
      rst            => aresetn(0),
      new_image      => new_image,
      valid_in       => valid_in,
      pixel          => pixel_buffer,
      valid_out      => valid_out,
      image_finished => image_finished,
      R              => R,
      G              => G,
      B              => B
    );


  ----------------------------------------------------------------------------
  -- 4) Pack R, G, B into 32-bit word

  data_out <= x"00" & R & G & B;

end architecture arch;