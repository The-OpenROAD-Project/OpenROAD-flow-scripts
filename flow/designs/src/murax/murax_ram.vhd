library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity MuraxPipelinedMemoryBusRam is
  port(
    io_bus_cmd_valid : in std_logic;
    io_bus_cmd_ready : out std_logic;
    io_bus_cmd_payload_write : in std_logic;
    io_bus_cmd_payload_address : in unsigned(31 downto 0);
    io_bus_cmd_payload_data : in std_logic_vector(31 downto 0);
    io_bus_cmd_payload_mask : in std_logic_vector(3 downto 0);
    io_bus_rsp_valid : out std_logic;
    io_bus_rsp_payload_data : out std_logic_vector(31 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end MuraxPipelinedMemoryBusRam;

architecture ihp of MuraxPipelinedMemoryBusRam is

  component RM_IHPSG13_1P_1024x8_c2_bm_bist is
    port(
      A_CLK       : in  std_logic;
      A_MEN       : in  std_logic;
      A_WEN       : in  std_logic;
      A_REN       : in  std_logic;
      A_ADDR      : in  std_logic_vector(9 downto 0);
      A_DIN       : in  std_logic_vector(7 downto 0);
      A_DLY       : in  std_logic;
      A_DOUT      : out std_logic_vector(7 downto 0);
      A_BM        : in  std_logic_vector(7 downto 0);
      A_BIST_CLK  : in  std_logic;
      A_BIST_EN   : in  std_logic;
      A_BIST_MEN  : in  std_logic;
      A_BIST_WEN  : in  std_logic;
      A_BIST_REN  : in  std_logic;
      A_BIST_ADDR : in  std_logic_vector(9 downto 0);
      A_BIST_DIN  : in  std_logic_vector(7 downto 0);
      A_BIST_BM   : in  std_logic_vector(7 downto 0)
    );
  end component;

  signal io_bus_cmd_fire            : std_logic;
  signal io_bus_cmd_ready_read_buffer : std_logic;
  signal zz_io_bus_rsp_valid        : std_logic;
  signal word_addr                  : std_logic_vector(9 downto 0);
  signal dout0, dout1, dout2, dout3 : std_logic_vector(7 downto 0);
  signal wen0, wen1, wen2, wen3     : std_logic;
  signal ren                        : std_logic;

begin

  word_addr <= std_logic_vector(io_bus_cmd_payload_address(11 downto 2));
  wen0 <= io_bus_cmd_payload_write and io_bus_cmd_payload_mask(0);
  wen1 <= io_bus_cmd_payload_write and io_bus_cmd_payload_mask(1);
  wen2 <= io_bus_cmd_payload_write and io_bus_cmd_payload_mask(2);
  wen3 <= io_bus_cmd_payload_write and io_bus_cmd_payload_mask(3);
  ren  <= not io_bus_cmd_payload_write;

  ram_byte0 : RM_IHPSG13_1P_1024x8_c2_bm_bist
    port map(
      A_CLK       => io_mainClk,
      A_MEN       => io_bus_cmd_valid,
      A_WEN       => wen0,
      A_REN       => ren,
      A_ADDR      => word_addr,
      A_DIN       => io_bus_cmd_payload_data(7 downto 0),
      A_DLY       => '1',
      A_DOUT      => dout0,
      A_BM        => (others => '1'),
      A_BIST_CLK  => '0',
      A_BIST_EN   => '0',
      A_BIST_MEN  => '0',
      A_BIST_WEN  => '0',
      A_BIST_REN  => '0',
      A_BIST_ADDR => (others => '0'),
      A_BIST_DIN  => (others => '0'),
      A_BIST_BM   => (others => '0')
    );

  ram_byte1 : RM_IHPSG13_1P_1024x8_c2_bm_bist
    port map(
      A_CLK       => io_mainClk,
      A_MEN       => io_bus_cmd_valid,
      A_WEN       => wen1,
      A_REN       => ren,
      A_ADDR      => word_addr,
      A_DIN       => io_bus_cmd_payload_data(15 downto 8),
      A_DLY       => '1',
      A_DOUT      => dout1,
      A_BM        => (others => '1'),
      A_BIST_CLK  => '0',
      A_BIST_EN   => '0',
      A_BIST_MEN  => '0',
      A_BIST_WEN  => '0',
      A_BIST_REN  => '0',
      A_BIST_ADDR => (others => '0'),
      A_BIST_DIN  => (others => '0'),
      A_BIST_BM   => (others => '0')
    );

  ram_byte2 : RM_IHPSG13_1P_1024x8_c2_bm_bist
    port map(
      A_CLK       => io_mainClk,
      A_MEN       => io_bus_cmd_valid,
      A_WEN       => wen2,
      A_REN       => ren,
      A_ADDR      => word_addr,
      A_DIN       => io_bus_cmd_payload_data(23 downto 16),
      A_DLY       => '1',
      A_DOUT      => dout2,
      A_BM        => (others => '1'),
      A_BIST_CLK  => '0',
      A_BIST_EN   => '0',
      A_BIST_MEN  => '0',
      A_BIST_WEN  => '0',
      A_BIST_REN  => '0',
      A_BIST_ADDR => (others => '0'),
      A_BIST_DIN  => (others => '0'),
      A_BIST_BM   => (others => '0')
    );

  ram_byte3 : RM_IHPSG13_1P_1024x8_c2_bm_bist
    port map(
      A_CLK       => io_mainClk,
      A_MEN       => io_bus_cmd_valid,
      A_WEN       => wen3,
      A_REN       => ren,
      A_ADDR      => word_addr,
      A_DIN       => io_bus_cmd_payload_data(31 downto 24),
      A_DLY       => '1',
      A_DOUT      => dout3,
      A_BM        => (others => '1'),
      A_BIST_CLK  => '0',
      A_BIST_EN   => '0',
      A_BIST_MEN  => '0',
      A_BIST_WEN  => '0',
      A_BIST_REN  => '0',
      A_BIST_ADDR => (others => '0'),
      A_BIST_DIN  => (others => '0'),
      A_BIST_BM   => (others => '0')
    );

  io_bus_cmd_ready_read_buffer    <= '1';
  io_bus_cmd_ready                <= io_bus_cmd_ready_read_buffer;
  io_bus_cmd_fire                 <= io_bus_cmd_valid and io_bus_cmd_ready_read_buffer;
  io_bus_rsp_payload_data         <= dout3 & dout2 & dout1 & dout0;
  io_bus_rsp_valid                <= zz_io_bus_rsp_valid;

  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      zz_io_bus_rsp_valid <= '0';
    elsif rising_edge(io_mainClk) then
      zz_io_bus_rsp_valid <= io_bus_cmd_fire and (not io_bus_cmd_payload_write);
    end if;
  end process;

end architecture ihp;
