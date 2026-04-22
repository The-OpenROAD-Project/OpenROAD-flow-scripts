library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
  port(
    en_i : in std_ulogic;
    cnt_o : out unsigned(15 downto 0);
    clk : in std_ulogic;
    rst_n : in std_ulogic
  );
end counter;

architecture rtl of counter is
  signal cnt : unsigned(cnt_o'range);
begin
  cnt <= (others => '0') when rst_n = '0' else cnt + 1 when en_i = '1' and rising_edge(clk); 
  cnt_o <= cnt;
end rtl;
