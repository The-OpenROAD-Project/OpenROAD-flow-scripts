-- Generator : SpinalHDL v1.7.1    git head : 0444bb76ab1d6e19f0ec46bc03c4769776deb7d5
-- Component : de1_murax_franz
-- Git hash  : 24795ef09b88defe2ee1bb335e5caaf7e07e64ff

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

package pkg_enum is
  type BranchCtrlEnum is (INC,B,JAL,JALR);
  type ShiftCtrlEnum is (DISABLE_1,SLL_1,SRL_1,SRA_1);
  type AluBitwiseCtrlEnum is (XOR_1,OR_1,AND_1);
  type AluCtrlEnum is (ADD_SUB,SLT_SLTU,BITWISE);
  type EnvCtrlEnum is (NONE,XRET);
  type Src2CtrlEnum is (RS,IMI,IMS,PC);
  type Src1CtrlEnum is (RS,IMU,PC_INCREMENT,URS1);
  type JtagState is (RESET,IDLE,IR_SELECT,IR_CAPTURE,IR_SHIFT,IR_EXIT1,IR_PAUSE,IR_EXIT2,IR_UPDATE,DR_SELECT,DR_CAPTURE,DR_SHIFT,DR_EXIT1,DR_PAUSE,DR_EXIT2,DR_UPDATE);
  type UartStopType is (UART_ONE,TWO);
  type UartParityType is (NONE,EVEN,ODD);
  type UartCtrlTxState is (IDLE,START,DATA,PARITY,STOP);
  type UartCtrlRxState is (IDLE,START,DATA,PARITY,STOP);

  function pkg_mux (sel : std_logic; one : BranchCtrlEnum; zero : BranchCtrlEnum) return BranchCtrlEnum;
  subtype BranchCtrlEnum_seq_type is std_logic_vector(1 downto 0);
  constant BranchCtrlEnum_seq_INC : BranchCtrlEnum_seq_type := "00";
  constant BranchCtrlEnum_seq_B : BranchCtrlEnum_seq_type := "01";
  constant BranchCtrlEnum_seq_JAL : BranchCtrlEnum_seq_type := "10";
  constant BranchCtrlEnum_seq_JALR : BranchCtrlEnum_seq_type := "11";

  function pkg_mux (sel : std_logic; one : ShiftCtrlEnum; zero : ShiftCtrlEnum) return ShiftCtrlEnum;
  subtype ShiftCtrlEnum_seq_type is std_logic_vector(1 downto 0);
  constant ShiftCtrlEnum_seq_DISABLE_1 : ShiftCtrlEnum_seq_type := "00";
  constant ShiftCtrlEnum_seq_SLL_1 : ShiftCtrlEnum_seq_type := "01";
  constant ShiftCtrlEnum_seq_SRL_1 : ShiftCtrlEnum_seq_type := "10";
  constant ShiftCtrlEnum_seq_SRA_1 : ShiftCtrlEnum_seq_type := "11";

  function pkg_mux (sel : std_logic; one : AluBitwiseCtrlEnum; zero : AluBitwiseCtrlEnum) return AluBitwiseCtrlEnum;
  subtype AluBitwiseCtrlEnum_seq_type is std_logic_vector(1 downto 0);
  constant AluBitwiseCtrlEnum_seq_XOR_1 : AluBitwiseCtrlEnum_seq_type := "00";
  constant AluBitwiseCtrlEnum_seq_OR_1 : AluBitwiseCtrlEnum_seq_type := "01";
  constant AluBitwiseCtrlEnum_seq_AND_1 : AluBitwiseCtrlEnum_seq_type := "10";

  function pkg_mux (sel : std_logic; one : AluCtrlEnum; zero : AluCtrlEnum) return AluCtrlEnum;
  subtype AluCtrlEnum_seq_type is std_logic_vector(1 downto 0);
  constant AluCtrlEnum_seq_ADD_SUB : AluCtrlEnum_seq_type := "00";
  constant AluCtrlEnum_seq_SLT_SLTU : AluCtrlEnum_seq_type := "01";
  constant AluCtrlEnum_seq_BITWISE : AluCtrlEnum_seq_type := "10";

  function pkg_mux (sel : std_logic; one : EnvCtrlEnum; zero : EnvCtrlEnum) return EnvCtrlEnum;
  subtype EnvCtrlEnum_seq_type is std_logic_vector(0 downto 0);
  constant EnvCtrlEnum_seq_NONE : EnvCtrlEnum_seq_type := "0";
  constant EnvCtrlEnum_seq_XRET : EnvCtrlEnum_seq_type := "1";

  function pkg_mux (sel : std_logic; one : Src2CtrlEnum; zero : Src2CtrlEnum) return Src2CtrlEnum;
  subtype Src2CtrlEnum_seq_type is std_logic_vector(1 downto 0);
  constant Src2CtrlEnum_seq_RS : Src2CtrlEnum_seq_type := "00";
  constant Src2CtrlEnum_seq_IMI : Src2CtrlEnum_seq_type := "01";
  constant Src2CtrlEnum_seq_IMS : Src2CtrlEnum_seq_type := "10";
  constant Src2CtrlEnum_seq_PC : Src2CtrlEnum_seq_type := "11";

  function pkg_mux (sel : std_logic; one : Src1CtrlEnum; zero : Src1CtrlEnum) return Src1CtrlEnum;
  subtype Src1CtrlEnum_seq_type is std_logic_vector(1 downto 0);
  constant Src1CtrlEnum_seq_RS : Src1CtrlEnum_seq_type := "00";
  constant Src1CtrlEnum_seq_IMU : Src1CtrlEnum_seq_type := "01";
  constant Src1CtrlEnum_seq_PC_INCREMENT : Src1CtrlEnum_seq_type := "10";
  constant Src1CtrlEnum_seq_URS1 : Src1CtrlEnum_seq_type := "11";

  function pkg_mux (sel : std_logic; one : JtagState; zero : JtagState) return JtagState;
  function pkg_toStdLogicVector_native (value : JtagState) return std_logic_vector;
  function pkg_toJtagState_native (value : std_logic_vector(3 downto 0)) return JtagState;
  function pkg_mux (sel : std_logic; one : UartStopType; zero : UartStopType) return UartStopType;
  subtype UartStopType_seq_type is std_logic_vector(0 downto 0);
  constant UartStopType_seq_ONE : UartStopType_seq_type := "0";
  constant UartStopType_seq_TWO : UartStopType_seq_type := "1";

  function pkg_mux (sel : std_logic; one : UartParityType; zero : UartParityType) return UartParityType;
  subtype UartParityType_seq_type is std_logic_vector(1 downto 0);
  constant UartParityType_seq_NONE : UartParityType_seq_type := "00";
  constant UartParityType_seq_EVEN : UartParityType_seq_type := "01";
  constant UartParityType_seq_ODD : UartParityType_seq_type := "10";

  function pkg_mux (sel : std_logic; one : UartCtrlTxState; zero : UartCtrlTxState) return UartCtrlTxState;
  function pkg_toStdLogicVector_native (value : UartCtrlTxState) return std_logic_vector;
  function pkg_toUartCtrlTxState_native (value : std_logic_vector(2 downto 0)) return UartCtrlTxState;
  function pkg_mux (sel : std_logic; one : UartCtrlRxState; zero : UartCtrlRxState) return UartCtrlRxState;
  function pkg_toStdLogicVector_native (value : UartCtrlRxState) return std_logic_vector;
  function pkg_toUartCtrlRxState_native (value : std_logic_vector(2 downto 0)) return UartCtrlRxState;
end pkg_enum;

package body pkg_enum is
  function pkg_mux (sel : std_logic; one : BranchCtrlEnum; zero : BranchCtrlEnum) return BranchCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : ShiftCtrlEnum; zero : ShiftCtrlEnum) return ShiftCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : AluBitwiseCtrlEnum; zero : AluBitwiseCtrlEnum) return AluBitwiseCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : AluCtrlEnum; zero : AluCtrlEnum) return AluCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : EnvCtrlEnum; zero : EnvCtrlEnum) return EnvCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : Src2CtrlEnum; zero : Src2CtrlEnum) return Src2CtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : Src1CtrlEnum; zero : Src1CtrlEnum) return Src1CtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : JtagState; zero : JtagState) return JtagState is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_toJtagState_native (value : std_logic_vector(3 downto 0)) return JtagState is
  begin
    case value is
      when "0000" => return RESET;
      when "0001" => return IDLE;
      when "0010" => return IR_SELECT;
      when "0011" => return IR_CAPTURE;
      when "0100" => return IR_SHIFT;
      when "0101" => return IR_EXIT1;
      when "0110" => return IR_PAUSE;
      when "0111" => return IR_EXIT2;
      when "1000" => return IR_UPDATE;
      when "1001" => return DR_SELECT;
      when "1010" => return DR_CAPTURE;
      when "1011" => return DR_SHIFT;
      when "1100" => return DR_EXIT1;
      when "1101" => return DR_PAUSE;
      when "1110" => return DR_EXIT2;
      when "1111" => return DR_UPDATE;
      when others => return RESET;
    end case;
  end;
  function pkg_toStdLogicVector_native (value : JtagState) return std_logic_vector is
  begin
    case value is
      when RESET => return "0000";
      when IDLE => return "0001";
      when IR_SELECT => return "0010";
      when IR_CAPTURE => return "0011";
      when IR_SHIFT => return "0100";
      when IR_EXIT1 => return "0101";
      when IR_PAUSE => return "0110";
      when IR_EXIT2 => return "0111";
      when IR_UPDATE => return "1000";
      when DR_SELECT => return "1001";
      when DR_CAPTURE => return "1010";
      when DR_SHIFT => return "1011";
      when DR_EXIT1 => return "1100";
      when DR_PAUSE => return "1101";
      when DR_EXIT2 => return "1110";
      when DR_UPDATE => return "1111";
      when others => return "0000";
    end case;
  end;
  function pkg_mux (sel : std_logic; one : UartStopType; zero : UartStopType) return UartStopType is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : UartParityType; zero : UartParityType) return UartParityType is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : UartCtrlTxState; zero : UartCtrlTxState) return UartCtrlTxState is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_toUartCtrlTxState_native (value : std_logic_vector(2 downto 0)) return UartCtrlTxState is
  begin
    case value is
      when "000" => return IDLE;
      when "001" => return START;
      when "010" => return DATA;
      when "011" => return PARITY;
      when "100" => return STOP;
      when others => return IDLE;
    end case;
  end;
  function pkg_toStdLogicVector_native (value : UartCtrlTxState) return std_logic_vector is
  begin
    case value is
      when IDLE => return "000";
      when START => return "001";
      when DATA => return "010";
      when PARITY => return "011";
      when STOP => return "100";
      when others => return "000";
    end case;
  end;
  function pkg_mux (sel : std_logic; one : UartCtrlRxState; zero : UartCtrlRxState) return UartCtrlRxState is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_toUartCtrlRxState_native (value : std_logic_vector(2 downto 0)) return UartCtrlRxState is
  begin
    case value is
      when "000" => return IDLE;
      when "001" => return START;
      when "010" => return DATA;
      when "011" => return PARITY;
      when "100" => return STOP;
      when others => return IDLE;
    end case;
  end;
  function pkg_toStdLogicVector_native (value : UartCtrlRxState) return std_logic_vector is
  begin
    case value is
      when IDLE => return "000";
      when START => return "001";
      when DATA => return "010";
      when PARITY => return "011";
      when STOP => return "100";
      when others => return "000";
    end case;
  end;
end pkg_enum;


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic;
  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector;
  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector;
  function pkg_not (value : std_logic_vector) return std_logic_vector;
  function pkg_extract (that : unsigned; bitId : integer) return std_logic;
  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned;
  function pkg_cat (a : unsigned; b : unsigned) return unsigned;
  function pkg_not (value : unsigned) return unsigned;
  function pkg_extract (that : signed; bitId : integer) return std_logic;
  function pkg_extract (that : signed; base : unsigned; size : integer) return signed;
  function pkg_cat (a : signed; b : signed) return signed;
  function pkg_not (value : signed) return signed;

  function pkg_mux (sel : std_logic; one : std_logic; zero : std_logic) return std_logic;
  function pkg_mux (sel : std_logic; one : std_logic_vector; zero : std_logic_vector) return std_logic_vector;
  function pkg_mux (sel : std_logic; one : unsigned; zero : unsigned) return unsigned;
  function pkg_mux (sel : std_logic; one : signed; zero : signed) return signed;

  function pkg_toStdLogic (value : boolean) return std_logic;
  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector;
  function pkg_toUnsigned (value : std_logic) return unsigned;
  function pkg_toSigned (value : std_logic) return signed;
  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector;
  function pkg_unsigned (lit : unsigned) return unsigned;
  function pkg_signed (lit : signed) return signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector;
  function pkg_resize (that : unsigned; width : integer) return unsigned;
  function pkg_resize (that : signed; width : integer) return signed;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector;
  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned;
  function pkg_extract (that : signed; high : integer; low : integer) return signed;

  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;

  function pkg_shiftRight (that : unsigned; size : natural) return unsigned;
  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned;

  function pkg_shiftRight (that : signed; size : natural) return signed;
  function pkg_shiftRight (that : signed; size : unsigned) return signed;
  function pkg_shiftLeft (that : signed; size : natural) return signed;
  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;
end  pkg_scala2hdl;

package body pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic is
    alias temp : std_logic_vector(that'length-1 downto 0) is that;
  begin
    if bitId >= temp'length then
      return 'U';
    end if;
    return temp(bitId);
  end pkg_extract;

  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector is
    alias temp : std_logic_vector(that'length-1 downto 0) is that;    constant elementCount : integer := temp'length - size + 1;
    type tableType is array (0 to elementCount-1) of std_logic_vector(size-1 downto 0);
    variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := temp(i + size - 1 downto i);
    end loop;
    if base + size >= elementCount then
      return (size-1 downto 0 => 'U');
    end if;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector is
    variable cat : std_logic_vector(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;

  function pkg_extract (that : unsigned; bitId : integer) return std_logic is
    alias temp : unsigned(that'length-1 downto 0) is that;
  begin
    if bitId >= temp'length then
      return 'U';
    end if;
    return temp(bitId);
  end pkg_extract;

  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned is
    alias temp : unsigned(that'length-1 downto 0) is that;    constant elementCount : integer := temp'length - size + 1;
    type tableType is array (0 to elementCount-1) of unsigned(size-1 downto 0);
    variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := temp(i + size - 1 downto i);
    end loop;
    if base + size >= elementCount then
      return (size-1 downto 0 => 'U');
    end if;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : unsigned; b : unsigned) return unsigned is
    variable cat : unsigned(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : unsigned) return unsigned is
    variable ret : unsigned(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;

  function pkg_extract (that : signed; bitId : integer) return std_logic is
    alias temp : signed(that'length-1 downto 0) is that;
  begin
    if bitId >= temp'length then
      return 'U';
    end if;
    return temp(bitId);
  end pkg_extract;

  function pkg_extract (that : signed; base : unsigned; size : integer) return signed is
    alias temp : signed(that'length-1 downto 0) is that;    constant elementCount : integer := temp'length - size + 1;
    type tableType is array (0 to elementCount-1) of signed(size-1 downto 0);
    variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := temp(i + size - 1 downto i);
    end loop;
    if base + size >= elementCount then
      return (size-1 downto 0 => 'U');
    end if;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : signed; b : signed) return signed is
    variable cat : signed(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : signed) return signed is
    variable ret : signed(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;


  -- unsigned shifts
  function pkg_shiftRight (that : unsigned; size : natural) return unsigned is
    variable ret : unsigned(that'length-1 downto 0);
  begin
    if size >= that'length then
      return "";
    else
      ret := shift_right(that,size);
      return ret(that'length-1-size downto 0);
    end if;
  end pkg_shiftRight;

  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned is
    variable ret : unsigned(that'length-1 downto 0);
  begin
    ret := shift_right(that,to_integer(size));
    return ret;
  end pkg_shiftRight;

  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned is
  begin
    return shift_left(resize(that,that'length + size),size);
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned is
  begin
    return shift_left(resize(that,that'length + 2**size'length - 1),to_integer(size));
  end pkg_shiftLeft;

  -- std_logic_vector shifts
  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  -- signed shifts
  function pkg_shiftRight (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : signed; size : unsigned) return signed is
  begin
    return shift_right(that,to_integer(size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed is
  begin
    return shift_left(resize(that,w),to_integer(size));
  end pkg_shiftLeft;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(rotate_left(unsigned(that),to_integer(size)));
  end pkg_rotateLeft;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector is
    alias temp : std_logic_vector(that'length-1 downto 0) is that;
  begin
    return temp(high downto low);
  end pkg_extract;

  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned is
    alias temp : unsigned(that'length-1 downto 0) is that;
  begin
    return temp(high downto low);
  end pkg_extract;

  function pkg_extract (that : signed; high : integer; low : integer) return signed is
    alias temp : signed(that'length-1 downto 0) is that;
  begin
    return temp(high downto low);
  end pkg_extract;

  function pkg_mux (sel : std_logic; one : std_logic; zero : std_logic) return std_logic is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : std_logic_vector; zero : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : unsigned; zero : unsigned) return unsigned is
    variable ret : unsigned(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : signed; zero : signed) return signed is
    variable ret : signed(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_toStdLogic (value : boolean) return std_logic is
  begin
    if value = true then
      return '1';
    else
      return '0';
    end if;
  end pkg_toStdLogic;

  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector is
    variable ret : std_logic_vector(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toStdLogicVector;

  function pkg_toUnsigned (value : std_logic) return unsigned is
    variable ret : unsigned(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toUnsigned;

  function pkg_toSigned (value : std_logic) return signed is
    variable ret : signed(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toSigned;

  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector is
    alias ret : std_logic_vector(lit'length-1 downto 0) is lit;
  begin
    return ret;
  end pkg_stdLogicVector;

  function pkg_unsigned (lit : unsigned) return unsigned is
    alias ret : unsigned(lit'length-1 downto 0) is lit;
  begin
    return ret;
  end pkg_unsigned;

  function pkg_signed (lit : signed) return signed is
    alias ret : signed(lit'length-1 downto 0) is lit;
  begin
    return ret;
  end pkg_signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector is
  begin
    return std_logic_vector(resize(unsigned(that),width));
  end pkg_resize;

  function pkg_resize (that : unsigned; width : integer) return unsigned is
    variable ret : unsigned(width-1 downto 0);
  begin
    if that'length = 0 then
       ret := (others => '0');
    else
       ret := resize(that,width);
    end if;
    return ret;
  end pkg_resize;
  function pkg_resize (that : signed; width : integer) return signed is
    alias temp : signed(that'length-1 downto 0) is that;
    variable ret : signed(width-1 downto 0);
  begin
    if temp'length = 0 then
       ret := (others => '0');
    elsif temp'length >= width then
       ret := temp(width-1 downto 0);
    else
       ret := resize(temp,width);
    end if;
    return ret;
  end pkg_resize;
end pkg_scala2hdl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity BufferCC is
  port(
    io_dataIn : in std_logic;
    io_dataOut : out std_logic;
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end BufferCC;

architecture arch of BufferCC is
  attribute async_reg : string;

  signal buffers_0 : std_logic;
  attribute async_reg of buffers_0 : signal is "true";
  signal buffers_1 : std_logic;
  attribute async_reg of buffers_1 : signal is "true";
begin
  io_dataOut <= buffers_1;
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      buffers_0 <= pkg_toStdLogic(false);
      buffers_1 <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity BufferCC_1 is
  port(
    io_dataIn : in std_logic;
    io_dataOut : out std_logic;
    io_mainClk : in std_logic;
    resetCtrl_mainClkReset : in std_logic
  );
end BufferCC_1;

architecture arch of BufferCC_1 is
  attribute async_reg : string;

  signal buffers_0 : std_logic := '0';
  attribute async_reg of buffers_0 : signal is "true";
  signal buffers_1 : std_logic := '0';
  attribute async_reg of buffers_1 : signal is "true";
begin
  io_dataOut <= buffers_1;
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity UartCtrlTx is
  port(
    io_configFrame_dataLength : in unsigned(2 downto 0);
    io_configFrame_stop : in UartStopType_seq_type;
    io_configFrame_parity : in UartParityType_seq_type;
    io_samplingTick : in std_logic;
    io_write_valid : in std_logic;
    io_write_ready : out std_logic;
    io_write_payload : in std_logic_vector(7 downto 0);
    io_cts : in std_logic;
    io_txd : out std_logic;
    io_break : in std_logic;
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end UartCtrlTx;

architecture arch of UartCtrlTx is

  signal clockDivider_counter_willIncrement : std_logic;
  signal clockDivider_counter_willClear : std_logic;
  signal clockDivider_counter_valueNext : unsigned(2 downto 0);
  signal clockDivider_counter_value : unsigned(2 downto 0);
  signal clockDivider_counter_willOverflowIfInc : std_logic;
  signal clockDivider_counter_willOverflow : std_logic;
  signal tickCounter_value : unsigned(2 downto 0);
  signal stateMachine_state : UartCtrlTxState;
  signal stateMachine_parity : std_logic;
  signal stateMachine_txd : std_logic;
  signal when_UartCtrlTx_l58 : std_logic;
  signal when_UartCtrlTx_l73 : std_logic;
  signal when_UartCtrlTx_l76 : std_logic;
  signal when_UartCtrlTx_l93 : std_logic;
  signal zz_stateMachine_state : UartCtrlTxState;
  signal zz_io_txd : std_logic;
begin
  process(io_samplingTick)
  begin
    clockDivider_counter_willIncrement <= pkg_toStdLogic(false);
    if io_samplingTick = '1' then
      clockDivider_counter_willIncrement <= pkg_toStdLogic(true);
    end if;
  end process;

  clockDivider_counter_willClear <= pkg_toStdLogic(false);
  clockDivider_counter_willOverflowIfInc <= pkg_toStdLogic(clockDivider_counter_value = pkg_unsigned("100"));
  clockDivider_counter_willOverflow <= (clockDivider_counter_willOverflowIfInc and clockDivider_counter_willIncrement);
  process(clockDivider_counter_willOverflow,clockDivider_counter_value,clockDivider_counter_willIncrement,clockDivider_counter_willClear)
  begin
    if clockDivider_counter_willOverflow = '1' then
      clockDivider_counter_valueNext <= pkg_unsigned("000");
    else
      clockDivider_counter_valueNext <= (clockDivider_counter_value + pkg_resize(unsigned(pkg_toStdLogicVector(clockDivider_counter_willIncrement)),3));
    end if;
    if clockDivider_counter_willClear = '1' then
      clockDivider_counter_valueNext <= pkg_unsigned("000");
    end if;
  end process;

  process(stateMachine_state,io_write_payload,tickCounter_value,stateMachine_parity)
  begin
    stateMachine_txd <= pkg_toStdLogic(true);
    case stateMachine_state is
      when pkg_enum.IDLE =>
      when pkg_enum.START =>
        stateMachine_txd <= pkg_toStdLogic(false);
      when pkg_enum.DATA =>
        stateMachine_txd <= pkg_extract(io_write_payload,to_integer(tickCounter_value));
      when pkg_enum.PARITY =>
        stateMachine_txd <= stateMachine_parity;
      when others =>
    end case;
  end process;

  process(io_break,stateMachine_state,clockDivider_counter_willOverflow,when_UartCtrlTx_l73)
  begin
    io_write_ready <= io_break;
    case stateMachine_state is
      when pkg_enum.IDLE =>
      when pkg_enum.START =>
      when pkg_enum.DATA =>
        if clockDivider_counter_willOverflow = '1' then
          if when_UartCtrlTx_l73 = '1' then
            io_write_ready <= pkg_toStdLogic(true);
          end if;
        end if;
      when pkg_enum.PARITY =>
      when others =>
    end case;
  end process;

  when_UartCtrlTx_l58 <= ((io_write_valid and (not io_cts)) and clockDivider_counter_willOverflow);
  when_UartCtrlTx_l73 <= pkg_toStdLogic(tickCounter_value = io_configFrame_dataLength);
  when_UartCtrlTx_l76 <= pkg_toStdLogic(io_configFrame_parity = UartParityType_seq_NONE);
  when_UartCtrlTx_l93 <= pkg_toStdLogic(tickCounter_value = pkg_resize(pkg_mux(pkg_toStdLogic(io_configFrame_stop = UartStopType_seq_ONE),pkg_unsigned("0"),pkg_unsigned("1")),3));
  zz_stateMachine_state <= pkg_mux(io_write_valid,pkg_enum.START,pkg_enum.IDLE);
  io_txd <= zz_io_txd;
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      clockDivider_counter_value <= pkg_unsigned("000");
      stateMachine_state <= pkg_enum.IDLE;
      zz_io_txd <= pkg_toStdLogic(true);
    elsif rising_edge(io_mainClk) then
      clockDivider_counter_value <= clockDivider_counter_valueNext;
      case stateMachine_state is
        when pkg_enum.IDLE =>
          if when_UartCtrlTx_l58 = '1' then
            stateMachine_state <= pkg_enum.START;
          end if;
        when pkg_enum.START =>
          if clockDivider_counter_willOverflow = '1' then
            stateMachine_state <= pkg_enum.DATA;
          end if;
        when pkg_enum.DATA =>
          if clockDivider_counter_willOverflow = '1' then
            if when_UartCtrlTx_l73 = '1' then
              if when_UartCtrlTx_l76 = '1' then
                stateMachine_state <= pkg_enum.STOP;
              else
                stateMachine_state <= pkg_enum.PARITY;
              end if;
            end if;
          end if;
        when pkg_enum.PARITY =>
          if clockDivider_counter_willOverflow = '1' then
            stateMachine_state <= pkg_enum.STOP;
          end if;
        when others =>
          if clockDivider_counter_willOverflow = '1' then
            if when_UartCtrlTx_l93 = '1' then
              stateMachine_state <= zz_stateMachine_state;
            end if;
          end if;
      end case;
      zz_io_txd <= (stateMachine_txd and (not io_break));
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if clockDivider_counter_willOverflow = '1' then
        tickCounter_value <= (tickCounter_value + pkg_unsigned("001"));
      end if;
      if clockDivider_counter_willOverflow = '1' then
        stateMachine_parity <= (stateMachine_parity xor stateMachine_txd);
      end if;
      case stateMachine_state is
        when pkg_enum.IDLE =>
        when pkg_enum.START =>
          if clockDivider_counter_willOverflow = '1' then
            stateMachine_parity <= pkg_toStdLogic(io_configFrame_parity = UartParityType_seq_ODD);
            tickCounter_value <= pkg_unsigned("000");
          end if;
        when pkg_enum.DATA =>
          if clockDivider_counter_willOverflow = '1' then
            if when_UartCtrlTx_l73 = '1' then
              tickCounter_value <= pkg_unsigned("000");
            end if;
          end if;
        when pkg_enum.PARITY =>
          if clockDivider_counter_willOverflow = '1' then
            tickCounter_value <= pkg_unsigned("000");
          end if;
        when others =>
      end case;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity UartCtrlRx is
  port(
    io_configFrame_dataLength : in unsigned(2 downto 0);
    io_configFrame_stop : in UartStopType_seq_type;
    io_configFrame_parity : in UartParityType_seq_type;
    io_samplingTick : in std_logic;
    io_read_valid : out std_logic;
    io_read_ready : in std_logic;
    io_read_payload : out std_logic_vector(7 downto 0);
    io_rxd : in std_logic;
    io_rts : out std_logic;
    io_error : out std_logic;
    io_break : out std_logic;
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end UartCtrlRx;

architecture arch of UartCtrlRx is
  signal io_rxd_buffercc_io_dataOut : std_logic;

  signal zz_io_rts : std_logic;
  signal sampler_synchroniser : std_logic;
  signal sampler_samples_0 : std_logic;
  signal sampler_samples_1 : std_logic;
  signal sampler_samples_2 : std_logic;
  signal sampler_value : std_logic;
  signal sampler_tick : std_logic;
  signal bitTimer_counter : unsigned(2 downto 0);
  signal bitTimer_tick : std_logic;
  signal when_UartCtrlRx_l43 : std_logic;
  signal bitCounter_value : unsigned(2 downto 0);
  signal break_counter : unsigned(6 downto 0);
  signal break_valid : std_logic;
  signal when_UartCtrlRx_l69 : std_logic;
  signal stateMachine_state : UartCtrlRxState;
  signal stateMachine_parity : std_logic;
  signal stateMachine_shifter : std_logic_vector(7 downto 0);
  signal stateMachine_validReg : std_logic;
  signal when_UartCtrlRx_l93 : std_logic;
  signal when_UartCtrlRx_l103 : std_logic;
  signal when_UartCtrlRx_l111 : std_logic;
  signal when_UartCtrlRx_l113 : std_logic;
  signal when_UartCtrlRx_l125 : std_logic;
  signal when_UartCtrlRx_l136 : std_logic;
  signal when_UartCtrlRx_l139 : std_logic;
begin
  io_rxd_buffercc : entity work.BufferCC
    port map ( 
      io_dataIn => io_rxd,
      io_dataOut => io_rxd_buffercc_io_dataOut,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  process(stateMachine_state,bitTimer_tick,when_UartCtrlRx_l125,when_UartCtrlRx_l136)
  begin
    io_error <= pkg_toStdLogic(false);
    case stateMachine_state is
      when pkg_enum.IDLE =>
      when pkg_enum.START =>
      when pkg_enum.DATA =>
      when pkg_enum.PARITY =>
        if bitTimer_tick = '1' then
          if when_UartCtrlRx_l125 = '0' then
            io_error <= pkg_toStdLogic(true);
          end if;
        end if;
      when others =>
        if bitTimer_tick = '1' then
          if when_UartCtrlRx_l136 = '1' then
            io_error <= pkg_toStdLogic(true);
          end if;
        end if;
    end case;
  end process;

  io_rts <= zz_io_rts;
  sampler_synchroniser <= io_rxd_buffercc_io_dataOut;
  sampler_samples_0 <= sampler_synchroniser;
  process(sampler_tick,when_UartCtrlRx_l43)
  begin
    bitTimer_tick <= pkg_toStdLogic(false);
    if sampler_tick = '1' then
      if when_UartCtrlRx_l43 = '1' then
        bitTimer_tick <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  when_UartCtrlRx_l43 <= pkg_toStdLogic(bitTimer_counter = pkg_unsigned("000"));
  break_valid <= pkg_toStdLogic(break_counter = pkg_unsigned("1000001"));
  when_UartCtrlRx_l69 <= (io_samplingTick and (not break_valid));
  io_break <= break_valid;
  io_read_valid <= stateMachine_validReg;
  when_UartCtrlRx_l93 <= ((sampler_tick and (not sampler_value)) and (not break_valid));
  when_UartCtrlRx_l103 <= pkg_toStdLogic(sampler_value = pkg_toStdLogic(true));
  when_UartCtrlRx_l111 <= pkg_toStdLogic(bitCounter_value = io_configFrame_dataLength);
  when_UartCtrlRx_l113 <= pkg_toStdLogic(io_configFrame_parity = UartParityType_seq_NONE);
  when_UartCtrlRx_l125 <= pkg_toStdLogic(stateMachine_parity = sampler_value);
  when_UartCtrlRx_l136 <= (not sampler_value);
  when_UartCtrlRx_l139 <= pkg_toStdLogic(bitCounter_value = pkg_resize(pkg_mux(pkg_toStdLogic(io_configFrame_stop = UartStopType_seq_ONE),pkg_unsigned("0"),pkg_unsigned("1")),3));
  io_read_payload <= stateMachine_shifter;
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      zz_io_rts <= pkg_toStdLogic(false);
      sampler_samples_1 <= pkg_toStdLogic(true);
      sampler_samples_2 <= pkg_toStdLogic(true);
      sampler_value <= pkg_toStdLogic(true);
      sampler_tick <= pkg_toStdLogic(false);
      break_counter <= pkg_unsigned("0000000");
      stateMachine_state <= pkg_enum.IDLE;
      stateMachine_validReg <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      zz_io_rts <= (not io_read_ready);
      if io_samplingTick = '1' then
        sampler_samples_1 <= sampler_samples_0;
      end if;
      if io_samplingTick = '1' then
        sampler_samples_2 <= sampler_samples_1;
      end if;
      sampler_value <= (((pkg_toStdLogic(false) or ((pkg_toStdLogic(true) and sampler_samples_0) and sampler_samples_1)) or ((pkg_toStdLogic(true) and sampler_samples_0) and sampler_samples_2)) or ((pkg_toStdLogic(true) and sampler_samples_1) and sampler_samples_2));
      sampler_tick <= io_samplingTick;
      if sampler_value = '1' then
        break_counter <= pkg_unsigned("0000000");
      else
        if when_UartCtrlRx_l69 = '1' then
          break_counter <= (break_counter + pkg_unsigned("0000001"));
        end if;
      end if;
      stateMachine_validReg <= pkg_toStdLogic(false);
      case stateMachine_state is
        when pkg_enum.IDLE =>
          if when_UartCtrlRx_l93 = '1' then
            stateMachine_state <= pkg_enum.START;
          end if;
        when pkg_enum.START =>
          if bitTimer_tick = '1' then
            stateMachine_state <= pkg_enum.DATA;
            if when_UartCtrlRx_l103 = '1' then
              stateMachine_state <= pkg_enum.IDLE;
            end if;
          end if;
        when pkg_enum.DATA =>
          if bitTimer_tick = '1' then
            if when_UartCtrlRx_l111 = '1' then
              if when_UartCtrlRx_l113 = '1' then
                stateMachine_state <= pkg_enum.STOP;
                stateMachine_validReg <= pkg_toStdLogic(true);
              else
                stateMachine_state <= pkg_enum.PARITY;
              end if;
            end if;
          end if;
        when pkg_enum.PARITY =>
          if bitTimer_tick = '1' then
            if when_UartCtrlRx_l125 = '1' then
              stateMachine_state <= pkg_enum.STOP;
              stateMachine_validReg <= pkg_toStdLogic(true);
            else
              stateMachine_state <= pkg_enum.IDLE;
            end if;
          end if;
        when others =>
          if bitTimer_tick = '1' then
            if when_UartCtrlRx_l136 = '1' then
              stateMachine_state <= pkg_enum.IDLE;
            else
              if when_UartCtrlRx_l139 = '1' then
                stateMachine_state <= pkg_enum.IDLE;
              end if;
            end if;
          end if;
      end case;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if sampler_tick = '1' then
        bitTimer_counter <= (bitTimer_counter - pkg_unsigned("001"));
        if when_UartCtrlRx_l43 = '1' then
          bitTimer_counter <= pkg_unsigned("100");
        end if;
      end if;
      if bitTimer_tick = '1' then
        bitCounter_value <= (bitCounter_value + pkg_unsigned("001"));
      end if;
      if bitTimer_tick = '1' then
        stateMachine_parity <= (stateMachine_parity xor sampler_value);
      end if;
      case stateMachine_state is
        when pkg_enum.IDLE =>
          if when_UartCtrlRx_l93 = '1' then
            bitTimer_counter <= pkg_unsigned("001");
          end if;
        when pkg_enum.START =>
          if bitTimer_tick = '1' then
            bitCounter_value <= pkg_unsigned("000");
            stateMachine_parity <= pkg_toStdLogic(io_configFrame_parity = UartParityType_seq_ODD);
          end if;
        when pkg_enum.DATA =>
          if bitTimer_tick = '1' then
            stateMachine_shifter(to_integer(bitCounter_value)) <= sampler_value;
            if when_UartCtrlRx_l111 = '1' then
              bitCounter_value <= pkg_unsigned("000");
            end if;
          end if;
        when pkg_enum.PARITY =>
          if bitTimer_tick = '1' then
            bitCounter_value <= pkg_unsigned("000");
          end if;
        when others =>
      end case;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity StreamFifoLowLatency is
  port(
    io_push_valid : in std_logic;
    io_push_ready : out std_logic;
    io_push_payload_error : in std_logic;
    io_push_payload_inst : in std_logic_vector(31 downto 0);
    io_pop_valid : out std_logic;
    io_pop_ready : in std_logic;
    io_pop_payload_error : out std_logic;
    io_pop_payload_inst : out std_logic_vector(31 downto 0);
    io_flush : in std_logic;
    io_occupancy : out unsigned(0 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end StreamFifoLowLatency;

architecture arch of StreamFifoLowLatency is
  signal io_push_ready_read_buffer : std_logic;
  signal io_pop_valid_read_buffer : std_logic;

  signal when_Phase_l649 : std_logic;
  signal pushPtr_willIncrement : std_logic;
  signal pushPtr_willClear : std_logic;
  signal pushPtr_willOverflowIfInc : std_logic;
  signal pushPtr_willOverflow : std_logic;
  signal popPtr_willIncrement : std_logic;
  signal popPtr_willClear : std_logic;
  signal popPtr_willOverflowIfInc : std_logic;
  signal popPtr_willOverflow : std_logic;
  signal ptrMatch : std_logic;
  signal risingOccupancy : std_logic;
  signal empty : std_logic;
  signal full : std_logic;
  signal pushing : std_logic;
  signal popping : std_logic;
  signal readed_error : std_logic;
  signal readed_inst : std_logic_vector(31 downto 0);
  signal zz_readed_error : std_logic_vector(32 downto 0);
  signal when_Stream_l1178 : std_logic;
  signal when_Stream_l1191 : std_logic;
  signal zz_readed_error_1 : std_logic_vector(32 downto 0);
  signal zz_readed_error_2 : std_logic_vector(32 downto 0);
begin
  io_push_ready <= io_push_ready_read_buffer;
  io_pop_valid <= io_pop_valid_read_buffer;
  process(pushing)
  begin
    when_Phase_l649 <= pkg_toStdLogic(false);
    if pushing = '1' then
      when_Phase_l649 <= pkg_toStdLogic(true);
    end if;
  end process;

  process(pushing)
  begin
    pushPtr_willIncrement <= pkg_toStdLogic(false);
    if pushing = '1' then
      pushPtr_willIncrement <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_flush)
  begin
    pushPtr_willClear <= pkg_toStdLogic(false);
    if io_flush = '1' then
      pushPtr_willClear <= pkg_toStdLogic(true);
    end if;
  end process;

  pushPtr_willOverflowIfInc <= pkg_toStdLogic(true);
  pushPtr_willOverflow <= (pushPtr_willOverflowIfInc and pushPtr_willIncrement);
  process(popping)
  begin
    popPtr_willIncrement <= pkg_toStdLogic(false);
    if popping = '1' then
      popPtr_willIncrement <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_flush)
  begin
    popPtr_willClear <= pkg_toStdLogic(false);
    if io_flush = '1' then
      popPtr_willClear <= pkg_toStdLogic(true);
    end if;
  end process;

  popPtr_willOverflowIfInc <= pkg_toStdLogic(true);
  popPtr_willOverflow <= (popPtr_willOverflowIfInc and popPtr_willIncrement);
  ptrMatch <= pkg_toStdLogic(true);
  empty <= (ptrMatch and (not risingOccupancy));
  full <= (ptrMatch and risingOccupancy);
  pushing <= (io_push_valid and io_push_ready_read_buffer);
  popping <= (io_pop_valid_read_buffer and io_pop_ready);
  io_push_ready_read_buffer <= (not full);
  zz_readed_error <= zz_readed_error_1;
  readed_error <= pkg_extract(zz_readed_error,0);
  readed_inst <= pkg_extract(zz_readed_error,32,1);
  when_Stream_l1178 <= (not empty);
  process(when_Stream_l1178,io_push_valid)
  begin
    if when_Stream_l1178 = '1' then
      io_pop_valid_read_buffer <= pkg_toStdLogic(true);
    else
      io_pop_valid_read_buffer <= io_push_valid;
    end if;
  end process;

  process(when_Stream_l1178,readed_error,io_push_payload_error)
  begin
    if when_Stream_l1178 = '1' then
      io_pop_payload_error <= readed_error;
    else
      io_pop_payload_error <= io_push_payload_error;
    end if;
  end process;

  process(when_Stream_l1178,readed_inst,io_push_payload_inst)
  begin
    if when_Stream_l1178 = '1' then
      io_pop_payload_inst <= readed_inst;
    else
      io_pop_payload_inst <= io_push_payload_inst;
    end if;
  end process;

  when_Stream_l1191 <= pkg_toStdLogic(pushing /= popping);
  io_occupancy <= unsigned(pkg_toStdLogicVector((risingOccupancy and ptrMatch)));
  zz_readed_error_1 <= zz_readed_error_2;
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      risingOccupancy <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      if when_Stream_l1191 = '1' then
        risingOccupancy <= pushing;
      end if;
      if io_flush = '1' then
        risingOccupancy <= pkg_toStdLogic(false);
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if when_Phase_l649 = '1' then
        zz_readed_error_2 <= pkg_cat(io_push_payload_inst,pkg_toStdLogicVector(io_push_payload_error));
      end if;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity FlowCCByToggle is
  port(
    io_input_valid : in std_logic;
    io_input_payload_last : in std_logic;
    io_input_payload_fragment : in std_logic_vector(0 downto 0);
    io_output_valid : out std_logic;
    io_output_payload_last : out std_logic;
    io_output_payload_fragment : out std_logic_vector(0 downto 0);
    io_jtag_tck : in std_logic;
    io_mainClk : in std_logic;
    resetCtrl_mainClkReset : in std_logic
  );
end FlowCCByToggle;

architecture arch of FlowCCByToggle is
  signal inputArea_target_buffercc_io_dataOut : std_logic;

  signal inputArea_target : std_logic := '0';
  signal inputArea_data_last : std_logic;
  signal inputArea_data_fragment : std_logic_vector(0 downto 0);
  signal outputArea_target : std_logic;
  signal outputArea_hit : std_logic := '0';
  signal outputArea_flow_valid : std_logic;
  signal outputArea_flow_payload_last : std_logic;
  signal outputArea_flow_payload_fragment : std_logic_vector(0 downto 0);
  signal outputArea_flow_m2sPipe_valid : std_logic;
  signal outputArea_flow_m2sPipe_payload_last : std_logic;
  signal outputArea_flow_m2sPipe_payload_fragment : std_logic_vector(0 downto 0);
begin
  inputArea_target_buffercc : entity work.BufferCC_1
    port map ( 
      io_dataIn => inputArea_target,
      io_dataOut => inputArea_target_buffercc_io_dataOut,
      io_mainClk => io_mainClk,
      resetCtrl_mainClkReset => resetCtrl_mainClkReset 
    );
  outputArea_target <= inputArea_target_buffercc_io_dataOut;
  outputArea_flow_valid <= pkg_toStdLogic(outputArea_target /= outputArea_hit);
  outputArea_flow_payload_last <= inputArea_data_last;
  outputArea_flow_payload_fragment <= inputArea_data_fragment;
  io_output_valid <= outputArea_flow_m2sPipe_valid;
  io_output_payload_last <= outputArea_flow_m2sPipe_payload_last;
  io_output_payload_fragment <= outputArea_flow_m2sPipe_payload_fragment;
  process(io_jtag_tck)
  begin
    if rising_edge(io_jtag_tck) then
      if io_input_valid = '1' then
        inputArea_target <= (not inputArea_target);
        inputArea_data_last <= io_input_payload_last;
        inputArea_data_fragment <= io_input_payload_fragment;
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      outputArea_hit <= outputArea_target;
      if outputArea_flow_valid = '1' then
        outputArea_flow_m2sPipe_payload_last <= outputArea_flow_payload_last;
        outputArea_flow_m2sPipe_payload_fragment <= outputArea_flow_payload_fragment;
      end if;
    end if;
  end process;

  process(io_mainClk, resetCtrl_mainClkReset)
  begin
    if resetCtrl_mainClkReset = '1' then
      outputArea_flow_m2sPipe_valid <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      outputArea_flow_m2sPipe_valid <= outputArea_flow_valid;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity BufferCC_2 is
  port(
    io_dataIn : in std_logic_vector(31 downto 0);
    io_dataOut : out std_logic_vector(31 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end BufferCC_2;

architecture arch of BufferCC_2 is
  attribute async_reg : string;

  signal buffers_0 : std_logic_vector(31 downto 0);
  attribute async_reg of buffers_0 : signal is "true";
  signal buffers_1 : std_logic_vector(31 downto 0);
  attribute async_reg of buffers_1 : signal is "true";
begin
  io_dataOut <= buffers_1;
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity UartCtrl is
  port(
    io_config_frame_dataLength : in unsigned(2 downto 0);
    io_config_frame_stop : in UartStopType_seq_type;
    io_config_frame_parity : in UartParityType_seq_type;
    io_config_clockDivider : in unsigned(19 downto 0);
    io_write_valid : in std_logic;
    io_write_ready : out std_logic;
    io_write_payload : in std_logic_vector(7 downto 0);
    io_read_valid : out std_logic;
    io_read_ready : in std_logic;
    io_read_payload : out std_logic_vector(7 downto 0);
    io_uart_txd : out std_logic;
    io_uart_rxd : in std_logic;
    io_readError : out std_logic;
    io_writeBreak : in std_logic;
    io_readBreak : out std_logic;
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end UartCtrl;

architecture arch of UartCtrl is
  signal tx_io_write_ready : std_logic;
  signal tx_io_txd : std_logic;
  signal rx_io_read_valid : std_logic;
  signal rx_io_read_payload : std_logic_vector(7 downto 0);
  signal rx_io_rts : std_logic;
  signal rx_io_error : std_logic;
  signal rx_io_break : std_logic;

  signal clockDivider_counter : unsigned(19 downto 0);
  signal clockDivider_tick : std_logic;
  signal clockDivider_tickReg : std_logic;
  signal io_write_thrown_valid : std_logic;
  signal io_write_thrown_ready : std_logic;
  signal io_write_thrown_payload : std_logic_vector(7 downto 0);
begin
  tx : entity work.UartCtrlTx
    port map ( 
      io_configFrame_dataLength => io_config_frame_dataLength,
      io_configFrame_stop => io_config_frame_stop,
      io_configFrame_parity => io_config_frame_parity,
      io_samplingTick => clockDivider_tickReg,
      io_write_valid => io_write_thrown_valid,
      io_write_ready => tx_io_write_ready,
      io_write_payload => io_write_thrown_payload,
      io_cts => pkg_toStdLogic(false),
      io_txd => tx_io_txd,
      io_break => io_writeBreak,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  rx : entity work.UartCtrlRx
    port map ( 
      io_configFrame_dataLength => io_config_frame_dataLength,
      io_configFrame_stop => io_config_frame_stop,
      io_configFrame_parity => io_config_frame_parity,
      io_samplingTick => clockDivider_tickReg,
      io_read_valid => rx_io_read_valid,
      io_read_ready => io_read_ready,
      io_read_payload => rx_io_read_payload,
      io_rxd => io_uart_rxd,
      io_rts => rx_io_rts,
      io_error => rx_io_error,
      io_break => rx_io_break,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  clockDivider_tick <= pkg_toStdLogic(clockDivider_counter = pkg_unsigned("00000000000000000000"));
  process(io_write_valid,rx_io_break)
  begin
    io_write_thrown_valid <= io_write_valid;
    if rx_io_break = '1' then
      io_write_thrown_valid <= pkg_toStdLogic(false);
    end if;
  end process;

  process(io_write_thrown_ready,rx_io_break)
  begin
    io_write_ready <= io_write_thrown_ready;
    if rx_io_break = '1' then
      io_write_ready <= pkg_toStdLogic(true);
    end if;
  end process;

  io_write_thrown_payload <= io_write_payload;
  io_write_thrown_ready <= tx_io_write_ready;
  io_read_valid <= rx_io_read_valid;
  io_read_payload <= rx_io_read_payload;
  io_uart_txd <= tx_io_txd;
  io_readError <= rx_io_error;
  io_readBreak <= rx_io_break;
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      clockDivider_counter <= pkg_unsigned("00000000000000000000");
      clockDivider_tickReg <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      clockDivider_tickReg <= clockDivider_tick;
      clockDivider_counter <= (clockDivider_counter - pkg_unsigned("00000000000000000001"));
      if clockDivider_tick = '1' then
        clockDivider_counter <= io_config_clockDivider;
      end if;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity StreamFifo is
  port(
    io_push_valid : in std_logic;
    io_push_ready : out std_logic;
    io_push_payload : in std_logic_vector(7 downto 0);
    io_pop_valid : out std_logic;
    io_pop_ready : in std_logic;
    io_pop_payload : out std_logic_vector(7 downto 0);
    io_flush : in std_logic;
    io_occupancy : out unsigned(4 downto 0);
    io_availability : out unsigned(4 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end StreamFifo;

architecture arch of StreamFifo is
  signal zz_logic_ram_port0 : std_logic_vector(7 downto 0);
  signal io_push_ready_read_buffer : std_logic;
  signal io_pop_valid_read_buffer : std_logic;
  signal zz_logic_ram_port : std_logic;
  signal zz_io_pop_payload : std_logic;

  signal zz_1 : std_logic;
  signal logic_pushPtr_willIncrement : std_logic;
  signal logic_pushPtr_willClear : std_logic;
  signal logic_pushPtr_valueNext : unsigned(3 downto 0);
  signal logic_pushPtr_value : unsigned(3 downto 0);
  signal logic_pushPtr_willOverflowIfInc : std_logic;
  signal logic_pushPtr_willOverflow : std_logic;
  signal logic_popPtr_willIncrement : std_logic;
  signal logic_popPtr_willClear : std_logic;
  signal logic_popPtr_valueNext : unsigned(3 downto 0);
  signal logic_popPtr_value : unsigned(3 downto 0);
  signal logic_popPtr_willOverflowIfInc : std_logic;
  signal logic_popPtr_willOverflow : std_logic;
  signal logic_ptrMatch : std_logic;
  signal logic_risingOccupancy : std_logic;
  signal logic_pushing : std_logic;
  signal logic_popping : std_logic;
  signal logic_empty : std_logic;
  signal logic_full : std_logic;
  signal zz_io_pop_valid : std_logic;
  signal when_Stream_l1078 : std_logic;
  signal logic_ptrDif : unsigned(3 downto 0);
  type logic_ram_type is array (0 to 15) of std_logic_vector(7 downto 0);
  signal logic_ram : logic_ram_type;
begin
  io_push_ready <= io_push_ready_read_buffer;
  io_pop_valid <= io_pop_valid_read_buffer;
  zz_io_pop_payload <= pkg_toStdLogic(true);
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if zz_io_pop_payload = '1' then
        zz_logic_ram_port0 <= logic_ram(to_integer(logic_popPtr_valueNext));
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if zz_1 = '1' then
        logic_ram(to_integer(logic_pushPtr_value)) <= io_push_payload;
      end if;
    end if;
  end process;

  process(logic_pushing)
  begin
    zz_1 <= pkg_toStdLogic(false);
    if logic_pushing = '1' then
      zz_1 <= pkg_toStdLogic(true);
    end if;
  end process;

  process(logic_pushing)
  begin
    logic_pushPtr_willIncrement <= pkg_toStdLogic(false);
    if logic_pushing = '1' then
      logic_pushPtr_willIncrement <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_flush)
  begin
    logic_pushPtr_willClear <= pkg_toStdLogic(false);
    if io_flush = '1' then
      logic_pushPtr_willClear <= pkg_toStdLogic(true);
    end if;
  end process;

  logic_pushPtr_willOverflowIfInc <= pkg_toStdLogic(logic_pushPtr_value = pkg_unsigned("1111"));
  logic_pushPtr_willOverflow <= (logic_pushPtr_willOverflowIfInc and logic_pushPtr_willIncrement);
  process(logic_pushPtr_value,logic_pushPtr_willIncrement,logic_pushPtr_willClear)
  begin
    logic_pushPtr_valueNext <= (logic_pushPtr_value + pkg_resize(unsigned(pkg_toStdLogicVector(logic_pushPtr_willIncrement)),4));
    if logic_pushPtr_willClear = '1' then
      logic_pushPtr_valueNext <= pkg_unsigned("0000");
    end if;
  end process;

  process(logic_popping)
  begin
    logic_popPtr_willIncrement <= pkg_toStdLogic(false);
    if logic_popping = '1' then
      logic_popPtr_willIncrement <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_flush)
  begin
    logic_popPtr_willClear <= pkg_toStdLogic(false);
    if io_flush = '1' then
      logic_popPtr_willClear <= pkg_toStdLogic(true);
    end if;
  end process;

  logic_popPtr_willOverflowIfInc <= pkg_toStdLogic(logic_popPtr_value = pkg_unsigned("1111"));
  logic_popPtr_willOverflow <= (logic_popPtr_willOverflowIfInc and logic_popPtr_willIncrement);
  process(logic_popPtr_value,logic_popPtr_willIncrement,logic_popPtr_willClear)
  begin
    logic_popPtr_valueNext <= (logic_popPtr_value + pkg_resize(unsigned(pkg_toStdLogicVector(logic_popPtr_willIncrement)),4));
    if logic_popPtr_willClear = '1' then
      logic_popPtr_valueNext <= pkg_unsigned("0000");
    end if;
  end process;

  logic_ptrMatch <= pkg_toStdLogic(logic_pushPtr_value = logic_popPtr_value);
  logic_pushing <= (io_push_valid and io_push_ready_read_buffer);
  logic_popping <= (io_pop_valid_read_buffer and io_pop_ready);
  logic_empty <= (logic_ptrMatch and (not logic_risingOccupancy));
  logic_full <= (logic_ptrMatch and logic_risingOccupancy);
  io_push_ready_read_buffer <= (not logic_full);
  io_pop_valid_read_buffer <= ((not logic_empty) and (not (zz_io_pop_valid and (not logic_full))));
  io_pop_payload <= zz_logic_ram_port0;
  when_Stream_l1078 <= pkg_toStdLogic(logic_pushing /= logic_popping);
  logic_ptrDif <= (logic_pushPtr_value - logic_popPtr_value);
  io_occupancy <= unsigned(pkg_cat(pkg_toStdLogicVector((logic_risingOccupancy and logic_ptrMatch)),std_logic_vector(logic_ptrDif)));
  io_availability <= unsigned(pkg_cat(pkg_toStdLogicVector(((not logic_risingOccupancy) and logic_ptrMatch)),std_logic_vector((logic_popPtr_value - logic_pushPtr_value))));
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      logic_pushPtr_value <= pkg_unsigned("0000");
      logic_popPtr_value <= pkg_unsigned("0000");
      logic_risingOccupancy <= pkg_toStdLogic(false);
      zz_io_pop_valid <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      zz_io_pop_valid <= pkg_toStdLogic(logic_popPtr_valueNext = logic_pushPtr_value);
      if when_Stream_l1078 = '1' then
        logic_risingOccupancy <= logic_pushing;
      end if;
      if io_flush = '1' then
        logic_risingOccupancy <= pkg_toStdLogic(false);
      end if;
    end if;
  end process;

end arch;


--StreamFifo_1 replaced by StreamFifo

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity Prescaler is
  port(
    io_clear : in std_logic;
    io_limit : in unsigned(15 downto 0);
    io_overflow : out std_logic;
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end Prescaler;

architecture arch of Prescaler is
  signal io_overflow_read_buffer : std_logic;

  signal counter : unsigned(15 downto 0);
  signal when_Prescaler_l17 : std_logic;
begin
  io_overflow <= io_overflow_read_buffer;
  when_Prescaler_l17 <= (io_clear or io_overflow_read_buffer);
  io_overflow_read_buffer <= pkg_toStdLogic(counter = io_limit);
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      counter <= (counter + pkg_unsigned("0000000000000001"));
      if when_Prescaler_l17 = '1' then
        counter <= pkg_unsigned("0000000000000000");
      end if;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity Timer is
  port(
    io_tick : in std_logic;
    io_clear : in std_logic;
    io_limit : in unsigned(15 downto 0);
    io_full : out std_logic;
    io_value : out unsigned(15 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end Timer;

architecture arch of Timer is

  signal counter : unsigned(15 downto 0);
  signal limitHit : std_logic;
  signal inhibitFull : std_logic;
begin
  limitHit <= pkg_toStdLogic(counter = io_limit);
  io_full <= ((limitHit and io_tick) and (not inhibitFull));
  io_value <= counter;
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      inhibitFull <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      if io_tick = '1' then
        inhibitFull <= limitHit;
      end if;
      if io_clear = '1' then
        inhibitFull <= pkg_toStdLogic(false);
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if io_tick = '1' then
        counter <= (counter + pkg_resize(unsigned(pkg_toStdLogicVector((not limitHit))),16));
      end if;
      if io_clear = '1' then
        counter <= pkg_unsigned("0000000000000000");
      end if;
    end if;
  end process;

end arch;


--Timer_1 replaced by Timer

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity InterruptCtrl is
  port(
    io_inputs : in std_logic_vector(1 downto 0);
    io_clears : in std_logic_vector(1 downto 0);
    io_masks : in std_logic_vector(1 downto 0);
    io_pendings : out std_logic_vector(1 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end InterruptCtrl;

architecture arch of InterruptCtrl is

  signal pendings : std_logic_vector(1 downto 0);
begin
  io_pendings <= (pendings and io_masks);
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      pendings <= pkg_stdLogicVector("00");
    elsif rising_edge(io_mainClk) then
      pendings <= ((pendings and pkg_not(io_clears)) or io_inputs);
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity BufferCC_3 is
  port(
    io_dataIn : in std_logic;
    io_dataOut : out std_logic;
    io_mainClk : in std_logic
  );
end BufferCC_3;

architecture arch of BufferCC_3 is
  attribute async_reg : string;

  signal buffers_0 : std_logic;
  attribute async_reg of buffers_0 : signal is "true";
  signal buffers_1 : std_logic;
  attribute async_reg of buffers_1 : signal is "true";
begin
  io_dataOut <= buffers_1;
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity MuraxMasterArbiter is
  port(
    io_iBus_cmd_valid : in std_logic;
    io_iBus_cmd_ready : out std_logic;
    io_iBus_cmd_payload_pc : in unsigned(31 downto 0);
    io_iBus_rsp_valid : out std_logic;
    io_iBus_rsp_payload_error : out std_logic;
    io_iBus_rsp_payload_inst : out std_logic_vector(31 downto 0);
    io_dBus_cmd_valid : in std_logic;
    io_dBus_cmd_ready : out std_logic;
    io_dBus_cmd_payload_wr : in std_logic;
    io_dBus_cmd_payload_address : in unsigned(31 downto 0);
    io_dBus_cmd_payload_data : in std_logic_vector(31 downto 0);
    io_dBus_cmd_payload_size : in unsigned(1 downto 0);
    io_dBus_rsp_ready : out std_logic;
    io_dBus_rsp_error : out std_logic;
    io_dBus_rsp_data : out std_logic_vector(31 downto 0);
    io_masterBus_cmd_valid : out std_logic;
    io_masterBus_cmd_ready : in std_logic;
    io_masterBus_cmd_payload_write : out std_logic;
    io_masterBus_cmd_payload_address : out unsigned(31 downto 0);
    io_masterBus_cmd_payload_data : out std_logic_vector(31 downto 0);
    io_masterBus_cmd_payload_mask : out std_logic_vector(3 downto 0);
    io_masterBus_rsp_valid : in std_logic;
    io_masterBus_rsp_payload_data : in std_logic_vector(31 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end MuraxMasterArbiter;

architecture arch of MuraxMasterArbiter is
  signal io_masterBus_cmd_valid_read_buffer : std_logic;
  signal io_masterBus_cmd_payload_write_read_buffer : std_logic;

  signal zz_io_masterBus_cmd_payload_mask : std_logic_vector(3 downto 0);
  signal rspPending : std_logic;
  signal rspTarget : std_logic;
  signal io_masterBus_cmd_fire : std_logic;
  signal when_MuraxUtiles_l31 : std_logic;
  signal when_MuraxUtiles_l36 : std_logic;
begin
  io_masterBus_cmd_valid <= io_masterBus_cmd_valid_read_buffer;
  io_masterBus_cmd_payload_write <= io_masterBus_cmd_payload_write_read_buffer;
  process(io_iBus_cmd_valid,io_dBus_cmd_valid,when_MuraxUtiles_l36)
  begin
    io_masterBus_cmd_valid_read_buffer <= (io_iBus_cmd_valid or io_dBus_cmd_valid);
    if when_MuraxUtiles_l36 = '1' then
      io_masterBus_cmd_valid_read_buffer <= pkg_toStdLogic(false);
    end if;
  end process;

  io_masterBus_cmd_payload_write_read_buffer <= (io_dBus_cmd_valid and io_dBus_cmd_payload_wr);
  io_masterBus_cmd_payload_address <= pkg_mux(io_dBus_cmd_valid,io_dBus_cmd_payload_address,io_iBus_cmd_payload_pc);
  io_masterBus_cmd_payload_data <= io_dBus_cmd_payload_data;
  process(io_dBus_cmd_payload_size)
  begin
    case io_dBus_cmd_payload_size is
      when "00" =>
        zz_io_masterBus_cmd_payload_mask <= pkg_stdLogicVector("0001");
      when "01" =>
        zz_io_masterBus_cmd_payload_mask <= pkg_stdLogicVector("0011");
      when others =>
        zz_io_masterBus_cmd_payload_mask <= pkg_stdLogicVector("1111");
    end case;
  end process;

  io_masterBus_cmd_payload_mask <= std_logic_vector(shift_left(unsigned(zz_io_masterBus_cmd_payload_mask),to_integer(pkg_extract(io_dBus_cmd_payload_address,1,0))));
  process(io_masterBus_cmd_ready,io_dBus_cmd_valid,when_MuraxUtiles_l36)
  begin
    io_iBus_cmd_ready <= (io_masterBus_cmd_ready and (not io_dBus_cmd_valid));
    if when_MuraxUtiles_l36 = '1' then
      io_iBus_cmd_ready <= pkg_toStdLogic(false);
    end if;
  end process;

  process(io_masterBus_cmd_ready,when_MuraxUtiles_l36)
  begin
    io_dBus_cmd_ready <= io_masterBus_cmd_ready;
    if when_MuraxUtiles_l36 = '1' then
      io_dBus_cmd_ready <= pkg_toStdLogic(false);
    end if;
  end process;

  io_masterBus_cmd_fire <= (io_masterBus_cmd_valid_read_buffer and io_masterBus_cmd_ready);
  when_MuraxUtiles_l31 <= (io_masterBus_cmd_fire and (not io_masterBus_cmd_payload_write_read_buffer));
  when_MuraxUtiles_l36 <= (rspPending and (not io_masterBus_rsp_valid));
  io_iBus_rsp_valid <= (io_masterBus_rsp_valid and (not rspTarget));
  io_iBus_rsp_payload_inst <= io_masterBus_rsp_payload_data;
  io_iBus_rsp_payload_error <= pkg_toStdLogic(false);
  io_dBus_rsp_ready <= (io_masterBus_rsp_valid and rspTarget);
  io_dBus_rsp_data <= io_masterBus_rsp_payload_data;
  io_dBus_rsp_error <= pkg_toStdLogic(false);
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      rspPending <= pkg_toStdLogic(false);
      rspTarget <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      if io_masterBus_rsp_valid = '1' then
        rspPending <= pkg_toStdLogic(false);
      end if;
      if when_MuraxUtiles_l31 = '1' then
        rspTarget <= io_dBus_cmd_valid;
        rspPending <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity VexRiscv is
  port(
    iBus_cmd_valid : out std_logic;
    iBus_cmd_ready : in std_logic;
    iBus_cmd_payload_pc : out unsigned(31 downto 0);
    iBus_rsp_valid : in std_logic;
    iBus_rsp_payload_error : in std_logic;
    iBus_rsp_payload_inst : in std_logic_vector(31 downto 0);
    timerInterrupt : in std_logic;
    externalInterrupt : in std_logic;
    softwareInterrupt : in std_logic;
    debug_bus_cmd_valid : in std_logic;
    debug_bus_cmd_ready : out std_logic;
    debug_bus_cmd_payload_wr : in std_logic;
    debug_bus_cmd_payload_address : in unsigned(7 downto 0);
    debug_bus_cmd_payload_data : in std_logic_vector(31 downto 0);
    debug_bus_rsp_data : out std_logic_vector(31 downto 0);
    debug_resetOut : out std_logic;
    dBus_cmd_valid : out std_logic;
    dBus_cmd_ready : in std_logic;
    dBus_cmd_payload_wr : out std_logic;
    dBus_cmd_payload_address : out unsigned(31 downto 0);
    dBus_cmd_payload_data : out std_logic_vector(31 downto 0);
    dBus_cmd_payload_size : out unsigned(1 downto 0);
    dBus_rsp_ready : in std_logic;
    dBus_rsp_error : in std_logic;
    dBus_rsp_data : in std_logic_vector(31 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic;
    resetCtrl_mainClkReset : in std_logic
  );
end VexRiscv;

architecture arch of VexRiscv is
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_ready : std_logic;
  signal zz_RegFilePlugin_regFile_port0 : std_logic_vector(31 downto 0);
  signal zz_RegFilePlugin_regFile_port0_1 : std_logic_vector(31 downto 0);
  signal dBus_cmd_payload_address_read_buffer : unsigned(31 downto 0);
  signal dBus_cmd_payload_size_read_buffer : unsigned(1 downto 0);
  signal debug_bus_cmd_ready_read_buffer : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy : unsigned(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_1 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_2 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_3 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_4 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_5 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_6 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_7 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_8 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_9 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_10 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_11 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_12 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_13 : std_logic_vector(19 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_14 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_15 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_16 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_17 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_18 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_19 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_20 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_21 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_22 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_23 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_24 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_25 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_26 : std_logic_vector(15 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_27 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_28 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_29 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_30 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_31 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_32 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_33 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_34 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_35 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_36 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_37 : std_logic_vector(12 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_38 : std_logic_vector(1 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_39 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_40 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_41 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_42 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_43 : std_logic_vector(1 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_44 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_45 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_46 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_47 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_48 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_49 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_50 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_51 : std_logic_vector(9 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_52 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_53 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_54 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_55 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_56 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_57 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_58 : std_logic_vector(4 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_59 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_60 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_61 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_62 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_63 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_64 : std_logic_vector(1 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_65 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_66 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_67 : std_logic_vector(6 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_68 : std_logic_vector(1 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_69 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_70 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_71 : std_logic_vector(1 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_72 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_73 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_74 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_75 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_76 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_77 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_78 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_79 : std_logic_vector(2 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_80 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_81 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_82 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_83 : std_logic_vector(3 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_84 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_85 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_86 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_87 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_88 : std_logic;
  signal zz_zz_decode_BRANCH_CTRL_2_89 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_90 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_91 : std_logic_vector(1 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_92 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_93 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_94 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_95 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_96 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_97 : std_logic_vector(1 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_98 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_99 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_100 : std_logic_vector(1 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_101 : std_logic_vector(0 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_102 : std_logic_vector(1 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_103 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_104 : std_logic_vector(31 downto 0);
  signal zz_zz_decode_BRANCH_CTRL_2_105 : std_logic_vector(1 downto 0);
  signal zz_RegFilePlugin_regFile_port : std_logic;
  signal zz_decode_RegFilePlugin_rs1Data : std_logic;
  signal zz_RegFilePlugin_regFile_port_1 : std_logic;
  signal zz_decode_RegFilePlugin_rs2Data : std_logic;

  signal memory_MEMORY_READ_DATA : std_logic_vector(31 downto 0);
  signal execute_BRANCH_CALC : unsigned(31 downto 0);
  signal execute_BRANCH_DO : std_logic;
  signal writeBack_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal execute_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal memory_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal execute_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal decode_DO_EBREAK : std_logic;
  signal decode_SRC2 : std_logic_vector(31 downto 0);
  signal decode_SRC1 : std_logic_vector(31 downto 0);
  signal decode_SRC2_FORCE_ZERO : std_logic;
  signal decode_RS2 : std_logic_vector(31 downto 0);
  signal decode_RS1 : std_logic_vector(31 downto 0);
  signal decode_BRANCH_CTRL : BranchCtrlEnum_seq_type;
  signal zz_decode_BRANCH_CTRL : BranchCtrlEnum_seq_type;
  signal zz_decode_to_execute_BRANCH_CTRL : BranchCtrlEnum_seq_type;
  signal zz_decode_to_execute_BRANCH_CTRL_1 : BranchCtrlEnum_seq_type;
  signal decode_SHIFT_CTRL : ShiftCtrlEnum_seq_type;
  signal zz_decode_SHIFT_CTRL : ShiftCtrlEnum_seq_type;
  signal zz_decode_to_execute_SHIFT_CTRL : ShiftCtrlEnum_seq_type;
  signal zz_decode_to_execute_SHIFT_CTRL_1 : ShiftCtrlEnum_seq_type;
  signal decode_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_seq_type;
  signal zz_decode_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_seq_type;
  signal zz_decode_to_execute_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_seq_type;
  signal zz_decode_to_execute_ALU_BITWISE_CTRL_1 : AluBitwiseCtrlEnum_seq_type;
  signal decode_SRC_LESS_UNSIGNED : std_logic;
  signal decode_ALU_CTRL : AluCtrlEnum_seq_type;
  signal zz_decode_ALU_CTRL : AluCtrlEnum_seq_type;
  signal zz_decode_to_execute_ALU_CTRL : AluCtrlEnum_seq_type;
  signal zz_decode_to_execute_ALU_CTRL_1 : AluCtrlEnum_seq_type;
  signal zz_memory_to_writeBack_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal zz_memory_to_writeBack_ENV_CTRL_1 : EnvCtrlEnum_seq_type;
  signal zz_execute_to_memory_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal zz_execute_to_memory_ENV_CTRL_1 : EnvCtrlEnum_seq_type;
  signal decode_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal zz_decode_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal zz_decode_to_execute_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal zz_decode_to_execute_ENV_CTRL_1 : EnvCtrlEnum_seq_type;
  signal decode_IS_CSR : std_logic;
  signal decode_MEMORY_STORE : std_logic;
  signal execute_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal decode_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal decode_BYPASSABLE_EXECUTE_STAGE : std_logic;
  signal decode_MEMORY_ENABLE : std_logic;
  signal decode_CSR_READ_OPCODE : std_logic;
  signal decode_CSR_WRITE_OPCODE : std_logic;
  signal writeBack_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal memory_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal execute_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal decode_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal memory_PC : unsigned(31 downto 0);
  signal execute_DO_EBREAK : std_logic;
  signal decode_IS_EBREAK : std_logic;
  signal memory_BRANCH_CALC : unsigned(31 downto 0);
  signal memory_BRANCH_DO : std_logic;
  signal execute_PC : unsigned(31 downto 0);
  signal execute_RS1 : std_logic_vector(31 downto 0);
  signal execute_BRANCH_CTRL : BranchCtrlEnum_seq_type;
  signal zz_execute_BRANCH_CTRL : BranchCtrlEnum_seq_type;
  signal decode_RS2_USE : std_logic;
  signal decode_RS1_USE : std_logic;
  signal execute_REGFILE_WRITE_VALID : std_logic;
  signal execute_BYPASSABLE_EXECUTE_STAGE : std_logic;
  signal memory_REGFILE_WRITE_VALID : std_logic;
  signal memory_INSTRUCTION : std_logic_vector(31 downto 0);
  signal memory_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal writeBack_REGFILE_WRITE_VALID : std_logic;
  signal memory_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal execute_SHIFT_CTRL : ShiftCtrlEnum_seq_type;
  signal zz_execute_SHIFT_CTRL : ShiftCtrlEnum_seq_type;
  signal execute_SRC_LESS_UNSIGNED : std_logic;
  signal execute_SRC2_FORCE_ZERO : std_logic;
  signal execute_SRC_USE_SUB_LESS : std_logic;
  signal zz_decode_SRC2 : unsigned(31 downto 0);
  signal zz_decode_SRC2_1 : std_logic_vector(31 downto 0);
  signal decode_SRC2_CTRL : Src2CtrlEnum_seq_type;
  signal zz_decode_SRC2_CTRL : Src2CtrlEnum_seq_type;
  signal zz_decode_SRC1 : std_logic_vector(31 downto 0);
  signal decode_SRC1_CTRL : Src1CtrlEnum_seq_type;
  signal zz_decode_SRC1_CTRL : Src1CtrlEnum_seq_type;
  signal decode_SRC_USE_SUB_LESS : std_logic;
  signal decode_SRC_ADD_ZERO : std_logic;
  signal execute_SRC_ADD_SUB : std_logic_vector(31 downto 0);
  signal execute_SRC_LESS : std_logic;
  signal execute_ALU_CTRL : AluCtrlEnum_seq_type;
  signal zz_execute_ALU_CTRL : AluCtrlEnum_seq_type;
  signal execute_SRC2 : std_logic_vector(31 downto 0);
  signal execute_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_seq_type;
  signal zz_execute_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_seq_type;
  signal zz_lastStageRegFileWrite_payload_address : std_logic_vector(31 downto 0);
  signal zz_lastStageRegFileWrite_valid : std_logic;
  signal zz_1 : std_logic;
  signal decode_INSTRUCTION_ANTICIPATED : std_logic_vector(31 downto 0);
  signal decode_REGFILE_WRITE_VALID : std_logic;
  signal zz_decode_BRANCH_CTRL_1 : BranchCtrlEnum_seq_type;
  signal zz_decode_SHIFT_CTRL_1 : ShiftCtrlEnum_seq_type;
  signal zz_decode_ALU_BITWISE_CTRL_1 : AluBitwiseCtrlEnum_seq_type;
  signal zz_decode_ALU_CTRL_1 : AluCtrlEnum_seq_type;
  signal zz_decode_ENV_CTRL_1 : EnvCtrlEnum_seq_type;
  signal zz_decode_SRC2_CTRL_1 : Src2CtrlEnum_seq_type;
  signal zz_decode_SRC1_CTRL_1 : Src1CtrlEnum_seq_type;
  signal zz_execute_to_memory_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal execute_SRC1 : std_logic_vector(31 downto 0);
  signal execute_CSR_READ_OPCODE : std_logic;
  signal execute_CSR_WRITE_OPCODE : std_logic;
  signal execute_IS_CSR : std_logic;
  signal memory_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal zz_memory_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal execute_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal zz_execute_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal writeBack_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal zz_writeBack_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal zz_lastStageRegFileWrite_payload_data : std_logic_vector(31 downto 0);
  signal writeBack_MEMORY_ENABLE : std_logic;
  signal writeBack_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal writeBack_MEMORY_READ_DATA : std_logic_vector(31 downto 0);
  signal memory_MEMORY_STORE : std_logic;
  signal memory_MEMORY_ENABLE : std_logic;
  signal execute_SRC_ADD : std_logic_vector(31 downto 0);
  signal execute_RS2 : std_logic_vector(31 downto 0);
  signal execute_INSTRUCTION : std_logic_vector(31 downto 0);
  signal execute_MEMORY_STORE : std_logic;
  signal execute_MEMORY_ENABLE : std_logic;
  signal execute_ALIGNEMENT_FAULT : std_logic;
  signal zz_memory_to_writeBack_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal decode_PC : unsigned(31 downto 0);
  signal decode_INSTRUCTION : std_logic_vector(31 downto 0);
  signal writeBack_PC : unsigned(31 downto 0);
  signal writeBack_INSTRUCTION : std_logic_vector(31 downto 0);
  signal decode_arbitration_haltItself : std_logic;
  signal decode_arbitration_haltByOther : std_logic;
  signal decode_arbitration_removeIt : std_logic;
  signal decode_arbitration_flushIt : std_logic;
  signal decode_arbitration_flushNext : std_logic;
  signal decode_arbitration_isValid : std_logic;
  signal decode_arbitration_isStuck : std_logic;
  signal decode_arbitration_isStuckByOthers : std_logic;
  signal decode_arbitration_isFlushed : std_logic;
  signal decode_arbitration_isMoving : std_logic;
  signal decode_arbitration_isFiring : std_logic;
  signal execute_arbitration_haltItself : std_logic;
  signal execute_arbitration_haltByOther : std_logic;
  signal execute_arbitration_removeIt : std_logic;
  signal execute_arbitration_flushIt : std_logic;
  signal execute_arbitration_flushNext : std_logic;
  signal execute_arbitration_isValid : std_logic;
  signal execute_arbitration_isStuck : std_logic;
  signal execute_arbitration_isStuckByOthers : std_logic;
  signal execute_arbitration_isFlushed : std_logic;
  signal execute_arbitration_isMoving : std_logic;
  signal execute_arbitration_isFiring : std_logic;
  signal memory_arbitration_haltItself : std_logic;
  signal memory_arbitration_haltByOther : std_logic;
  signal memory_arbitration_removeIt : std_logic;
  signal memory_arbitration_flushIt : std_logic;
  signal memory_arbitration_flushNext : std_logic;
  signal memory_arbitration_isValid : std_logic;
  signal memory_arbitration_isStuck : std_logic;
  signal memory_arbitration_isStuckByOthers : std_logic;
  signal memory_arbitration_isFlushed : std_logic;
  signal memory_arbitration_isMoving : std_logic;
  signal memory_arbitration_isFiring : std_logic;
  signal writeBack_arbitration_haltItself : std_logic;
  signal writeBack_arbitration_haltByOther : std_logic;
  signal writeBack_arbitration_removeIt : std_logic;
  signal writeBack_arbitration_flushIt : std_logic;
  signal writeBack_arbitration_flushNext : std_logic;
  signal writeBack_arbitration_isValid : std_logic;
  signal writeBack_arbitration_isStuck : std_logic;
  signal writeBack_arbitration_isStuckByOthers : std_logic;
  signal writeBack_arbitration_isFlushed : std_logic;
  signal writeBack_arbitration_isMoving : std_logic;
  signal writeBack_arbitration_isFiring : std_logic;
  signal lastStageInstruction : std_logic_vector(31 downto 0);
  signal lastStagePc : unsigned(31 downto 0);
  signal lastStageIsValid : std_logic;
  signal lastStageIsFiring : std_logic;
  signal IBusSimplePlugin_fetcherHalt : std_logic;
  signal IBusSimplePlugin_forceNoDecodeCond : std_logic;
  signal IBusSimplePlugin_incomingInstruction : std_logic;
  signal IBusSimplePlugin_pcValids_0 : std_logic;
  signal IBusSimplePlugin_pcValids_1 : std_logic;
  signal IBusSimplePlugin_pcValids_2 : std_logic;
  signal IBusSimplePlugin_pcValids_3 : std_logic;
  signal CsrPlugin_csrMapping_readDataSignal : std_logic_vector(31 downto 0);
  signal CsrPlugin_csrMapping_readDataInit : std_logic_vector(31 downto 0);
  signal CsrPlugin_csrMapping_writeDataSignal : std_logic_vector(31 downto 0);
  signal CsrPlugin_csrMapping_allowCsrSignal : std_logic;
  signal CsrPlugin_csrMapping_hazardFree : std_logic;
  signal CsrPlugin_inWfi : std_logic;
  signal CsrPlugin_thirdPartyWake : std_logic;
  signal CsrPlugin_jumpInterface_valid : std_logic;
  signal CsrPlugin_jumpInterface_payload : unsigned(31 downto 0);
  signal CsrPlugin_exceptionPendings_0 : std_logic;
  signal CsrPlugin_exceptionPendings_1 : std_logic;
  signal CsrPlugin_exceptionPendings_2 : std_logic;
  signal CsrPlugin_exceptionPendings_3 : std_logic;
  signal contextSwitching : std_logic;
  signal CsrPlugin_privilege : unsigned(1 downto 0);
  signal CsrPlugin_forceMachineWire : std_logic;
  signal CsrPlugin_allowInterrupts : std_logic;
  signal CsrPlugin_allowException : std_logic;
  signal CsrPlugin_allowEbreakException : std_logic;
  signal BranchPlugin_jumpInterface_valid : std_logic;
  signal BranchPlugin_jumpInterface_payload : unsigned(31 downto 0);
  signal BranchPlugin_inDebugNoFetchFlag : std_logic;
  signal IBusSimplePlugin_injectionPort_valid : std_logic;
  signal IBusSimplePlugin_injectionPort_ready : std_logic;
  signal IBusSimplePlugin_injectionPort_payload : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_externalFlush : std_logic;
  signal IBusSimplePlugin_jump_pcLoad_valid : std_logic;
  signal IBusSimplePlugin_jump_pcLoad_payload : unsigned(31 downto 0);
  signal zz_IBusSimplePlugin_jump_pcLoad_payload : unsigned(1 downto 0);
  signal IBusSimplePlugin_fetchPc_output_valid : std_logic;
  signal IBusSimplePlugin_fetchPc_output_ready : std_logic;
  signal IBusSimplePlugin_fetchPc_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_fetchPc_pcReg : unsigned(31 downto 0);
  signal IBusSimplePlugin_fetchPc_correction : std_logic;
  signal IBusSimplePlugin_fetchPc_correctionReg : std_logic;
  signal IBusSimplePlugin_fetchPc_output_fire : std_logic;
  signal IBusSimplePlugin_fetchPc_corrected : std_logic;
  signal IBusSimplePlugin_fetchPc_pcRegPropagate : std_logic;
  signal IBusSimplePlugin_fetchPc_booted : std_logic;
  signal IBusSimplePlugin_fetchPc_inc : std_logic;
  signal when_Fetcher_l134 : std_logic;
  signal IBusSimplePlugin_fetchPc_output_fire_1 : std_logic;
  signal when_Fetcher_l134_1 : std_logic;
  signal IBusSimplePlugin_fetchPc_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_fetchPc_flushed : std_logic;
  signal when_Fetcher_l161 : std_logic;
  signal IBusSimplePlugin_iBusRsp_redoFetch : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_input_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_input_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_input_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_0_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_0_halt : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_input_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_input_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_input_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_1_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_1_halt : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_input_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_input_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_input_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_2_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_2_halt : std_logic;
  signal zz_IBusSimplePlugin_iBusRsp_stages_0_input_ready : std_logic;
  signal zz_IBusSimplePlugin_iBusRsp_stages_1_input_ready : std_logic;
  signal zz_IBusSimplePlugin_iBusRsp_stages_2_input_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_flush : std_logic;
  signal zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready : std_logic;
  signal zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready_1 : std_logic;
  signal zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready_2 : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_payload : unsigned(31 downto 0);
  signal zz_IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_valid : std_logic;
  signal zz_IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_readyForError : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_output_payload_rsp_error : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_output_payload_isRvc : std_logic;
  signal when_Fetcher_l243 : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_valid : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_ready : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_injector_decodeInput_payload_rsp_error : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_injector_decodeInput_payload_isRvc : std_logic;
  signal zz_IBusSimplePlugin_injector_decodeInput_valid : std_logic;
  signal zz_IBusSimplePlugin_injector_decodeInput_payload_pc : unsigned(31 downto 0);
  signal zz_IBusSimplePlugin_injector_decodeInput_payload_rsp_error : std_logic;
  signal zz_IBusSimplePlugin_injector_decodeInput_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal zz_IBusSimplePlugin_injector_decodeInput_payload_isRvc : std_logic;
  signal when_Fetcher_l323 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_0 : std_logic;
  signal when_Fetcher_l332 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_1 : std_logic;
  signal when_Fetcher_l332_1 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_2 : std_logic;
  signal when_Fetcher_l332_2 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_3 : std_logic;
  signal when_Fetcher_l332_3 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_4 : std_logic;
  signal when_Fetcher_l332_4 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_5 : std_logic;
  signal when_Fetcher_l332_5 : std_logic;
  signal IBusSimplePlugin_injector_formal_rawInDecode : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_cmd_valid : std_logic;
  signal IBusSimplePlugin_cmd_ready : std_logic;
  signal IBusSimplePlugin_cmd_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_pending_inc : std_logic;
  signal IBusSimplePlugin_pending_dec : std_logic;
  signal IBusSimplePlugin_pending_value : unsigned(2 downto 0);
  signal IBusSimplePlugin_pending_next : unsigned(2 downto 0);
  signal IBusSimplePlugin_cmdFork_canEmit : std_logic;
  signal when_IBusSimplePlugin_l305 : std_logic;
  signal IBusSimplePlugin_cmd_fire : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_output_valid : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_output_ready : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_output_payload_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBuffer_discardCounter : unsigned(2 downto 0);
  signal iBus_rsp_toStream_valid : std_logic;
  signal iBus_rsp_toStream_ready : std_logic;
  signal iBus_rsp_toStream_payload_error : std_logic;
  signal iBus_rsp_toStream_payload_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBuffer_flush : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_fire : std_logic;
  signal IBusSimplePlugin_rspJoin_fetchRsp_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_rspJoin_fetchRsp_rsp_error : std_logic;
  signal IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_fetchRsp_isRvc : std_logic;
  signal when_IBusSimplePlugin_l376 : std_logic;
  signal IBusSimplePlugin_rspJoin_join_valid : std_logic;
  signal IBusSimplePlugin_rspJoin_join_ready : std_logic;
  signal IBusSimplePlugin_rspJoin_join_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_rspJoin_join_payload_rsp_error : std_logic;
  signal IBusSimplePlugin_rspJoin_join_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_join_payload_isRvc : std_logic;
  signal IBusSimplePlugin_rspJoin_exceptionDetected : std_logic;
  signal IBusSimplePlugin_rspJoin_join_fire : std_logic;
  signal IBusSimplePlugin_rspJoin_join_fire_1 : std_logic;
  signal zz_IBusSimplePlugin_iBusRsp_output_valid : std_logic;
  signal zz_dBus_cmd_valid : std_logic;
  signal execute_DBusSimplePlugin_skipCmd : std_logic;
  signal zz_dBus_cmd_payload_data : std_logic_vector(31 downto 0);
  signal when_DBusSimplePlugin_l428 : std_logic;
  signal zz_execute_DBusSimplePlugin_formalMask : std_logic_vector(3 downto 0);
  signal execute_DBusSimplePlugin_formalMask : std_logic_vector(3 downto 0);
  signal when_DBusSimplePlugin_l482 : std_logic;
  signal writeBack_DBusSimplePlugin_rspShifted : std_logic_vector(31 downto 0);
  signal switch_Misc_l210 : std_logic_vector(1 downto 0);
  signal zz_writeBack_DBusSimplePlugin_rspFormated : std_logic;
  signal zz_writeBack_DBusSimplePlugin_rspFormated_1 : std_logic_vector(31 downto 0);
  signal zz_writeBack_DBusSimplePlugin_rspFormated_2 : std_logic;
  signal zz_writeBack_DBusSimplePlugin_rspFormated_3 : std_logic_vector(31 downto 0);
  signal writeBack_DBusSimplePlugin_rspFormated : std_logic_vector(31 downto 0);
  signal when_DBusSimplePlugin_l558 : std_logic;
  signal CsrPlugin_misa_base : unsigned(1 downto 0);
  signal CsrPlugin_misa_extensions : std_logic_vector(25 downto 0);
  signal CsrPlugin_mtvec_mode : std_logic_vector(1 downto 0);
  signal CsrPlugin_mtvec_base : unsigned(29 downto 0);
  signal CsrPlugin_mepc : unsigned(31 downto 0);
  signal CsrPlugin_mstatus_MIE : std_logic;
  signal CsrPlugin_mstatus_MPIE : std_logic;
  signal CsrPlugin_mstatus_MPP : unsigned(1 downto 0);
  signal CsrPlugin_mip_MEIP : std_logic;
  signal CsrPlugin_mip_MTIP : std_logic;
  signal CsrPlugin_mip_MSIP : std_logic;
  signal CsrPlugin_mie_MEIE : std_logic;
  signal CsrPlugin_mie_MTIE : std_logic;
  signal CsrPlugin_mie_MSIE : std_logic;
  signal CsrPlugin_mcause_interrupt : std_logic;
  signal CsrPlugin_mcause_exceptionCode : unsigned(3 downto 0);
  signal CsrPlugin_mtval : unsigned(31 downto 0);
  signal CsrPlugin_mcycle : unsigned(63 downto 0);
  signal CsrPlugin_minstret : unsigned(63 downto 0);
  signal zz_when_CsrPlugin_l965 : std_logic;
  signal zz_when_CsrPlugin_l965_1 : std_logic;
  signal zz_when_CsrPlugin_l965_2 : std_logic;
  signal CsrPlugin_interrupt_valid : std_logic;
  signal CsrPlugin_interrupt_code : unsigned(3 downto 0);
  signal CsrPlugin_interrupt_targetPrivilege : unsigned(1 downto 0);
  signal when_CsrPlugin_l959 : std_logic;
  signal when_CsrPlugin_l965 : std_logic;
  signal when_CsrPlugin_l965_1 : std_logic;
  signal when_CsrPlugin_l965_2 : std_logic;
  signal CsrPlugin_exception : std_logic;
  signal CsrPlugin_lastStageWasWfi : std_logic;
  signal CsrPlugin_pipelineLiberator_pcValids_0 : std_logic;
  signal CsrPlugin_pipelineLiberator_pcValids_1 : std_logic;
  signal CsrPlugin_pipelineLiberator_pcValids_2 : std_logic;
  signal CsrPlugin_pipelineLiberator_active : std_logic;
  signal when_CsrPlugin_l993 : std_logic;
  signal when_CsrPlugin_l993_1 : std_logic;
  signal when_CsrPlugin_l993_2 : std_logic;
  signal when_CsrPlugin_l998 : std_logic;
  signal CsrPlugin_pipelineLiberator_done : std_logic;
  signal CsrPlugin_interruptJump : std_logic;
  signal CsrPlugin_hadException : std_logic;
  signal CsrPlugin_targetPrivilege : unsigned(1 downto 0);
  signal CsrPlugin_trapCause : unsigned(3 downto 0);
  signal CsrPlugin_xtvec_mode : std_logic_vector(1 downto 0);
  signal CsrPlugin_xtvec_base : unsigned(29 downto 0);
  signal when_CsrPlugin_l1032 : std_logic;
  signal when_CsrPlugin_l1077 : std_logic;
  signal switch_CsrPlugin_l1081 : std_logic_vector(1 downto 0);
  signal execute_CsrPlugin_wfiWake : std_logic;
  signal when_CsrPlugin_l1129 : std_logic;
  signal execute_CsrPlugin_blockedBySideEffects : std_logic;
  signal execute_CsrPlugin_illegalAccess : std_logic;
  signal execute_CsrPlugin_illegalInstruction : std_logic;
  signal when_CsrPlugin_l1149 : std_logic;
  signal when_CsrPlugin_l1150 : std_logic;
  signal execute_CsrPlugin_writeInstruction : std_logic;
  signal execute_CsrPlugin_readInstruction : std_logic;
  signal execute_CsrPlugin_writeEnable : std_logic;
  signal execute_CsrPlugin_readEnable : std_logic;
  signal execute_CsrPlugin_readToWriteData : std_logic_vector(31 downto 0);
  signal switch_Misc_l210_1 : std_logic;
  signal zz_CsrPlugin_csrMapping_writeDataSignal : std_logic_vector(31 downto 0);
  signal when_CsrPlugin_l1189 : std_logic;
  signal when_CsrPlugin_l1193 : std_logic;
  signal execute_CsrPlugin_csrAddress : std_logic_vector(11 downto 0);
  signal zz_decode_BRANCH_CTRL_2 : std_logic_vector(25 downto 0);
  signal zz_decode_BRANCH_CTRL_3 : std_logic;
  signal zz_decode_BRANCH_CTRL_4 : std_logic;
  signal zz_decode_BRANCH_CTRL_5 : std_logic;
  signal zz_decode_BRANCH_CTRL_6 : std_logic;
  signal zz_decode_BRANCH_CTRL_7 : std_logic;
  signal zz_decode_BRANCH_CTRL_8 : std_logic;
  signal zz_decode_SRC1_CTRL_2 : Src1CtrlEnum_seq_type;
  signal zz_decode_SRC2_CTRL_2 : Src2CtrlEnum_seq_type;
  signal zz_decode_ENV_CTRL_2 : EnvCtrlEnum_seq_type;
  signal zz_decode_ALU_CTRL_2 : AluCtrlEnum_seq_type;
  signal zz_decode_ALU_BITWISE_CTRL_2 : AluBitwiseCtrlEnum_seq_type;
  signal zz_decode_SHIFT_CTRL_2 : ShiftCtrlEnum_seq_type;
  signal zz_decode_BRANCH_CTRL_9 : BranchCtrlEnum_seq_type;
  signal when_RegFilePlugin_l63 : std_logic;
  signal decode_RegFilePlugin_regFileReadAddress1 : unsigned(4 downto 0);
  signal decode_RegFilePlugin_regFileReadAddress2 : unsigned(4 downto 0);
  signal decode_RegFilePlugin_rs1Data : std_logic_vector(31 downto 0);
  signal decode_RegFilePlugin_rs2Data : std_logic_vector(31 downto 0);
  signal lastStageRegFileWrite_valid : std_logic;
  signal lastStageRegFileWrite_payload_address : unsigned(4 downto 0);
  signal lastStageRegFileWrite_payload_data : std_logic_vector(31 downto 0);
  signal zz_2 : std_logic;
  signal execute_IntAluPlugin_bitwise : std_logic_vector(31 downto 0);
  signal zz_execute_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal zz_decode_SRC1_1 : std_logic_vector(31 downto 0);
  signal zz_decode_SRC2_2 : std_logic;
  signal zz_decode_SRC2_3 : std_logic_vector(19 downto 0);
  signal zz_decode_SRC2_4 : std_logic;
  signal zz_decode_SRC2_5 : std_logic_vector(19 downto 0);
  signal zz_decode_SRC2_6 : std_logic_vector(31 downto 0);
  signal execute_SrcPlugin_addSub : std_logic_vector(31 downto 0);
  signal execute_SrcPlugin_less : std_logic;
  signal execute_LightShifterPlugin_isActive : std_logic;
  signal execute_LightShifterPlugin_isShift : std_logic;
  signal execute_LightShifterPlugin_amplitudeReg : unsigned(4 downto 0);
  signal execute_LightShifterPlugin_amplitude : unsigned(4 downto 0);
  signal execute_LightShifterPlugin_shiftInput : std_logic_vector(31 downto 0);
  signal execute_LightShifterPlugin_done : std_logic;
  signal when_ShiftPlugins_l169 : std_logic;
  signal zz_execute_to_memory_REGFILE_WRITE_DATA_1 : std_logic_vector(31 downto 0);
  signal when_ShiftPlugins_l175 : std_logic;
  signal when_ShiftPlugins_l184 : std_logic;
  signal HazardSimplePlugin_src0Hazard : std_logic;
  signal HazardSimplePlugin_src1Hazard : std_logic;
  signal HazardSimplePlugin_writeBackWrites_valid : std_logic;
  signal HazardSimplePlugin_writeBackWrites_payload_address : std_logic_vector(4 downto 0);
  signal HazardSimplePlugin_writeBackWrites_payload_data : std_logic_vector(31 downto 0);
  signal HazardSimplePlugin_writeBackBuffer_valid : std_logic;
  signal HazardSimplePlugin_writeBackBuffer_payload_address : std_logic_vector(4 downto 0);
  signal HazardSimplePlugin_writeBackBuffer_payload_data : std_logic_vector(31 downto 0);
  signal HazardSimplePlugin_addr0Match : std_logic;
  signal HazardSimplePlugin_addr1Match : std_logic;
  signal when_HazardSimplePlugin_l59 : std_logic;
  signal when_HazardSimplePlugin_l62 : std_logic;
  signal when_HazardSimplePlugin_l57 : std_logic;
  signal when_HazardSimplePlugin_l58 : std_logic;
  signal when_HazardSimplePlugin_l59_1 : std_logic;
  signal when_HazardSimplePlugin_l62_1 : std_logic;
  signal when_HazardSimplePlugin_l57_1 : std_logic;
  signal when_HazardSimplePlugin_l58_1 : std_logic;
  signal when_HazardSimplePlugin_l59_2 : std_logic;
  signal when_HazardSimplePlugin_l62_2 : std_logic;
  signal when_HazardSimplePlugin_l57_2 : std_logic;
  signal when_HazardSimplePlugin_l58_2 : std_logic;
  signal when_HazardSimplePlugin_l105 : std_logic;
  signal when_HazardSimplePlugin_l108 : std_logic;
  signal when_HazardSimplePlugin_l113 : std_logic;
  signal execute_BranchPlugin_eq : std_logic;
  signal switch_Misc_l210_2 : std_logic_vector(2 downto 0);
  signal zz_execute_BRANCH_DO : std_logic;
  signal zz_execute_BRANCH_DO_1 : std_logic;
  signal execute_BranchPlugin_branch_src1 : unsigned(31 downto 0);
  signal zz_execute_BranchPlugin_branch_src2 : std_logic;
  signal zz_execute_BranchPlugin_branch_src2_1 : std_logic_vector(10 downto 0);
  signal zz_execute_BranchPlugin_branch_src2_2 : std_logic;
  signal zz_execute_BranchPlugin_branch_src2_3 : std_logic_vector(19 downto 0);
  signal zz_execute_BranchPlugin_branch_src2_4 : std_logic;
  signal zz_execute_BranchPlugin_branch_src2_5 : std_logic_vector(18 downto 0);
  signal zz_execute_BranchPlugin_branch_src2_6 : std_logic_vector(31 downto 0);
  signal execute_BranchPlugin_branch_src2 : unsigned(31 downto 0);
  signal execute_BranchPlugin_branchAdder : unsigned(31 downto 0);
  signal DebugPlugin_firstCycle : std_logic;
  signal DebugPlugin_secondCycle : std_logic;
  signal DebugPlugin_resetIt : std_logic;
  signal DebugPlugin_haltIt : std_logic;
  signal DebugPlugin_stepIt : std_logic;
  signal DebugPlugin_isPipBusy : std_logic;
  signal DebugPlugin_godmode : std_logic;
  signal when_DebugPlugin_l225 : std_logic;
  signal DebugPlugin_haltedByBreak : std_logic;
  signal DebugPlugin_debugUsed : std_logic;
  signal DebugPlugin_disableEbreak : std_logic;
  signal DebugPlugin_allowEBreak : std_logic;
  signal DebugPlugin_busReadDataReg : std_logic_vector(31 downto 0);
  signal zz_when_DebugPlugin_l244 : std_logic;
  signal when_DebugPlugin_l244 : std_logic;
  signal switch_DebugPlugin_l267 : unsigned(5 downto 0);
  signal when_DebugPlugin_l271 : std_logic;
  signal when_DebugPlugin_l271_1 : std_logic;
  signal when_DebugPlugin_l272 : std_logic;
  signal when_DebugPlugin_l272_1 : std_logic;
  signal when_DebugPlugin_l273 : std_logic;
  signal when_DebugPlugin_l274 : std_logic;
  signal when_DebugPlugin_l275 : std_logic;
  signal when_DebugPlugin_l275_1 : std_logic;
  signal when_DebugPlugin_l295 : std_logic;
  signal when_DebugPlugin_l298 : std_logic;
  signal when_DebugPlugin_l311 : std_logic;
  signal DebugPlugin_resetIt_regNext : std_logic;
  signal when_DebugPlugin_l331 : std_logic;
  signal when_Pipeline_l124 : std_logic;
  signal decode_to_execute_PC : unsigned(31 downto 0);
  signal when_Pipeline_l124_1 : std_logic;
  signal execute_to_memory_PC : unsigned(31 downto 0);
  signal when_Pipeline_l124_2 : std_logic;
  signal memory_to_writeBack_PC : unsigned(31 downto 0);
  signal when_Pipeline_l124_3 : std_logic;
  signal decode_to_execute_INSTRUCTION : std_logic_vector(31 downto 0);
  signal when_Pipeline_l124_4 : std_logic;
  signal execute_to_memory_INSTRUCTION : std_logic_vector(31 downto 0);
  signal when_Pipeline_l124_5 : std_logic;
  signal memory_to_writeBack_INSTRUCTION : std_logic_vector(31 downto 0);
  signal when_Pipeline_l124_6 : std_logic;
  signal decode_to_execute_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal when_Pipeline_l124_7 : std_logic;
  signal execute_to_memory_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal when_Pipeline_l124_8 : std_logic;
  signal memory_to_writeBack_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal when_Pipeline_l124_9 : std_logic;
  signal decode_to_execute_CSR_WRITE_OPCODE : std_logic;
  signal when_Pipeline_l124_10 : std_logic;
  signal decode_to_execute_CSR_READ_OPCODE : std_logic;
  signal when_Pipeline_l124_11 : std_logic;
  signal decode_to_execute_SRC_USE_SUB_LESS : std_logic;
  signal when_Pipeline_l124_12 : std_logic;
  signal decode_to_execute_MEMORY_ENABLE : std_logic;
  signal when_Pipeline_l124_13 : std_logic;
  signal execute_to_memory_MEMORY_ENABLE : std_logic;
  signal when_Pipeline_l124_14 : std_logic;
  signal memory_to_writeBack_MEMORY_ENABLE : std_logic;
  signal when_Pipeline_l124_15 : std_logic;
  signal decode_to_execute_REGFILE_WRITE_VALID : std_logic;
  signal when_Pipeline_l124_16 : std_logic;
  signal execute_to_memory_REGFILE_WRITE_VALID : std_logic;
  signal when_Pipeline_l124_17 : std_logic;
  signal memory_to_writeBack_REGFILE_WRITE_VALID : std_logic;
  signal when_Pipeline_l124_18 : std_logic;
  signal decode_to_execute_BYPASSABLE_EXECUTE_STAGE : std_logic;
  signal when_Pipeline_l124_19 : std_logic;
  signal decode_to_execute_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal when_Pipeline_l124_20 : std_logic;
  signal execute_to_memory_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal when_Pipeline_l124_21 : std_logic;
  signal decode_to_execute_MEMORY_STORE : std_logic;
  signal when_Pipeline_l124_22 : std_logic;
  signal execute_to_memory_MEMORY_STORE : std_logic;
  signal when_Pipeline_l124_23 : std_logic;
  signal decode_to_execute_IS_CSR : std_logic;
  signal when_Pipeline_l124_24 : std_logic;
  signal decode_to_execute_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal when_Pipeline_l124_25 : std_logic;
  signal execute_to_memory_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal when_Pipeline_l124_26 : std_logic;
  signal memory_to_writeBack_ENV_CTRL : EnvCtrlEnum_seq_type;
  signal when_Pipeline_l124_27 : std_logic;
  signal decode_to_execute_ALU_CTRL : AluCtrlEnum_seq_type;
  signal when_Pipeline_l124_28 : std_logic;
  signal decode_to_execute_SRC_LESS_UNSIGNED : std_logic;
  signal when_Pipeline_l124_29 : std_logic;
  signal decode_to_execute_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_seq_type;
  signal when_Pipeline_l124_30 : std_logic;
  signal decode_to_execute_SHIFT_CTRL : ShiftCtrlEnum_seq_type;
  signal when_Pipeline_l124_31 : std_logic;
  signal decode_to_execute_BRANCH_CTRL : BranchCtrlEnum_seq_type;
  signal when_Pipeline_l124_32 : std_logic;
  signal decode_to_execute_RS1 : std_logic_vector(31 downto 0);
  signal when_Pipeline_l124_33 : std_logic;
  signal decode_to_execute_RS2 : std_logic_vector(31 downto 0);
  signal when_Pipeline_l124_34 : std_logic;
  signal decode_to_execute_SRC2_FORCE_ZERO : std_logic;
  signal when_Pipeline_l124_35 : std_logic;
  signal decode_to_execute_SRC1 : std_logic_vector(31 downto 0);
  signal when_Pipeline_l124_36 : std_logic;
  signal decode_to_execute_SRC2 : std_logic_vector(31 downto 0);
  signal when_Pipeline_l124_37 : std_logic;
  signal decode_to_execute_DO_EBREAK : std_logic;
  signal when_Pipeline_l124_38 : std_logic;
  signal execute_to_memory_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal when_Pipeline_l124_39 : std_logic;
  signal memory_to_writeBack_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal when_Pipeline_l124_40 : std_logic;
  signal execute_to_memory_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal when_Pipeline_l124_41 : std_logic;
  signal memory_to_writeBack_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal when_Pipeline_l124_42 : std_logic;
  signal execute_to_memory_BRANCH_DO : std_logic;
  signal when_Pipeline_l124_43 : std_logic;
  signal execute_to_memory_BRANCH_CALC : unsigned(31 downto 0);
  signal when_Pipeline_l124_44 : std_logic;
  signal memory_to_writeBack_MEMORY_READ_DATA : std_logic_vector(31 downto 0);
  signal when_Pipeline_l151 : std_logic;
  signal when_Pipeline_l154 : std_logic;
  signal when_Pipeline_l151_1 : std_logic;
  signal when_Pipeline_l154_1 : std_logic;
  signal when_Pipeline_l151_2 : std_logic;
  signal when_Pipeline_l154_2 : std_logic;
  signal switch_Fetcher_l365 : unsigned(2 downto 0);
  signal when_Fetcher_l381 : std_logic;
  signal when_Fetcher_l401 : std_logic;
  signal when_CsrPlugin_l1277 : std_logic;
  signal execute_CsrPlugin_csr_768 : std_logic;
  signal when_CsrPlugin_l1277_1 : std_logic;
  signal execute_CsrPlugin_csr_836 : std_logic;
  signal when_CsrPlugin_l1277_2 : std_logic;
  signal execute_CsrPlugin_csr_772 : std_logic;
  signal when_CsrPlugin_l1277_3 : std_logic;
  signal execute_CsrPlugin_csr_834 : std_logic;
  signal switch_CsrPlugin_l723 : std_logic_vector(1 downto 0);
  signal zz_CsrPlugin_csrMapping_readDataInit : std_logic_vector(31 downto 0);
  signal zz_CsrPlugin_csrMapping_readDataInit_1 : std_logic_vector(31 downto 0);
  signal zz_CsrPlugin_csrMapping_readDataInit_2 : std_logic_vector(31 downto 0);
  signal zz_CsrPlugin_csrMapping_readDataInit_3 : std_logic_vector(31 downto 0);
  signal when_CsrPlugin_l1310 : std_logic;
  signal when_CsrPlugin_l1315 : std_logic;
  type RegFilePlugin_regFile_type is array (0 to 31) of std_logic_vector(31 downto 0);
  signal RegFilePlugin_regFile : RegFilePlugin_regFile_type;
begin
  dBus_cmd_payload_address <= dBus_cmd_payload_address_read_buffer;
  dBus_cmd_payload_size <= dBus_cmd_payload_size_read_buffer;
  debug_bus_cmd_ready <= debug_bus_cmd_ready_read_buffer;
  zz_decode_RegFilePlugin_rs1Data <= pkg_toStdLogic(true);
  zz_decode_RegFilePlugin_rs2Data <= pkg_toStdLogic(true);
  zz_zz_decode_BRANCH_CTRL_2 <= pkg_stdLogicVector("00010000000000000011000001010000");
  zz_zz_decode_BRANCH_CTRL_2_1 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000011100")) = pkg_stdLogicVector("00000000000000000000000000000100"));
  zz_zz_decode_BRANCH_CTRL_2_2 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001011000")) = pkg_stdLogicVector("00000000000000000000000001000000"));
  zz_zz_decode_BRANCH_CTRL_2_3 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000111000001010100")) = pkg_stdLogicVector("00000000000000000101000000010000")));
  zz_zz_decode_BRANCH_CTRL_2_4 <= pkg_stdLogicVector("0");
  zz_zz_decode_BRANCH_CTRL_2_5 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_6 = zz_zz_decode_BRANCH_CTRL_2_7)),pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_8 = zz_zz_decode_BRANCH_CTRL_2_9))) /= pkg_stdLogicVector("00"));
  zz_zz_decode_BRANCH_CTRL_2_10 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_11),pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_12)) /= pkg_stdLogicVector("00")));
  zz_zz_decode_BRANCH_CTRL_2_13 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_14) /= pkg_stdLogicVector("0"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_15 /= zz_zz_decode_BRANCH_CTRL_2_17)),pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_18),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_21,zz_zz_decode_BRANCH_CTRL_2_26))));
  zz_zz_decode_BRANCH_CTRL_2_6 <= (decode_INSTRUCTION and pkg_stdLogicVector("01000000000000000011000001010100"));
  zz_zz_decode_BRANCH_CTRL_2_7 <= pkg_stdLogicVector("01000000000000000001000000010000");
  zz_zz_decode_BRANCH_CTRL_2_8 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000111000001010100"));
  zz_zz_decode_BRANCH_CTRL_2_9 <= pkg_stdLogicVector("00000000000000000001000000010000");
  zz_zz_decode_BRANCH_CTRL_2_11 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001100100")) = pkg_stdLogicVector("00000000000000000000000000100100"));
  zz_zz_decode_BRANCH_CTRL_2_12 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000011000001010100")) = pkg_stdLogicVector("00000000000000000001000000010000"));
  zz_zz_decode_BRANCH_CTRL_2_14 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000001000000000000")) = pkg_stdLogicVector("00000000000000000001000000000000"));
  zz_zz_decode_BRANCH_CTRL_2_15 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_16) = pkg_stdLogicVector("00000000000000000010000000000000")));
  zz_zz_decode_BRANCH_CTRL_2_17 <= pkg_stdLogicVector("0");
  zz_zz_decode_BRANCH_CTRL_2_18 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_19),pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_20)) /= pkg_stdLogicVector("00"));
  zz_zz_decode_BRANCH_CTRL_2_21 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_zz_decode_BRANCH_CTRL_2_22,zz_zz_decode_BRANCH_CTRL_2_24) /= pkg_stdLogicVector("00")));
  zz_zz_decode_BRANCH_CTRL_2_26 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_27 /= zz_zz_decode_BRANCH_CTRL_2_28)),pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_29),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_32,zz_zz_decode_BRANCH_CTRL_2_37)));
  zz_zz_decode_BRANCH_CTRL_2_16 <= pkg_stdLogicVector("00000000000000000011000000000000");
  zz_zz_decode_BRANCH_CTRL_2_19 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000010000000010000")) = pkg_stdLogicVector("00000000000000000010000000000000"));
  zz_zz_decode_BRANCH_CTRL_2_20 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000101000000000000")) = pkg_stdLogicVector("00000000000000000001000000000000"));
  zz_zz_decode_BRANCH_CTRL_2_22 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_23) = pkg_stdLogicVector("00000000000000000110000000000000")));
  zz_zz_decode_BRANCH_CTRL_2_24 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_25) = pkg_stdLogicVector("00000000000000000100000000000000")));
  zz_zz_decode_BRANCH_CTRL_2_27 <= pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_4);
  zz_zz_decode_BRANCH_CTRL_2_28 <= pkg_stdLogicVector("0");
  zz_zz_decode_BRANCH_CTRL_2_29 <= pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_30 = zz_zz_decode_BRANCH_CTRL_2_31)) /= pkg_stdLogicVector("0"));
  zz_zz_decode_BRANCH_CTRL_2_32 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_zz_decode_BRANCH_CTRL_2_33,zz_zz_decode_BRANCH_CTRL_2_35) /= pkg_stdLogicVector("00")));
  zz_zz_decode_BRANCH_CTRL_2_37 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_38 /= zz_zz_decode_BRANCH_CTRL_2_43)),pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_44),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_49,zz_zz_decode_BRANCH_CTRL_2_51)));
  zz_zz_decode_BRANCH_CTRL_2_23 <= pkg_stdLogicVector("00000000000000000110000000000100");
  zz_zz_decode_BRANCH_CTRL_2_25 <= pkg_stdLogicVector("00000000000000000101000000000100");
  zz_zz_decode_BRANCH_CTRL_2_30 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000100000011000001010000"));
  zz_zz_decode_BRANCH_CTRL_2_31 <= pkg_stdLogicVector("00000000000000000000000001010000");
  zz_zz_decode_BRANCH_CTRL_2_33 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_34) = pkg_stdLogicVector("00000000000000000001000001010000")));
  zz_zz_decode_BRANCH_CTRL_2_35 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_36) = pkg_stdLogicVector("00000000000000000010000001010000")));
  zz_zz_decode_BRANCH_CTRL_2_38 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_39 = zz_zz_decode_BRANCH_CTRL_2_40)),pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_41 = zz_zz_decode_BRANCH_CTRL_2_42)));
  zz_zz_decode_BRANCH_CTRL_2_43 <= pkg_stdLogicVector("00");
  zz_zz_decode_BRANCH_CTRL_2_44 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_45),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_46,zz_zz_decode_BRANCH_CTRL_2_47)) /= pkg_stdLogicVector("000"));
  zz_zz_decode_BRANCH_CTRL_2_49 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_50) /= pkg_stdLogicVector("0")));
  zz_zz_decode_BRANCH_CTRL_2_51 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_52 /= zz_zz_decode_BRANCH_CTRL_2_54)),pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_55),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_56,zz_zz_decode_BRANCH_CTRL_2_67)));
  zz_zz_decode_BRANCH_CTRL_2_34 <= pkg_stdLogicVector("00000000000000000001000001010000");
  zz_zz_decode_BRANCH_CTRL_2_36 <= pkg_stdLogicVector("00000000000000000010000001010000");
  zz_zz_decode_BRANCH_CTRL_2_39 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000110100"));
  zz_zz_decode_BRANCH_CTRL_2_40 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_zz_decode_BRANCH_CTRL_2_41 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001100100"));
  zz_zz_decode_BRANCH_CTRL_2_42 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_zz_decode_BRANCH_CTRL_2_45 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001010000")) = pkg_stdLogicVector("00000000000000000000000001000000"));
  zz_zz_decode_BRANCH_CTRL_2_46 <= pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_5);
  zz_zz_decode_BRANCH_CTRL_2_47 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_48) = pkg_stdLogicVector("00000000000000000000000001000000")));
  zz_zz_decode_BRANCH_CTRL_2_50 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000100000")) = pkg_stdLogicVector("00000000000000000000000000100000"));
  zz_zz_decode_BRANCH_CTRL_2_52 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_53) = pkg_stdLogicVector("00000000000000000000000000010000")));
  zz_zz_decode_BRANCH_CTRL_2_54 <= pkg_stdLogicVector("0");
  zz_zz_decode_BRANCH_CTRL_2_55 <= pkg_toStdLogic(pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_7) /= pkg_stdLogicVector("0"));
  zz_zz_decode_BRANCH_CTRL_2_56 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_zz_decode_BRANCH_CTRL_2_57,zz_zz_decode_BRANCH_CTRL_2_58) /= pkg_stdLogicVector("000000")));
  zz_zz_decode_BRANCH_CTRL_2_67 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_68 /= zz_zz_decode_BRANCH_CTRL_2_71)),pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_72),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_75,zz_zz_decode_BRANCH_CTRL_2_83)));
  zz_zz_decode_BRANCH_CTRL_2_48 <= pkg_stdLogicVector("00000000000100000011000001000000");
  zz_zz_decode_BRANCH_CTRL_2_53 <= pkg_stdLogicVector("00000000000000000000000000010000");
  zz_zz_decode_BRANCH_CTRL_2_57 <= pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_8);
  zz_zz_decode_BRANCH_CTRL_2_58 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_59 = zz_zz_decode_BRANCH_CTRL_2_60)),pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_61),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_63,zz_zz_decode_BRANCH_CTRL_2_64)));
  zz_zz_decode_BRANCH_CTRL_2_68 <= pkg_cat(pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_6),pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_69 = zz_zz_decode_BRANCH_CTRL_2_70)));
  zz_zz_decode_BRANCH_CTRL_2_71 <= pkg_stdLogicVector("00");
  zz_zz_decode_BRANCH_CTRL_2_72 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_6),pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_73)) /= pkg_stdLogicVector("00"));
  zz_zz_decode_BRANCH_CTRL_2_75 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_zz_decode_BRANCH_CTRL_2_76,zz_zz_decode_BRANCH_CTRL_2_79) /= pkg_stdLogicVector("0000")));
  zz_zz_decode_BRANCH_CTRL_2_83 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_84 /= zz_zz_decode_BRANCH_CTRL_2_87)),pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_88),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_96,zz_zz_decode_BRANCH_CTRL_2_101)));
  zz_zz_decode_BRANCH_CTRL_2_59 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000001000000010000"));
  zz_zz_decode_BRANCH_CTRL_2_60 <= pkg_stdLogicVector("00000000000000000001000000010000");
  zz_zz_decode_BRANCH_CTRL_2_61 <= pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_62) = pkg_stdLogicVector("00000000000000000010000000010000"));
  zz_zz_decode_BRANCH_CTRL_2_63 <= pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_7);
  zz_zz_decode_BRANCH_CTRL_2_64 <= pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_65),pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_66));
  zz_zz_decode_BRANCH_CTRL_2_69 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001110000"));
  zz_zz_decode_BRANCH_CTRL_2_70 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_zz_decode_BRANCH_CTRL_2_73 <= pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_74) = pkg_stdLogicVector("00000000000000000000000000000000"));
  zz_zz_decode_BRANCH_CTRL_2_76 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_77 = zz_zz_decode_BRANCH_CTRL_2_78));
  zz_zz_decode_BRANCH_CTRL_2_79 <= pkg_cat(pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_5),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_80,zz_zz_decode_BRANCH_CTRL_2_81));
  zz_zz_decode_BRANCH_CTRL_2_84 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_85 = zz_zz_decode_BRANCH_CTRL_2_86));
  zz_zz_decode_BRANCH_CTRL_2_87 <= pkg_stdLogicVector("0");
  zz_zz_decode_BRANCH_CTRL_2_88 <= pkg_toStdLogic(pkg_cat(zz_zz_decode_BRANCH_CTRL_2_89,zz_zz_decode_BRANCH_CTRL_2_91) /= pkg_stdLogicVector("000"));
  zz_zz_decode_BRANCH_CTRL_2_96 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_97 /= zz_zz_decode_BRANCH_CTRL_2_100));
  zz_zz_decode_BRANCH_CTRL_2_101 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_102 /= zz_zz_decode_BRANCH_CTRL_2_105));
  zz_zz_decode_BRANCH_CTRL_2_62 <= pkg_stdLogicVector("00000000000000000010000000010000");
  zz_zz_decode_BRANCH_CTRL_2_65 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000001100")) = pkg_stdLogicVector("00000000000000000000000000000100"));
  zz_zz_decode_BRANCH_CTRL_2_66 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000101000")) = pkg_stdLogicVector("00000000000000000000000000000000"));
  zz_zz_decode_BRANCH_CTRL_2_74 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_zz_decode_BRANCH_CTRL_2_77 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001000100"));
  zz_zz_decode_BRANCH_CTRL_2_78 <= pkg_stdLogicVector("00000000000000000000000000000000");
  zz_zz_decode_BRANCH_CTRL_2_80 <= pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_4);
  zz_zz_decode_BRANCH_CTRL_2_81 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_82) = pkg_stdLogicVector("00000000000000000001000000000000")));
  zz_zz_decode_BRANCH_CTRL_2_85 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001011000"));
  zz_zz_decode_BRANCH_CTRL_2_86 <= pkg_stdLogicVector("00000000000000000000000000000000");
  zz_zz_decode_BRANCH_CTRL_2_89 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2_90) = pkg_stdLogicVector("00000000000000000000000001000000")));
  zz_zz_decode_BRANCH_CTRL_2_91 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_92 = zz_zz_decode_BRANCH_CTRL_2_93)),pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_94 = zz_zz_decode_BRANCH_CTRL_2_95)));
  zz_zz_decode_BRANCH_CTRL_2_97 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_98 = zz_zz_decode_BRANCH_CTRL_2_99)),pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_3));
  zz_zz_decode_BRANCH_CTRL_2_100 <= pkg_stdLogicVector("00");
  zz_zz_decode_BRANCH_CTRL_2_102 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_103 = zz_zz_decode_BRANCH_CTRL_2_104)),pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_3));
  zz_zz_decode_BRANCH_CTRL_2_105 <= pkg_stdLogicVector("00");
  zz_zz_decode_BRANCH_CTRL_2_82 <= pkg_stdLogicVector("00000000000000000101000000000100");
  zz_zz_decode_BRANCH_CTRL_2_90 <= pkg_stdLogicVector("00000000000000000000000001000100");
  zz_zz_decode_BRANCH_CTRL_2_92 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000010000000010100"));
  zz_zz_decode_BRANCH_CTRL_2_93 <= pkg_stdLogicVector("00000000000000000010000000010000");
  zz_zz_decode_BRANCH_CTRL_2_94 <= (decode_INSTRUCTION and pkg_stdLogicVector("01000000000000000100000000110100"));
  zz_zz_decode_BRANCH_CTRL_2_95 <= pkg_stdLogicVector("01000000000000000000000000110000");
  zz_zz_decode_BRANCH_CTRL_2_98 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000010100"));
  zz_zz_decode_BRANCH_CTRL_2_99 <= pkg_stdLogicVector("00000000000000000000000000000100");
  zz_zz_decode_BRANCH_CTRL_2_103 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001000100"));
  zz_zz_decode_BRANCH_CTRL_2_104 <= pkg_stdLogicVector("00000000000000000000000000000100");
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if zz_decode_RegFilePlugin_rs1Data = '1' then
        zz_RegFilePlugin_regFile_port0 <= RegFilePlugin_regFile(to_integer(decode_RegFilePlugin_regFileReadAddress1));
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if zz_decode_RegFilePlugin_rs2Data = '1' then
        zz_RegFilePlugin_regFile_port0_1 <= RegFilePlugin_regFile(to_integer(decode_RegFilePlugin_regFileReadAddress2));
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if zz_1 = '1' then
        RegFilePlugin_regFile(to_integer(lastStageRegFileWrite_payload_address)) <= lastStageRegFileWrite_payload_data;
      end if;
    end if;
  end process;

  IBusSimplePlugin_rspJoin_rspBuffer_c : entity work.StreamFifoLowLatency
    port map ( 
      io_push_valid => iBus_rsp_toStream_valid,
      io_push_ready => IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready,
      io_push_payload_error => iBus_rsp_toStream_payload_error,
      io_push_payload_inst => iBus_rsp_toStream_payload_inst,
      io_pop_valid => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid,
      io_pop_ready => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_ready,
      io_pop_payload_error => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error,
      io_pop_payload_inst => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst,
      io_flush => pkg_toStdLogic(false),
      io_occupancy => IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  memory_MEMORY_READ_DATA <= dBus_rsp_data;
  execute_BRANCH_CALC <= unsigned(pkg_cat(std_logic_vector(pkg_extract(execute_BranchPlugin_branchAdder,31,1)),std_logic_vector(pkg_unsigned("0"))));
  execute_BRANCH_DO <= zz_execute_BRANCH_DO_1;
  writeBack_REGFILE_WRITE_DATA <= memory_to_writeBack_REGFILE_WRITE_DATA;
  execute_REGFILE_WRITE_DATA <= zz_execute_REGFILE_WRITE_DATA;
  memory_MEMORY_ADDRESS_LOW <= execute_to_memory_MEMORY_ADDRESS_LOW;
  execute_MEMORY_ADDRESS_LOW <= pkg_extract(dBus_cmd_payload_address_read_buffer,1,0);
  decode_DO_EBREAK <= (((not DebugPlugin_haltIt) and (decode_IS_EBREAK or pkg_toStdLogic(false))) and DebugPlugin_allowEBreak);
  decode_SRC2 <= zz_decode_SRC2_6;
  decode_SRC1 <= zz_decode_SRC1_1;
  decode_SRC2_FORCE_ZERO <= (decode_SRC_ADD_ZERO and (not decode_SRC_USE_SUB_LESS));
  decode_RS2 <= decode_RegFilePlugin_rs2Data;
  decode_RS1 <= decode_RegFilePlugin_rs1Data;
  decode_BRANCH_CTRL <= zz_decode_BRANCH_CTRL;
  zz_decode_to_execute_BRANCH_CTRL <= zz_decode_to_execute_BRANCH_CTRL_1;
  decode_SHIFT_CTRL <= zz_decode_SHIFT_CTRL;
  zz_decode_to_execute_SHIFT_CTRL <= zz_decode_to_execute_SHIFT_CTRL_1;
  decode_ALU_BITWISE_CTRL <= zz_decode_ALU_BITWISE_CTRL;
  zz_decode_to_execute_ALU_BITWISE_CTRL <= zz_decode_to_execute_ALU_BITWISE_CTRL_1;
  decode_SRC_LESS_UNSIGNED <= pkg_extract(zz_decode_BRANCH_CTRL_2,17);
  decode_ALU_CTRL <= zz_decode_ALU_CTRL;
  zz_decode_to_execute_ALU_CTRL <= zz_decode_to_execute_ALU_CTRL_1;
  zz_memory_to_writeBack_ENV_CTRL <= zz_memory_to_writeBack_ENV_CTRL_1;
  zz_execute_to_memory_ENV_CTRL <= zz_execute_to_memory_ENV_CTRL_1;
  decode_ENV_CTRL <= zz_decode_ENV_CTRL;
  zz_decode_to_execute_ENV_CTRL <= zz_decode_to_execute_ENV_CTRL_1;
  decode_IS_CSR <= pkg_extract(zz_decode_BRANCH_CTRL_2,13);
  decode_MEMORY_STORE <= pkg_extract(zz_decode_BRANCH_CTRL_2,10);
  execute_BYPASSABLE_MEMORY_STAGE <= decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  decode_BYPASSABLE_MEMORY_STAGE <= pkg_extract(zz_decode_BRANCH_CTRL_2,9);
  decode_BYPASSABLE_EXECUTE_STAGE <= pkg_extract(zz_decode_BRANCH_CTRL_2,8);
  decode_MEMORY_ENABLE <= pkg_extract(zz_decode_BRANCH_CTRL_2,3);
  decode_CSR_READ_OPCODE <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,13,7) /= pkg_stdLogicVector("0100000"));
  decode_CSR_WRITE_OPCODE <= (not ((pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,14,13) = pkg_stdLogicVector("01")) and pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,19,15) = pkg_stdLogicVector("00000"))) or (pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,14,13) = pkg_stdLogicVector("11")) and pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,19,15) = pkg_stdLogicVector("00000")))));
  writeBack_FORMAL_PC_NEXT <= memory_to_writeBack_FORMAL_PC_NEXT;
  memory_FORMAL_PC_NEXT <= execute_to_memory_FORMAL_PC_NEXT;
  execute_FORMAL_PC_NEXT <= decode_to_execute_FORMAL_PC_NEXT;
  decode_FORMAL_PC_NEXT <= (decode_PC + pkg_unsigned("00000000000000000000000000000100"));
  memory_PC <= execute_to_memory_PC;
  execute_DO_EBREAK <= decode_to_execute_DO_EBREAK;
  decode_IS_EBREAK <= pkg_extract(zz_decode_BRANCH_CTRL_2,25);
  memory_BRANCH_CALC <= execute_to_memory_BRANCH_CALC;
  memory_BRANCH_DO <= execute_to_memory_BRANCH_DO;
  execute_PC <= decode_to_execute_PC;
  execute_RS1 <= decode_to_execute_RS1;
  execute_BRANCH_CTRL <= zz_execute_BRANCH_CTRL;
  decode_RS2_USE <= pkg_extract(zz_decode_BRANCH_CTRL_2,12);
  decode_RS1_USE <= pkg_extract(zz_decode_BRANCH_CTRL_2,4);
  execute_REGFILE_WRITE_VALID <= decode_to_execute_REGFILE_WRITE_VALID;
  execute_BYPASSABLE_EXECUTE_STAGE <= decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  memory_REGFILE_WRITE_VALID <= execute_to_memory_REGFILE_WRITE_VALID;
  memory_INSTRUCTION <= execute_to_memory_INSTRUCTION;
  memory_BYPASSABLE_MEMORY_STAGE <= execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  writeBack_REGFILE_WRITE_VALID <= memory_to_writeBack_REGFILE_WRITE_VALID;
  memory_REGFILE_WRITE_DATA <= execute_to_memory_REGFILE_WRITE_DATA;
  execute_SHIFT_CTRL <= zz_execute_SHIFT_CTRL;
  execute_SRC_LESS_UNSIGNED <= decode_to_execute_SRC_LESS_UNSIGNED;
  execute_SRC2_FORCE_ZERO <= decode_to_execute_SRC2_FORCE_ZERO;
  execute_SRC_USE_SUB_LESS <= decode_to_execute_SRC_USE_SUB_LESS;
  zz_decode_SRC2 <= decode_PC;
  zz_decode_SRC2_1 <= decode_RS2;
  decode_SRC2_CTRL <= zz_decode_SRC2_CTRL;
  zz_decode_SRC1 <= decode_RS1;
  decode_SRC1_CTRL <= zz_decode_SRC1_CTRL;
  decode_SRC_USE_SUB_LESS <= pkg_extract(zz_decode_BRANCH_CTRL_2,2);
  decode_SRC_ADD_ZERO <= pkg_extract(zz_decode_BRANCH_CTRL_2,20);
  execute_SRC_ADD_SUB <= execute_SrcPlugin_addSub;
  execute_SRC_LESS <= execute_SrcPlugin_less;
  execute_ALU_CTRL <= zz_execute_ALU_CTRL;
  execute_SRC2 <= decode_to_execute_SRC2;
  execute_ALU_BITWISE_CTRL <= zz_execute_ALU_BITWISE_CTRL;
  zz_lastStageRegFileWrite_payload_address <= writeBack_INSTRUCTION;
  zz_lastStageRegFileWrite_valid <= writeBack_REGFILE_WRITE_VALID;
  process(lastStageRegFileWrite_valid)
  begin
    zz_1 <= pkg_toStdLogic(false);
    if lastStageRegFileWrite_valid = '1' then
      zz_1 <= pkg_toStdLogic(true);
    end if;
  end process;

  decode_INSTRUCTION_ANTICIPATED <= pkg_mux(decode_arbitration_isStuck,decode_INSTRUCTION,IBusSimplePlugin_iBusRsp_output_payload_rsp_inst);
  process(zz_decode_BRANCH_CTRL_2,when_RegFilePlugin_l63)
  begin
    decode_REGFILE_WRITE_VALID <= pkg_extract(zz_decode_BRANCH_CTRL_2,7);
    if when_RegFilePlugin_l63 = '1' then
      decode_REGFILE_WRITE_VALID <= pkg_toStdLogic(false);
    end if;
  end process;

  process(execute_REGFILE_WRITE_DATA,when_CsrPlugin_l1189,CsrPlugin_csrMapping_readDataSignal,when_ShiftPlugins_l169,zz_execute_to_memory_REGFILE_WRITE_DATA_1)
  begin
    zz_execute_to_memory_REGFILE_WRITE_DATA <= execute_REGFILE_WRITE_DATA;
    if when_CsrPlugin_l1189 = '1' then
      zz_execute_to_memory_REGFILE_WRITE_DATA <= CsrPlugin_csrMapping_readDataSignal;
    end if;
    if when_ShiftPlugins_l169 = '1' then
      zz_execute_to_memory_REGFILE_WRITE_DATA <= zz_execute_to_memory_REGFILE_WRITE_DATA_1;
    end if;
  end process;

  execute_SRC1 <= decode_to_execute_SRC1;
  execute_CSR_READ_OPCODE <= decode_to_execute_CSR_READ_OPCODE;
  execute_CSR_WRITE_OPCODE <= decode_to_execute_CSR_WRITE_OPCODE;
  execute_IS_CSR <= decode_to_execute_IS_CSR;
  memory_ENV_CTRL <= zz_memory_ENV_CTRL;
  execute_ENV_CTRL <= zz_execute_ENV_CTRL;
  writeBack_ENV_CTRL <= zz_writeBack_ENV_CTRL;
  process(writeBack_REGFILE_WRITE_DATA,when_DBusSimplePlugin_l558,writeBack_DBusSimplePlugin_rspFormated)
  begin
    zz_lastStageRegFileWrite_payload_data <= writeBack_REGFILE_WRITE_DATA;
    if when_DBusSimplePlugin_l558 = '1' then
      zz_lastStageRegFileWrite_payload_data <= writeBack_DBusSimplePlugin_rspFormated;
    end if;
  end process;

  writeBack_MEMORY_ENABLE <= memory_to_writeBack_MEMORY_ENABLE;
  writeBack_MEMORY_ADDRESS_LOW <= memory_to_writeBack_MEMORY_ADDRESS_LOW;
  writeBack_MEMORY_READ_DATA <= memory_to_writeBack_MEMORY_READ_DATA;
  memory_MEMORY_STORE <= execute_to_memory_MEMORY_STORE;
  memory_MEMORY_ENABLE <= execute_to_memory_MEMORY_ENABLE;
  execute_SRC_ADD <= execute_SrcPlugin_addSub;
  execute_RS2 <= decode_to_execute_RS2;
  execute_INSTRUCTION <= decode_to_execute_INSTRUCTION;
  execute_MEMORY_STORE <= decode_to_execute_MEMORY_STORE;
  execute_MEMORY_ENABLE <= decode_to_execute_MEMORY_ENABLE;
  execute_ALIGNEMENT_FAULT <= pkg_toStdLogic(false);
  process(memory_FORMAL_PC_NEXT,BranchPlugin_jumpInterface_valid,BranchPlugin_jumpInterface_payload)
  begin
    zz_memory_to_writeBack_FORMAL_PC_NEXT <= memory_FORMAL_PC_NEXT;
    if BranchPlugin_jumpInterface_valid = '1' then
      zz_memory_to_writeBack_FORMAL_PC_NEXT <= BranchPlugin_jumpInterface_payload;
    end if;
  end process;

  decode_PC <= IBusSimplePlugin_injector_decodeInput_payload_pc;
  decode_INSTRUCTION <= IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  writeBack_PC <= memory_to_writeBack_PC;
  writeBack_INSTRUCTION <= memory_to_writeBack_INSTRUCTION;
  process(switch_Fetcher_l365)
  begin
    decode_arbitration_haltItself <= pkg_toStdLogic(false);
    case switch_Fetcher_l365 is
      when "010" =>
        decode_arbitration_haltItself <= pkg_toStdLogic(true);
      when others =>
    end case;
  end process;

  process(CsrPlugin_pipelineLiberator_active,when_CsrPlugin_l1129,when_HazardSimplePlugin_l113)
  begin
    decode_arbitration_haltByOther <= pkg_toStdLogic(false);
    if CsrPlugin_pipelineLiberator_active = '1' then
      decode_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
    if when_CsrPlugin_l1129 = '1' then
      decode_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
    if when_HazardSimplePlugin_l113 = '1' then
      decode_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
  end process;

  process(decode_arbitration_isFlushed)
  begin
    decode_arbitration_removeIt <= pkg_toStdLogic(false);
    if decode_arbitration_isFlushed = '1' then
      decode_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  decode_arbitration_flushIt <= pkg_toStdLogic(false);
  decode_arbitration_flushNext <= pkg_toStdLogic(false);
  process(when_DBusSimplePlugin_l428,when_CsrPlugin_l1193,execute_CsrPlugin_blockedBySideEffects,when_ShiftPlugins_l169,when_ShiftPlugins_l184)
  begin
    execute_arbitration_haltItself <= pkg_toStdLogic(false);
    if when_DBusSimplePlugin_l428 = '1' then
      execute_arbitration_haltItself <= pkg_toStdLogic(true);
    end if;
    if when_CsrPlugin_l1193 = '1' then
      if execute_CsrPlugin_blockedBySideEffects = '1' then
        execute_arbitration_haltItself <= pkg_toStdLogic(true);
      end if;
    end if;
    if when_ShiftPlugins_l169 = '1' then
      if when_ShiftPlugins_l184 = '1' then
        execute_arbitration_haltItself <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(when_DebugPlugin_l295)
  begin
    execute_arbitration_haltByOther <= pkg_toStdLogic(false);
    if when_DebugPlugin_l295 = '1' then
      execute_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
  end process;

  process(execute_arbitration_isFlushed)
  begin
    execute_arbitration_removeIt <= pkg_toStdLogic(false);
    if execute_arbitration_isFlushed = '1' then
      execute_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  process(when_DebugPlugin_l295,when_DebugPlugin_l298)
  begin
    execute_arbitration_flushIt <= pkg_toStdLogic(false);
    if when_DebugPlugin_l295 = '1' then
      if when_DebugPlugin_l298 = '1' then
        execute_arbitration_flushIt <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(when_DebugPlugin_l295,when_DebugPlugin_l298)
  begin
    execute_arbitration_flushNext <= pkg_toStdLogic(false);
    if when_DebugPlugin_l295 = '1' then
      if when_DebugPlugin_l298 = '1' then
        execute_arbitration_flushNext <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(when_DBusSimplePlugin_l482)
  begin
    memory_arbitration_haltItself <= pkg_toStdLogic(false);
    if when_DBusSimplePlugin_l482 = '1' then
      memory_arbitration_haltItself <= pkg_toStdLogic(true);
    end if;
  end process;

  memory_arbitration_haltByOther <= pkg_toStdLogic(false);
  process(memory_arbitration_isFlushed)
  begin
    memory_arbitration_removeIt <= pkg_toStdLogic(false);
    if memory_arbitration_isFlushed = '1' then
      memory_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  memory_arbitration_flushIt <= pkg_toStdLogic(false);
  process(BranchPlugin_jumpInterface_valid)
  begin
    memory_arbitration_flushNext <= pkg_toStdLogic(false);
    if BranchPlugin_jumpInterface_valid = '1' then
      memory_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
  end process;

  writeBack_arbitration_haltItself <= pkg_toStdLogic(false);
  writeBack_arbitration_haltByOther <= pkg_toStdLogic(false);
  process(writeBack_arbitration_isFlushed)
  begin
    writeBack_arbitration_removeIt <= pkg_toStdLogic(false);
    if writeBack_arbitration_isFlushed = '1' then
      writeBack_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  writeBack_arbitration_flushIt <= pkg_toStdLogic(false);
  process(when_CsrPlugin_l1032,when_CsrPlugin_l1077)
  begin
    writeBack_arbitration_flushNext <= pkg_toStdLogic(false);
    if when_CsrPlugin_l1032 = '1' then
      writeBack_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
    if when_CsrPlugin_l1077 = '1' then
      writeBack_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
  end process;

  lastStageInstruction <= writeBack_INSTRUCTION;
  lastStagePc <= writeBack_PC;
  lastStageIsValid <= writeBack_arbitration_isValid;
  lastStageIsFiring <= writeBack_arbitration_isFiring;
  process(when_CsrPlugin_l1032,when_CsrPlugin_l1077,when_DebugPlugin_l295,when_DebugPlugin_l298,DebugPlugin_haltIt,when_DebugPlugin_l311)
  begin
    IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(false);
    if when_CsrPlugin_l1032 = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
    if when_CsrPlugin_l1077 = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
    if when_DebugPlugin_l295 = '1' then
      if when_DebugPlugin_l298 = '1' then
        IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
      end if;
    end if;
    if DebugPlugin_haltIt = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
    if when_DebugPlugin_l311 = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
  end process;

  IBusSimplePlugin_forceNoDecodeCond <= pkg_toStdLogic(false);
  process(when_Fetcher_l243,IBusSimplePlugin_injector_decodeInput_valid)
  begin
    IBusSimplePlugin_incomingInstruction <= pkg_toStdLogic(false);
    if when_Fetcher_l243 = '1' then
      IBusSimplePlugin_incomingInstruction <= pkg_toStdLogic(true);
    end if;
    if IBusSimplePlugin_injector_decodeInput_valid = '1' then
      IBusSimplePlugin_incomingInstruction <= pkg_toStdLogic(true);
    end if;
  end process;

  CsrPlugin_csrMapping_allowCsrSignal <= pkg_toStdLogic(false);
  CsrPlugin_csrMapping_readDataSignal <= CsrPlugin_csrMapping_readDataInit;
  CsrPlugin_inWfi <= pkg_toStdLogic(false);
  process(DebugPlugin_haltIt)
  begin
    CsrPlugin_thirdPartyWake <= pkg_toStdLogic(false);
    if DebugPlugin_haltIt = '1' then
      CsrPlugin_thirdPartyWake <= pkg_toStdLogic(true);
    end if;
  end process;

  process(when_CsrPlugin_l1032,when_CsrPlugin_l1077)
  begin
    CsrPlugin_jumpInterface_valid <= pkg_toStdLogic(false);
    if when_CsrPlugin_l1032 = '1' then
      CsrPlugin_jumpInterface_valid <= pkg_toStdLogic(true);
    end if;
    if when_CsrPlugin_l1077 = '1' then
      CsrPlugin_jumpInterface_valid <= pkg_toStdLogic(true);
    end if;
  end process;

  process(when_CsrPlugin_l1032,CsrPlugin_xtvec_base,when_CsrPlugin_l1077,switch_CsrPlugin_l1081,CsrPlugin_mepc)
  begin
    CsrPlugin_jumpInterface_payload <= pkg_unsigned("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    if when_CsrPlugin_l1032 = '1' then
      CsrPlugin_jumpInterface_payload <= unsigned(pkg_cat(std_logic_vector(CsrPlugin_xtvec_base),std_logic_vector(pkg_unsigned("00"))));
    end if;
    if when_CsrPlugin_l1077 = '1' then
      case switch_CsrPlugin_l1081 is
        when "11" =>
          CsrPlugin_jumpInterface_payload <= CsrPlugin_mepc;
        when others =>
      end case;
    end if;
  end process;

  process(DebugPlugin_godmode)
  begin
    CsrPlugin_forceMachineWire <= pkg_toStdLogic(false);
    if DebugPlugin_godmode = '1' then
      CsrPlugin_forceMachineWire <= pkg_toStdLogic(true);
    end if;
  end process;

  process(when_DebugPlugin_l331)
  begin
    CsrPlugin_allowInterrupts <= pkg_toStdLogic(true);
    if when_DebugPlugin_l331 = '1' then
      CsrPlugin_allowInterrupts <= pkg_toStdLogic(false);
    end if;
  end process;

  process(DebugPlugin_godmode)
  begin
    CsrPlugin_allowException <= pkg_toStdLogic(true);
    if DebugPlugin_godmode = '1' then
      CsrPlugin_allowException <= pkg_toStdLogic(false);
    end if;
  end process;

  process(DebugPlugin_allowEBreak)
  begin
    CsrPlugin_allowEbreakException <= pkg_toStdLogic(true);
    if DebugPlugin_allowEBreak = '1' then
      CsrPlugin_allowEbreakException <= pkg_toStdLogic(false);
    end if;
  end process;

  process(DebugPlugin_godmode)
  begin
    BranchPlugin_inDebugNoFetchFlag <= pkg_toStdLogic(false);
    if DebugPlugin_godmode = '1' then
      BranchPlugin_inDebugNoFetchFlag <= pkg_toStdLogic(true);
    end if;
  end process;

  IBusSimplePlugin_externalFlush <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushNext),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushNext),pkg_cat(pkg_toStdLogicVector(execute_arbitration_flushNext),pkg_toStdLogicVector(decode_arbitration_flushNext)))) /= pkg_stdLogicVector("0000"));
  IBusSimplePlugin_jump_pcLoad_valid <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(BranchPlugin_jumpInterface_valid),pkg_toStdLogicVector(CsrPlugin_jumpInterface_valid)) /= pkg_stdLogicVector("00"));
  zz_IBusSimplePlugin_jump_pcLoad_payload <= unsigned(pkg_cat(pkg_toStdLogicVector(BranchPlugin_jumpInterface_valid),pkg_toStdLogicVector(CsrPlugin_jumpInterface_valid)));
  IBusSimplePlugin_jump_pcLoad_payload <= pkg_mux(pkg_extract(std_logic_vector((zz_IBusSimplePlugin_jump_pcLoad_payload and pkg_not((zz_IBusSimplePlugin_jump_pcLoad_payload - pkg_unsigned("01"))))),0),CsrPlugin_jumpInterface_payload,BranchPlugin_jumpInterface_payload);
  process(IBusSimplePlugin_jump_pcLoad_valid)
  begin
    IBusSimplePlugin_fetchPc_correction <= pkg_toStdLogic(false);
    if IBusSimplePlugin_jump_pcLoad_valid = '1' then
      IBusSimplePlugin_fetchPc_correction <= pkg_toStdLogic(true);
    end if;
  end process;

  IBusSimplePlugin_fetchPc_output_fire <= (IBusSimplePlugin_fetchPc_output_valid and IBusSimplePlugin_fetchPc_output_ready);
  IBusSimplePlugin_fetchPc_corrected <= (IBusSimplePlugin_fetchPc_correction or IBusSimplePlugin_fetchPc_correctionReg);
  process(IBusSimplePlugin_iBusRsp_stages_1_input_ready)
  begin
    IBusSimplePlugin_fetchPc_pcRegPropagate <= pkg_toStdLogic(false);
    if IBusSimplePlugin_iBusRsp_stages_1_input_ready = '1' then
      IBusSimplePlugin_fetchPc_pcRegPropagate <= pkg_toStdLogic(true);
    end if;
  end process;

  when_Fetcher_l134 <= (IBusSimplePlugin_fetchPc_correction or IBusSimplePlugin_fetchPc_pcRegPropagate);
  IBusSimplePlugin_fetchPc_output_fire_1 <= (IBusSimplePlugin_fetchPc_output_valid and IBusSimplePlugin_fetchPc_output_ready);
  when_Fetcher_l134_1 <= ((not IBusSimplePlugin_fetchPc_output_valid) and IBusSimplePlugin_fetchPc_output_ready);
  process(IBusSimplePlugin_fetchPc_pcReg,IBusSimplePlugin_fetchPc_inc,IBusSimplePlugin_jump_pcLoad_valid,IBusSimplePlugin_jump_pcLoad_payload)
  begin
    IBusSimplePlugin_fetchPc_pc <= (IBusSimplePlugin_fetchPc_pcReg + pkg_resize(unsigned(pkg_cat(pkg_toStdLogicVector(IBusSimplePlugin_fetchPc_inc),pkg_stdLogicVector("00"))),32));
    if IBusSimplePlugin_jump_pcLoad_valid = '1' then
      IBusSimplePlugin_fetchPc_pc <= IBusSimplePlugin_jump_pcLoad_payload;
    end if;
    IBusSimplePlugin_fetchPc_pc(0) <= pkg_toStdLogic(false);
    IBusSimplePlugin_fetchPc_pc(1) <= pkg_toStdLogic(false);
  end process;

  process(IBusSimplePlugin_jump_pcLoad_valid)
  begin
    IBusSimplePlugin_fetchPc_flushed <= pkg_toStdLogic(false);
    if IBusSimplePlugin_jump_pcLoad_valid = '1' then
      IBusSimplePlugin_fetchPc_flushed <= pkg_toStdLogic(true);
    end if;
  end process;

  when_Fetcher_l161 <= (IBusSimplePlugin_fetchPc_booted and ((IBusSimplePlugin_fetchPc_output_ready or IBusSimplePlugin_fetchPc_correction) or IBusSimplePlugin_fetchPc_pcRegPropagate));
  IBusSimplePlugin_fetchPc_output_valid <= ((not IBusSimplePlugin_fetcherHalt) and IBusSimplePlugin_fetchPc_booted);
  IBusSimplePlugin_fetchPc_output_payload <= IBusSimplePlugin_fetchPc_pc;
  IBusSimplePlugin_iBusRsp_redoFetch <= pkg_toStdLogic(false);
  IBusSimplePlugin_iBusRsp_stages_0_input_valid <= IBusSimplePlugin_fetchPc_output_valid;
  IBusSimplePlugin_fetchPc_output_ready <= IBusSimplePlugin_iBusRsp_stages_0_input_ready;
  IBusSimplePlugin_iBusRsp_stages_0_input_payload <= IBusSimplePlugin_fetchPc_output_payload;
  IBusSimplePlugin_iBusRsp_stages_0_halt <= pkg_toStdLogic(false);
  zz_IBusSimplePlugin_iBusRsp_stages_0_input_ready <= (not IBusSimplePlugin_iBusRsp_stages_0_halt);
  IBusSimplePlugin_iBusRsp_stages_0_input_ready <= (IBusSimplePlugin_iBusRsp_stages_0_output_ready and zz_IBusSimplePlugin_iBusRsp_stages_0_input_ready);
  IBusSimplePlugin_iBusRsp_stages_0_output_valid <= (IBusSimplePlugin_iBusRsp_stages_0_input_valid and zz_IBusSimplePlugin_iBusRsp_stages_0_input_ready);
  IBusSimplePlugin_iBusRsp_stages_0_output_payload <= IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  process(when_IBusSimplePlugin_l305)
  begin
    IBusSimplePlugin_iBusRsp_stages_1_halt <= pkg_toStdLogic(false);
    if when_IBusSimplePlugin_l305 = '1' then
      IBusSimplePlugin_iBusRsp_stages_1_halt <= pkg_toStdLogic(true);
    end if;
  end process;

  zz_IBusSimplePlugin_iBusRsp_stages_1_input_ready <= (not IBusSimplePlugin_iBusRsp_stages_1_halt);
  IBusSimplePlugin_iBusRsp_stages_1_input_ready <= (IBusSimplePlugin_iBusRsp_stages_1_output_ready and zz_IBusSimplePlugin_iBusRsp_stages_1_input_ready);
  IBusSimplePlugin_iBusRsp_stages_1_output_valid <= (IBusSimplePlugin_iBusRsp_stages_1_input_valid and zz_IBusSimplePlugin_iBusRsp_stages_1_input_ready);
  IBusSimplePlugin_iBusRsp_stages_1_output_payload <= IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  IBusSimplePlugin_iBusRsp_stages_2_halt <= pkg_toStdLogic(false);
  zz_IBusSimplePlugin_iBusRsp_stages_2_input_ready <= (not IBusSimplePlugin_iBusRsp_stages_2_halt);
  IBusSimplePlugin_iBusRsp_stages_2_input_ready <= (IBusSimplePlugin_iBusRsp_stages_2_output_ready and zz_IBusSimplePlugin_iBusRsp_stages_2_input_ready);
  IBusSimplePlugin_iBusRsp_stages_2_output_valid <= (IBusSimplePlugin_iBusRsp_stages_2_input_valid and zz_IBusSimplePlugin_iBusRsp_stages_2_input_ready);
  IBusSimplePlugin_iBusRsp_stages_2_output_payload <= IBusSimplePlugin_iBusRsp_stages_2_input_payload;
  IBusSimplePlugin_iBusRsp_flush <= (IBusSimplePlugin_externalFlush or IBusSimplePlugin_iBusRsp_redoFetch);
  IBusSimplePlugin_iBusRsp_stages_0_output_ready <= zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready;
  zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready <= ((pkg_toStdLogic(false) and (not zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready_1)) or IBusSimplePlugin_iBusRsp_stages_1_input_ready);
  zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready_1 <= zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready_2;
  IBusSimplePlugin_iBusRsp_stages_1_input_valid <= zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready_1;
  IBusSimplePlugin_iBusRsp_stages_1_input_payload <= IBusSimplePlugin_fetchPc_pcReg;
  IBusSimplePlugin_iBusRsp_stages_1_output_ready <= ((pkg_toStdLogic(false) and (not IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_valid)) or IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_ready);
  IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_valid <= zz_IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_valid;
  IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_payload <= zz_IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_payload;
  IBusSimplePlugin_iBusRsp_stages_2_input_valid <= IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_valid;
  IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_ready <= IBusSimplePlugin_iBusRsp_stages_2_input_ready;
  IBusSimplePlugin_iBusRsp_stages_2_input_payload <= IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_payload;
  process(IBusSimplePlugin_injector_decodeInput_valid,when_Fetcher_l323)
  begin
    IBusSimplePlugin_iBusRsp_readyForError <= pkg_toStdLogic(true);
    if IBusSimplePlugin_injector_decodeInput_valid = '1' then
      IBusSimplePlugin_iBusRsp_readyForError <= pkg_toStdLogic(false);
    end if;
    if when_Fetcher_l323 = '1' then
      IBusSimplePlugin_iBusRsp_readyForError <= pkg_toStdLogic(false);
    end if;
  end process;

  when_Fetcher_l243 <= (IBusSimplePlugin_iBusRsp_stages_1_input_valid or IBusSimplePlugin_iBusRsp_stages_2_input_valid);
  IBusSimplePlugin_iBusRsp_output_ready <= ((pkg_toStdLogic(false) and (not IBusSimplePlugin_injector_decodeInput_valid)) or IBusSimplePlugin_injector_decodeInput_ready);
  IBusSimplePlugin_injector_decodeInput_valid <= zz_IBusSimplePlugin_injector_decodeInput_valid;
  IBusSimplePlugin_injector_decodeInput_payload_pc <= zz_IBusSimplePlugin_injector_decodeInput_payload_pc;
  IBusSimplePlugin_injector_decodeInput_payload_rsp_error <= zz_IBusSimplePlugin_injector_decodeInput_payload_rsp_error;
  IBusSimplePlugin_injector_decodeInput_payload_rsp_inst <= zz_IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  IBusSimplePlugin_injector_decodeInput_payload_isRvc <= zz_IBusSimplePlugin_injector_decodeInput_payload_isRvc;
  when_Fetcher_l323 <= (not IBusSimplePlugin_pcValids_0);
  when_Fetcher_l332 <= (not (not IBusSimplePlugin_iBusRsp_stages_1_input_ready));
  when_Fetcher_l332_1 <= (not (not IBusSimplePlugin_iBusRsp_stages_2_input_ready));
  when_Fetcher_l332_2 <= (not (not IBusSimplePlugin_injector_decodeInput_ready));
  when_Fetcher_l332_3 <= (not execute_arbitration_isStuck);
  when_Fetcher_l332_4 <= (not memory_arbitration_isStuck);
  when_Fetcher_l332_5 <= (not writeBack_arbitration_isStuck);
  IBusSimplePlugin_pcValids_0 <= IBusSimplePlugin_injector_nextPcCalc_valids_2;
  IBusSimplePlugin_pcValids_1 <= IBusSimplePlugin_injector_nextPcCalc_valids_3;
  IBusSimplePlugin_pcValids_2 <= IBusSimplePlugin_injector_nextPcCalc_valids_4;
  IBusSimplePlugin_pcValids_3 <= IBusSimplePlugin_injector_nextPcCalc_valids_5;
  IBusSimplePlugin_injector_decodeInput_ready <= (not decode_arbitration_isStuck);
  process(IBusSimplePlugin_injector_decodeInput_valid,switch_Fetcher_l365,IBusSimplePlugin_forceNoDecodeCond)
  begin
    decode_arbitration_isValid <= IBusSimplePlugin_injector_decodeInput_valid;
    case switch_Fetcher_l365 is
      when "010" =>
        decode_arbitration_isValid <= pkg_toStdLogic(true);
      when "011" =>
        decode_arbitration_isValid <= pkg_toStdLogic(true);
      when others =>
    end case;
    if IBusSimplePlugin_forceNoDecodeCond = '1' then
      decode_arbitration_isValid <= pkg_toStdLogic(false);
    end if;
  end process;

  iBus_cmd_valid <= IBusSimplePlugin_cmd_valid;
  IBusSimplePlugin_cmd_ready <= iBus_cmd_ready;
  iBus_cmd_payload_pc <= IBusSimplePlugin_cmd_payload_pc;
  IBusSimplePlugin_pending_next <= ((IBusSimplePlugin_pending_value + pkg_resize(unsigned(pkg_toStdLogicVector(IBusSimplePlugin_pending_inc)),3)) - pkg_resize(unsigned(pkg_toStdLogicVector(IBusSimplePlugin_pending_dec)),3));
  IBusSimplePlugin_cmdFork_canEmit <= (IBusSimplePlugin_iBusRsp_stages_1_output_ready and pkg_toStdLogic(IBusSimplePlugin_pending_value /= pkg_unsigned("111")));
  when_IBusSimplePlugin_l305 <= (IBusSimplePlugin_iBusRsp_stages_1_input_valid and ((not IBusSimplePlugin_cmdFork_canEmit) or (not IBusSimplePlugin_cmd_ready)));
  IBusSimplePlugin_cmd_valid <= (IBusSimplePlugin_iBusRsp_stages_1_input_valid and IBusSimplePlugin_cmdFork_canEmit);
  IBusSimplePlugin_cmd_fire <= (IBusSimplePlugin_cmd_valid and IBusSimplePlugin_cmd_ready);
  IBusSimplePlugin_pending_inc <= IBusSimplePlugin_cmd_fire;
  IBusSimplePlugin_cmd_payload_pc <= unsigned(pkg_cat(std_logic_vector(pkg_extract(IBusSimplePlugin_iBusRsp_stages_1_input_payload,31,2)),std_logic_vector(pkg_unsigned("00"))));
  iBus_rsp_toStream_valid <= iBus_rsp_valid;
  iBus_rsp_toStream_payload_error <= iBus_rsp_payload_error;
  iBus_rsp_toStream_payload_inst <= iBus_rsp_payload_inst;
  iBus_rsp_toStream_ready <= IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready;
  IBusSimplePlugin_rspJoin_rspBuffer_flush <= (pkg_toStdLogic(IBusSimplePlugin_rspJoin_rspBuffer_discardCounter /= pkg_unsigned("000")) or IBusSimplePlugin_iBusRsp_flush);
  IBusSimplePlugin_rspJoin_rspBuffer_output_valid <= (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid and pkg_toStdLogic(IBusSimplePlugin_rspJoin_rspBuffer_discardCounter = pkg_unsigned("000")));
  IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error <= IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  IBusSimplePlugin_rspJoin_rspBuffer_output_payload_inst <= IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_ready <= (IBusSimplePlugin_rspJoin_rspBuffer_output_ready or IBusSimplePlugin_rspJoin_rspBuffer_flush);
  IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_fire <= (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid and IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_ready);
  IBusSimplePlugin_pending_dec <= IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_fire;
  IBusSimplePlugin_rspJoin_fetchRsp_pc <= IBusSimplePlugin_iBusRsp_stages_2_output_payload;
  process(IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error,when_IBusSimplePlugin_l376)
  begin
    IBusSimplePlugin_rspJoin_fetchRsp_rsp_error <= IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error;
    if when_IBusSimplePlugin_l376 = '1' then
      IBusSimplePlugin_rspJoin_fetchRsp_rsp_error <= pkg_toStdLogic(false);
    end if;
  end process;

  IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst <= IBusSimplePlugin_rspJoin_rspBuffer_output_payload_inst;
  when_IBusSimplePlugin_l376 <= (not IBusSimplePlugin_rspJoin_rspBuffer_output_valid);
  IBusSimplePlugin_rspJoin_exceptionDetected <= pkg_toStdLogic(false);
  IBusSimplePlugin_rspJoin_join_valid <= (IBusSimplePlugin_iBusRsp_stages_2_output_valid and IBusSimplePlugin_rspJoin_rspBuffer_output_valid);
  IBusSimplePlugin_rspJoin_join_payload_pc <= IBusSimplePlugin_rspJoin_fetchRsp_pc;
  IBusSimplePlugin_rspJoin_join_payload_rsp_error <= IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  IBusSimplePlugin_rspJoin_join_payload_rsp_inst <= IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  IBusSimplePlugin_rspJoin_join_payload_isRvc <= IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  IBusSimplePlugin_rspJoin_join_fire <= (IBusSimplePlugin_rspJoin_join_valid and IBusSimplePlugin_rspJoin_join_ready);
  IBusSimplePlugin_iBusRsp_stages_2_output_ready <= pkg_mux(IBusSimplePlugin_iBusRsp_stages_2_output_valid,IBusSimplePlugin_rspJoin_join_fire,IBusSimplePlugin_rspJoin_join_ready);
  IBusSimplePlugin_rspJoin_join_fire_1 <= (IBusSimplePlugin_rspJoin_join_valid and IBusSimplePlugin_rspJoin_join_ready);
  IBusSimplePlugin_rspJoin_rspBuffer_output_ready <= IBusSimplePlugin_rspJoin_join_fire_1;
  zz_IBusSimplePlugin_iBusRsp_output_valid <= (not IBusSimplePlugin_rspJoin_exceptionDetected);
  IBusSimplePlugin_rspJoin_join_ready <= (IBusSimplePlugin_iBusRsp_output_ready and zz_IBusSimplePlugin_iBusRsp_output_valid);
  IBusSimplePlugin_iBusRsp_output_valid <= (IBusSimplePlugin_rspJoin_join_valid and zz_IBusSimplePlugin_iBusRsp_output_valid);
  IBusSimplePlugin_iBusRsp_output_payload_pc <= IBusSimplePlugin_rspJoin_join_payload_pc;
  IBusSimplePlugin_iBusRsp_output_payload_rsp_error <= IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  IBusSimplePlugin_iBusRsp_output_payload_rsp_inst <= IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  IBusSimplePlugin_iBusRsp_output_payload_isRvc <= IBusSimplePlugin_rspJoin_join_payload_isRvc;
  zz_dBus_cmd_valid <= pkg_toStdLogic(false);
  process(execute_ALIGNEMENT_FAULT)
  begin
    execute_DBusSimplePlugin_skipCmd <= pkg_toStdLogic(false);
    if execute_ALIGNEMENT_FAULT = '1' then
      execute_DBusSimplePlugin_skipCmd <= pkg_toStdLogic(true);
    end if;
  end process;

  dBus_cmd_valid <= (((((execute_arbitration_isValid and execute_MEMORY_ENABLE) and (not execute_arbitration_isStuckByOthers)) and (not execute_arbitration_isFlushed)) and (not execute_DBusSimplePlugin_skipCmd)) and (not zz_dBus_cmd_valid));
  dBus_cmd_payload_wr <= execute_MEMORY_STORE;
  dBus_cmd_payload_size_read_buffer <= unsigned(pkg_extract(execute_INSTRUCTION,13,12));
  process(dBus_cmd_payload_size_read_buffer,execute_RS2)
  begin
    case dBus_cmd_payload_size_read_buffer is
      when "00" =>
        zz_dBus_cmd_payload_data <= pkg_cat(pkg_cat(pkg_cat(pkg_extract(execute_RS2,7,0),pkg_extract(execute_RS2,7,0)),pkg_extract(execute_RS2,7,0)),pkg_extract(execute_RS2,7,0));
      when "01" =>
        zz_dBus_cmd_payload_data <= pkg_cat(pkg_extract(execute_RS2,15,0),pkg_extract(execute_RS2,15,0));
      when others =>
        zz_dBus_cmd_payload_data <= pkg_extract(execute_RS2,31,0);
    end case;
  end process;

  dBus_cmd_payload_data <= zz_dBus_cmd_payload_data;
  when_DBusSimplePlugin_l428 <= ((((execute_arbitration_isValid and execute_MEMORY_ENABLE) and (not dBus_cmd_ready)) and (not execute_DBusSimplePlugin_skipCmd)) and (not zz_dBus_cmd_valid));
  process(dBus_cmd_payload_size_read_buffer)
  begin
    case dBus_cmd_payload_size_read_buffer is
      when "00" =>
        zz_execute_DBusSimplePlugin_formalMask <= pkg_stdLogicVector("0001");
      when "01" =>
        zz_execute_DBusSimplePlugin_formalMask <= pkg_stdLogicVector("0011");
      when others =>
        zz_execute_DBusSimplePlugin_formalMask <= pkg_stdLogicVector("1111");
    end case;
  end process;

  execute_DBusSimplePlugin_formalMask <= std_logic_vector(shift_left(unsigned(zz_execute_DBusSimplePlugin_formalMask),to_integer(pkg_extract(dBus_cmd_payload_address_read_buffer,1,0))));
  dBus_cmd_payload_address_read_buffer <= unsigned(execute_SRC_ADD);
  when_DBusSimplePlugin_l482 <= (((memory_arbitration_isValid and memory_MEMORY_ENABLE) and (not memory_MEMORY_STORE)) and ((not dBus_rsp_ready) or pkg_toStdLogic(false)));
  process(writeBack_MEMORY_READ_DATA,writeBack_MEMORY_ADDRESS_LOW)
  begin
    writeBack_DBusSimplePlugin_rspShifted <= writeBack_MEMORY_READ_DATA;
    case writeBack_MEMORY_ADDRESS_LOW is
      when "01" =>
        writeBack_DBusSimplePlugin_rspShifted(7 downto 0) <= pkg_extract(writeBack_MEMORY_READ_DATA,15,8);
      when "10" =>
        writeBack_DBusSimplePlugin_rspShifted(15 downto 0) <= pkg_extract(writeBack_MEMORY_READ_DATA,31,16);
      when "11" =>
        writeBack_DBusSimplePlugin_rspShifted(7 downto 0) <= pkg_extract(writeBack_MEMORY_READ_DATA,31,24);
      when others =>
    end case;
  end process;

  switch_Misc_l210 <= pkg_extract(writeBack_INSTRUCTION,13,12);
  zz_writeBack_DBusSimplePlugin_rspFormated <= (pkg_extract(writeBack_DBusSimplePlugin_rspShifted,7) and (not pkg_extract(writeBack_INSTRUCTION,14)));
  process(zz_writeBack_DBusSimplePlugin_rspFormated,writeBack_DBusSimplePlugin_rspShifted)
  begin
    zz_writeBack_DBusSimplePlugin_rspFormated_1(31) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(30) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(29) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(28) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(27) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(26) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(25) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(24) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(23) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(22) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(21) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(20) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(19) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(18) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(17) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(16) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(15) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(14) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(13) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(12) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(11) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(10) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(9) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(8) <= zz_writeBack_DBusSimplePlugin_rspFormated;
    zz_writeBack_DBusSimplePlugin_rspFormated_1(7 downto 0) <= pkg_extract(writeBack_DBusSimplePlugin_rspShifted,7,0);
  end process;

  zz_writeBack_DBusSimplePlugin_rspFormated_2 <= (pkg_extract(writeBack_DBusSimplePlugin_rspShifted,15) and (not pkg_extract(writeBack_INSTRUCTION,14)));
  process(zz_writeBack_DBusSimplePlugin_rspFormated_2,writeBack_DBusSimplePlugin_rspShifted)
  begin
    zz_writeBack_DBusSimplePlugin_rspFormated_3(31) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(30) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(29) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(28) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(27) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(26) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(25) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(24) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(23) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(22) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(21) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(20) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(19) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(18) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(17) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(16) <= zz_writeBack_DBusSimplePlugin_rspFormated_2;
    zz_writeBack_DBusSimplePlugin_rspFormated_3(15 downto 0) <= pkg_extract(writeBack_DBusSimplePlugin_rspShifted,15,0);
  end process;

  process(switch_Misc_l210,zz_writeBack_DBusSimplePlugin_rspFormated_1,zz_writeBack_DBusSimplePlugin_rspFormated_3,writeBack_DBusSimplePlugin_rspShifted)
  begin
    case switch_Misc_l210 is
      when "00" =>
        writeBack_DBusSimplePlugin_rspFormated <= zz_writeBack_DBusSimplePlugin_rspFormated_1;
      when "01" =>
        writeBack_DBusSimplePlugin_rspFormated <= zz_writeBack_DBusSimplePlugin_rspFormated_3;
      when others =>
        writeBack_DBusSimplePlugin_rspFormated <= writeBack_DBusSimplePlugin_rspShifted;
    end case;
  end process;

  when_DBusSimplePlugin_l558 <= (writeBack_arbitration_isValid and writeBack_MEMORY_ENABLE);
  process(CsrPlugin_forceMachineWire)
  begin
    CsrPlugin_privilege <= pkg_unsigned("11");
    if CsrPlugin_forceMachineWire = '1' then
      CsrPlugin_privilege <= pkg_unsigned("11");
    end if;
  end process;

  CsrPlugin_misa_base <= pkg_unsigned("01");
  CsrPlugin_misa_extensions <= pkg_stdLogicVector("00000000000000000001000010");
  CsrPlugin_mtvec_mode <= pkg_stdLogicVector("00");
  CsrPlugin_mtvec_base <= pkg_unsigned("100000000000000000000000001000");
  zz_when_CsrPlugin_l965 <= (CsrPlugin_mip_MTIP and CsrPlugin_mie_MTIE);
  zz_when_CsrPlugin_l965_1 <= (CsrPlugin_mip_MSIP and CsrPlugin_mie_MSIE);
  zz_when_CsrPlugin_l965_2 <= (CsrPlugin_mip_MEIP and CsrPlugin_mie_MEIE);
  when_CsrPlugin_l959 <= (CsrPlugin_mstatus_MIE or pkg_toStdLogic(CsrPlugin_privilege < pkg_unsigned("11")));
  when_CsrPlugin_l965 <= ((zz_when_CsrPlugin_l965 and pkg_toStdLogic(true)) and (not pkg_toStdLogic(false)));
  when_CsrPlugin_l965_1 <= ((zz_when_CsrPlugin_l965_1 and pkg_toStdLogic(true)) and (not pkg_toStdLogic(false)));
  when_CsrPlugin_l965_2 <= ((zz_when_CsrPlugin_l965_2 and pkg_toStdLogic(true)) and (not pkg_toStdLogic(false)));
  CsrPlugin_exception <= pkg_toStdLogic(false);
  CsrPlugin_lastStageWasWfi <= pkg_toStdLogic(false);
  CsrPlugin_pipelineLiberator_active <= ((CsrPlugin_interrupt_valid and CsrPlugin_allowInterrupts) and decode_arbitration_isValid);
  when_CsrPlugin_l993 <= (not execute_arbitration_isStuck);
  when_CsrPlugin_l993_1 <= (not memory_arbitration_isStuck);
  when_CsrPlugin_l993_2 <= (not writeBack_arbitration_isStuck);
  when_CsrPlugin_l998 <= ((not CsrPlugin_pipelineLiberator_active) or decode_arbitration_removeIt);
  process(CsrPlugin_pipelineLiberator_pcValids_2,CsrPlugin_hadException)
  begin
    CsrPlugin_pipelineLiberator_done <= CsrPlugin_pipelineLiberator_pcValids_2;
    if CsrPlugin_hadException = '1' then
      CsrPlugin_pipelineLiberator_done <= pkg_toStdLogic(false);
    end if;
  end process;

  CsrPlugin_interruptJump <= ((CsrPlugin_interrupt_valid and CsrPlugin_pipelineLiberator_done) and CsrPlugin_allowInterrupts);
  CsrPlugin_targetPrivilege <= CsrPlugin_interrupt_targetPrivilege;
  CsrPlugin_trapCause <= pkg_resize(CsrPlugin_interrupt_code,4);
  process(CsrPlugin_targetPrivilege,CsrPlugin_mtvec_mode)
  begin
    CsrPlugin_xtvec_mode <= pkg_stdLogicVector("XX");
    case CsrPlugin_targetPrivilege is
      when "11" =>
        CsrPlugin_xtvec_mode <= CsrPlugin_mtvec_mode;
      when others =>
    end case;
  end process;

  process(CsrPlugin_targetPrivilege,CsrPlugin_mtvec_base)
  begin
    CsrPlugin_xtvec_base <= pkg_unsigned("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    case CsrPlugin_targetPrivilege is
      when "11" =>
        CsrPlugin_xtvec_base <= CsrPlugin_mtvec_base;
      when others =>
    end case;
  end process;

  when_CsrPlugin_l1032 <= (CsrPlugin_hadException or CsrPlugin_interruptJump);
  when_CsrPlugin_l1077 <= (writeBack_arbitration_isValid and pkg_toStdLogic(writeBack_ENV_CTRL = EnvCtrlEnum_seq_XRET));
  switch_CsrPlugin_l1081 <= pkg_extract(writeBack_INSTRUCTION,29,28);
  contextSwitching <= CsrPlugin_jumpInterface_valid;
  when_CsrPlugin_l1129 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector((writeBack_arbitration_isValid and pkg_toStdLogic(writeBack_ENV_CTRL = EnvCtrlEnum_seq_XRET))),pkg_cat(pkg_toStdLogicVector((memory_arbitration_isValid and pkg_toStdLogic(memory_ENV_CTRL = EnvCtrlEnum_seq_XRET))),pkg_toStdLogicVector((execute_arbitration_isValid and pkg_toStdLogic(execute_ENV_CTRL = EnvCtrlEnum_seq_XRET))))) /= pkg_stdLogicVector("000"));
  execute_CsrPlugin_blockedBySideEffects <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_isValid),pkg_toStdLogicVector(memory_arbitration_isValid)) /= pkg_stdLogicVector("00")) or pkg_toStdLogic(false));
  process(execute_CsrPlugin_csr_768,execute_CsrPlugin_csr_836,execute_CsrPlugin_csr_772,execute_CsrPlugin_csr_834,execute_CSR_READ_OPCODE,CsrPlugin_csrMapping_allowCsrSignal,when_CsrPlugin_l1310,when_CsrPlugin_l1315)
  begin
    execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(true);
    if execute_CsrPlugin_csr_768 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
    if execute_CsrPlugin_csr_836 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
    if execute_CsrPlugin_csr_772 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
    if execute_CsrPlugin_csr_834 = '1' then
      if execute_CSR_READ_OPCODE = '1' then
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      end if;
    end if;
    if CsrPlugin_csrMapping_allowCsrSignal = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
    if when_CsrPlugin_l1310 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(true);
    end if;
    if when_CsrPlugin_l1315 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
  end process;

  process(when_CsrPlugin_l1149,when_CsrPlugin_l1150)
  begin
    execute_CsrPlugin_illegalInstruction <= pkg_toStdLogic(false);
    if when_CsrPlugin_l1149 = '1' then
      if when_CsrPlugin_l1150 = '1' then
        execute_CsrPlugin_illegalInstruction <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  when_CsrPlugin_l1149 <= (execute_arbitration_isValid and pkg_toStdLogic(execute_ENV_CTRL = EnvCtrlEnum_seq_XRET));
  when_CsrPlugin_l1150 <= pkg_toStdLogic(CsrPlugin_privilege < unsigned(pkg_extract(execute_INSTRUCTION,29,28)));
  process(execute_arbitration_isValid,execute_IS_CSR,execute_CSR_WRITE_OPCODE,when_CsrPlugin_l1310)
  begin
    execute_CsrPlugin_writeInstruction <= ((execute_arbitration_isValid and execute_IS_CSR) and execute_CSR_WRITE_OPCODE);
    if when_CsrPlugin_l1310 = '1' then
      execute_CsrPlugin_writeInstruction <= pkg_toStdLogic(false);
    end if;
  end process;

  process(execute_arbitration_isValid,execute_IS_CSR,execute_CSR_READ_OPCODE,when_CsrPlugin_l1310)
  begin
    execute_CsrPlugin_readInstruction <= ((execute_arbitration_isValid and execute_IS_CSR) and execute_CSR_READ_OPCODE);
    if when_CsrPlugin_l1310 = '1' then
      execute_CsrPlugin_readInstruction <= pkg_toStdLogic(false);
    end if;
  end process;

  execute_CsrPlugin_writeEnable <= (execute_CsrPlugin_writeInstruction and (not execute_arbitration_isStuck));
  execute_CsrPlugin_readEnable <= (execute_CsrPlugin_readInstruction and (not execute_arbitration_isStuck));
  CsrPlugin_csrMapping_hazardFree <= (not execute_CsrPlugin_blockedBySideEffects);
  execute_CsrPlugin_readToWriteData <= CsrPlugin_csrMapping_readDataSignal;
  switch_Misc_l210_1 <= pkg_extract(execute_INSTRUCTION,13);
  process(switch_Misc_l210_1,execute_SRC1,execute_INSTRUCTION,execute_CsrPlugin_readToWriteData)
  begin
    case switch_Misc_l210_1 is
      when '0' =>
        zz_CsrPlugin_csrMapping_writeDataSignal <= execute_SRC1;
      when others =>
        zz_CsrPlugin_csrMapping_writeDataSignal <= pkg_mux(pkg_extract(execute_INSTRUCTION,12),(execute_CsrPlugin_readToWriteData and pkg_not(execute_SRC1)),(execute_CsrPlugin_readToWriteData or execute_SRC1));
    end case;
  end process;

  CsrPlugin_csrMapping_writeDataSignal <= zz_CsrPlugin_csrMapping_writeDataSignal;
  when_CsrPlugin_l1189 <= (execute_arbitration_isValid and execute_IS_CSR);
  when_CsrPlugin_l1193 <= (execute_arbitration_isValid and (execute_IS_CSR or pkg_toStdLogic(false)));
  execute_CsrPlugin_csrAddress <= pkg_extract(execute_INSTRUCTION,31,20);
  zz_decode_BRANCH_CTRL_3 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000100000001010000")) = pkg_stdLogicVector("00000000000000000100000001010000"));
  zz_decode_BRANCH_CTRL_4 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000110000000000100")) = pkg_stdLogicVector("00000000000000000010000000000000"));
  zz_decode_BRANCH_CTRL_5 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000011000")) = pkg_stdLogicVector("00000000000000000000000000000000"));
  zz_decode_BRANCH_CTRL_6 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000000100")) = pkg_stdLogicVector("00000000000000000000000000000100"));
  zz_decode_BRANCH_CTRL_7 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001010000")) = pkg_stdLogicVector("00000000000000000000000000010000"));
  zz_decode_BRANCH_CTRL_8 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001001000")) = pkg_stdLogicVector("00000000000000000000000001001000"));
  zz_decode_BRANCH_CTRL_2 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_zz_decode_BRANCH_CTRL_2) = pkg_stdLogicVector("00000000000000000000000001010000"))) /= pkg_stdLogicVector("0"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_decode_BRANCH_CTRL_8),pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_1)) /= pkg_stdLogicVector("00"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_2) /= pkg_stdLogicVector("0"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_zz_decode_BRANCH_CTRL_2_3 /= zz_zz_decode_BRANCH_CTRL_2_4)),pkg_cat(pkg_toStdLogicVector(zz_zz_decode_BRANCH_CTRL_2_5),pkg_cat(zz_zz_decode_BRANCH_CTRL_2_10,zz_zz_decode_BRANCH_CTRL_2_13))))));
  zz_decode_SRC1_CTRL_2 <= pkg_extract(zz_decode_BRANCH_CTRL_2,1,0);
  zz_decode_SRC1_CTRL_1 <= zz_decode_SRC1_CTRL_2;
  zz_decode_SRC2_CTRL_2 <= pkg_extract(zz_decode_BRANCH_CTRL_2,6,5);
  zz_decode_SRC2_CTRL_1 <= zz_decode_SRC2_CTRL_2;
  zz_decode_ENV_CTRL_2 <= pkg_extract(zz_decode_BRANCH_CTRL_2,14,14);
  zz_decode_ENV_CTRL_1 <= zz_decode_ENV_CTRL_2;
  zz_decode_ALU_CTRL_2 <= pkg_extract(zz_decode_BRANCH_CTRL_2,16,15);
  zz_decode_ALU_CTRL_1 <= zz_decode_ALU_CTRL_2;
  zz_decode_ALU_BITWISE_CTRL_2 <= pkg_extract(zz_decode_BRANCH_CTRL_2,19,18);
  zz_decode_ALU_BITWISE_CTRL_1 <= zz_decode_ALU_BITWISE_CTRL_2;
  zz_decode_SHIFT_CTRL_2 <= pkg_extract(zz_decode_BRANCH_CTRL_2,22,21);
  zz_decode_SHIFT_CTRL_1 <= zz_decode_SHIFT_CTRL_2;
  zz_decode_BRANCH_CTRL_9 <= pkg_extract(zz_decode_BRANCH_CTRL_2,24,23);
  zz_decode_BRANCH_CTRL_1 <= zz_decode_BRANCH_CTRL_9;
  when_RegFilePlugin_l63 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,11,7) = pkg_stdLogicVector("00000"));
  decode_RegFilePlugin_regFileReadAddress1 <= unsigned(pkg_extract(decode_INSTRUCTION_ANTICIPATED,19,15));
  decode_RegFilePlugin_regFileReadAddress2 <= unsigned(pkg_extract(decode_INSTRUCTION_ANTICIPATED,24,20));
  decode_RegFilePlugin_rs1Data <= zz_RegFilePlugin_regFile_port0;
  decode_RegFilePlugin_rs2Data <= zz_RegFilePlugin_regFile_port0_1;
  process(zz_lastStageRegFileWrite_valid,writeBack_arbitration_isFiring,zz_2)
  begin
    lastStageRegFileWrite_valid <= (zz_lastStageRegFileWrite_valid and writeBack_arbitration_isFiring);
    if zz_2 = '1' then
      lastStageRegFileWrite_valid <= pkg_toStdLogic(true);
    end if;
  end process;

  process(zz_lastStageRegFileWrite_payload_address,zz_2)
  begin
    lastStageRegFileWrite_payload_address <= unsigned(pkg_extract(zz_lastStageRegFileWrite_payload_address,11,7));
    if zz_2 = '1' then
      lastStageRegFileWrite_payload_address <= pkg_unsigned("00000");
    end if;
  end process;

  process(zz_lastStageRegFileWrite_payload_data,zz_2)
  begin
    lastStageRegFileWrite_payload_data <= zz_lastStageRegFileWrite_payload_data;
    if zz_2 = '1' then
      lastStageRegFileWrite_payload_data <= pkg_stdLogicVector("00000000000000000000000000000000");
    end if;
  end process;

  process(execute_ALU_BITWISE_CTRL,execute_SRC1,execute_SRC2)
  begin
    case execute_ALU_BITWISE_CTRL is
      when AluBitwiseCtrlEnum_seq_AND_1 =>
        execute_IntAluPlugin_bitwise <= (execute_SRC1 and execute_SRC2);
      when AluBitwiseCtrlEnum_seq_OR_1 =>
        execute_IntAluPlugin_bitwise <= (execute_SRC1 or execute_SRC2);
      when others =>
        execute_IntAluPlugin_bitwise <= (execute_SRC1 xor execute_SRC2);
    end case;
  end process;

  process(execute_ALU_CTRL,execute_IntAluPlugin_bitwise,execute_SRC_LESS,execute_SRC_ADD_SUB)
  begin
    case execute_ALU_CTRL is
      when AluCtrlEnum_seq_BITWISE =>
        zz_execute_REGFILE_WRITE_DATA <= execute_IntAluPlugin_bitwise;
      when AluCtrlEnum_seq_SLT_SLTU =>
        zz_execute_REGFILE_WRITE_DATA <= pkg_resize(pkg_toStdLogicVector(execute_SRC_LESS),32);
      when others =>
        zz_execute_REGFILE_WRITE_DATA <= execute_SRC_ADD_SUB;
    end case;
  end process;

  process(decode_SRC1_CTRL,zz_decode_SRC1,decode_INSTRUCTION)
  begin
    case decode_SRC1_CTRL is
      when Src1CtrlEnum_seq_RS =>
        zz_decode_SRC1_1 <= zz_decode_SRC1;
      when Src1CtrlEnum_seq_PC_INCREMENT =>
        zz_decode_SRC1_1 <= pkg_resize(pkg_stdLogicVector("100"),32);
      when Src1CtrlEnum_seq_IMU =>
        zz_decode_SRC1_1 <= pkg_cat(pkg_extract(decode_INSTRUCTION,31,12),std_logic_vector(pkg_unsigned("000000000000")));
      when others =>
        zz_decode_SRC1_1 <= pkg_resize(pkg_extract(decode_INSTRUCTION,19,15),32);
    end case;
  end process;

  zz_decode_SRC2_2 <= pkg_extract(decode_INSTRUCTION,31);
  process(zz_decode_SRC2_2)
  begin
    zz_decode_SRC2_3(19) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(18) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(17) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(16) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(15) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(14) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(13) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(12) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(11) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(10) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(9) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(8) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(7) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(6) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(5) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(4) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(3) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(2) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(1) <= zz_decode_SRC2_2;
    zz_decode_SRC2_3(0) <= zz_decode_SRC2_2;
  end process;

  zz_decode_SRC2_4 <= pkg_extract(pkg_cat(pkg_extract(decode_INSTRUCTION,31,25),pkg_extract(decode_INSTRUCTION,11,7)),11);
  process(zz_decode_SRC2_4)
  begin
    zz_decode_SRC2_5(19) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(18) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(17) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(16) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(15) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(14) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(13) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(12) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(11) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(10) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(9) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(8) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(7) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(6) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(5) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(4) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(3) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(2) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(1) <= zz_decode_SRC2_4;
    zz_decode_SRC2_5(0) <= zz_decode_SRC2_4;
  end process;

  process(decode_SRC2_CTRL,zz_decode_SRC2_1,zz_decode_SRC2_3,decode_INSTRUCTION,zz_decode_SRC2_5,zz_decode_SRC2)
  begin
    case decode_SRC2_CTRL is
      when Src2CtrlEnum_seq_RS =>
        zz_decode_SRC2_6 <= zz_decode_SRC2_1;
      when Src2CtrlEnum_seq_IMI =>
        zz_decode_SRC2_6 <= pkg_cat(zz_decode_SRC2_3,pkg_extract(decode_INSTRUCTION,31,20));
      when Src2CtrlEnum_seq_IMS =>
        zz_decode_SRC2_6 <= pkg_cat(zz_decode_SRC2_5,pkg_cat(pkg_extract(decode_INSTRUCTION,31,25),pkg_extract(decode_INSTRUCTION,11,7)));
      when others =>
        zz_decode_SRC2_6 <= std_logic_vector(zz_decode_SRC2);
    end case;
  end process;

  process(execute_SRC1,execute_SRC_USE_SUB_LESS,execute_SRC2,execute_SRC2_FORCE_ZERO)
  begin
    execute_SrcPlugin_addSub <= std_logic_vector(((signed(execute_SRC1) + signed(pkg_mux(execute_SRC_USE_SUB_LESS,pkg_not(execute_SRC2),execute_SRC2))) + pkg_mux(execute_SRC_USE_SUB_LESS,pkg_signed("00000000000000000000000000000001"),pkg_signed("00000000000000000000000000000000"))));
    if execute_SRC2_FORCE_ZERO = '1' then
      execute_SrcPlugin_addSub <= execute_SRC1;
    end if;
  end process;

  execute_SrcPlugin_less <= pkg_mux(pkg_toStdLogic(pkg_extract(execute_SRC1,31) = pkg_extract(execute_SRC2,31)),pkg_extract(execute_SrcPlugin_addSub,31),pkg_mux(execute_SRC_LESS_UNSIGNED,pkg_extract(execute_SRC2,31),pkg_extract(execute_SRC1,31)));
  execute_LightShifterPlugin_isShift <= pkg_toStdLogic(execute_SHIFT_CTRL /= ShiftCtrlEnum_seq_DISABLE_1);
  execute_LightShifterPlugin_amplitude <= pkg_mux(execute_LightShifterPlugin_isActive,execute_LightShifterPlugin_amplitudeReg,unsigned(pkg_extract(execute_SRC2,4,0)));
  execute_LightShifterPlugin_shiftInput <= pkg_mux(execute_LightShifterPlugin_isActive,memory_REGFILE_WRITE_DATA,execute_SRC1);
  execute_LightShifterPlugin_done <= pkg_toStdLogic(pkg_extract(execute_LightShifterPlugin_amplitude,4,1) = pkg_unsigned("0000"));
  when_ShiftPlugins_l169 <= ((execute_arbitration_isValid and execute_LightShifterPlugin_isShift) and pkg_toStdLogic(pkg_extract(execute_SRC2,4,0) /= pkg_stdLogicVector("00000")));
  process(execute_SHIFT_CTRL,execute_LightShifterPlugin_shiftInput)
  begin
    case execute_SHIFT_CTRL is
      when ShiftCtrlEnum_seq_SLL_1 =>
        zz_execute_to_memory_REGFILE_WRITE_DATA_1 <= std_logic_vector(shift_left(unsigned(execute_LightShifterPlugin_shiftInput),1));
      when others =>
        zz_execute_to_memory_REGFILE_WRITE_DATA_1 <= std_logic_vector(pkg_shiftRight(signed(pkg_cat(pkg_toStdLogicVector((pkg_toStdLogic(execute_SHIFT_CTRL = ShiftCtrlEnum_seq_SRA_1) and pkg_extract(execute_LightShifterPlugin_shiftInput,31))),execute_LightShifterPlugin_shiftInput)),1));
    end case;
  end process;

  when_ShiftPlugins_l175 <= (not execute_arbitration_isStuckByOthers);
  when_ShiftPlugins_l184 <= (not execute_LightShifterPlugin_done);
  process(HazardSimplePlugin_writeBackBuffer_valid,HazardSimplePlugin_addr0Match,when_HazardSimplePlugin_l57,when_HazardSimplePlugin_l58,when_HazardSimplePlugin_l59,when_HazardSimplePlugin_l57_1,when_HazardSimplePlugin_l58_1,when_HazardSimplePlugin_l59_1,when_HazardSimplePlugin_l57_2,when_HazardSimplePlugin_l58_2,when_HazardSimplePlugin_l59_2,when_HazardSimplePlugin_l105)
  begin
    HazardSimplePlugin_src0Hazard <= pkg_toStdLogic(false);
    if HazardSimplePlugin_writeBackBuffer_valid = '1' then
      if HazardSimplePlugin_addr0Match = '1' then
        HazardSimplePlugin_src0Hazard <= pkg_toStdLogic(true);
      end if;
    end if;
    if when_HazardSimplePlugin_l57 = '1' then
      if when_HazardSimplePlugin_l58 = '1' then
        if when_HazardSimplePlugin_l59 = '1' then
          HazardSimplePlugin_src0Hazard <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if when_HazardSimplePlugin_l57_1 = '1' then
      if when_HazardSimplePlugin_l58_1 = '1' then
        if when_HazardSimplePlugin_l59_1 = '1' then
          HazardSimplePlugin_src0Hazard <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if when_HazardSimplePlugin_l57_2 = '1' then
      if when_HazardSimplePlugin_l58_2 = '1' then
        if when_HazardSimplePlugin_l59_2 = '1' then
          HazardSimplePlugin_src0Hazard <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if when_HazardSimplePlugin_l105 = '1' then
      HazardSimplePlugin_src0Hazard <= pkg_toStdLogic(false);
    end if;
  end process;

  process(HazardSimplePlugin_writeBackBuffer_valid,HazardSimplePlugin_addr1Match,when_HazardSimplePlugin_l57,when_HazardSimplePlugin_l58,when_HazardSimplePlugin_l62,when_HazardSimplePlugin_l57_1,when_HazardSimplePlugin_l58_1,when_HazardSimplePlugin_l62_1,when_HazardSimplePlugin_l57_2,when_HazardSimplePlugin_l58_2,when_HazardSimplePlugin_l62_2,when_HazardSimplePlugin_l108)
  begin
    HazardSimplePlugin_src1Hazard <= pkg_toStdLogic(false);
    if HazardSimplePlugin_writeBackBuffer_valid = '1' then
      if HazardSimplePlugin_addr1Match = '1' then
        HazardSimplePlugin_src1Hazard <= pkg_toStdLogic(true);
      end if;
    end if;
    if when_HazardSimplePlugin_l57 = '1' then
      if when_HazardSimplePlugin_l58 = '1' then
        if when_HazardSimplePlugin_l62 = '1' then
          HazardSimplePlugin_src1Hazard <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if when_HazardSimplePlugin_l57_1 = '1' then
      if when_HazardSimplePlugin_l58_1 = '1' then
        if when_HazardSimplePlugin_l62_1 = '1' then
          HazardSimplePlugin_src1Hazard <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if when_HazardSimplePlugin_l57_2 = '1' then
      if when_HazardSimplePlugin_l58_2 = '1' then
        if when_HazardSimplePlugin_l62_2 = '1' then
          HazardSimplePlugin_src1Hazard <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if when_HazardSimplePlugin_l108 = '1' then
      HazardSimplePlugin_src1Hazard <= pkg_toStdLogic(false);
    end if;
  end process;

  HazardSimplePlugin_writeBackWrites_valid <= (zz_lastStageRegFileWrite_valid and writeBack_arbitration_isFiring);
  HazardSimplePlugin_writeBackWrites_payload_address <= pkg_extract(zz_lastStageRegFileWrite_payload_address,11,7);
  HazardSimplePlugin_writeBackWrites_payload_data <= zz_lastStageRegFileWrite_payload_data;
  HazardSimplePlugin_addr0Match <= pkg_toStdLogic(HazardSimplePlugin_writeBackBuffer_payload_address = pkg_extract(decode_INSTRUCTION,19,15));
  HazardSimplePlugin_addr1Match <= pkg_toStdLogic(HazardSimplePlugin_writeBackBuffer_payload_address = pkg_extract(decode_INSTRUCTION,24,20));
  when_HazardSimplePlugin_l59 <= pkg_toStdLogic(pkg_extract(writeBack_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,19,15));
  when_HazardSimplePlugin_l62 <= pkg_toStdLogic(pkg_extract(writeBack_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,24,20));
  when_HazardSimplePlugin_l57 <= (writeBack_arbitration_isValid and writeBack_REGFILE_WRITE_VALID);
  when_HazardSimplePlugin_l58 <= (pkg_toStdLogic(true) or (not pkg_toStdLogic(true)));
  when_HazardSimplePlugin_l59_1 <= pkg_toStdLogic(pkg_extract(memory_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,19,15));
  when_HazardSimplePlugin_l62_1 <= pkg_toStdLogic(pkg_extract(memory_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,24,20));
  when_HazardSimplePlugin_l57_1 <= (memory_arbitration_isValid and memory_REGFILE_WRITE_VALID);
  when_HazardSimplePlugin_l58_1 <= (pkg_toStdLogic(true) or (not memory_BYPASSABLE_MEMORY_STAGE));
  when_HazardSimplePlugin_l59_2 <= pkg_toStdLogic(pkg_extract(execute_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,19,15));
  when_HazardSimplePlugin_l62_2 <= pkg_toStdLogic(pkg_extract(execute_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,24,20));
  when_HazardSimplePlugin_l57_2 <= (execute_arbitration_isValid and execute_REGFILE_WRITE_VALID);
  when_HazardSimplePlugin_l58_2 <= (pkg_toStdLogic(true) or (not execute_BYPASSABLE_EXECUTE_STAGE));
  when_HazardSimplePlugin_l105 <= (not decode_RS1_USE);
  when_HazardSimplePlugin_l108 <= (not decode_RS2_USE);
  when_HazardSimplePlugin_l113 <= (decode_arbitration_isValid and (HazardSimplePlugin_src0Hazard or HazardSimplePlugin_src1Hazard));
  execute_BranchPlugin_eq <= pkg_toStdLogic(execute_SRC1 = execute_SRC2);
  switch_Misc_l210_2 <= pkg_extract(execute_INSTRUCTION,14,12);
  process(switch_Misc_l210_2,execute_BranchPlugin_eq,execute_SRC_LESS)
  begin
    if (switch_Misc_l210_2 = pkg_stdLogicVector("000")) then
        zz_execute_BRANCH_DO <= execute_BranchPlugin_eq;
    elsif (switch_Misc_l210_2 = pkg_stdLogicVector("001")) then
        zz_execute_BRANCH_DO <= (not execute_BranchPlugin_eq);
    elsif (pkg_toStdLogic((switch_Misc_l210_2 and pkg_stdLogicVector("101")) = pkg_stdLogicVector("101")) = '1') then
        zz_execute_BRANCH_DO <= (not execute_SRC_LESS);
    else
        zz_execute_BRANCH_DO <= execute_SRC_LESS;
    end if;
  end process;

  process(execute_BRANCH_CTRL,zz_execute_BRANCH_DO)
  begin
    case execute_BRANCH_CTRL is
      when BranchCtrlEnum_seq_INC =>
        zz_execute_BRANCH_DO_1 <= pkg_toStdLogic(false);
      when BranchCtrlEnum_seq_JAL =>
        zz_execute_BRANCH_DO_1 <= pkg_toStdLogic(true);
      when BranchCtrlEnum_seq_JALR =>
        zz_execute_BRANCH_DO_1 <= pkg_toStdLogic(true);
      when others =>
        zz_execute_BRANCH_DO_1 <= zz_execute_BRANCH_DO;
    end case;
  end process;

  execute_BranchPlugin_branch_src1 <= pkg_mux(pkg_toStdLogic(execute_BRANCH_CTRL = BranchCtrlEnum_seq_JALR),unsigned(execute_RS1),execute_PC);
  zz_execute_BranchPlugin_branch_src2 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_extract(execute_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,20))),pkg_extract(execute_INSTRUCTION,30,21)),19);
  process(zz_execute_BranchPlugin_branch_src2)
  begin
    zz_execute_BranchPlugin_branch_src2_1(10) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(9) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(8) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(7) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(6) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(5) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(4) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(3) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(2) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(1) <= zz_execute_BranchPlugin_branch_src2;
    zz_execute_BranchPlugin_branch_src2_1(0) <= zz_execute_BranchPlugin_branch_src2;
  end process;

  zz_execute_BranchPlugin_branch_src2_2 <= pkg_extract(execute_INSTRUCTION,31);
  process(zz_execute_BranchPlugin_branch_src2_2)
  begin
    zz_execute_BranchPlugin_branch_src2_3(19) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(18) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(17) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(16) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(15) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(14) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(13) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(12) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(11) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(10) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(9) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(8) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(7) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(6) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(5) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(4) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(3) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(2) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(1) <= zz_execute_BranchPlugin_branch_src2_2;
    zz_execute_BranchPlugin_branch_src2_3(0) <= zz_execute_BranchPlugin_branch_src2_2;
  end process;

  zz_execute_BranchPlugin_branch_src2_4 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,7))),pkg_extract(execute_INSTRUCTION,30,25)),pkg_extract(execute_INSTRUCTION,11,8)),11);
  process(zz_execute_BranchPlugin_branch_src2_4)
  begin
    zz_execute_BranchPlugin_branch_src2_5(18) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(17) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(16) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(15) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(14) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(13) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(12) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(11) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(10) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(9) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(8) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(7) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(6) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(5) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(4) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(3) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(2) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(1) <= zz_execute_BranchPlugin_branch_src2_4;
    zz_execute_BranchPlugin_branch_src2_5(0) <= zz_execute_BranchPlugin_branch_src2_4;
  end process;

  process(execute_BRANCH_CTRL,zz_execute_BranchPlugin_branch_src2_1,execute_INSTRUCTION,zz_execute_BranchPlugin_branch_src2_3,zz_execute_BranchPlugin_branch_src2_5)
  begin
    case execute_BRANCH_CTRL is
      when BranchCtrlEnum_seq_JAL =>
        zz_execute_BranchPlugin_branch_src2_6 <= pkg_cat(pkg_cat(zz_execute_BranchPlugin_branch_src2_1,pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_extract(execute_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,20))),pkg_extract(execute_INSTRUCTION,30,21))),pkg_toStdLogicVector(pkg_toStdLogic(false)));
      when BranchCtrlEnum_seq_JALR =>
        zz_execute_BranchPlugin_branch_src2_6 <= pkg_cat(zz_execute_BranchPlugin_branch_src2_3,pkg_extract(execute_INSTRUCTION,31,20));
      when others =>
        zz_execute_BranchPlugin_branch_src2_6 <= pkg_cat(pkg_cat(zz_execute_BranchPlugin_branch_src2_5,pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,7))),pkg_extract(execute_INSTRUCTION,30,25)),pkg_extract(execute_INSTRUCTION,11,8))),pkg_toStdLogicVector(pkg_toStdLogic(false)));
    end case;
  end process;

  execute_BranchPlugin_branch_src2 <= unsigned(zz_execute_BranchPlugin_branch_src2_6);
  execute_BranchPlugin_branchAdder <= (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  BranchPlugin_jumpInterface_valid <= ((memory_arbitration_isValid and memory_BRANCH_DO) and (not pkg_toStdLogic(false)));
  BranchPlugin_jumpInterface_payload <= memory_BRANCH_CALC;
  when_DebugPlugin_l225 <= (DebugPlugin_haltIt and (not DebugPlugin_isPipBusy));
  DebugPlugin_allowEBreak <= (DebugPlugin_debugUsed and (not DebugPlugin_disableEbreak));
  process(debug_bus_cmd_valid,switch_DebugPlugin_l267,debug_bus_cmd_payload_wr,IBusSimplePlugin_injectionPort_ready)
  begin
    debug_bus_cmd_ready_read_buffer <= pkg_toStdLogic(true);
    if debug_bus_cmd_valid = '1' then
      case switch_DebugPlugin_l267 is
        when "000001" =>
          if debug_bus_cmd_payload_wr = '1' then
            debug_bus_cmd_ready_read_buffer <= IBusSimplePlugin_injectionPort_ready;
          end if;
        when others =>
      end case;
    end if;
  end process;

  process(DebugPlugin_busReadDataReg,when_DebugPlugin_l244,DebugPlugin_resetIt,DebugPlugin_haltIt,DebugPlugin_isPipBusy,DebugPlugin_haltedByBreak,DebugPlugin_stepIt)
  begin
    debug_bus_rsp_data <= DebugPlugin_busReadDataReg;
    if when_DebugPlugin_l244 = '1' then
      debug_bus_rsp_data(0) <= DebugPlugin_resetIt;
      debug_bus_rsp_data(1) <= DebugPlugin_haltIt;
      debug_bus_rsp_data(2) <= DebugPlugin_isPipBusy;
      debug_bus_rsp_data(3) <= DebugPlugin_haltedByBreak;
      debug_bus_rsp_data(4) <= DebugPlugin_stepIt;
    end if;
  end process;

  when_DebugPlugin_l244 <= (not zz_when_DebugPlugin_l244);
  process(debug_bus_cmd_valid,switch_DebugPlugin_l267,debug_bus_cmd_payload_wr)
  begin
    IBusSimplePlugin_injectionPort_valid <= pkg_toStdLogic(false);
    if debug_bus_cmd_valid = '1' then
      case switch_DebugPlugin_l267 is
        when "000001" =>
          if debug_bus_cmd_payload_wr = '1' then
            IBusSimplePlugin_injectionPort_valid <= pkg_toStdLogic(true);
          end if;
        when others =>
      end case;
    end if;
  end process;

  IBusSimplePlugin_injectionPort_payload <= debug_bus_cmd_payload_data;
  switch_DebugPlugin_l267 <= pkg_extract(debug_bus_cmd_payload_address,7,2);
  when_DebugPlugin_l271 <= pkg_extract(debug_bus_cmd_payload_data,16);
  when_DebugPlugin_l271_1 <= pkg_extract(debug_bus_cmd_payload_data,24);
  when_DebugPlugin_l272 <= pkg_extract(debug_bus_cmd_payload_data,17);
  when_DebugPlugin_l272_1 <= pkg_extract(debug_bus_cmd_payload_data,25);
  when_DebugPlugin_l273 <= pkg_extract(debug_bus_cmd_payload_data,25);
  when_DebugPlugin_l274 <= pkg_extract(debug_bus_cmd_payload_data,25);
  when_DebugPlugin_l275 <= pkg_extract(debug_bus_cmd_payload_data,18);
  when_DebugPlugin_l275_1 <= pkg_extract(debug_bus_cmd_payload_data,26);
  when_DebugPlugin_l295 <= (execute_arbitration_isValid and execute_DO_EBREAK);
  when_DebugPlugin_l298 <= pkg_toStdLogic(pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_isValid),pkg_toStdLogicVector(memory_arbitration_isValid)) /= pkg_stdLogicVector("00")) = pkg_toStdLogic(false));
  when_DebugPlugin_l311 <= (DebugPlugin_stepIt and IBusSimplePlugin_incomingInstruction);
  debug_resetOut <= DebugPlugin_resetIt_regNext;
  when_DebugPlugin_l331 <= (DebugPlugin_haltIt or DebugPlugin_stepIt);
  when_Pipeline_l124 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_1 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_2 <= (not writeBack_arbitration_isStuck);
  when_Pipeline_l124_3 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_4 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_5 <= (not writeBack_arbitration_isStuck);
  when_Pipeline_l124_6 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_7 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_8 <= (not writeBack_arbitration_isStuck);
  when_Pipeline_l124_9 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_10 <= (not execute_arbitration_isStuck);
  zz_decode_SRC1_CTRL <= zz_decode_SRC1_CTRL_1;
  when_Pipeline_l124_11 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_12 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_13 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_14 <= (not writeBack_arbitration_isStuck);
  zz_decode_SRC2_CTRL <= zz_decode_SRC2_CTRL_1;
  when_Pipeline_l124_15 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_16 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_17 <= (not writeBack_arbitration_isStuck);
  when_Pipeline_l124_18 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_19 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_20 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_21 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_22 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_23 <= (not execute_arbitration_isStuck);
  zz_decode_to_execute_ENV_CTRL_1 <= decode_ENV_CTRL;
  zz_execute_to_memory_ENV_CTRL_1 <= execute_ENV_CTRL;
  zz_memory_to_writeBack_ENV_CTRL_1 <= memory_ENV_CTRL;
  zz_decode_ENV_CTRL <= zz_decode_ENV_CTRL_1;
  when_Pipeline_l124_24 <= (not execute_arbitration_isStuck);
  zz_execute_ENV_CTRL <= decode_to_execute_ENV_CTRL;
  when_Pipeline_l124_25 <= (not memory_arbitration_isStuck);
  zz_memory_ENV_CTRL <= execute_to_memory_ENV_CTRL;
  when_Pipeline_l124_26 <= (not writeBack_arbitration_isStuck);
  zz_writeBack_ENV_CTRL <= memory_to_writeBack_ENV_CTRL;
  zz_decode_to_execute_ALU_CTRL_1 <= decode_ALU_CTRL;
  zz_decode_ALU_CTRL <= zz_decode_ALU_CTRL_1;
  when_Pipeline_l124_27 <= (not execute_arbitration_isStuck);
  zz_execute_ALU_CTRL <= decode_to_execute_ALU_CTRL;
  when_Pipeline_l124_28 <= (not execute_arbitration_isStuck);
  zz_decode_to_execute_ALU_BITWISE_CTRL_1 <= decode_ALU_BITWISE_CTRL;
  zz_decode_ALU_BITWISE_CTRL <= zz_decode_ALU_BITWISE_CTRL_1;
  when_Pipeline_l124_29 <= (not execute_arbitration_isStuck);
  zz_execute_ALU_BITWISE_CTRL <= decode_to_execute_ALU_BITWISE_CTRL;
  zz_decode_to_execute_SHIFT_CTRL_1 <= decode_SHIFT_CTRL;
  zz_decode_SHIFT_CTRL <= zz_decode_SHIFT_CTRL_1;
  when_Pipeline_l124_30 <= (not execute_arbitration_isStuck);
  zz_execute_SHIFT_CTRL <= decode_to_execute_SHIFT_CTRL;
  zz_decode_to_execute_BRANCH_CTRL_1 <= decode_BRANCH_CTRL;
  zz_decode_BRANCH_CTRL <= zz_decode_BRANCH_CTRL_1;
  when_Pipeline_l124_31 <= (not execute_arbitration_isStuck);
  zz_execute_BRANCH_CTRL <= decode_to_execute_BRANCH_CTRL;
  when_Pipeline_l124_32 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_33 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_34 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_35 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_36 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_37 <= (not execute_arbitration_isStuck);
  when_Pipeline_l124_38 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_39 <= (not writeBack_arbitration_isStuck);
  when_Pipeline_l124_40 <= ((not memory_arbitration_isStuck) and (not execute_arbitration_isStuckByOthers));
  when_Pipeline_l124_41 <= (not writeBack_arbitration_isStuck);
  when_Pipeline_l124_42 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_43 <= (not memory_arbitration_isStuck);
  when_Pipeline_l124_44 <= (not writeBack_arbitration_isStuck);
  decode_arbitration_isFlushed <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushNext),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushNext),pkg_toStdLogicVector(execute_arbitration_flushNext))) /= pkg_stdLogicVector("000")) or pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushIt),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushIt),pkg_cat(pkg_toStdLogicVector(execute_arbitration_flushIt),pkg_toStdLogicVector(decode_arbitration_flushIt)))) /= pkg_stdLogicVector("0000")));
  execute_arbitration_isFlushed <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushNext),pkg_toStdLogicVector(memory_arbitration_flushNext)) /= pkg_stdLogicVector("00")) or pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushIt),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushIt),pkg_toStdLogicVector(execute_arbitration_flushIt))) /= pkg_stdLogicVector("000")));
  memory_arbitration_isFlushed <= (pkg_toStdLogic(pkg_toStdLogicVector(writeBack_arbitration_flushNext) /= pkg_stdLogicVector("0")) or pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushIt),pkg_toStdLogicVector(memory_arbitration_flushIt)) /= pkg_stdLogicVector("00")));
  writeBack_arbitration_isFlushed <= (pkg_toStdLogic(false) or pkg_toStdLogic(pkg_toStdLogicVector(writeBack_arbitration_flushIt) /= pkg_stdLogicVector("0")));
  decode_arbitration_isStuckByOthers <= (decode_arbitration_haltByOther or (((pkg_toStdLogic(false) or execute_arbitration_isStuck) or memory_arbitration_isStuck) or writeBack_arbitration_isStuck));
  decode_arbitration_isStuck <= (decode_arbitration_haltItself or decode_arbitration_isStuckByOthers);
  decode_arbitration_isMoving <= ((not decode_arbitration_isStuck) and (not decode_arbitration_removeIt));
  decode_arbitration_isFiring <= ((decode_arbitration_isValid and (not decode_arbitration_isStuck)) and (not decode_arbitration_removeIt));
  execute_arbitration_isStuckByOthers <= (execute_arbitration_haltByOther or ((pkg_toStdLogic(false) or memory_arbitration_isStuck) or writeBack_arbitration_isStuck));
  execute_arbitration_isStuck <= (execute_arbitration_haltItself or execute_arbitration_isStuckByOthers);
  execute_arbitration_isMoving <= ((not execute_arbitration_isStuck) and (not execute_arbitration_removeIt));
  execute_arbitration_isFiring <= ((execute_arbitration_isValid and (not execute_arbitration_isStuck)) and (not execute_arbitration_removeIt));
  memory_arbitration_isStuckByOthers <= (memory_arbitration_haltByOther or (pkg_toStdLogic(false) or writeBack_arbitration_isStuck));
  memory_arbitration_isStuck <= (memory_arbitration_haltItself or memory_arbitration_isStuckByOthers);
  memory_arbitration_isMoving <= ((not memory_arbitration_isStuck) and (not memory_arbitration_removeIt));
  memory_arbitration_isFiring <= ((memory_arbitration_isValid and (not memory_arbitration_isStuck)) and (not memory_arbitration_removeIt));
  writeBack_arbitration_isStuckByOthers <= (writeBack_arbitration_haltByOther or pkg_toStdLogic(false));
  writeBack_arbitration_isStuck <= (writeBack_arbitration_haltItself or writeBack_arbitration_isStuckByOthers);
  writeBack_arbitration_isMoving <= ((not writeBack_arbitration_isStuck) and (not writeBack_arbitration_removeIt));
  writeBack_arbitration_isFiring <= ((writeBack_arbitration_isValid and (not writeBack_arbitration_isStuck)) and (not writeBack_arbitration_removeIt));
  when_Pipeline_l151 <= ((not execute_arbitration_isStuck) or execute_arbitration_removeIt);
  when_Pipeline_l154 <= ((not decode_arbitration_isStuck) and (not decode_arbitration_removeIt));
  when_Pipeline_l151_1 <= ((not memory_arbitration_isStuck) or memory_arbitration_removeIt);
  when_Pipeline_l154_1 <= ((not execute_arbitration_isStuck) and (not execute_arbitration_removeIt));
  when_Pipeline_l151_2 <= ((not writeBack_arbitration_isStuck) or writeBack_arbitration_removeIt);
  when_Pipeline_l154_2 <= ((not memory_arbitration_isStuck) and (not memory_arbitration_removeIt));
  process(switch_Fetcher_l365)
  begin
    IBusSimplePlugin_injectionPort_ready <= pkg_toStdLogic(false);
    case switch_Fetcher_l365 is
      when "100" =>
        IBusSimplePlugin_injectionPort_ready <= pkg_toStdLogic(true);
      when others =>
    end case;
  end process;

  when_Fetcher_l381 <= (not decode_arbitration_isStuck);
  when_Fetcher_l401 <= pkg_toStdLogic(switch_Fetcher_l365 /= pkg_unsigned("000"));
  when_CsrPlugin_l1277 <= (not execute_arbitration_isStuck);
  when_CsrPlugin_l1277_1 <= (not execute_arbitration_isStuck);
  when_CsrPlugin_l1277_2 <= (not execute_arbitration_isStuck);
  when_CsrPlugin_l1277_3 <= (not execute_arbitration_isStuck);
  switch_CsrPlugin_l723 <= pkg_extract(CsrPlugin_csrMapping_writeDataSignal,12,11);
  process(execute_CsrPlugin_csr_768,CsrPlugin_mstatus_MPIE,CsrPlugin_mstatus_MIE,CsrPlugin_mstatus_MPP)
  begin
    zz_CsrPlugin_csrMapping_readDataInit <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_768 = '1' then
      zz_CsrPlugin_csrMapping_readDataInit(7 downto 7) <= pkg_toStdLogicVector(CsrPlugin_mstatus_MPIE);
      zz_CsrPlugin_csrMapping_readDataInit(3 downto 3) <= pkg_toStdLogicVector(CsrPlugin_mstatus_MIE);
      zz_CsrPlugin_csrMapping_readDataInit(12 downto 11) <= std_logic_vector(CsrPlugin_mstatus_MPP);
    end if;
  end process;

  process(execute_CsrPlugin_csr_836,CsrPlugin_mip_MEIP,CsrPlugin_mip_MTIP,CsrPlugin_mip_MSIP)
  begin
    zz_CsrPlugin_csrMapping_readDataInit_1 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_836 = '1' then
      zz_CsrPlugin_csrMapping_readDataInit_1(11 downto 11) <= pkg_toStdLogicVector(CsrPlugin_mip_MEIP);
      zz_CsrPlugin_csrMapping_readDataInit_1(7 downto 7) <= pkg_toStdLogicVector(CsrPlugin_mip_MTIP);
      zz_CsrPlugin_csrMapping_readDataInit_1(3 downto 3) <= pkg_toStdLogicVector(CsrPlugin_mip_MSIP);
    end if;
  end process;

  process(execute_CsrPlugin_csr_772,CsrPlugin_mie_MEIE,CsrPlugin_mie_MTIE,CsrPlugin_mie_MSIE)
  begin
    zz_CsrPlugin_csrMapping_readDataInit_2 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_772 = '1' then
      zz_CsrPlugin_csrMapping_readDataInit_2(11 downto 11) <= pkg_toStdLogicVector(CsrPlugin_mie_MEIE);
      zz_CsrPlugin_csrMapping_readDataInit_2(7 downto 7) <= pkg_toStdLogicVector(CsrPlugin_mie_MTIE);
      zz_CsrPlugin_csrMapping_readDataInit_2(3 downto 3) <= pkg_toStdLogicVector(CsrPlugin_mie_MSIE);
    end if;
  end process;

  process(execute_CsrPlugin_csr_834,CsrPlugin_mcause_interrupt,CsrPlugin_mcause_exceptionCode)
  begin
    zz_CsrPlugin_csrMapping_readDataInit_3 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_834 = '1' then
      zz_CsrPlugin_csrMapping_readDataInit_3(31 downto 31) <= pkg_toStdLogicVector(CsrPlugin_mcause_interrupt);
      zz_CsrPlugin_csrMapping_readDataInit_3(3 downto 0) <= std_logic_vector(CsrPlugin_mcause_exceptionCode);
    end if;
  end process;

  CsrPlugin_csrMapping_readDataInit <= ((zz_CsrPlugin_csrMapping_readDataInit or zz_CsrPlugin_csrMapping_readDataInit_1) or (zz_CsrPlugin_csrMapping_readDataInit_2 or zz_CsrPlugin_csrMapping_readDataInit_3));
  when_CsrPlugin_l1310 <= pkg_toStdLogic(CsrPlugin_privilege < unsigned(pkg_extract(execute_CsrPlugin_csrAddress,9,8)));
  when_CsrPlugin_l1315 <= ((not execute_arbitration_isValid) or (not execute_IS_CSR));
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      IBusSimplePlugin_fetchPc_pcReg <= pkg_unsigned("10000000000000000000000000000000");
      IBusSimplePlugin_fetchPc_correctionReg <= pkg_toStdLogic(false);
      IBusSimplePlugin_fetchPc_booted <= pkg_toStdLogic(false);
      IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(false);
      zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready_2 <= pkg_toStdLogic(false);
      zz_IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_valid <= pkg_toStdLogic(false);
      zz_IBusSimplePlugin_injector_decodeInput_valid <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_0 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_1 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_2 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_3 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_4 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_5 <= pkg_toStdLogic(false);
      IBusSimplePlugin_pending_value <= pkg_unsigned("000");
      IBusSimplePlugin_rspJoin_rspBuffer_discardCounter <= pkg_unsigned("000");
      CsrPlugin_mstatus_MIE <= pkg_toStdLogic(false);
      CsrPlugin_mstatus_MPIE <= pkg_toStdLogic(false);
      CsrPlugin_mstatus_MPP <= pkg_unsigned("11");
      CsrPlugin_mie_MEIE <= pkg_toStdLogic(false);
      CsrPlugin_mie_MTIE <= pkg_toStdLogic(false);
      CsrPlugin_mie_MSIE <= pkg_toStdLogic(false);
      CsrPlugin_mcycle <= pkg_unsigned("0000000000000000000000000000000000000000000000000000000000000000");
      CsrPlugin_minstret <= pkg_unsigned("0000000000000000000000000000000000000000000000000000000000000000");
      CsrPlugin_interrupt_valid <= pkg_toStdLogic(false);
      CsrPlugin_pipelineLiberator_pcValids_0 <= pkg_toStdLogic(false);
      CsrPlugin_pipelineLiberator_pcValids_1 <= pkg_toStdLogic(false);
      CsrPlugin_pipelineLiberator_pcValids_2 <= pkg_toStdLogic(false);
      CsrPlugin_hadException <= pkg_toStdLogic(false);
      execute_CsrPlugin_wfiWake <= pkg_toStdLogic(false);
      zz_2 <= pkg_toStdLogic(true);
      execute_LightShifterPlugin_isActive <= pkg_toStdLogic(false);
      HazardSimplePlugin_writeBackBuffer_valid <= pkg_toStdLogic(false);
      execute_arbitration_isValid <= pkg_toStdLogic(false);
      memory_arbitration_isValid <= pkg_toStdLogic(false);
      writeBack_arbitration_isValid <= pkg_toStdLogic(false);
      switch_Fetcher_l365 <= pkg_unsigned("000");
    elsif rising_edge(io_mainClk) then
      if IBusSimplePlugin_fetchPc_correction = '1' then
        IBusSimplePlugin_fetchPc_correctionReg <= pkg_toStdLogic(true);
      end if;
      if IBusSimplePlugin_fetchPc_output_fire = '1' then
        IBusSimplePlugin_fetchPc_correctionReg <= pkg_toStdLogic(false);
      end if;
      IBusSimplePlugin_fetchPc_booted <= pkg_toStdLogic(true);
      if when_Fetcher_l134 = '1' then
        IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_fetchPc_output_fire_1 = '1' then
        IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(true);
      end if;
      if when_Fetcher_l134_1 = '1' then
        IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(false);
      end if;
      if when_Fetcher_l161 = '1' then
        IBusSimplePlugin_fetchPc_pcReg <= IBusSimplePlugin_fetchPc_pc;
      end if;
      if IBusSimplePlugin_iBusRsp_flush = '1' then
        zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready_2 <= pkg_toStdLogic(false);
      end if;
      if zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready = '1' then
        zz_IBusSimplePlugin_iBusRsp_stages_0_output_ready_2 <= (IBusSimplePlugin_iBusRsp_stages_0_output_valid and (not pkg_toStdLogic(false)));
      end if;
      if IBusSimplePlugin_iBusRsp_flush = '1' then
        zz_IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_valid <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_iBusRsp_stages_1_output_ready = '1' then
        zz_IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_valid <= (IBusSimplePlugin_iBusRsp_stages_1_output_valid and (not IBusSimplePlugin_iBusRsp_flush));
      end if;
      if decode_arbitration_removeIt = '1' then
        zz_IBusSimplePlugin_injector_decodeInput_valid <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_iBusRsp_output_ready = '1' then
        zz_IBusSimplePlugin_injector_decodeInput_valid <= (IBusSimplePlugin_iBusRsp_output_valid and (not IBusSimplePlugin_externalFlush));
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= pkg_toStdLogic(false);
      end if;
      if when_Fetcher_l332 = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= pkg_toStdLogic(true);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= pkg_toStdLogic(false);
      end if;
      if when_Fetcher_l332_1 = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= IBusSimplePlugin_injector_nextPcCalc_valids_0;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= pkg_toStdLogic(false);
      end if;
      if when_Fetcher_l332_2 = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= IBusSimplePlugin_injector_nextPcCalc_valids_1;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= pkg_toStdLogic(false);
      end if;
      if when_Fetcher_l332_3 = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= IBusSimplePlugin_injector_nextPcCalc_valids_2;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= pkg_toStdLogic(false);
      end if;
      if when_Fetcher_l332_4 = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= IBusSimplePlugin_injector_nextPcCalc_valids_3;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_5 <= pkg_toStdLogic(false);
      end if;
      if when_Fetcher_l332_5 = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_5 <= IBusSimplePlugin_injector_nextPcCalc_valids_4;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_5 <= pkg_toStdLogic(false);
      end if;
      IBusSimplePlugin_pending_value <= IBusSimplePlugin_pending_next;
      IBusSimplePlugin_rspJoin_rspBuffer_discardCounter <= (IBusSimplePlugin_rspJoin_rspBuffer_discardCounter - pkg_resize(unsigned(pkg_toStdLogicVector((IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid and pkg_toStdLogic(IBusSimplePlugin_rspJoin_rspBuffer_discardCounter /= pkg_unsigned("000"))))),3));
      if IBusSimplePlugin_iBusRsp_flush = '1' then
        IBusSimplePlugin_rspJoin_rspBuffer_discardCounter <= IBusSimplePlugin_pending_next;
      end if;
      CsrPlugin_mcycle <= (CsrPlugin_mcycle + pkg_unsigned("0000000000000000000000000000000000000000000000000000000000000001"));
      if writeBack_arbitration_isFiring = '1' then
        CsrPlugin_minstret <= (CsrPlugin_minstret + pkg_unsigned("0000000000000000000000000000000000000000000000000000000000000001"));
      end if;
      CsrPlugin_interrupt_valid <= pkg_toStdLogic(false);
      if when_CsrPlugin_l959 = '1' then
        if when_CsrPlugin_l965 = '1' then
          CsrPlugin_interrupt_valid <= pkg_toStdLogic(true);
        end if;
        if when_CsrPlugin_l965_1 = '1' then
          CsrPlugin_interrupt_valid <= pkg_toStdLogic(true);
        end if;
        if when_CsrPlugin_l965_2 = '1' then
          CsrPlugin_interrupt_valid <= pkg_toStdLogic(true);
        end if;
      end if;
      if CsrPlugin_pipelineLiberator_active = '1' then
        if when_CsrPlugin_l993 = '1' then
          CsrPlugin_pipelineLiberator_pcValids_0 <= pkg_toStdLogic(true);
        end if;
        if when_CsrPlugin_l993_1 = '1' then
          CsrPlugin_pipelineLiberator_pcValids_1 <= CsrPlugin_pipelineLiberator_pcValids_0;
        end if;
        if when_CsrPlugin_l993_2 = '1' then
          CsrPlugin_pipelineLiberator_pcValids_2 <= CsrPlugin_pipelineLiberator_pcValids_1;
        end if;
      end if;
      if when_CsrPlugin_l998 = '1' then
        CsrPlugin_pipelineLiberator_pcValids_0 <= pkg_toStdLogic(false);
        CsrPlugin_pipelineLiberator_pcValids_1 <= pkg_toStdLogic(false);
        CsrPlugin_pipelineLiberator_pcValids_2 <= pkg_toStdLogic(false);
      end if;
      if CsrPlugin_interruptJump = '1' then
        CsrPlugin_interrupt_valid <= pkg_toStdLogic(false);
      end if;
      CsrPlugin_hadException <= CsrPlugin_exception;
      if when_CsrPlugin_l1032 = '1' then
        case CsrPlugin_targetPrivilege is
          when "11" =>
            CsrPlugin_mstatus_MIE <= pkg_toStdLogic(false);
            CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
            CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
          when others =>
        end case;
      end if;
      if when_CsrPlugin_l1077 = '1' then
        case switch_CsrPlugin_l1081 is
          when "11" =>
            CsrPlugin_mstatus_MPP <= pkg_unsigned("00");
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= pkg_toStdLogic(true);
          when others =>
        end case;
      end if;
      execute_CsrPlugin_wfiWake <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_when_CsrPlugin_l965_2),pkg_cat(pkg_toStdLogicVector(zz_when_CsrPlugin_l965_1),pkg_toStdLogicVector(zz_when_CsrPlugin_l965))) /= pkg_stdLogicVector("000")) or CsrPlugin_thirdPartyWake);
      zz_2 <= pkg_toStdLogic(false);
      if when_ShiftPlugins_l169 = '1' then
        if when_ShiftPlugins_l175 = '1' then
          execute_LightShifterPlugin_isActive <= pkg_toStdLogic(true);
          if execute_LightShifterPlugin_done = '1' then
            execute_LightShifterPlugin_isActive <= pkg_toStdLogic(false);
          end if;
        end if;
      end if;
      if execute_arbitration_removeIt = '1' then
        execute_LightShifterPlugin_isActive <= pkg_toStdLogic(false);
      end if;
      HazardSimplePlugin_writeBackBuffer_valid <= HazardSimplePlugin_writeBackWrites_valid;
      if when_Pipeline_l151 = '1' then
        execute_arbitration_isValid <= pkg_toStdLogic(false);
      end if;
      if when_Pipeline_l154 = '1' then
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end if;
      if when_Pipeline_l151_1 = '1' then
        memory_arbitration_isValid <= pkg_toStdLogic(false);
      end if;
      if when_Pipeline_l154_1 = '1' then
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end if;
      if when_Pipeline_l151_2 = '1' then
        writeBack_arbitration_isValid <= pkg_toStdLogic(false);
      end if;
      if when_Pipeline_l154_2 = '1' then
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end if;
      case switch_Fetcher_l365 is
        when "000" =>
          if IBusSimplePlugin_injectionPort_valid = '1' then
            switch_Fetcher_l365 <= pkg_unsigned("001");
          end if;
        when "001" =>
          switch_Fetcher_l365 <= pkg_unsigned("010");
        when "010" =>
          switch_Fetcher_l365 <= pkg_unsigned("011");
        when "011" =>
          if when_Fetcher_l381 = '1' then
            switch_Fetcher_l365 <= pkg_unsigned("100");
          end if;
        when "100" =>
          switch_Fetcher_l365 <= pkg_unsigned("000");
        when others =>
      end case;
      if execute_CsrPlugin_csr_768 = '1' then
        if execute_CsrPlugin_writeEnable = '1' then
          CsrPlugin_mstatus_MPIE <= pkg_extract(CsrPlugin_csrMapping_writeDataSignal,7);
          CsrPlugin_mstatus_MIE <= pkg_extract(CsrPlugin_csrMapping_writeDataSignal,3);
          case switch_CsrPlugin_l723 is
            when "11" =>
              CsrPlugin_mstatus_MPP <= pkg_unsigned("11");
            when others =>
          end case;
        end if;
      end if;
      if execute_CsrPlugin_csr_772 = '1' then
        if execute_CsrPlugin_writeEnable = '1' then
          CsrPlugin_mie_MEIE <= pkg_extract(CsrPlugin_csrMapping_writeDataSignal,11);
          CsrPlugin_mie_MTIE <= pkg_extract(CsrPlugin_csrMapping_writeDataSignal,7);
          CsrPlugin_mie_MSIE <= pkg_extract(CsrPlugin_csrMapping_writeDataSignal,3);
        end if;
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if IBusSimplePlugin_iBusRsp_stages_1_output_ready = '1' then
        zz_IBusSimplePlugin_iBusRsp_stages_1_output_m2sPipe_payload <= IBusSimplePlugin_iBusRsp_stages_1_output_payload;
      end if;
      if IBusSimplePlugin_iBusRsp_output_ready = '1' then
        zz_IBusSimplePlugin_injector_decodeInput_payload_pc <= IBusSimplePlugin_iBusRsp_output_payload_pc;
        zz_IBusSimplePlugin_injector_decodeInput_payload_rsp_error <= IBusSimplePlugin_iBusRsp_output_payload_rsp_error;
        zz_IBusSimplePlugin_injector_decodeInput_payload_rsp_inst <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
        zz_IBusSimplePlugin_injector_decodeInput_payload_isRvc <= IBusSimplePlugin_iBusRsp_output_payload_isRvc;
      end if;
      if IBusSimplePlugin_injector_decodeInput_ready = '1' then
        IBusSimplePlugin_injector_formal_rawInDecode <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
      end if;
      CsrPlugin_mip_MEIP <= externalInterrupt;
      CsrPlugin_mip_MTIP <= timerInterrupt;
      CsrPlugin_mip_MSIP <= softwareInterrupt;
      if when_CsrPlugin_l959 = '1' then
        if when_CsrPlugin_l965 = '1' then
          CsrPlugin_interrupt_code <= pkg_unsigned("0111");
          CsrPlugin_interrupt_targetPrivilege <= pkg_unsigned("11");
        end if;
        if when_CsrPlugin_l965_1 = '1' then
          CsrPlugin_interrupt_code <= pkg_unsigned("0011");
          CsrPlugin_interrupt_targetPrivilege <= pkg_unsigned("11");
        end if;
        if when_CsrPlugin_l965_2 = '1' then
          CsrPlugin_interrupt_code <= pkg_unsigned("1011");
          CsrPlugin_interrupt_targetPrivilege <= pkg_unsigned("11");
        end if;
      end if;
      if when_CsrPlugin_l1032 = '1' then
        case CsrPlugin_targetPrivilege is
          when "11" =>
            CsrPlugin_mcause_interrupt <= (not CsrPlugin_hadException);
            CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
            CsrPlugin_mepc <= decode_PC;
          when others =>
        end case;
      end if;
      if when_ShiftPlugins_l169 = '1' then
        if when_ShiftPlugins_l175 = '1' then
          execute_LightShifterPlugin_amplitudeReg <= (execute_LightShifterPlugin_amplitude - pkg_unsigned("00001"));
        end if;
      end if;
      HazardSimplePlugin_writeBackBuffer_payload_address <= HazardSimplePlugin_writeBackWrites_payload_address;
      HazardSimplePlugin_writeBackBuffer_payload_data <= HazardSimplePlugin_writeBackWrites_payload_data;
      if when_Pipeline_l124 = '1' then
        decode_to_execute_PC <= zz_decode_SRC2;
      end if;
      if when_Pipeline_l124_1 = '1' then
        execute_to_memory_PC <= execute_PC;
      end if;
      if when_Pipeline_l124_2 = '1' then
        memory_to_writeBack_PC <= memory_PC;
      end if;
      if when_Pipeline_l124_3 = '1' then
        decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
      end if;
      if when_Pipeline_l124_4 = '1' then
        execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
      end if;
      if when_Pipeline_l124_5 = '1' then
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end if;
      if when_Pipeline_l124_6 = '1' then
        decode_to_execute_FORMAL_PC_NEXT <= decode_FORMAL_PC_NEXT;
      end if;
      if when_Pipeline_l124_7 = '1' then
        execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
      end if;
      if when_Pipeline_l124_8 = '1' then
        memory_to_writeBack_FORMAL_PC_NEXT <= zz_memory_to_writeBack_FORMAL_PC_NEXT;
      end if;
      if when_Pipeline_l124_9 = '1' then
        decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
      end if;
      if when_Pipeline_l124_10 = '1' then
        decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
      end if;
      if when_Pipeline_l124_11 = '1' then
        decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
      end if;
      if when_Pipeline_l124_12 = '1' then
        decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
      end if;
      if when_Pipeline_l124_13 = '1' then
        execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
      end if;
      if when_Pipeline_l124_14 = '1' then
        memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
      end if;
      if when_Pipeline_l124_15 = '1' then
        decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
      end if;
      if when_Pipeline_l124_16 = '1' then
        execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
      end if;
      if when_Pipeline_l124_17 = '1' then
        memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
      end if;
      if when_Pipeline_l124_18 = '1' then
        decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
      end if;
      if when_Pipeline_l124_19 = '1' then
        decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
      end if;
      if when_Pipeline_l124_20 = '1' then
        execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
      end if;
      if when_Pipeline_l124_21 = '1' then
        decode_to_execute_MEMORY_STORE <= decode_MEMORY_STORE;
      end if;
      if when_Pipeline_l124_22 = '1' then
        execute_to_memory_MEMORY_STORE <= execute_MEMORY_STORE;
      end if;
      if when_Pipeline_l124_23 = '1' then
        decode_to_execute_IS_CSR <= decode_IS_CSR;
      end if;
      if when_Pipeline_l124_24 = '1' then
        decode_to_execute_ENV_CTRL <= zz_decode_to_execute_ENV_CTRL;
      end if;
      if when_Pipeline_l124_25 = '1' then
        execute_to_memory_ENV_CTRL <= zz_execute_to_memory_ENV_CTRL;
      end if;
      if when_Pipeline_l124_26 = '1' then
        memory_to_writeBack_ENV_CTRL <= zz_memory_to_writeBack_ENV_CTRL;
      end if;
      if when_Pipeline_l124_27 = '1' then
        decode_to_execute_ALU_CTRL <= zz_decode_to_execute_ALU_CTRL;
      end if;
      if when_Pipeline_l124_28 = '1' then
        decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
      end if;
      if when_Pipeline_l124_29 = '1' then
        decode_to_execute_ALU_BITWISE_CTRL <= zz_decode_to_execute_ALU_BITWISE_CTRL;
      end if;
      if when_Pipeline_l124_30 = '1' then
        decode_to_execute_SHIFT_CTRL <= zz_decode_to_execute_SHIFT_CTRL;
      end if;
      if when_Pipeline_l124_31 = '1' then
        decode_to_execute_BRANCH_CTRL <= zz_decode_to_execute_BRANCH_CTRL;
      end if;
      if when_Pipeline_l124_32 = '1' then
        decode_to_execute_RS1 <= zz_decode_SRC1;
      end if;
      if when_Pipeline_l124_33 = '1' then
        decode_to_execute_RS2 <= zz_decode_SRC2_1;
      end if;
      if when_Pipeline_l124_34 = '1' then
        decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
      end if;
      if when_Pipeline_l124_35 = '1' then
        decode_to_execute_SRC1 <= decode_SRC1;
      end if;
      if when_Pipeline_l124_36 = '1' then
        decode_to_execute_SRC2 <= decode_SRC2;
      end if;
      if when_Pipeline_l124_37 = '1' then
        decode_to_execute_DO_EBREAK <= decode_DO_EBREAK;
      end if;
      if when_Pipeline_l124_38 = '1' then
        execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
      end if;
      if when_Pipeline_l124_39 = '1' then
        memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
      end if;
      if when_Pipeline_l124_40 = '1' then
        execute_to_memory_REGFILE_WRITE_DATA <= zz_execute_to_memory_REGFILE_WRITE_DATA;
      end if;
      if when_Pipeline_l124_41 = '1' then
        memory_to_writeBack_REGFILE_WRITE_DATA <= memory_REGFILE_WRITE_DATA;
      end if;
      if when_Pipeline_l124_42 = '1' then
        execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
      end if;
      if when_Pipeline_l124_43 = '1' then
        execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
      end if;
      if when_Pipeline_l124_44 = '1' then
        memory_to_writeBack_MEMORY_READ_DATA <= memory_MEMORY_READ_DATA;
      end if;
      if when_Fetcher_l401 = '1' then
        zz_IBusSimplePlugin_injector_decodeInput_payload_rsp_inst <= IBusSimplePlugin_injectionPort_payload;
      end if;
      if when_CsrPlugin_l1277 = '1' then
        execute_CsrPlugin_csr_768 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001100000000"));
      end if;
      if when_CsrPlugin_l1277_1 = '1' then
        execute_CsrPlugin_csr_836 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001101000100"));
      end if;
      if when_CsrPlugin_l1277_2 = '1' then
        execute_CsrPlugin_csr_772 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001100000100"));
      end if;
      if when_CsrPlugin_l1277_3 = '1' then
        execute_CsrPlugin_csr_834 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001101000010"));
      end if;
      if execute_CsrPlugin_csr_836 = '1' then
        if execute_CsrPlugin_writeEnable = '1' then
          CsrPlugin_mip_MSIP <= pkg_extract(CsrPlugin_csrMapping_writeDataSignal,3);
        end if;
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      DebugPlugin_firstCycle <= pkg_toStdLogic(false);
      if debug_bus_cmd_ready_read_buffer = '1' then
        DebugPlugin_firstCycle <= pkg_toStdLogic(true);
      end if;
      DebugPlugin_secondCycle <= DebugPlugin_firstCycle;
      DebugPlugin_isPipBusy <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_isValid),pkg_cat(pkg_toStdLogicVector(memory_arbitration_isValid),pkg_cat(pkg_toStdLogicVector(execute_arbitration_isValid),pkg_toStdLogicVector(decode_arbitration_isValid)))) /= pkg_stdLogicVector("0000")) or IBusSimplePlugin_incomingInstruction);
      if writeBack_arbitration_isValid = '1' then
        DebugPlugin_busReadDataReg <= zz_lastStageRegFileWrite_payload_data;
      end if;
      zz_when_DebugPlugin_l244 <= pkg_extract(debug_bus_cmd_payload_address,2);
      if when_DebugPlugin_l295 = '1' then
        DebugPlugin_busReadDataReg <= std_logic_vector(execute_PC);
      end if;
      DebugPlugin_resetIt_regNext <= DebugPlugin_resetIt;
    end if;
  end process;

  process(io_mainClk, resetCtrl_mainClkReset)
  begin
    if resetCtrl_mainClkReset = '1' then
      DebugPlugin_resetIt <= pkg_toStdLogic(false);
      DebugPlugin_haltIt <= pkg_toStdLogic(false);
      DebugPlugin_stepIt <= pkg_toStdLogic(false);
      DebugPlugin_godmode <= pkg_toStdLogic(false);
      DebugPlugin_haltedByBreak <= pkg_toStdLogic(false);
      DebugPlugin_debugUsed <= pkg_toStdLogic(false);
      DebugPlugin_disableEbreak <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      if when_DebugPlugin_l225 = '1' then
        DebugPlugin_godmode <= pkg_toStdLogic(true);
      end if;
      if debug_bus_cmd_valid = '1' then
        DebugPlugin_debugUsed <= pkg_toStdLogic(true);
      end if;
      if debug_bus_cmd_valid = '1' then
        case switch_DebugPlugin_l267 is
          when "000000" =>
            if debug_bus_cmd_payload_wr = '1' then
              DebugPlugin_stepIt <= pkg_extract(debug_bus_cmd_payload_data,4);
              if when_DebugPlugin_l271 = '1' then
                DebugPlugin_resetIt <= pkg_toStdLogic(true);
              end if;
              if when_DebugPlugin_l271_1 = '1' then
                DebugPlugin_resetIt <= pkg_toStdLogic(false);
              end if;
              if when_DebugPlugin_l272 = '1' then
                DebugPlugin_haltIt <= pkg_toStdLogic(true);
              end if;
              if when_DebugPlugin_l272_1 = '1' then
                DebugPlugin_haltIt <= pkg_toStdLogic(false);
              end if;
              if when_DebugPlugin_l273 = '1' then
                DebugPlugin_haltedByBreak <= pkg_toStdLogic(false);
              end if;
              if when_DebugPlugin_l274 = '1' then
                DebugPlugin_godmode <= pkg_toStdLogic(false);
              end if;
              if when_DebugPlugin_l275 = '1' then
                DebugPlugin_disableEbreak <= pkg_toStdLogic(true);
              end if;
              if when_DebugPlugin_l275_1 = '1' then
                DebugPlugin_disableEbreak <= pkg_toStdLogic(false);
              end if;
            end if;
          when others =>
        end case;
      end if;
      if when_DebugPlugin_l295 = '1' then
        if when_DebugPlugin_l298 = '1' then
          DebugPlugin_haltIt <= pkg_toStdLogic(true);
          DebugPlugin_haltedByBreak <= pkg_toStdLogic(true);
        end if;
      end if;
      if when_DebugPlugin_l311 = '1' then
        if decode_arbitration_isValid = '1' then
          DebugPlugin_haltIt <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity JtagBridge is
  port(
    io_jtag_tms : in std_logic;
    io_jtag_tdi : in std_logic;
    io_jtag_tdo : out std_logic;
    io_jtag_tck : in std_logic;
    io_remote_cmd_valid : out std_logic;
    io_remote_cmd_ready : in std_logic;
    io_remote_cmd_payload_last : out std_logic;
    io_remote_cmd_payload_fragment : out std_logic_vector(0 downto 0);
    io_remote_rsp_valid : in std_logic;
    io_remote_rsp_ready : out std_logic;
    io_remote_rsp_payload_error : in std_logic;
    io_remote_rsp_payload_data : in std_logic_vector(31 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_mainClkReset : in std_logic
  );
end JtagBridge;

architecture arch of JtagBridge is
  signal io_remote_cmd_valid_read_buffer : std_logic;
  signal io_remote_rsp_ready_read_buffer : std_logic;
  signal flowCCByToggle_1_io_output_valid : std_logic;
  signal flowCCByToggle_1_io_output_payload_last : std_logic;
  signal flowCCByToggle_1_io_output_payload_fragment : std_logic_vector(0 downto 0);
  attribute async_reg : string;

  signal system_cmd_valid : std_logic;
  signal system_cmd_payload_last : std_logic;
  signal system_cmd_payload_fragment : std_logic_vector(0 downto 0);
  signal system_cmd_toStream_valid : std_logic;
  signal system_cmd_toStream_ready : std_logic;
  signal system_cmd_toStream_payload_last : std_logic;
  signal system_cmd_toStream_payload_fragment : std_logic_vector(0 downto 0);
  signal system_rsp_valid : std_logic;
  attribute async_reg of system_rsp_valid : signal is "true";
  signal system_rsp_payload_error : std_logic;
  attribute async_reg of system_rsp_payload_error : signal is "true";
  signal system_rsp_payload_data : std_logic_vector(31 downto 0);
  attribute async_reg of system_rsp_payload_data : signal is "true";
  signal io_remote_rsp_fire : std_logic;
  signal jtag_tap_fsm_stateNext : JtagState;
  signal jtag_tap_fsm_state : JtagState := pkg_enum.RESET;
  signal zz_jtag_tap_fsm_stateNext : JtagState;
  signal zz_jtag_tap_fsm_stateNext_1 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_2 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_3 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_4 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_5 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_6 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_7 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_8 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_9 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_10 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_11 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_12 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_13 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_14 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_15 : JtagState;
  signal zz_jtag_tap_fsm_stateNext_16 : JtagState;
  signal jtag_tap_instruction : std_logic_vector(3 downto 0);
  signal jtag_tap_instructionShift : std_logic_vector(3 downto 0);
  signal jtag_tap_bypass : std_logic;
  signal jtag_tap_tdoUnbufferd : std_logic;
  signal jtag_tap_tdoDr : std_logic;
  signal jtag_tap_tdoIr : std_logic;
  signal jtag_tap_isBypass : std_logic;
  signal jtag_tap_tdoUnbufferd_regNext : std_logic;
  signal jtag_idcodeArea_ctrl_tdi : std_logic;
  signal jtag_idcodeArea_ctrl_enable : std_logic;
  signal jtag_idcodeArea_ctrl_capture : std_logic;
  signal jtag_idcodeArea_ctrl_shift : std_logic;
  signal jtag_idcodeArea_ctrl_update : std_logic;
  signal jtag_idcodeArea_ctrl_reset : std_logic;
  signal jtag_idcodeArea_ctrl_tdo : std_logic;
  signal jtag_idcodeArea_shifter : std_logic_vector(31 downto 0);
  signal when_JtagTap_l120 : std_logic;
  signal jtag_writeArea_ctrl_tdi : std_logic;
  signal jtag_writeArea_ctrl_enable : std_logic;
  signal jtag_writeArea_ctrl_capture : std_logic;
  signal jtag_writeArea_ctrl_shift : std_logic;
  signal jtag_writeArea_ctrl_update : std_logic;
  signal jtag_writeArea_ctrl_reset : std_logic;
  signal jtag_writeArea_ctrl_tdo : std_logic;
  signal jtag_writeArea_source_valid : std_logic;
  signal jtag_writeArea_source_payload_last : std_logic;
  signal jtag_writeArea_source_payload_fragment : std_logic_vector(0 downto 0);
  signal jtag_writeArea_valid : std_logic;
  signal jtag_writeArea_data : std_logic;
  signal jtag_readArea_ctrl_tdi : std_logic;
  signal jtag_readArea_ctrl_enable : std_logic;
  signal jtag_readArea_ctrl_capture : std_logic;
  signal jtag_readArea_ctrl_shift : std_logic;
  signal jtag_readArea_ctrl_update : std_logic;
  signal jtag_readArea_ctrl_reset : std_logic;
  signal jtag_readArea_ctrl_tdo : std_logic;
  signal jtag_readArea_full_shifter : std_logic_vector(33 downto 0);
begin
  io_remote_cmd_valid <= io_remote_cmd_valid_read_buffer;
  io_remote_rsp_ready <= io_remote_rsp_ready_read_buffer;
  flowCCByToggle_1 : entity work.FlowCCByToggle
    port map ( 
      io_input_valid => jtag_writeArea_source_valid,
      io_input_payload_last => jtag_writeArea_source_payload_last,
      io_input_payload_fragment => jtag_writeArea_source_payload_fragment,
      io_output_valid => flowCCByToggle_1_io_output_valid,
      io_output_payload_last => flowCCByToggle_1_io_output_payload_last,
      io_output_payload_fragment => flowCCByToggle_1_io_output_payload_fragment,
      io_jtag_tck => io_jtag_tck,
      io_mainClk => io_mainClk,
      resetCtrl_mainClkReset => resetCtrl_mainClkReset 
    );
  system_cmd_toStream_valid <= system_cmd_valid;
  system_cmd_toStream_payload_last <= system_cmd_payload_last;
  system_cmd_toStream_payload_fragment <= system_cmd_payload_fragment;
  io_remote_cmd_valid_read_buffer <= system_cmd_toStream_valid;
  system_cmd_toStream_ready <= io_remote_cmd_ready;
  io_remote_cmd_payload_last <= system_cmd_toStream_payload_last;
  io_remote_cmd_payload_fragment <= system_cmd_toStream_payload_fragment;
  io_remote_rsp_fire <= (io_remote_rsp_valid and io_remote_rsp_ready_read_buffer);
  io_remote_rsp_ready_read_buffer <= pkg_toStdLogic(true);
  zz_jtag_tap_fsm_stateNext <= pkg_mux(io_jtag_tms,pkg_enum.RESET,pkg_enum.IDLE);
  zz_jtag_tap_fsm_stateNext_1 <= pkg_mux(io_jtag_tms,pkg_enum.DR_SELECT,pkg_enum.IDLE);
  zz_jtag_tap_fsm_stateNext_2 <= pkg_mux(io_jtag_tms,pkg_enum.RESET,pkg_enum.IR_CAPTURE);
  zz_jtag_tap_fsm_stateNext_3 <= pkg_mux(io_jtag_tms,pkg_enum.IR_EXIT1,pkg_enum.IR_SHIFT);
  zz_jtag_tap_fsm_stateNext_4 <= pkg_mux(io_jtag_tms,pkg_enum.IR_EXIT1,pkg_enum.IR_SHIFT);
  zz_jtag_tap_fsm_stateNext_5 <= pkg_mux(io_jtag_tms,pkg_enum.IR_UPDATE,pkg_enum.IR_PAUSE);
  zz_jtag_tap_fsm_stateNext_6 <= pkg_mux(io_jtag_tms,pkg_enum.IR_EXIT2,pkg_enum.IR_PAUSE);
  zz_jtag_tap_fsm_stateNext_7 <= pkg_mux(io_jtag_tms,pkg_enum.IR_UPDATE,pkg_enum.IR_SHIFT);
  zz_jtag_tap_fsm_stateNext_8 <= pkg_mux(io_jtag_tms,pkg_enum.DR_SELECT,pkg_enum.IDLE);
  zz_jtag_tap_fsm_stateNext_9 <= pkg_mux(io_jtag_tms,pkg_enum.IR_SELECT,pkg_enum.DR_CAPTURE);
  zz_jtag_tap_fsm_stateNext_10 <= pkg_mux(io_jtag_tms,pkg_enum.DR_EXIT1,pkg_enum.DR_SHIFT);
  zz_jtag_tap_fsm_stateNext_11 <= pkg_mux(io_jtag_tms,pkg_enum.DR_EXIT1,pkg_enum.DR_SHIFT);
  zz_jtag_tap_fsm_stateNext_12 <= pkg_mux(io_jtag_tms,pkg_enum.DR_UPDATE,pkg_enum.DR_PAUSE);
  zz_jtag_tap_fsm_stateNext_13 <= pkg_mux(io_jtag_tms,pkg_enum.DR_EXIT2,pkg_enum.DR_PAUSE);
  zz_jtag_tap_fsm_stateNext_14 <= pkg_mux(io_jtag_tms,pkg_enum.DR_UPDATE,pkg_enum.DR_SHIFT);
  zz_jtag_tap_fsm_stateNext_15 <= pkg_mux(io_jtag_tms,pkg_enum.DR_SELECT,pkg_enum.IDLE);
  process(jtag_tap_fsm_state,zz_jtag_tap_fsm_stateNext_1,zz_jtag_tap_fsm_stateNext_2,zz_jtag_tap_fsm_stateNext_3,zz_jtag_tap_fsm_stateNext_4,zz_jtag_tap_fsm_stateNext_5,zz_jtag_tap_fsm_stateNext_6,zz_jtag_tap_fsm_stateNext_7,zz_jtag_tap_fsm_stateNext_8,zz_jtag_tap_fsm_stateNext_9,zz_jtag_tap_fsm_stateNext_10,zz_jtag_tap_fsm_stateNext_11,zz_jtag_tap_fsm_stateNext_12,zz_jtag_tap_fsm_stateNext_13,zz_jtag_tap_fsm_stateNext_14,zz_jtag_tap_fsm_stateNext_15,zz_jtag_tap_fsm_stateNext)
  begin
    case jtag_tap_fsm_state is
      when pkg_enum.IDLE =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_1;
      when pkg_enum.IR_SELECT =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_2;
      when pkg_enum.IR_CAPTURE =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_3;
      when pkg_enum.IR_SHIFT =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_4;
      when pkg_enum.IR_EXIT1 =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_5;
      when pkg_enum.IR_PAUSE =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_6;
      when pkg_enum.IR_EXIT2 =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_7;
      when pkg_enum.IR_UPDATE =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_8;
      when pkg_enum.DR_SELECT =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_9;
      when pkg_enum.DR_CAPTURE =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_10;
      when pkg_enum.DR_SHIFT =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_11;
      when pkg_enum.DR_EXIT1 =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_12;
      when pkg_enum.DR_PAUSE =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_13;
      when pkg_enum.DR_EXIT2 =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_14;
      when pkg_enum.DR_UPDATE =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext_15;
      when others =>
        zz_jtag_tap_fsm_stateNext_16 <= zz_jtag_tap_fsm_stateNext;
    end case;
  end process;

  jtag_tap_fsm_stateNext <= zz_jtag_tap_fsm_stateNext_16;
  process(jtag_tap_bypass,jtag_tap_fsm_state,jtag_tap_tdoIr,jtag_tap_isBypass,jtag_tap_tdoDr)
  begin
    jtag_tap_tdoUnbufferd <= jtag_tap_bypass;
    case jtag_tap_fsm_state is
      when pkg_enum.IR_SHIFT =>
        jtag_tap_tdoUnbufferd <= jtag_tap_tdoIr;
      when pkg_enum.DR_SHIFT =>
        if jtag_tap_isBypass = '1' then
          jtag_tap_tdoUnbufferd <= jtag_tap_bypass;
        else
          jtag_tap_tdoUnbufferd <= jtag_tap_tdoDr;
        end if;
      when others =>
    end case;
  end process;

  process(jtag_idcodeArea_ctrl_enable,jtag_idcodeArea_ctrl_tdo,jtag_writeArea_ctrl_enable,jtag_writeArea_ctrl_tdo,jtag_readArea_ctrl_enable,jtag_readArea_ctrl_tdo)
  begin
    jtag_tap_tdoDr <= pkg_toStdLogic(false);
    if jtag_idcodeArea_ctrl_enable = '1' then
      jtag_tap_tdoDr <= jtag_idcodeArea_ctrl_tdo;
    end if;
    if jtag_writeArea_ctrl_enable = '1' then
      jtag_tap_tdoDr <= jtag_writeArea_ctrl_tdo;
    end if;
    if jtag_readArea_ctrl_enable = '1' then
      jtag_tap_tdoDr <= jtag_readArea_ctrl_tdo;
    end if;
  end process;

  jtag_tap_tdoIr <= pkg_extract(jtag_tap_instructionShift,0);
  jtag_tap_isBypass <= pkg_toStdLogic(signed(jtag_tap_instruction) = pkg_signed("1111"));
  io_jtag_tdo <= jtag_tap_tdoUnbufferd_regNext;
  jtag_idcodeArea_ctrl_tdo <= pkg_extract(jtag_idcodeArea_shifter,0);
  jtag_idcodeArea_ctrl_tdi <= io_jtag_tdi;
  jtag_idcodeArea_ctrl_enable <= pkg_toStdLogic(jtag_tap_instruction = pkg_stdLogicVector("0001"));
  jtag_idcodeArea_ctrl_capture <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.DR_CAPTURE);
  jtag_idcodeArea_ctrl_shift <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.DR_SHIFT);
  jtag_idcodeArea_ctrl_update <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.DR_UPDATE);
  jtag_idcodeArea_ctrl_reset <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.RESET);
  when_JtagTap_l120 <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.RESET);
  jtag_writeArea_source_valid <= jtag_writeArea_valid;
  jtag_writeArea_source_payload_last <= (not (jtag_writeArea_ctrl_enable and jtag_writeArea_ctrl_shift));
  jtag_writeArea_source_payload_fragment(0) <= jtag_writeArea_data;
  system_cmd_valid <= flowCCByToggle_1_io_output_valid;
  system_cmd_payload_last <= flowCCByToggle_1_io_output_payload_last;
  system_cmd_payload_fragment <= flowCCByToggle_1_io_output_payload_fragment;
  jtag_writeArea_ctrl_tdo <= pkg_toStdLogic(false);
  jtag_writeArea_ctrl_tdi <= io_jtag_tdi;
  jtag_writeArea_ctrl_enable <= pkg_toStdLogic(jtag_tap_instruction = pkg_stdLogicVector("0010"));
  jtag_writeArea_ctrl_capture <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.DR_CAPTURE);
  jtag_writeArea_ctrl_shift <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.DR_SHIFT);
  jtag_writeArea_ctrl_update <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.DR_UPDATE);
  jtag_writeArea_ctrl_reset <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.RESET);
  jtag_readArea_ctrl_tdo <= pkg_extract(jtag_readArea_full_shifter,0);
  jtag_readArea_ctrl_tdi <= io_jtag_tdi;
  jtag_readArea_ctrl_enable <= pkg_toStdLogic(jtag_tap_instruction = pkg_stdLogicVector("0011"));
  jtag_readArea_ctrl_capture <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.DR_CAPTURE);
  jtag_readArea_ctrl_shift <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.DR_SHIFT);
  jtag_readArea_ctrl_update <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.DR_UPDATE);
  jtag_readArea_ctrl_reset <= pkg_toStdLogic(jtag_tap_fsm_state = pkg_enum.RESET);
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if io_remote_cmd_valid_read_buffer = '1' then
        system_rsp_valid <= pkg_toStdLogic(false);
      end if;
      if io_remote_rsp_fire = '1' then
        system_rsp_valid <= pkg_toStdLogic(true);
        system_rsp_payload_error <= io_remote_rsp_payload_error;
        system_rsp_payload_data <= io_remote_rsp_payload_data;
      end if;
    end if;
  end process;

  process(io_jtag_tck)
  begin
    if rising_edge(io_jtag_tck) then
      jtag_tap_fsm_state <= jtag_tap_fsm_stateNext;
      jtag_tap_bypass <= io_jtag_tdi;
      case jtag_tap_fsm_state is
        when pkg_enum.IR_CAPTURE =>
          jtag_tap_instructionShift <= pkg_resize(pkg_stdLogicVector("01"),4);
        when pkg_enum.IR_SHIFT =>
          jtag_tap_instructionShift <= pkg_shiftRight(pkg_cat(pkg_toStdLogicVector(io_jtag_tdi),jtag_tap_instructionShift),1);
        when pkg_enum.IR_UPDATE =>
          jtag_tap_instruction <= jtag_tap_instructionShift;
        when pkg_enum.DR_SHIFT =>
          jtag_tap_instructionShift <= pkg_shiftRight(pkg_cat(pkg_toStdLogicVector(io_jtag_tdi),jtag_tap_instructionShift),1);
        when others =>
      end case;
      if jtag_idcodeArea_ctrl_enable = '1' then
        if jtag_idcodeArea_ctrl_shift = '1' then
          jtag_idcodeArea_shifter <= pkg_shiftRight(pkg_cat(pkg_toStdLogicVector(jtag_idcodeArea_ctrl_tdi),jtag_idcodeArea_shifter),1);
        end if;
      end if;
      if jtag_idcodeArea_ctrl_capture = '1' then
        jtag_idcodeArea_shifter <= pkg_stdLogicVector("00010000000000000001111111111111");
      end if;
      if when_JtagTap_l120 = '1' then
        jtag_tap_instruction <= pkg_stdLogicVector("0001");
      end if;
      jtag_writeArea_valid <= (jtag_writeArea_ctrl_enable and jtag_writeArea_ctrl_shift);
      jtag_writeArea_data <= jtag_writeArea_ctrl_tdi;
      if jtag_readArea_ctrl_enable = '1' then
        if jtag_readArea_ctrl_capture = '1' then
          jtag_readArea_full_shifter <= pkg_cat(pkg_cat(system_rsp_payload_data,pkg_toStdLogicVector(system_rsp_payload_error)),pkg_toStdLogicVector(system_rsp_valid));
        end if;
        if jtag_readArea_ctrl_shift = '1' then
          jtag_readArea_full_shifter <= pkg_shiftRight(pkg_cat(pkg_toStdLogicVector(jtag_readArea_ctrl_tdi),jtag_readArea_full_shifter),1);
        end if;
      end if;
    end if;
  end process;

  process(io_jtag_tck)
  begin
    if falling_edge(io_jtag_tck) then
      jtag_tap_tdoUnbufferd_regNext <= jtag_tap_tdoUnbufferd;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity SystemDebugger is
  port(
    io_remote_cmd_valid : in std_logic;
    io_remote_cmd_ready : out std_logic;
    io_remote_cmd_payload_last : in std_logic;
    io_remote_cmd_payload_fragment : in std_logic_vector(0 downto 0);
    io_remote_rsp_valid : out std_logic;
    io_remote_rsp_ready : in std_logic;
    io_remote_rsp_payload_error : out std_logic;
    io_remote_rsp_payload_data : out std_logic_vector(31 downto 0);
    io_mem_cmd_valid : out std_logic;
    io_mem_cmd_ready : in std_logic;
    io_mem_cmd_payload_address : out unsigned(31 downto 0);
    io_mem_cmd_payload_data : out std_logic_vector(31 downto 0);
    io_mem_cmd_payload_wr : out std_logic;
    io_mem_cmd_payload_size : out unsigned(1 downto 0);
    io_mem_rsp_valid : in std_logic;
    io_mem_rsp_payload : in std_logic_vector(31 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_mainClkReset : in std_logic
  );
end SystemDebugger;

architecture arch of SystemDebugger is
  signal io_mem_cmd_valid_read_buffer : std_logic;

  signal dispatcher_dataShifter : std_logic_vector(66 downto 0);
  signal dispatcher_dataLoaded : std_logic;
  signal dispatcher_headerShifter : std_logic_vector(7 downto 0);
  signal dispatcher_header : std_logic_vector(7 downto 0);
  signal dispatcher_headerLoaded : std_logic;
  signal dispatcher_counter : unsigned(2 downto 0);
  signal when_Fragment_l346 : std_logic;
  signal when_Fragment_l349 : std_logic;
  signal zz_io_mem_cmd_payload_address : std_logic_vector(66 downto 0);
  signal io_mem_cmd_isStall : std_logic;
  signal when_Fragment_l372 : std_logic;
begin
  io_mem_cmd_valid <= io_mem_cmd_valid_read_buffer;
  dispatcher_header <= pkg_extract(dispatcher_headerShifter,7,0);
  when_Fragment_l346 <= pkg_toStdLogic(dispatcher_headerLoaded = pkg_toStdLogic(false));
  when_Fragment_l349 <= pkg_toStdLogic(dispatcher_counter = pkg_unsigned("111"));
  io_remote_cmd_ready <= (not dispatcher_dataLoaded);
  zz_io_mem_cmd_payload_address <= pkg_extract(dispatcher_dataShifter,66,0);
  io_mem_cmd_payload_address <= unsigned(pkg_extract(zz_io_mem_cmd_payload_address,31,0));
  io_mem_cmd_payload_data <= pkg_extract(zz_io_mem_cmd_payload_address,63,32);
  io_mem_cmd_payload_wr <= pkg_extract(zz_io_mem_cmd_payload_address,64);
  io_mem_cmd_payload_size <= unsigned(pkg_extract(zz_io_mem_cmd_payload_address,66,65));
  io_mem_cmd_valid_read_buffer <= (dispatcher_dataLoaded and pkg_toStdLogic(dispatcher_header = pkg_stdLogicVector("00000000")));
  io_mem_cmd_isStall <= (io_mem_cmd_valid_read_buffer and (not io_mem_cmd_ready));
  when_Fragment_l372 <= ((dispatcher_headerLoaded and dispatcher_dataLoaded) and (not io_mem_cmd_isStall));
  io_remote_rsp_valid <= io_mem_rsp_valid;
  io_remote_rsp_payload_error <= pkg_toStdLogic(false);
  io_remote_rsp_payload_data <= io_mem_rsp_payload;
  process(io_mainClk, resetCtrl_mainClkReset)
  begin
    if resetCtrl_mainClkReset = '1' then
      dispatcher_dataLoaded <= pkg_toStdLogic(false);
      dispatcher_headerLoaded <= pkg_toStdLogic(false);
      dispatcher_counter <= pkg_unsigned("000");
    elsif rising_edge(io_mainClk) then
      if io_remote_cmd_valid = '1' then
        if when_Fragment_l346 = '1' then
          dispatcher_counter <= (dispatcher_counter + pkg_unsigned("001"));
          if when_Fragment_l349 = '1' then
            dispatcher_headerLoaded <= pkg_toStdLogic(true);
          end if;
        end if;
        if io_remote_cmd_payload_last = '1' then
          dispatcher_headerLoaded <= pkg_toStdLogic(true);
          dispatcher_dataLoaded <= pkg_toStdLogic(true);
          dispatcher_counter <= pkg_unsigned("000");
        end if;
      end if;
      if when_Fragment_l372 = '1' then
        dispatcher_headerLoaded <= pkg_toStdLogic(false);
        dispatcher_dataLoaded <= pkg_toStdLogic(false);
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if io_remote_cmd_valid = '1' then
        if when_Fragment_l346 = '1' then
          dispatcher_headerShifter <= pkg_shiftRight(pkg_cat(io_remote_cmd_payload_fragment,dispatcher_headerShifter),1);
        else
          dispatcher_dataShifter <= pkg_shiftRight(pkg_cat(io_remote_cmd_payload_fragment,dispatcher_dataShifter),1);
        end if;
      end if;
    end if;
  end process;

end arch;

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

architecture arch of MuraxPipelinedMemoryBusRam is
  signal zz_ram_port0 : std_logic_vector(31 downto 0);
  signal io_bus_cmd_ready_read_buffer : std_logic;
  signal zz_ram_port : unsigned(9 downto 0);
  signal zz_io_bus_rsp_payload_data_2 : unsigned(9 downto 0);

  signal io_bus_cmd_fire : std_logic;
  signal zz_io_bus_rsp_valid : std_logic;
  signal zz_io_bus_rsp_payload_data : unsigned(29 downto 0);
  signal zz_io_bus_rsp_payload_data_1 : std_logic_vector(31 downto 0);
  type ram_type is array (0 to 1023) of std_logic_vector(7 downto 0);
  signal ram_symbol0 : ram_type := (
     "01101111","00010011","00010011","00010011","00010011","00010011","00010011","00010011","00100011","00100011","00100011","00100011","00100011","00100011","00100011","00100011",
     "00100011","00100011","00100011","00100011","00100011","00100011","00100011","00100011","00010011","11101111","10000011","10000011","00000011","10000011","00000011","10000011",
     "00000011","10000011","00000011","10000011","00000011","10000011","00000011","10000011","00000011","10000011","00010011","01110011","10010111","10010011","00010011","00010111",
     "00010011","10010111","10010011","01100011","00100011","00010011","01101111","00010111","00010011","00010011","10010111","10010011","01100011","10000011","00010011","00100011",
     "11100111","00000011","01101111","00010011","00110111","00010011","01110011","00110111","00010011","01110011","11101111","01101111","00010011","00100011","00010011","00100011",
     "10000011","00100011","10000011","00100011","00010011","00000011","00010011","01100111","00010011","00100011","00010011","00100011","00010011","00000011","00010011","01100111",
     "00010011","00100011","00010011","00100011","10000011","00100011","10000011","00010011","00100011","00010011","00000011","00010011","01100111","00010011","00100011","00010011",
     "00100011","10000011","10000011","10010011","10010011","00010011","00000011","00010011","01100111","00010011","00100011","00010011","00100011","10000011","10000011","10010011",
     "00010011","00000011","00010011","01100111","00010011","00100011","00100011","00010011","00100011","00100011","00010011","00000011","11101111","10010011","11100011","10000011",
     "00000011","00100011","00010011","10000011","00000011","00010011","01100111","00010011","00100011","00010011","00100011","00100011","10000011","00000011","10000011","00100011",
     "10000011","10000011","00010011","10000011","10000011","10010011","00110011","10000011","10000011","10010011","00110011","10000011","00100011","00010011","00000011","00010011",
     "01100111","00010011","00100011","00100011","00010011","10010011","00100011","10010011","00100011","10010011","00100011","00100011","10110111","10010011","00000011","10000011",
     "00000011","00000011","10000011","00000011","00000011","10000011","00000011","10000011","00000011","10000011","00100011","00100011","00100011","00100011","00100011","00100011",
     "00100011","00100011","00100011","00100011","00100011","00100011","00100011","10110111","00010011","11101111","00110111","11101111","10110111","00010011","11101111","10110111",
     "00110111","00010011","00100011","10110111","10010011","00010011","00100011","10110111","10010011","00110111","00010011","00100011","10110111","10010011","00010011","00100011",
     "10110111","10010011","00010011","00100011","10110111","00010011","00100011","10110111","00100011","10110111","00010011","00100011","10110111","00010011","00100011","10000011",
     "00000011","10110011","00100011","00000011","10000011","10110011","00000011","10110011","00100011","00100011","01101111","10000011","10010011","00100011","00000011","10110111",
     "10010011","11100011","00000011","10010011","01100011","00100011","01101111","10000011","10010011","00100011","10000011","00010011","10110011","00000011","10110111","00100011",
     "10110111","10000011","10010011","10110111","10000011","10010011","00010011","10110111","00110011","00100011","01101111","00010011","00100011","00010011","10110111","10010011",
     "10000011","10010011","01100011","10110111","00000011","10110111","00010011","00100011","10110111","10010011","00010011","00100011","01101111","10110111","00000011","10110111",
     "00010011","00100011","10110111","10000011","10010011","11100011","00010011","00010011","00000011","00010011","01100111","01001100","01100101","01110010","00100001","01110010",
     "10111100","01101000","01000100","01100101","00100000","01100101","01101001","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000");
  signal ram_symbol1 : ram_type := (
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00101110","00101100","00101010","00101000","00100110","00100100","00100010","00100000",
     "00101110","00101100","00101010","00101000","00100110","00100100","00100010","00100000","00000001","00000000","00100000","00100010","00100011","00100011","00100101","00100101",
     "00100110","00100110","00100111","00100111","00101000","00101000","00101110","00101110","00101111","00101111","00000001","00000000","00010001","10000001","10000001","00000101",
     "00000101","00000101","10000101","00001000","00100000","00000101","11110000","00000101","00000101","00000001","00000101","10000101","00001110","00100110","00000101","00100000",
     "10000000","00100101","11110000","00000001","00010101","00000101","00010000","00100101","00000101","00010000","00000000","00000000","00000001","00101110","00000100","00100110",
     "00100111","10100000","00100111","10100100","00000000","00100100","00000001","10000000","00000001","00101110","00000100","00100110","00000000","00100100","00000001","10000000",
     "00000001","00101110","00000100","00100110","00100111","10100010","00100111","00000111","10100000","00000000","00100100","00000001","10000000","00000001","00101110","00000100",
     "00100110","00100111","10100111","11010111","11110111","10000101","00100100","00000001","10000000","00000001","00101110","00000100","00100110","00100111","10100111","11010111",
     "10000101","00100100","00000001","10000000","00000001","00101110","00101100","00000100","00100110","00100100","00000000","00100101","11110000","00000111","10001010","00100111",
     "00100111","10100000","00000000","00100000","00100100","00000001","10000000","00000001","00101110","00000100","00100110","00100100","00100111","10100111","00100111","10100100",
     "00100111","10100111","10000111","00100111","10100111","10010111","01100111","00100111","10100111","10010111","01100111","00100111","10100110","00000000","00100100","00000001",
     "10000000","00000001","00101110","00101100","00000100","00000111","00100000","00000111","00101110","00000111","00101100","00100110","00000111","10000111","10101111","10101110",
     "10101110","10100011","10101000","10101000","10100101","10100101","10100110","10100110","10100111","10100111","00100100","00100110","00101000","00101010","00101100","00101110",
     "00100000","00100010","00100100","00100110","00101000","00101010","00100100","00000111","10000101","11110000","00000101","11110000","00000111","10000101","11110000","00000111",
     "11000111","00000111","10100000","00000111","10000111","00000111","10100010","00000111","10000111","00000111","00000111","10100000","00000111","10000111","00000111","10100000",
     "00000111","10000111","00000111","10100010","00000111","00000111","10100100","00000111","10100010","00000111","00000111","10100010","00000111","00000111","10100000","00100111",
     "00100111","00000111","00100110","00100111","00100111","00000111","00100111","00000111","00100110","00100010","00000000","00100111","10000111","00100010","00100111","00010111",
     "10000111","11110100","00100111","00000111","00010110","00100100","00000000","00100111","10000111","00100100","00100111","00000111","00000111","11000111","00000111","10100000",
     "00000111","10100111","11110110","00000111","10100111","10000111","11110111","00000111","11100111","10100010","11110000","00000001","00100110","00000100","00000111","10000111",
     "10100111","11110111","10000000","00000111","10100111","00000111","01000111","10100010","00000111","10000111","00000111","10100000","00000000","00000111","10100111","00000111",
     "01110111","10100000","00000111","10100111","11110111","10010000","00000000","00000000","00100100","00000001","10000000","01101001","01110010","01100001","00100000","00100000",
     "01101110","01100101","01101001","01101001","01100111","00100000","01110100","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000");
  signal ram_symbol2 : ram_type := (
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00010001","01010001","01100001","01110001","10100001","10110001","11000001","11010001",
     "11100001","11110001","00000001","00010001","11000001","11010001","11100001","11110001","00000001","10000000","11000001","10000001","01000001","00000001","11000001","10000001",
     "01000001","00000001","11000001","10000001","01000001","00000001","11000001","10000001","01000001","00000001","00000001","00100000","00000000","00000001","00000001","00000000",
     "01000101","00000000","11000101","10110101","00000101","01000101","01011111","00000000","00000101","11000001","00000000","01000101","10110101","00000101","01000101","10100001",
     "00000110","00000001","00011111","01000001","00000000","00000101","01000101","00000000","10000101","00000101","11000000","00000000","00000001","10000001","00000001","10100100",
     "11000100","00000111","11000100","00000111","00000000","11000001","00000001","00000000","00000001","10000001","00000001","10100100","00000000","11000001","00000001","00000000",
     "00000001","10000001","00000001","10100100","11000100","00000111","11000100","11110000","11100111","00000000","11000001","00000001","00000000","00000001","10000001","00000001",
     "10100100","11000100","01000111","00000111","11110111","00000111","11000001","00000001","00000000","00000001","10000001","00000001","10100100","11000100","01000111","10000111",
     "00000111","11000001","00000001","00000000","00000001","00010001","10000001","00000001","10100100","10110100","00000000","11000100","01011111","00000101","00000111","11000100",
     "10000100","11100111","00000000","11000001","10000001","00000001","00000000","00000001","10000001","00000001","10100100","10110100","10000100","11000111","11000100","11100111",
     "10000100","00000111","11110111","10000100","01000111","10000111","11110111","10000100","10000111","00000111","11110111","11000100","11100111","00000000","11000001","00000001",
     "00000000","00000001","00010001","10000001","00000001","00010000","11110100","00100000","11110100","00110000","11110100","00000100","00000000","11000111","00000111","01000111",
     "10000111","11000111","00000111","01000111","10000111","11000111","00000111","01000111","10000111","11000111","11100100","11010100","11000100","01100100","00010100","00000100",
     "10100100","10110100","11000100","11010100","11100100","11110100","00000100","00000010","00000111","11011111","00000010","01011111","00000010","00000111","10011111","00000010",
     "00000000","11110111","11100111","00000010","00000111","01110000","11100111","00000010","00000111","00000001","00100111","11100111","00000010","00000111","11110000","11100111",
     "00000010","00000111","00010000","11100111","00000000","11110000","11100111","00000000","00000111","00000001","00100000","11100111","00000001","00010000","11100111","00000100",
     "11000100","11110111","11110100","11000100","10000100","11110111","11000100","11110111","11110100","00000100","00000000","01000100","00010111","11110100","01000100","00000011",
     "11110111","11100111","10000100","11110000","11110111","00000100","00000000","10000100","00010111","11110100","10000100","00000100","11110111","10000111","00000001","11100111",
     "00000000","01000111","00000111","00000000","01000111","00010111","11110111","00000000","11100110","11100111","01011111","00000001","10000001","00000001","00000010","00000111",
     "00000111","00010111","00000111","00000000","01000111","00000000","00000111","11100111","00000010","00000111","00010000","11100111","10000000","00000001","00000111","00000001",
     "11110111","11100111","00000001","01000111","00000111","00000111","00000000","00000000","11000001","00000001","00000000","01100101","00100000","01101110","01010111","01110111",
     "01110011","01101110","01110010","01101110","01110101","01011010","00100001","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000");
  signal ram_symbol3 : ram_type := (
     "00001011","00000000","00000000","00000000","00000000","00000000","00000000","00000000","11111110","11111110","11111110","11111110","11111110","11111110","11111110","11111110",
     "11111100","11111100","11111101","11111101","11111101","11111101","11111101","11111101","11111100","01000100","00000011","00000011","00000011","00000011","00000010","00000010",
     "00000010","00000010","00000001","00000001","00000001","00000001","00000000","00000000","00000000","00000000","00000100","00110000","00000000","11001011","10100000","00000000",
     "01001010","00000000","01001001","00000000","00000000","00000000","11111111","00000000","01001000","11111111","00000000","01000111","00000000","00000000","00000000","00000000",
     "00000000","00000000","11111110","00000000","00000000","10001000","00110000","00000000","10000000","00110000","00011001","00000000","11111110","00000000","00000010","11111110",
     "11111110","00000000","11111110","00000000","00000000","00000001","00000010","00000000","11111110","00000000","00000010","11111110","00000000","00000001","00000010","00000000",
     "11111110","00000000","00000010","11111110","11111110","00000000","11111110","11111111","00000000","00000000","00000001","00000010","00000000","11111110","00000000","00000010",
     "11111110","11111110","00000000","00000001","00001111","00000000","00000001","00000010","00000000","11111110","00000000","00000010","11111110","11111110","00000000","00000001",
     "00000000","00000001","00000010","00000000","11111110","00000000","00000000","00000010","11111110","11111110","00000000","11111110","11111000","00000000","11111110","11111110",
     "11111110","00000000","00000000","00000001","00000001","00000010","00000000","11111110","00000000","00000010","11111110","11111110","11111110","00000000","11111110","00000000",
     "11111110","00000000","11111111","11111110","00000000","00000000","00000000","11111110","00000000","00000001","00000000","11111110","00000000","00000000","00000001","00000010",
     "00000000","11111010","00000100","00000100","00000110","00000000","11111110","00000000","11111100","00000000","11111100","11111110","10000000","01010010","00000000","00000000",
     "00000000","00000000","00000001","00000001","00000001","00000001","00000010","00000010","00000010","00000010","11111011","11111011","11111011","11111010","11111011","11111011",
     "11111100","11111100","11111100","11111100","11111100","11111100","11111110","11110000","00000001","11100001","11110000","11011111","11110000","00000100","11011011","11110000",
     "00000000","00110100","00000000","11110000","00000100","00111110","00000000","11110000","00000100","00000000","00000000","00000000","11110000","00000001","00000000","00000000",
     "11110000","00000001","00000000","00000000","11110000","00001111","00000000","11110000","00000000","11110000","00000000","00000000","11110000","00000100","00000000","11111110",
     "11111110","00000000","11111110","11111101","11111101","00000000","11111110","00000000","11111110","11111110","00000001","11111110","00000000","11111110","11111110","00000000",
     "11010011","11111110","11111110","00000010","00000000","11111110","00000001","11111110","00000000","11111110","11111110","11111111","00000000","11111011","11110000","00000000",
     "11110000","00000000","11111100","11110000","00000000","00000000","00000011","11110000","00000000","00000000","11110101","11111111","00000000","00000001","11110000","00000001",
     "00000000","00000000","00000100","11110000","00000000","11110000","00001000","00000000","11110000","00000001","00000000","00000000","00000001","11110000","00000000","11110000",
     "00001111","00000000","11110000","00000000","00100000","11111110","00000000","00000000","00000000","00000001","00000000","01100010","01000110","01111010","01101001","11000011",
     "01100011","00100000","00100000","01100101","01110100","01100101","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000",
     "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000");
  signal zz_1 : std_logic_vector(7 downto 0);
  signal zz_2 : std_logic_vector(7 downto 0);
  signal zz_3 : std_logic_vector(7 downto 0);
  signal zz_4 : std_logic_vector(7 downto 0);
begin
  io_bus_cmd_ready <= io_bus_cmd_ready_read_buffer;
  zz_io_bus_rsp_payload_data_2 <= pkg_resize(zz_io_bus_rsp_payload_data,10);
  process (zz_1, zz_2, zz_3, zz_4)
  begin
    zz_ram_port0 <= zz_4 & zz_3 & zz_2 & zz_1;
  end process;
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if io_bus_cmd_valid = '1' then
        zz_1 <= ram_symbol0(to_integer(zz_io_bus_rsp_payload_data_2));
        zz_2 <= ram_symbol1(to_integer(zz_io_bus_rsp_payload_data_2));
        zz_3 <= ram_symbol2(to_integer(zz_io_bus_rsp_payload_data_2));
        zz_4 <= ram_symbol3(to_integer(zz_io_bus_rsp_payload_data_2));
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if io_bus_cmd_payload_mask(0) = '1' and io_bus_cmd_valid = '1' and io_bus_cmd_payload_write = '1' then
        ram_symbol0(to_integer(zz_io_bus_rsp_payload_data_2)) <= zz_io_bus_rsp_payload_data_1(7 downto 0);
      end if;
      if io_bus_cmd_payload_mask(1) = '1' and io_bus_cmd_valid = '1' and io_bus_cmd_payload_write = '1' then
        ram_symbol1(to_integer(zz_io_bus_rsp_payload_data_2)) <= zz_io_bus_rsp_payload_data_1(15 downto 8);
      end if;
      if io_bus_cmd_payload_mask(2) = '1' and io_bus_cmd_valid = '1' and io_bus_cmd_payload_write = '1' then
        ram_symbol2(to_integer(zz_io_bus_rsp_payload_data_2)) <= zz_io_bus_rsp_payload_data_1(23 downto 16);
      end if;
      if io_bus_cmd_payload_mask(3) = '1' and io_bus_cmd_valid = '1' and io_bus_cmd_payload_write = '1' then
        ram_symbol3(to_integer(zz_io_bus_rsp_payload_data_2)) <= zz_io_bus_rsp_payload_data_1(31 downto 24);
      end if;
    end if;
  end process;

  io_bus_cmd_fire <= (io_bus_cmd_valid and io_bus_cmd_ready_read_buffer);
  io_bus_rsp_valid <= zz_io_bus_rsp_valid;
  zz_io_bus_rsp_payload_data <= pkg_shiftRight(io_bus_cmd_payload_address,2);
  zz_io_bus_rsp_payload_data_1 <= io_bus_cmd_payload_data;
  io_bus_rsp_payload_data <= zz_ram_port0;
  io_bus_cmd_ready_read_buffer <= pkg_toStdLogic(true);
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      zz_io_bus_rsp_valid <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      zz_io_bus_rsp_valid <= (io_bus_cmd_fire and (not io_bus_cmd_payload_write));
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity PipelinedMemoryBusToApbBridge is
  port(
    io_pipelinedMemoryBus_cmd_valid : in std_logic;
    io_pipelinedMemoryBus_cmd_ready : out std_logic;
    io_pipelinedMemoryBus_cmd_payload_write : in std_logic;
    io_pipelinedMemoryBus_cmd_payload_address : in unsigned(31 downto 0);
    io_pipelinedMemoryBus_cmd_payload_data : in std_logic_vector(31 downto 0);
    io_pipelinedMemoryBus_cmd_payload_mask : in std_logic_vector(3 downto 0);
    io_pipelinedMemoryBus_rsp_valid : out std_logic;
    io_pipelinedMemoryBus_rsp_payload_data : out std_logic_vector(31 downto 0);
    io_apb_PADDR : out unsigned(19 downto 0);
    io_apb_PSEL : out std_logic_vector(0 downto 0);
    io_apb_PENABLE : out std_logic;
    io_apb_PREADY : in std_logic;
    io_apb_PWRITE : out std_logic;
    io_apb_PWDATA : out std_logic_vector(31 downto 0);
    io_apb_PRDATA : in std_logic_vector(31 downto 0);
    io_apb_PSLVERROR : in std_logic;
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end PipelinedMemoryBusToApbBridge;

architecture arch of PipelinedMemoryBusToApbBridge is
  signal io_pipelinedMemoryBus_cmd_ready_read_buffer : std_logic;

  signal pipelinedMemoryBusStage_cmd_valid : std_logic;
  signal pipelinedMemoryBusStage_cmd_ready : std_logic;
  signal pipelinedMemoryBusStage_cmd_payload_write : std_logic;
  signal pipelinedMemoryBusStage_cmd_payload_address : unsigned(31 downto 0);
  signal pipelinedMemoryBusStage_cmd_payload_data : std_logic_vector(31 downto 0);
  signal pipelinedMemoryBusStage_cmd_payload_mask : std_logic_vector(3 downto 0);
  signal pipelinedMemoryBusStage_rsp_valid : std_logic;
  signal pipelinedMemoryBusStage_rsp_payload_data : std_logic_vector(31 downto 0);
  signal io_pipelinedMemoryBus_cmd_halfPipe_valid : std_logic;
  signal io_pipelinedMemoryBus_cmd_halfPipe_ready : std_logic;
  signal io_pipelinedMemoryBus_cmd_halfPipe_payload_write : std_logic;
  signal io_pipelinedMemoryBus_cmd_halfPipe_payload_address : unsigned(31 downto 0);
  signal io_pipelinedMemoryBus_cmd_halfPipe_payload_data : std_logic_vector(31 downto 0);
  signal io_pipelinedMemoryBus_cmd_halfPipe_payload_mask : std_logic_vector(3 downto 0);
  signal io_pipelinedMemoryBus_cmd_rValid : std_logic;
  signal io_pipelinedMemoryBus_cmd_halfPipe_fire : std_logic;
  signal io_pipelinedMemoryBus_cmd_rData_write : std_logic;
  signal io_pipelinedMemoryBus_cmd_rData_address : unsigned(31 downto 0);
  signal io_pipelinedMemoryBus_cmd_rData_data : std_logic_vector(31 downto 0);
  signal io_pipelinedMemoryBus_cmd_rData_mask : std_logic_vector(3 downto 0);
  signal pipelinedMemoryBusStage_rsp_regNext_valid : std_logic;
  signal pipelinedMemoryBusStage_rsp_regNext_payload_data : std_logic_vector(31 downto 0);
  signal state : std_logic;
  signal when_PipelinedMemoryBus_l369 : std_logic;
begin
  io_pipelinedMemoryBus_cmd_ready <= io_pipelinedMemoryBus_cmd_ready_read_buffer;
  io_pipelinedMemoryBus_cmd_halfPipe_fire <= (io_pipelinedMemoryBus_cmd_halfPipe_valid and io_pipelinedMemoryBus_cmd_halfPipe_ready);
  io_pipelinedMemoryBus_cmd_ready_read_buffer <= (not io_pipelinedMemoryBus_cmd_rValid);
  io_pipelinedMemoryBus_cmd_halfPipe_valid <= io_pipelinedMemoryBus_cmd_rValid;
  io_pipelinedMemoryBus_cmd_halfPipe_payload_write <= io_pipelinedMemoryBus_cmd_rData_write;
  io_pipelinedMemoryBus_cmd_halfPipe_payload_address <= io_pipelinedMemoryBus_cmd_rData_address;
  io_pipelinedMemoryBus_cmd_halfPipe_payload_data <= io_pipelinedMemoryBus_cmd_rData_data;
  io_pipelinedMemoryBus_cmd_halfPipe_payload_mask <= io_pipelinedMemoryBus_cmd_rData_mask;
  pipelinedMemoryBusStage_cmd_valid <= io_pipelinedMemoryBus_cmd_halfPipe_valid;
  io_pipelinedMemoryBus_cmd_halfPipe_ready <= pipelinedMemoryBusStage_cmd_ready;
  pipelinedMemoryBusStage_cmd_payload_write <= io_pipelinedMemoryBus_cmd_halfPipe_payload_write;
  pipelinedMemoryBusStage_cmd_payload_address <= io_pipelinedMemoryBus_cmd_halfPipe_payload_address;
  pipelinedMemoryBusStage_cmd_payload_data <= io_pipelinedMemoryBus_cmd_halfPipe_payload_data;
  pipelinedMemoryBusStage_cmd_payload_mask <= io_pipelinedMemoryBus_cmd_halfPipe_payload_mask;
  io_pipelinedMemoryBus_rsp_valid <= pipelinedMemoryBusStage_rsp_regNext_valid;
  io_pipelinedMemoryBus_rsp_payload_data <= pipelinedMemoryBusStage_rsp_regNext_payload_data;
  process(when_PipelinedMemoryBus_l369,io_apb_PREADY)
  begin
    pipelinedMemoryBusStage_cmd_ready <= pkg_toStdLogic(false);
    if when_PipelinedMemoryBus_l369 = '0' then
      if io_apb_PREADY = '1' then
        pipelinedMemoryBusStage_cmd_ready <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  io_apb_PSEL(0) <= pipelinedMemoryBusStage_cmd_valid;
  io_apb_PENABLE <= state;
  io_apb_PWRITE <= pipelinedMemoryBusStage_cmd_payload_write;
  io_apb_PADDR <= pkg_resize(pipelinedMemoryBusStage_cmd_payload_address,20);
  io_apb_PWDATA <= pipelinedMemoryBusStage_cmd_payload_data;
  process(when_PipelinedMemoryBus_l369,io_apb_PREADY,pipelinedMemoryBusStage_cmd_payload_write)
  begin
    pipelinedMemoryBusStage_rsp_valid <= pkg_toStdLogic(false);
    if when_PipelinedMemoryBus_l369 = '0' then
      if io_apb_PREADY = '1' then
        pipelinedMemoryBusStage_rsp_valid <= (not pipelinedMemoryBusStage_cmd_payload_write);
      end if;
    end if;
  end process;

  pipelinedMemoryBusStage_rsp_payload_data <= io_apb_PRDATA;
  when_PipelinedMemoryBus_l369 <= (not state);
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      io_pipelinedMemoryBus_cmd_rValid <= pkg_toStdLogic(false);
      pipelinedMemoryBusStage_rsp_regNext_valid <= pkg_toStdLogic(false);
      state <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      if io_pipelinedMemoryBus_cmd_valid = '1' then
        io_pipelinedMemoryBus_cmd_rValid <= pkg_toStdLogic(true);
      end if;
      if io_pipelinedMemoryBus_cmd_halfPipe_fire = '1' then
        io_pipelinedMemoryBus_cmd_rValid <= pkg_toStdLogic(false);
      end if;
      pipelinedMemoryBusStage_rsp_regNext_valid <= pipelinedMemoryBusStage_rsp_valid;
      if when_PipelinedMemoryBus_l369 = '1' then
        state <= pipelinedMemoryBusStage_cmd_valid;
      else
        if io_apb_PREADY = '1' then
          state <= pkg_toStdLogic(false);
        end if;
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if io_pipelinedMemoryBus_cmd_ready_read_buffer = '1' then
        io_pipelinedMemoryBus_cmd_rData_write <= io_pipelinedMemoryBus_cmd_payload_write;
        io_pipelinedMemoryBus_cmd_rData_address <= io_pipelinedMemoryBus_cmd_payload_address;
        io_pipelinedMemoryBus_cmd_rData_data <= io_pipelinedMemoryBus_cmd_payload_data;
        io_pipelinedMemoryBus_cmd_rData_mask <= io_pipelinedMemoryBus_cmd_payload_mask;
      end if;
      pipelinedMemoryBusStage_rsp_regNext_payload_data <= pipelinedMemoryBusStage_rsp_payload_data;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity Apb3Gpio is
  port(
    io_apb_PADDR : in unsigned(3 downto 0);
    io_apb_PSEL : in std_logic_vector(0 downto 0);
    io_apb_PENABLE : in std_logic;
    io_apb_PREADY : out std_logic;
    io_apb_PWRITE : in std_logic;
    io_apb_PWDATA : in std_logic_vector(31 downto 0);
    io_apb_PRDATA : out std_logic_vector(31 downto 0);
    io_apb_PSLVERROR : out std_logic;
    io_gpio_read : in std_logic_vector(31 downto 0);
    io_gpio_write : out std_logic_vector(31 downto 0);
    io_gpio_writeEnable : out std_logic_vector(31 downto 0);
    io_value : out std_logic_vector(31 downto 0);
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end Apb3Gpio;

architecture arch of Apb3Gpio is
  signal io_apb_PREADY_read_buffer : std_logic;
  signal io_value_read_buffer : std_logic_vector(31 downto 0);
  signal io_gpio_read_buffercc_io_dataOut : std_logic_vector(31 downto 0);

  signal ctrl_askWrite : std_logic;
  signal ctrl_askRead : std_logic;
  signal ctrl_doWrite : std_logic;
  signal ctrl_doRead : std_logic;
  signal io_gpio_write_driver : std_logic_vector(31 downto 0);
  signal io_gpio_writeEnable_driver : std_logic_vector(31 downto 0);
begin
  io_apb_PREADY <= io_apb_PREADY_read_buffer;
  io_value <= io_value_read_buffer;
  io_gpio_read_buffercc : entity work.BufferCC_2
    port map ( 
      io_dataIn => io_gpio_read,
      io_dataOut => io_gpio_read_buffercc_io_dataOut,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  io_value_read_buffer <= io_gpio_read_buffercc_io_dataOut;
  io_apb_PREADY_read_buffer <= pkg_toStdLogic(true);
  process(io_apb_PADDR,io_value_read_buffer,io_gpio_write_driver,io_gpio_writeEnable_driver)
  begin
    io_apb_PRDATA <= pkg_stdLogicVector("00000000000000000000000000000000");
    case io_apb_PADDR is
      when "0000" =>
        io_apb_PRDATA(31 downto 0) <= io_value_read_buffer;
      when "0100" =>
        io_apb_PRDATA(31 downto 0) <= io_gpio_write_driver;
      when "1000" =>
        io_apb_PRDATA(31 downto 0) <= io_gpio_writeEnable_driver;
      when others =>
    end case;
  end process;

  io_apb_PSLVERROR <= pkg_toStdLogic(false);
  ctrl_askWrite <= ((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and io_apb_PWRITE);
  ctrl_askRead <= ((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and (not io_apb_PWRITE));
  ctrl_doWrite <= (((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and io_apb_PREADY_read_buffer) and io_apb_PWRITE);
  ctrl_doRead <= (((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and io_apb_PREADY_read_buffer) and (not io_apb_PWRITE));
  io_gpio_write <= io_gpio_write_driver;
  io_gpio_writeEnable <= io_gpio_writeEnable_driver;
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      io_gpio_writeEnable_driver <= pkg_stdLogicVector("00000000000000000000000000000000");
    elsif rising_edge(io_mainClk) then
      case io_apb_PADDR is
        when "1000" =>
          if ctrl_doWrite = '1' then
            io_gpio_writeEnable_driver <= pkg_extract(io_apb_PWDATA,31,0);
          end if;
        when others =>
      end case;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      case io_apb_PADDR is
        when "0100" =>
          if ctrl_doWrite = '1' then
            io_gpio_write_driver <= pkg_extract(io_apb_PWDATA,31,0);
          end if;
        when others =>
      end case;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity Apb3UartCtrl is
  port(
    io_apb_PADDR : in unsigned(4 downto 0);
    io_apb_PSEL : in std_logic_vector(0 downto 0);
    io_apb_PENABLE : in std_logic;
    io_apb_PREADY : out std_logic;
    io_apb_PWRITE : in std_logic;
    io_apb_PWDATA : in std_logic_vector(31 downto 0);
    io_apb_PRDATA : out std_logic_vector(31 downto 0);
    io_uart_txd : out std_logic;
    io_uart_rxd : in std_logic;
    io_interrupt : out std_logic;
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end Apb3UartCtrl;

architecture arch of Apb3UartCtrl is
  signal uartCtrl_1_io_read_queueWithOccupancy_io_pop_ready : std_logic;
  signal io_apb_PREADY_read_buffer : std_logic;
  signal uartCtrl_1_io_write_ready : std_logic;
  signal uartCtrl_1_io_read_valid : std_logic;
  signal uartCtrl_1_io_read_payload : std_logic_vector(7 downto 0);
  signal uartCtrl_1_io_uart_txd : std_logic;
  signal uartCtrl_1_io_readError : std_logic;
  signal uartCtrl_1_io_readBreak : std_logic;
  signal bridge_write_streamUnbuffered_queueWithOccupancy_io_push_ready : std_logic;
  signal bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid : std_logic;
  signal bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_payload : std_logic_vector(7 downto 0);
  signal bridge_write_streamUnbuffered_queueWithOccupancy_io_occupancy : unsigned(4 downto 0);
  signal bridge_write_streamUnbuffered_queueWithOccupancy_io_availability : unsigned(4 downto 0);
  signal uartCtrl_1_io_read_queueWithOccupancy_io_push_ready : std_logic;
  signal uartCtrl_1_io_read_queueWithOccupancy_io_pop_valid : std_logic;
  signal uartCtrl_1_io_read_queueWithOccupancy_io_pop_payload : std_logic_vector(7 downto 0);
  signal uartCtrl_1_io_read_queueWithOccupancy_io_occupancy : unsigned(4 downto 0);
  signal uartCtrl_1_io_read_queueWithOccupancy_io_availability : unsigned(4 downto 0);

  signal busCtrl_askWrite : std_logic;
  signal busCtrl_askRead : std_logic;
  signal busCtrl_doWrite : std_logic;
  signal busCtrl_doRead : std_logic;
  signal bridge_uartConfigReg_frame_dataLength : unsigned(2 downto 0);
  signal bridge_uartConfigReg_frame_stop : UartStopType_seq_type;
  signal bridge_uartConfigReg_frame_parity : UartParityType_seq_type;
  signal bridge_uartConfigReg_clockDivider : unsigned(19 downto 0);
  signal zz_bridge_write_streamUnbuffered_valid : std_logic;
  signal bridge_write_streamUnbuffered_valid : std_logic;
  signal bridge_write_streamUnbuffered_ready : std_logic;
  signal bridge_write_streamUnbuffered_payload : std_logic_vector(7 downto 0);
  signal bridge_read_streamBreaked_valid : std_logic;
  signal bridge_read_streamBreaked_ready : std_logic;
  signal bridge_read_streamBreaked_payload : std_logic_vector(7 downto 0);
  signal bridge_interruptCtrl_writeIntEnable : std_logic;
  signal bridge_interruptCtrl_readIntEnable : std_logic;
  signal bridge_interruptCtrl_readInt : std_logic;
  signal bridge_interruptCtrl_writeInt : std_logic;
  signal bridge_interruptCtrl_interrupt : std_logic;
  signal bridge_misc_readError : std_logic;
  signal when_BusSlaveFactory_l335 : std_logic;
  signal when_BusSlaveFactory_l341 : std_logic;
  signal bridge_misc_readOverflowError : std_logic;
  signal when_BusSlaveFactory_l335_1 : std_logic;
  signal when_BusSlaveFactory_l341_1 : std_logic;
  signal uartCtrl_1_io_read_isStall : std_logic;
  signal bridge_misc_breakDetected : std_logic;
  signal uartCtrl_1_io_readBreak_regNext : std_logic;
  signal when_UartCtrl_l155 : std_logic;
  signal when_BusSlaveFactory_l335_2 : std_logic;
  signal when_BusSlaveFactory_l341_2 : std_logic;
  signal bridge_misc_doBreak : std_logic;
  signal when_BusSlaveFactory_l371 : std_logic;
  signal when_BusSlaveFactory_l373 : std_logic;
  signal when_BusSlaveFactory_l335_3 : std_logic;
  signal when_BusSlaveFactory_l341_3 : std_logic;
  function zz_bridge_uartConfigReg_clockDivider return unsigned is
    variable bridge_uartConfigReg_clockDivider_v : unsigned(19 downto 0);
  begin
    bridge_uartConfigReg_clockDivider_v := pkg_unsigned("00000000000000000000");
    bridge_uartConfigReg_clockDivider_v := pkg_unsigned("00000000000001010101");
    return bridge_uartConfigReg_clockDivider_v;
  end function;
begin
  io_apb_PREADY <= io_apb_PREADY_read_buffer;
  uartCtrl_1 : entity work.UartCtrl
    port map ( 
      io_config_frame_dataLength => bridge_uartConfigReg_frame_dataLength,
      io_config_frame_stop => bridge_uartConfigReg_frame_stop,
      io_config_frame_parity => bridge_uartConfigReg_frame_parity,
      io_config_clockDivider => bridge_uartConfigReg_clockDivider,
      io_write_valid => bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid,
      io_write_ready => uartCtrl_1_io_write_ready,
      io_write_payload => bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_payload,
      io_read_valid => uartCtrl_1_io_read_valid,
      io_read_ready => uartCtrl_1_io_read_queueWithOccupancy_io_push_ready,
      io_read_payload => uartCtrl_1_io_read_payload,
      io_uart_txd => uartCtrl_1_io_uart_txd,
      io_uart_rxd => io_uart_rxd,
      io_readError => uartCtrl_1_io_readError,
      io_writeBreak => bridge_misc_doBreak,
      io_readBreak => uartCtrl_1_io_readBreak,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  bridge_write_streamUnbuffered_queueWithOccupancy : entity work.StreamFifo
    port map ( 
      io_push_valid => bridge_write_streamUnbuffered_valid,
      io_push_ready => bridge_write_streamUnbuffered_queueWithOccupancy_io_push_ready,
      io_push_payload => bridge_write_streamUnbuffered_payload,
      io_pop_valid => bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid,
      io_pop_ready => uartCtrl_1_io_write_ready,
      io_pop_payload => bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_payload,
      io_flush => pkg_toStdLogic(false),
      io_occupancy => bridge_write_streamUnbuffered_queueWithOccupancy_io_occupancy,
      io_availability => bridge_write_streamUnbuffered_queueWithOccupancy_io_availability,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  uartCtrl_1_io_read_queueWithOccupancy : entity work.StreamFifo
    port map ( 
      io_push_valid => uartCtrl_1_io_read_valid,
      io_push_ready => uartCtrl_1_io_read_queueWithOccupancy_io_push_ready,
      io_push_payload => uartCtrl_1_io_read_payload,
      io_pop_valid => uartCtrl_1_io_read_queueWithOccupancy_io_pop_valid,
      io_pop_ready => uartCtrl_1_io_read_queueWithOccupancy_io_pop_ready,
      io_pop_payload => uartCtrl_1_io_read_queueWithOccupancy_io_pop_payload,
      io_flush => pkg_toStdLogic(false),
      io_occupancy => uartCtrl_1_io_read_queueWithOccupancy_io_occupancy,
      io_availability => uartCtrl_1_io_read_queueWithOccupancy_io_availability,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  io_uart_txd <= uartCtrl_1_io_uart_txd;
  io_apb_PREADY_read_buffer <= pkg_toStdLogic(true);
  process(io_apb_PADDR,bridge_read_streamBreaked_valid,bridge_read_streamBreaked_payload,bridge_write_streamUnbuffered_queueWithOccupancy_io_occupancy,bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid,uartCtrl_1_io_read_queueWithOccupancy_io_occupancy,bridge_interruptCtrl_writeIntEnable,bridge_interruptCtrl_readIntEnable,bridge_interruptCtrl_writeInt,bridge_interruptCtrl_readInt,bridge_misc_readError,bridge_misc_readOverflowError,uartCtrl_1_io_readBreak,bridge_misc_breakDetected)
  begin
    io_apb_PRDATA <= pkg_stdLogicVector("00000000000000000000000000000000");
    case io_apb_PADDR is
      when "00000" =>
        io_apb_PRDATA(16 downto 16) <= pkg_toStdLogicVector((bridge_read_streamBreaked_valid xor pkg_toStdLogic(false)));
        io_apb_PRDATA(7 downto 0) <= bridge_read_streamBreaked_payload;
      when "00100" =>
        io_apb_PRDATA(20 downto 16) <= std_logic_vector((pkg_unsigned("10000") - bridge_write_streamUnbuffered_queueWithOccupancy_io_occupancy));
        io_apb_PRDATA(15 downto 15) <= pkg_toStdLogicVector(bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid);
        io_apb_PRDATA(28 downto 24) <= std_logic_vector(uartCtrl_1_io_read_queueWithOccupancy_io_occupancy);
        io_apb_PRDATA(0 downto 0) <= pkg_toStdLogicVector(bridge_interruptCtrl_writeIntEnable);
        io_apb_PRDATA(1 downto 1) <= pkg_toStdLogicVector(bridge_interruptCtrl_readIntEnable);
        io_apb_PRDATA(8 downto 8) <= pkg_toStdLogicVector(bridge_interruptCtrl_writeInt);
        io_apb_PRDATA(9 downto 9) <= pkg_toStdLogicVector(bridge_interruptCtrl_readInt);
      when "10000" =>
        io_apb_PRDATA(0 downto 0) <= pkg_toStdLogicVector(bridge_misc_readError);
        io_apb_PRDATA(1 downto 1) <= pkg_toStdLogicVector(bridge_misc_readOverflowError);
        io_apb_PRDATA(8 downto 8) <= pkg_toStdLogicVector(uartCtrl_1_io_readBreak);
        io_apb_PRDATA(9 downto 9) <= pkg_toStdLogicVector(bridge_misc_breakDetected);
      when others =>
    end case;
  end process;

  busCtrl_askWrite <= ((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and io_apb_PWRITE);
  busCtrl_askRead <= ((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and (not io_apb_PWRITE));
  busCtrl_doWrite <= (((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and io_apb_PREADY_read_buffer) and io_apb_PWRITE);
  busCtrl_doRead <= (((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and io_apb_PREADY_read_buffer) and (not io_apb_PWRITE));
  bridge_uartConfigReg_clockDivider <= zz_bridge_uartConfigReg_clockDivider;
  bridge_uartConfigReg_frame_dataLength <= pkg_unsigned("111");
  bridge_uartConfigReg_frame_parity <= UartParityType_seq_NONE;
  bridge_uartConfigReg_frame_stop <= UartStopType_seq_ONE;
  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    zz_bridge_write_streamUnbuffered_valid <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "00000" =>
        if busCtrl_doWrite = '1' then
          zz_bridge_write_streamUnbuffered_valid <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  bridge_write_streamUnbuffered_valid <= zz_bridge_write_streamUnbuffered_valid;
  bridge_write_streamUnbuffered_payload <= pkg_extract(io_apb_PWDATA,7,0);
  bridge_write_streamUnbuffered_ready <= bridge_write_streamUnbuffered_queueWithOccupancy_io_push_ready;
  process(uartCtrl_1_io_read_queueWithOccupancy_io_pop_valid,uartCtrl_1_io_readBreak)
  begin
    bridge_read_streamBreaked_valid <= uartCtrl_1_io_read_queueWithOccupancy_io_pop_valid;
    if uartCtrl_1_io_readBreak = '1' then
      bridge_read_streamBreaked_valid <= pkg_toStdLogic(false);
    end if;
  end process;

  process(bridge_read_streamBreaked_ready,uartCtrl_1_io_readBreak)
  begin
    uartCtrl_1_io_read_queueWithOccupancy_io_pop_ready <= bridge_read_streamBreaked_ready;
    if uartCtrl_1_io_readBreak = '1' then
      uartCtrl_1_io_read_queueWithOccupancy_io_pop_ready <= pkg_toStdLogic(true);
    end if;
  end process;

  bridge_read_streamBreaked_payload <= uartCtrl_1_io_read_queueWithOccupancy_io_pop_payload;
  process(io_apb_PADDR,busCtrl_doRead)
  begin
    bridge_read_streamBreaked_ready <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "00000" =>
        if busCtrl_doRead = '1' then
          bridge_read_streamBreaked_ready <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  bridge_interruptCtrl_readInt <= (bridge_interruptCtrl_readIntEnable and bridge_read_streamBreaked_valid);
  bridge_interruptCtrl_writeInt <= (bridge_interruptCtrl_writeIntEnable and (not bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid));
  bridge_interruptCtrl_interrupt <= (bridge_interruptCtrl_readInt or bridge_interruptCtrl_writeInt);
  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    when_BusSlaveFactory_l335 <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "10000" =>
        if busCtrl_doWrite = '1' then
          when_BusSlaveFactory_l335 <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  when_BusSlaveFactory_l341 <= pkg_extract(io_apb_PWDATA,0);
  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    when_BusSlaveFactory_l335_1 <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "10000" =>
        if busCtrl_doWrite = '1' then
          when_BusSlaveFactory_l335_1 <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  when_BusSlaveFactory_l341_1 <= pkg_extract(io_apb_PWDATA,1);
  uartCtrl_1_io_read_isStall <= (uartCtrl_1_io_read_valid and (not uartCtrl_1_io_read_queueWithOccupancy_io_push_ready));
  when_UartCtrl_l155 <= (uartCtrl_1_io_readBreak and (not uartCtrl_1_io_readBreak_regNext));
  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    when_BusSlaveFactory_l335_2 <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "10000" =>
        if busCtrl_doWrite = '1' then
          when_BusSlaveFactory_l335_2 <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  when_BusSlaveFactory_l341_2 <= pkg_extract(io_apb_PWDATA,9);
  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    when_BusSlaveFactory_l371 <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "10000" =>
        if busCtrl_doWrite = '1' then
          when_BusSlaveFactory_l371 <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  when_BusSlaveFactory_l373 <= pkg_extract(io_apb_PWDATA,10);
  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    when_BusSlaveFactory_l335_3 <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "10000" =>
        if busCtrl_doWrite = '1' then
          when_BusSlaveFactory_l335_3 <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  when_BusSlaveFactory_l341_3 <= pkg_extract(io_apb_PWDATA,11);
  io_interrupt <= bridge_interruptCtrl_interrupt;
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      bridge_interruptCtrl_writeIntEnable <= pkg_toStdLogic(false);
      bridge_interruptCtrl_readIntEnable <= pkg_toStdLogic(false);
      bridge_misc_readError <= pkg_toStdLogic(false);
      bridge_misc_readOverflowError <= pkg_toStdLogic(false);
      bridge_misc_breakDetected <= pkg_toStdLogic(false);
      bridge_misc_doBreak <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      if when_BusSlaveFactory_l335 = '1' then
        if when_BusSlaveFactory_l341 = '1' then
          bridge_misc_readError <= pkg_extract(pkg_stdLogicVector("0"),0);
        end if;
      end if;
      if uartCtrl_1_io_readError = '1' then
        bridge_misc_readError <= pkg_toStdLogic(true);
      end if;
      if when_BusSlaveFactory_l335_1 = '1' then
        if when_BusSlaveFactory_l341_1 = '1' then
          bridge_misc_readOverflowError <= pkg_extract(pkg_stdLogicVector("0"),0);
        end if;
      end if;
      if uartCtrl_1_io_read_isStall = '1' then
        bridge_misc_readOverflowError <= pkg_toStdLogic(true);
      end if;
      if when_UartCtrl_l155 = '1' then
        bridge_misc_breakDetected <= pkg_toStdLogic(true);
      end if;
      if when_BusSlaveFactory_l335_2 = '1' then
        if when_BusSlaveFactory_l341_2 = '1' then
          bridge_misc_breakDetected <= pkg_extract(pkg_stdLogicVector("0"),0);
        end if;
      end if;
      if when_BusSlaveFactory_l371 = '1' then
        if when_BusSlaveFactory_l373 = '1' then
          bridge_misc_doBreak <= pkg_extract(pkg_stdLogicVector("1"),0);
        end if;
      end if;
      if when_BusSlaveFactory_l335_3 = '1' then
        if when_BusSlaveFactory_l341_3 = '1' then
          bridge_misc_doBreak <= pkg_extract(pkg_stdLogicVector("0"),0);
        end if;
      end if;
      case io_apb_PADDR is
        when "00100" =>
          if busCtrl_doWrite = '1' then
            bridge_interruptCtrl_writeIntEnable <= pkg_extract(io_apb_PWDATA,0);
            bridge_interruptCtrl_readIntEnable <= pkg_extract(io_apb_PWDATA,1);
          end if;
        when others =>
      end case;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      uartCtrl_1_io_readBreak_regNext <= uartCtrl_1_io_readBreak;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity MuraxApb3Timer is
  port(
    io_apb_PADDR : in unsigned(7 downto 0);
    io_apb_PSEL : in std_logic_vector(0 downto 0);
    io_apb_PENABLE : in std_logic;
    io_apb_PREADY : out std_logic;
    io_apb_PWRITE : in std_logic;
    io_apb_PWDATA : in std_logic_vector(31 downto 0);
    io_apb_PRDATA : out std_logic_vector(31 downto 0);
    io_apb_PSLVERROR : out std_logic;
    io_interrupt : out std_logic;
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end MuraxApb3Timer;

architecture arch of MuraxApb3Timer is
  signal timerA_io_tick : std_logic;
  signal timerA_io_clear : std_logic;
  signal timerB_io_tick : std_logic;
  signal timerB_io_clear : std_logic;
  signal interruptCtrl_1_io_inputs : std_logic_vector(1 downto 0);
  signal interruptCtrl_1_io_clears : std_logic_vector(1 downto 0);
  signal io_apb_PREADY_read_buffer : std_logic;
  signal prescaler_1_io_overflow : std_logic;
  signal timerA_io_full : std_logic;
  signal timerA_io_value : unsigned(15 downto 0);
  signal timerB_io_full : std_logic;
  signal timerB_io_value : unsigned(15 downto 0);
  signal interruptCtrl_1_io_pendings : std_logic_vector(1 downto 0);

  signal busCtrl_askWrite : std_logic;
  signal busCtrl_askRead : std_logic;
  signal busCtrl_doWrite : std_logic;
  signal busCtrl_doRead : std_logic;
  signal zz_io_limit : unsigned(15 downto 0);
  signal zz_io_clear : std_logic;
  signal timerABridge_ticksEnable : std_logic_vector(1 downto 0);
  signal timerABridge_clearsEnable : std_logic_vector(0 downto 0);
  signal timerABridge_busClearing : std_logic;
  signal timerA_io_limit_driver : unsigned(15 downto 0);
  signal when_Timer_l40 : std_logic;
  signal when_Timer_l44 : std_logic;
  signal timerBBridge_ticksEnable : std_logic_vector(1 downto 0);
  signal timerBBridge_clearsEnable : std_logic_vector(0 downto 0);
  signal timerBBridge_busClearing : std_logic;
  signal timerB_io_limit_driver : unsigned(15 downto 0);
  signal when_Timer_l40_1 : std_logic;
  signal when_Timer_l44_1 : std_logic;
  signal interruptCtrl_1_io_masks_driver : std_logic_vector(1 downto 0);
begin
  io_apb_PREADY <= io_apb_PREADY_read_buffer;
  prescaler_1 : entity work.Prescaler
    port map ( 
      io_clear => zz_io_clear,
      io_limit => zz_io_limit,
      io_overflow => prescaler_1_io_overflow,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  timerA : entity work.Timer
    port map ( 
      io_tick => timerA_io_tick,
      io_clear => timerA_io_clear,
      io_limit => timerA_io_limit_driver,
      io_full => timerA_io_full,
      io_value => timerA_io_value,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  timerB : entity work.Timer
    port map ( 
      io_tick => timerB_io_tick,
      io_clear => timerB_io_clear,
      io_limit => timerB_io_limit_driver,
      io_full => timerB_io_full,
      io_value => timerB_io_value,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  interruptCtrl_1 : entity work.InterruptCtrl
    port map ( 
      io_inputs => interruptCtrl_1_io_inputs,
      io_clears => interruptCtrl_1_io_clears,
      io_masks => interruptCtrl_1_io_masks_driver,
      io_pendings => interruptCtrl_1_io_pendings,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  io_apb_PREADY_read_buffer <= pkg_toStdLogic(true);
  process(io_apb_PADDR,zz_io_limit,timerABridge_ticksEnable,timerABridge_clearsEnable,timerA_io_limit_driver,timerA_io_value,timerBBridge_ticksEnable,timerBBridge_clearsEnable,timerB_io_limit_driver,timerB_io_value,interruptCtrl_1_io_pendings,interruptCtrl_1_io_masks_driver)
  begin
    io_apb_PRDATA <= pkg_stdLogicVector("00000000000000000000000000000000");
    case io_apb_PADDR is
      when "00000000" =>
        io_apb_PRDATA(15 downto 0) <= std_logic_vector(zz_io_limit);
      when "01000000" =>
        io_apb_PRDATA(1 downto 0) <= timerABridge_ticksEnable;
        io_apb_PRDATA(16 downto 16) <= timerABridge_clearsEnable;
      when "01000100" =>
        io_apb_PRDATA(15 downto 0) <= std_logic_vector(timerA_io_limit_driver);
      when "01001000" =>
        io_apb_PRDATA(15 downto 0) <= std_logic_vector(timerA_io_value);
      when "01010000" =>
        io_apb_PRDATA(1 downto 0) <= timerBBridge_ticksEnable;
        io_apb_PRDATA(16 downto 16) <= timerBBridge_clearsEnable;
      when "01010100" =>
        io_apb_PRDATA(15 downto 0) <= std_logic_vector(timerB_io_limit_driver);
      when "01011000" =>
        io_apb_PRDATA(15 downto 0) <= std_logic_vector(timerB_io_value);
      when "00010000" =>
        io_apb_PRDATA(1 downto 0) <= interruptCtrl_1_io_pendings;
      when "00010100" =>
        io_apb_PRDATA(1 downto 0) <= interruptCtrl_1_io_masks_driver;
      when others =>
    end case;
  end process;

  io_apb_PSLVERROR <= pkg_toStdLogic(false);
  busCtrl_askWrite <= ((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and io_apb_PWRITE);
  busCtrl_askRead <= ((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and (not io_apb_PWRITE));
  busCtrl_doWrite <= (((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and io_apb_PREADY_read_buffer) and io_apb_PWRITE);
  busCtrl_doRead <= (((pkg_extract(io_apb_PSEL,0) and io_apb_PENABLE) and io_apb_PREADY_read_buffer) and (not io_apb_PWRITE));
  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    zz_io_clear <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "00000000" =>
        if busCtrl_doWrite = '1' then
          zz_io_clear <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  process(when_Timer_l40,when_Timer_l44)
  begin
    timerABridge_busClearing <= pkg_toStdLogic(false);
    if when_Timer_l40 = '1' then
      timerABridge_busClearing <= pkg_toStdLogic(true);
    end if;
    if when_Timer_l44 = '1' then
      timerABridge_busClearing <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    when_Timer_l40 <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "01000100" =>
        if busCtrl_doWrite = '1' then
          when_Timer_l40 <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    when_Timer_l44 <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "01001000" =>
        if busCtrl_doWrite = '1' then
          when_Timer_l44 <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  timerA_io_clear <= (pkg_toStdLogic((timerABridge_clearsEnable and pkg_toStdLogicVector(timerA_io_full)) /= pkg_stdLogicVector("0")) or timerABridge_busClearing);
  timerA_io_tick <= pkg_toStdLogic((timerABridge_ticksEnable and pkg_cat(pkg_toStdLogicVector(prescaler_1_io_overflow),pkg_toStdLogicVector(pkg_toStdLogic(true)))) /= pkg_stdLogicVector("00"));
  process(when_Timer_l40_1,when_Timer_l44_1)
  begin
    timerBBridge_busClearing <= pkg_toStdLogic(false);
    if when_Timer_l40_1 = '1' then
      timerBBridge_busClearing <= pkg_toStdLogic(true);
    end if;
    if when_Timer_l44_1 = '1' then
      timerBBridge_busClearing <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    when_Timer_l40_1 <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "01010100" =>
        if busCtrl_doWrite = '1' then
          when_Timer_l40_1 <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  process(io_apb_PADDR,busCtrl_doWrite)
  begin
    when_Timer_l44_1 <= pkg_toStdLogic(false);
    case io_apb_PADDR is
      when "01011000" =>
        if busCtrl_doWrite = '1' then
          when_Timer_l44_1 <= pkg_toStdLogic(true);
        end if;
      when others =>
    end case;
  end process;

  timerB_io_clear <= (pkg_toStdLogic((timerBBridge_clearsEnable and pkg_toStdLogicVector(timerB_io_full)) /= pkg_stdLogicVector("0")) or timerBBridge_busClearing);
  timerB_io_tick <= pkg_toStdLogic((timerBBridge_ticksEnable and pkg_cat(pkg_toStdLogicVector(prescaler_1_io_overflow),pkg_toStdLogicVector(pkg_toStdLogic(true)))) /= pkg_stdLogicVector("00"));
  process(io_apb_PADDR,busCtrl_doWrite,io_apb_PWDATA)
  begin
    interruptCtrl_1_io_clears <= pkg_stdLogicVector("00");
    case io_apb_PADDR is
      when "00010000" =>
        if busCtrl_doWrite = '1' then
          interruptCtrl_1_io_clears <= pkg_extract(io_apb_PWDATA,1,0);
        end if;
      when others =>
    end case;
  end process;

  process(timerA_io_full,timerB_io_full)
  begin
    interruptCtrl_1_io_inputs(0) <= timerA_io_full;
    interruptCtrl_1_io_inputs(1) <= timerB_io_full;
  end process;

  io_interrupt <= pkg_toStdLogic(interruptCtrl_1_io_pendings /= pkg_stdLogicVector("00"));
  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      timerABridge_ticksEnable <= pkg_stdLogicVector("00");
      timerABridge_clearsEnable <= pkg_stdLogicVector("0");
      timerBBridge_ticksEnable <= pkg_stdLogicVector("00");
      timerBBridge_clearsEnable <= pkg_stdLogicVector("0");
      interruptCtrl_1_io_masks_driver <= pkg_stdLogicVector("00");
    elsif rising_edge(io_mainClk) then
      case io_apb_PADDR is
        when "01000000" =>
          if busCtrl_doWrite = '1' then
            timerABridge_ticksEnable <= pkg_extract(io_apb_PWDATA,1,0);
            timerABridge_clearsEnable <= pkg_extract(io_apb_PWDATA,16,16);
          end if;
        when "01010000" =>
          if busCtrl_doWrite = '1' then
            timerBBridge_ticksEnable <= pkg_extract(io_apb_PWDATA,1,0);
            timerBBridge_clearsEnable <= pkg_extract(io_apb_PWDATA,16,16);
          end if;
        when "00010100" =>
          if busCtrl_doWrite = '1' then
            interruptCtrl_1_io_masks_driver <= pkg_extract(io_apb_PWDATA,1,0);
          end if;
        when others =>
      end case;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      case io_apb_PADDR is
        when "00000000" =>
          if busCtrl_doWrite = '1' then
            zz_io_limit <= unsigned(pkg_extract(io_apb_PWDATA,15,0));
          end if;
        when "01000100" =>
          if busCtrl_doWrite = '1' then
            timerA_io_limit_driver <= unsigned(pkg_extract(io_apb_PWDATA,15,0));
          end if;
        when "01010100" =>
          if busCtrl_doWrite = '1' then
            timerB_io_limit_driver <= unsigned(pkg_extract(io_apb_PWDATA,15,0));
          end if;
        when others =>
      end case;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity Apb3Decoder is
  port(
    io_input_PADDR : in unsigned(19 downto 0);
    io_input_PSEL : in std_logic_vector(0 downto 0);
    io_input_PENABLE : in std_logic;
    io_input_PREADY : out std_logic;
    io_input_PWRITE : in std_logic;
    io_input_PWDATA : in std_logic_vector(31 downto 0);
    io_input_PRDATA : out std_logic_vector(31 downto 0);
    io_input_PSLVERROR : out std_logic;
    io_output_PADDR : out unsigned(19 downto 0);
    io_output_PSEL : out std_logic_vector(2 downto 0);
    io_output_PENABLE : out std_logic;
    io_output_PREADY : in std_logic;
    io_output_PWRITE : out std_logic;
    io_output_PWDATA : out std_logic_vector(31 downto 0);
    io_output_PRDATA : in std_logic_vector(31 downto 0);
    io_output_PSLVERROR : in std_logic
  );
end Apb3Decoder;

architecture arch of Apb3Decoder is
  signal io_output_PSEL_read_buffer : std_logic_vector(2 downto 0);

  signal when_Apb3Decoder_l88 : std_logic;
begin
  io_output_PSEL <= io_output_PSEL_read_buffer;
  io_output_PADDR <= io_input_PADDR;
  io_output_PENABLE <= io_input_PENABLE;
  io_output_PWRITE <= io_input_PWRITE;
  io_output_PWDATA <= io_input_PWDATA;
  process(io_input_PADDR,io_input_PSEL)
  begin
    io_output_PSEL_read_buffer(0) <= (pkg_toStdLogic((io_input_PADDR and pkg_not(pkg_unsigned("00000000111111111111"))) = pkg_unsigned("00000000000000000000")) and pkg_extract(io_input_PSEL,0));
    io_output_PSEL_read_buffer(1) <= (pkg_toStdLogic((io_input_PADDR and pkg_not(pkg_unsigned("00000000111111111111"))) = pkg_unsigned("00010000000000000000")) and pkg_extract(io_input_PSEL,0));
    io_output_PSEL_read_buffer(2) <= (pkg_toStdLogic((io_input_PADDR and pkg_not(pkg_unsigned("00000000111111111111"))) = pkg_unsigned("00100000000000000000")) and pkg_extract(io_input_PSEL,0));
  end process;

  process(io_output_PREADY,when_Apb3Decoder_l88)
  begin
    io_input_PREADY <= io_output_PREADY;
    if when_Apb3Decoder_l88 = '1' then
      io_input_PREADY <= pkg_toStdLogic(true);
    end if;
  end process;

  io_input_PRDATA <= io_output_PRDATA;
  process(io_output_PSLVERROR,when_Apb3Decoder_l88)
  begin
    io_input_PSLVERROR <= io_output_PSLVERROR;
    if when_Apb3Decoder_l88 = '1' then
      io_input_PSLVERROR <= pkg_toStdLogic(true);
    end if;
  end process;

  when_Apb3Decoder_l88 <= (pkg_extract(io_input_PSEL,0) and pkg_toStdLogic(io_output_PSEL_read_buffer = pkg_stdLogicVector("000")));
end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity Apb3Router is
  port(
    io_input_PADDR : in unsigned(19 downto 0);
    io_input_PSEL : in std_logic_vector(2 downto 0);
    io_input_PENABLE : in std_logic;
    io_input_PREADY : out std_logic;
    io_input_PWRITE : in std_logic;
    io_input_PWDATA : in std_logic_vector(31 downto 0);
    io_input_PRDATA : out std_logic_vector(31 downto 0);
    io_input_PSLVERROR : out std_logic;
    io_outputs_0_PADDR : out unsigned(19 downto 0);
    io_outputs_0_PSEL : out std_logic_vector(0 downto 0);
    io_outputs_0_PENABLE : out std_logic;
    io_outputs_0_PREADY : in std_logic;
    io_outputs_0_PWRITE : out std_logic;
    io_outputs_0_PWDATA : out std_logic_vector(31 downto 0);
    io_outputs_0_PRDATA : in std_logic_vector(31 downto 0);
    io_outputs_0_PSLVERROR : in std_logic;
    io_outputs_1_PADDR : out unsigned(19 downto 0);
    io_outputs_1_PSEL : out std_logic_vector(0 downto 0);
    io_outputs_1_PENABLE : out std_logic;
    io_outputs_1_PREADY : in std_logic;
    io_outputs_1_PWRITE : out std_logic;
    io_outputs_1_PWDATA : out std_logic_vector(31 downto 0);
    io_outputs_1_PRDATA : in std_logic_vector(31 downto 0);
    io_outputs_1_PSLVERROR : in std_logic;
    io_outputs_2_PADDR : out unsigned(19 downto 0);
    io_outputs_2_PSEL : out std_logic_vector(0 downto 0);
    io_outputs_2_PENABLE : out std_logic;
    io_outputs_2_PREADY : in std_logic;
    io_outputs_2_PWRITE : out std_logic;
    io_outputs_2_PWDATA : out std_logic_vector(31 downto 0);
    io_outputs_2_PRDATA : in std_logic_vector(31 downto 0);
    io_outputs_2_PSLVERROR : in std_logic;
    io_mainClk : in std_logic;
    resetCtrl_systemReset : in std_logic
  );
end Apb3Router;

architecture arch of Apb3Router is
  signal zz_io_input_PREADY : std_logic;
  signal zz_io_input_PRDATA : std_logic_vector(31 downto 0);
  signal zz_io_input_PSLVERROR : std_logic;

  signal zz_selIndex : std_logic;
  signal zz_selIndex_1 : std_logic;
  signal selIndex : unsigned(1 downto 0);
begin
  process(selIndex,io_outputs_0_PREADY,io_outputs_0_PRDATA,io_outputs_0_PSLVERROR,io_outputs_1_PREADY,io_outputs_1_PRDATA,io_outputs_1_PSLVERROR,io_outputs_2_PREADY,io_outputs_2_PRDATA,io_outputs_2_PSLVERROR)
  begin
    case selIndex is
      when "00" =>
        zz_io_input_PREADY <= io_outputs_0_PREADY;
        zz_io_input_PRDATA <= io_outputs_0_PRDATA;
        zz_io_input_PSLVERROR <= io_outputs_0_PSLVERROR;
      when "01" =>
        zz_io_input_PREADY <= io_outputs_1_PREADY;
        zz_io_input_PRDATA <= io_outputs_1_PRDATA;
        zz_io_input_PSLVERROR <= io_outputs_1_PSLVERROR;
      when others =>
        zz_io_input_PREADY <= io_outputs_2_PREADY;
        zz_io_input_PRDATA <= io_outputs_2_PRDATA;
        zz_io_input_PSLVERROR <= io_outputs_2_PSLVERROR;
    end case;
  end process;

  io_outputs_0_PADDR <= io_input_PADDR;
  io_outputs_0_PENABLE <= io_input_PENABLE;
  io_outputs_0_PSEL(0) <= pkg_extract(io_input_PSEL,0);
  io_outputs_0_PWRITE <= io_input_PWRITE;
  io_outputs_0_PWDATA <= io_input_PWDATA;
  io_outputs_1_PADDR <= io_input_PADDR;
  io_outputs_1_PENABLE <= io_input_PENABLE;
  io_outputs_1_PSEL(0) <= pkg_extract(io_input_PSEL,1);
  io_outputs_1_PWRITE <= io_input_PWRITE;
  io_outputs_1_PWDATA <= io_input_PWDATA;
  io_outputs_2_PADDR <= io_input_PADDR;
  io_outputs_2_PENABLE <= io_input_PENABLE;
  io_outputs_2_PSEL(0) <= pkg_extract(io_input_PSEL,2);
  io_outputs_2_PWRITE <= io_input_PWRITE;
  io_outputs_2_PWDATA <= io_input_PWDATA;
  zz_selIndex <= pkg_extract(io_input_PSEL,1);
  zz_selIndex_1 <= pkg_extract(io_input_PSEL,2);
  io_input_PREADY <= zz_io_input_PREADY;
  io_input_PRDATA <= zz_io_input_PRDATA;
  io_input_PSLVERROR <= zz_io_input_PSLVERROR;
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      selIndex <= unsigned(pkg_cat(pkg_toStdLogicVector(zz_selIndex_1),pkg_toStdLogicVector(zz_selIndex)));
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity Murax is
  port(
    io_asyncReset : in std_logic;
    io_mainClk : in std_logic;
    io_jtag_tms : in std_logic;
    io_jtag_tdi : in std_logic;
    io_jtag_tdo : out std_logic;
    io_jtag_tck : in std_logic;
    io_gpioA_read : in std_logic_vector(31 downto 0);
    io_gpioA_write : out std_logic_vector(31 downto 0);
    io_gpioA_writeEnable : out std_logic_vector(31 downto 0);
    io_uart_txd : out std_logic;
    io_uart_rxd : in std_logic
  );
end Murax;

architecture arch of Murax is
  signal system_cpu_debug_bus_cmd_payload_address : unsigned(7 downto 0);
  signal system_cpu_dBus_cmd_ready : std_logic;
  signal system_ram_io_bus_cmd_valid : std_logic;
  signal system_apbBridge_io_pipelinedMemoryBus_cmd_valid : std_logic;
  signal system_gpioACtrl_io_apb_PADDR : unsigned(3 downto 0);
  signal system_uartCtrl_io_apb_PADDR : unsigned(4 downto 0);
  signal system_timer_io_apb_PADDR : unsigned(7 downto 0);
  signal io_asyncReset_buffercc_io_dataOut : std_logic;
  signal system_mainBusArbiter_io_iBus_cmd_ready : std_logic;
  signal system_mainBusArbiter_io_iBus_rsp_valid : std_logic;
  signal system_mainBusArbiter_io_iBus_rsp_payload_error : std_logic;
  signal system_mainBusArbiter_io_iBus_rsp_payload_inst : std_logic_vector(31 downto 0);
  signal system_mainBusArbiter_io_dBus_cmd_ready : std_logic;
  signal system_mainBusArbiter_io_dBus_rsp_ready : std_logic;
  signal system_mainBusArbiter_io_dBus_rsp_error : std_logic;
  signal system_mainBusArbiter_io_dBus_rsp_data : std_logic_vector(31 downto 0);
  signal system_mainBusArbiter_io_masterBus_cmd_valid : std_logic;
  signal system_mainBusArbiter_io_masterBus_cmd_payload_write : std_logic;
  signal system_mainBusArbiter_io_masterBus_cmd_payload_address : unsigned(31 downto 0);
  signal system_mainBusArbiter_io_masterBus_cmd_payload_data : std_logic_vector(31 downto 0);
  signal system_mainBusArbiter_io_masterBus_cmd_payload_mask : std_logic_vector(3 downto 0);
  signal system_cpu_iBus_cmd_valid : std_logic;
  signal system_cpu_iBus_cmd_payload_pc : unsigned(31 downto 0);
  signal system_cpu_debug_bus_cmd_ready : std_logic;
  signal system_cpu_debug_bus_rsp_data : std_logic_vector(31 downto 0);
  signal system_cpu_debug_resetOut : std_logic;
  signal system_cpu_dBus_cmd_valid : std_logic;
  signal system_cpu_dBus_cmd_payload_wr : std_logic;
  signal system_cpu_dBus_cmd_payload_address : unsigned(31 downto 0);
  signal system_cpu_dBus_cmd_payload_data : std_logic_vector(31 downto 0);
  signal system_cpu_dBus_cmd_payload_size : unsigned(1 downto 0);
  signal jtagBridge_1_io_jtag_tdo : std_logic;
  signal jtagBridge_1_io_remote_cmd_valid : std_logic;
  signal jtagBridge_1_io_remote_cmd_payload_last : std_logic;
  signal jtagBridge_1_io_remote_cmd_payload_fragment : std_logic_vector(0 downto 0);
  signal jtagBridge_1_io_remote_rsp_ready : std_logic;
  signal systemDebugger_1_io_remote_cmd_ready : std_logic;
  signal systemDebugger_1_io_remote_rsp_valid : std_logic;
  signal systemDebugger_1_io_remote_rsp_payload_error : std_logic;
  signal systemDebugger_1_io_remote_rsp_payload_data : std_logic_vector(31 downto 0);
  signal systemDebugger_1_io_mem_cmd_valid : std_logic;
  signal systemDebugger_1_io_mem_cmd_payload_address : unsigned(31 downto 0);
  signal systemDebugger_1_io_mem_cmd_payload_data : std_logic_vector(31 downto 0);
  signal systemDebugger_1_io_mem_cmd_payload_wr : std_logic;
  signal systemDebugger_1_io_mem_cmd_payload_size : unsigned(1 downto 0);
  signal system_ram_io_bus_cmd_ready : std_logic;
  signal system_ram_io_bus_rsp_valid : std_logic;
  signal system_ram_io_bus_rsp_payload_data : std_logic_vector(31 downto 0);
  signal system_apbBridge_io_pipelinedMemoryBus_cmd_ready : std_logic;
  signal system_apbBridge_io_pipelinedMemoryBus_rsp_valid : std_logic;
  signal system_apbBridge_io_pipelinedMemoryBus_rsp_payload_data : std_logic_vector(31 downto 0);
  signal system_apbBridge_io_apb_PADDR : unsigned(19 downto 0);
  signal system_apbBridge_io_apb_PSEL : std_logic_vector(0 downto 0);
  signal system_apbBridge_io_apb_PENABLE : std_logic;
  signal system_apbBridge_io_apb_PWRITE : std_logic;
  signal system_apbBridge_io_apb_PWDATA : std_logic_vector(31 downto 0);
  signal system_gpioACtrl_io_apb_PREADY : std_logic;
  signal system_gpioACtrl_io_apb_PRDATA : std_logic_vector(31 downto 0);
  signal system_gpioACtrl_io_apb_PSLVERROR : std_logic;
  signal system_gpioACtrl_io_gpio_write : std_logic_vector(31 downto 0);
  signal system_gpioACtrl_io_gpio_writeEnable : std_logic_vector(31 downto 0);
  signal system_gpioACtrl_io_value : std_logic_vector(31 downto 0);
  signal system_uartCtrl_io_apb_PREADY : std_logic;
  signal system_uartCtrl_io_apb_PRDATA : std_logic_vector(31 downto 0);
  signal system_uartCtrl_io_uart_txd : std_logic;
  signal system_uartCtrl_io_interrupt : std_logic;
  signal system_timer_io_apb_PREADY : std_logic;
  signal system_timer_io_apb_PRDATA : std_logic_vector(31 downto 0);
  signal system_timer_io_apb_PSLVERROR : std_logic;
  signal system_timer_io_interrupt : std_logic;
  signal io_apb_decoder_io_input_PREADY : std_logic;
  signal io_apb_decoder_io_input_PRDATA : std_logic_vector(31 downto 0);
  signal io_apb_decoder_io_input_PSLVERROR : std_logic;
  signal io_apb_decoder_io_output_PADDR : unsigned(19 downto 0);
  signal io_apb_decoder_io_output_PSEL : std_logic_vector(2 downto 0);
  signal io_apb_decoder_io_output_PENABLE : std_logic;
  signal io_apb_decoder_io_output_PWRITE : std_logic;
  signal io_apb_decoder_io_output_PWDATA : std_logic_vector(31 downto 0);
  signal apb3Router_1_io_input_PREADY : std_logic;
  signal apb3Router_1_io_input_PRDATA : std_logic_vector(31 downto 0);
  signal apb3Router_1_io_input_PSLVERROR : std_logic;
  signal apb3Router_1_io_outputs_0_PADDR : unsigned(19 downto 0);
  signal apb3Router_1_io_outputs_0_PSEL : std_logic_vector(0 downto 0);
  signal apb3Router_1_io_outputs_0_PENABLE : std_logic;
  signal apb3Router_1_io_outputs_0_PWRITE : std_logic;
  signal apb3Router_1_io_outputs_0_PWDATA : std_logic_vector(31 downto 0);
  signal apb3Router_1_io_outputs_1_PADDR : unsigned(19 downto 0);
  signal apb3Router_1_io_outputs_1_PSEL : std_logic_vector(0 downto 0);
  signal apb3Router_1_io_outputs_1_PENABLE : std_logic;
  signal apb3Router_1_io_outputs_1_PWRITE : std_logic;
  signal apb3Router_1_io_outputs_1_PWDATA : std_logic_vector(31 downto 0);
  signal apb3Router_1_io_outputs_2_PADDR : unsigned(19 downto 0);
  signal apb3Router_1_io_outputs_2_PSEL : std_logic_vector(0 downto 0);
  signal apb3Router_1_io_outputs_2_PENABLE : std_logic;
  signal apb3Router_1_io_outputs_2_PWRITE : std_logic;
  signal apb3Router_1_io_outputs_2_PWDATA : std_logic_vector(31 downto 0);
  signal zz_system_mainBusDecoder_logic_masterPipelined_rsp_payload_data : std_logic_vector(31 downto 0);

  signal resetCtrl_mainClkResetUnbuffered : std_logic;
  signal resetCtrl_systemClkResetCounter : unsigned(5 downto 0) := pkg_unsigned("000000");
  signal zz_when_Murax_l188 : unsigned(5 downto 0);
  signal when_Murax_l188 : std_logic;
  signal when_Murax_l192 : std_logic;
  signal resetCtrl_mainClkReset : std_logic;
  signal resetCtrl_systemReset : std_logic;
  signal system_timerInterrupt : std_logic;
  signal system_externalInterrupt : std_logic;
  signal system_cpu_dBus_cmd_halfPipe_valid : std_logic;
  signal system_cpu_dBus_cmd_halfPipe_ready : std_logic;
  signal system_cpu_dBus_cmd_halfPipe_payload_wr : std_logic;
  signal system_cpu_dBus_cmd_halfPipe_payload_address : unsigned(31 downto 0);
  signal system_cpu_dBus_cmd_halfPipe_payload_data : std_logic_vector(31 downto 0);
  signal system_cpu_dBus_cmd_halfPipe_payload_size : unsigned(1 downto 0);
  signal system_cpu_dBus_cmd_rValid : std_logic;
  signal system_cpu_dBus_cmd_halfPipe_fire : std_logic;
  signal system_cpu_dBus_cmd_rData_wr : std_logic;
  signal system_cpu_dBus_cmd_rData_address : unsigned(31 downto 0);
  signal system_cpu_dBus_cmd_rData_data : std_logic_vector(31 downto 0);
  signal system_cpu_dBus_cmd_rData_size : unsigned(1 downto 0);
  signal system_cpu_debug_resetOut_regNext : std_logic;
  signal system_cpu_debug_bus_cmd_fire : std_logic;
  signal system_cpu_debug_bus_cmd_fire_regNext : std_logic;
  signal system_mainBusDecoder_logic_masterPipelined_cmd_valid : std_logic;
  signal system_mainBusDecoder_logic_masterPipelined_cmd_ready : std_logic;
  signal system_mainBusDecoder_logic_masterPipelined_cmd_payload_write : std_logic;
  signal system_mainBusDecoder_logic_masterPipelined_cmd_payload_address : unsigned(31 downto 0);
  signal system_mainBusDecoder_logic_masterPipelined_cmd_payload_data : std_logic_vector(31 downto 0);
  signal system_mainBusDecoder_logic_masterPipelined_cmd_payload_mask : std_logic_vector(3 downto 0);
  signal system_mainBusDecoder_logic_masterPipelined_rsp_valid : std_logic;
  signal system_mainBusDecoder_logic_masterPipelined_rsp_payload_data : std_logic_vector(31 downto 0);
  signal system_mainBusDecoder_logic_hits_0 : std_logic;
  signal zz_io_bus_cmd_payload_write : std_logic;
  signal system_mainBusDecoder_logic_hits_1 : std_logic;
  signal zz_io_pipelinedMemoryBus_cmd_payload_write : std_logic;
  signal system_mainBusDecoder_logic_noHit : std_logic;
  signal system_mainBusDecoder_logic_rspPending : std_logic;
  signal system_mainBusDecoder_logic_masterPipelined_cmd_fire : std_logic;
  signal when_MuraxUtiles_l127 : std_logic;
  signal system_mainBusDecoder_logic_rspNoHit : std_logic;
  signal system_mainBusDecoder_logic_masterPipelined_cmd_fire_1 : std_logic;
  signal system_mainBusDecoder_logic_rspSourceId : unsigned(0 downto 0);
  signal when_MuraxUtiles_l133 : std_logic;
begin
  io_asyncReset_buffercc : entity work.BufferCC_3
    port map ( 
      io_dataIn => io_asyncReset,
      io_dataOut => io_asyncReset_buffercc_io_dataOut,
      io_mainClk => io_mainClk 
    );
  system_mainBusArbiter : entity work.MuraxMasterArbiter
    port map ( 
      io_iBus_cmd_valid => system_cpu_iBus_cmd_valid,
      io_iBus_cmd_ready => system_mainBusArbiter_io_iBus_cmd_ready,
      io_iBus_cmd_payload_pc => system_cpu_iBus_cmd_payload_pc,
      io_iBus_rsp_valid => system_mainBusArbiter_io_iBus_rsp_valid,
      io_iBus_rsp_payload_error => system_mainBusArbiter_io_iBus_rsp_payload_error,
      io_iBus_rsp_payload_inst => system_mainBusArbiter_io_iBus_rsp_payload_inst,
      io_dBus_cmd_valid => system_cpu_dBus_cmd_halfPipe_valid,
      io_dBus_cmd_ready => system_mainBusArbiter_io_dBus_cmd_ready,
      io_dBus_cmd_payload_wr => system_cpu_dBus_cmd_halfPipe_payload_wr,
      io_dBus_cmd_payload_address => system_cpu_dBus_cmd_halfPipe_payload_address,
      io_dBus_cmd_payload_data => system_cpu_dBus_cmd_halfPipe_payload_data,
      io_dBus_cmd_payload_size => system_cpu_dBus_cmd_halfPipe_payload_size,
      io_dBus_rsp_ready => system_mainBusArbiter_io_dBus_rsp_ready,
      io_dBus_rsp_error => system_mainBusArbiter_io_dBus_rsp_error,
      io_dBus_rsp_data => system_mainBusArbiter_io_dBus_rsp_data,
      io_masterBus_cmd_valid => system_mainBusArbiter_io_masterBus_cmd_valid,
      io_masterBus_cmd_ready => system_mainBusDecoder_logic_masterPipelined_cmd_ready,
      io_masterBus_cmd_payload_write => system_mainBusArbiter_io_masterBus_cmd_payload_write,
      io_masterBus_cmd_payload_address => system_mainBusArbiter_io_masterBus_cmd_payload_address,
      io_masterBus_cmd_payload_data => system_mainBusArbiter_io_masterBus_cmd_payload_data,
      io_masterBus_cmd_payload_mask => system_mainBusArbiter_io_masterBus_cmd_payload_mask,
      io_masterBus_rsp_valid => system_mainBusDecoder_logic_masterPipelined_rsp_valid,
      io_masterBus_rsp_payload_data => system_mainBusDecoder_logic_masterPipelined_rsp_payload_data,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  system_cpu : entity work.VexRiscv
    port map ( 
      iBus_cmd_valid => system_cpu_iBus_cmd_valid,
      iBus_cmd_ready => system_mainBusArbiter_io_iBus_cmd_ready,
      iBus_cmd_payload_pc => system_cpu_iBus_cmd_payload_pc,
      iBus_rsp_valid => system_mainBusArbiter_io_iBus_rsp_valid,
      iBus_rsp_payload_error => system_mainBusArbiter_io_iBus_rsp_payload_error,
      iBus_rsp_payload_inst => system_mainBusArbiter_io_iBus_rsp_payload_inst,
      timerInterrupt => system_timerInterrupt,
      externalInterrupt => system_externalInterrupt,
      softwareInterrupt => pkg_toStdLogic(false),
      debug_bus_cmd_valid => systemDebugger_1_io_mem_cmd_valid,
      debug_bus_cmd_ready => system_cpu_debug_bus_cmd_ready,
      debug_bus_cmd_payload_wr => systemDebugger_1_io_mem_cmd_payload_wr,
      debug_bus_cmd_payload_address => system_cpu_debug_bus_cmd_payload_address,
      debug_bus_cmd_payload_data => systemDebugger_1_io_mem_cmd_payload_data,
      debug_bus_rsp_data => system_cpu_debug_bus_rsp_data,
      debug_resetOut => system_cpu_debug_resetOut,
      dBus_cmd_valid => system_cpu_dBus_cmd_valid,
      dBus_cmd_ready => system_cpu_dBus_cmd_ready,
      dBus_cmd_payload_wr => system_cpu_dBus_cmd_payload_wr,
      dBus_cmd_payload_address => system_cpu_dBus_cmd_payload_address,
      dBus_cmd_payload_data => system_cpu_dBus_cmd_payload_data,
      dBus_cmd_payload_size => system_cpu_dBus_cmd_payload_size,
      dBus_rsp_ready => system_mainBusArbiter_io_dBus_rsp_ready,
      dBus_rsp_error => system_mainBusArbiter_io_dBus_rsp_error,
      dBus_rsp_data => system_mainBusArbiter_io_dBus_rsp_data,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset,
      resetCtrl_mainClkReset => resetCtrl_mainClkReset 
    );
  jtagBridge_1 : entity work.JtagBridge
    port map ( 
      io_jtag_tms => io_jtag_tms,
      io_jtag_tdi => io_jtag_tdi,
      io_jtag_tdo => jtagBridge_1_io_jtag_tdo,
      io_jtag_tck => io_jtag_tck,
      io_remote_cmd_valid => jtagBridge_1_io_remote_cmd_valid,
      io_remote_cmd_ready => systemDebugger_1_io_remote_cmd_ready,
      io_remote_cmd_payload_last => jtagBridge_1_io_remote_cmd_payload_last,
      io_remote_cmd_payload_fragment => jtagBridge_1_io_remote_cmd_payload_fragment,
      io_remote_rsp_valid => systemDebugger_1_io_remote_rsp_valid,
      io_remote_rsp_ready => jtagBridge_1_io_remote_rsp_ready,
      io_remote_rsp_payload_error => systemDebugger_1_io_remote_rsp_payload_error,
      io_remote_rsp_payload_data => systemDebugger_1_io_remote_rsp_payload_data,
      io_mainClk => io_mainClk,
      resetCtrl_mainClkReset => resetCtrl_mainClkReset 
    );
  systemDebugger_1 : entity work.SystemDebugger
    port map ( 
      io_remote_cmd_valid => jtagBridge_1_io_remote_cmd_valid,
      io_remote_cmd_ready => systemDebugger_1_io_remote_cmd_ready,
      io_remote_cmd_payload_last => jtagBridge_1_io_remote_cmd_payload_last,
      io_remote_cmd_payload_fragment => jtagBridge_1_io_remote_cmd_payload_fragment,
      io_remote_rsp_valid => systemDebugger_1_io_remote_rsp_valid,
      io_remote_rsp_ready => jtagBridge_1_io_remote_rsp_ready,
      io_remote_rsp_payload_error => systemDebugger_1_io_remote_rsp_payload_error,
      io_remote_rsp_payload_data => systemDebugger_1_io_remote_rsp_payload_data,
      io_mem_cmd_valid => systemDebugger_1_io_mem_cmd_valid,
      io_mem_cmd_ready => system_cpu_debug_bus_cmd_ready,
      io_mem_cmd_payload_address => systemDebugger_1_io_mem_cmd_payload_address,
      io_mem_cmd_payload_data => systemDebugger_1_io_mem_cmd_payload_data,
      io_mem_cmd_payload_wr => systemDebugger_1_io_mem_cmd_payload_wr,
      io_mem_cmd_payload_size => systemDebugger_1_io_mem_cmd_payload_size,
      io_mem_rsp_valid => system_cpu_debug_bus_cmd_fire_regNext,
      io_mem_rsp_payload => system_cpu_debug_bus_rsp_data,
      io_mainClk => io_mainClk,
      resetCtrl_mainClkReset => resetCtrl_mainClkReset 
    );
  system_ram : entity work.MuraxPipelinedMemoryBusRam
    port map ( 
      io_bus_cmd_valid => system_ram_io_bus_cmd_valid,
      io_bus_cmd_ready => system_ram_io_bus_cmd_ready,
      io_bus_cmd_payload_write => zz_io_bus_cmd_payload_write,
      io_bus_cmd_payload_address => system_mainBusDecoder_logic_masterPipelined_cmd_payload_address,
      io_bus_cmd_payload_data => system_mainBusDecoder_logic_masterPipelined_cmd_payload_data,
      io_bus_cmd_payload_mask => system_mainBusDecoder_logic_masterPipelined_cmd_payload_mask,
      io_bus_rsp_valid => system_ram_io_bus_rsp_valid,
      io_bus_rsp_payload_data => system_ram_io_bus_rsp_payload_data,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  system_apbBridge : entity work.PipelinedMemoryBusToApbBridge
    port map ( 
      io_pipelinedMemoryBus_cmd_valid => system_apbBridge_io_pipelinedMemoryBus_cmd_valid,
      io_pipelinedMemoryBus_cmd_ready => system_apbBridge_io_pipelinedMemoryBus_cmd_ready,
      io_pipelinedMemoryBus_cmd_payload_write => zz_io_pipelinedMemoryBus_cmd_payload_write,
      io_pipelinedMemoryBus_cmd_payload_address => system_mainBusDecoder_logic_masterPipelined_cmd_payload_address,
      io_pipelinedMemoryBus_cmd_payload_data => system_mainBusDecoder_logic_masterPipelined_cmd_payload_data,
      io_pipelinedMemoryBus_cmd_payload_mask => system_mainBusDecoder_logic_masterPipelined_cmd_payload_mask,
      io_pipelinedMemoryBus_rsp_valid => system_apbBridge_io_pipelinedMemoryBus_rsp_valid,
      io_pipelinedMemoryBus_rsp_payload_data => system_apbBridge_io_pipelinedMemoryBus_rsp_payload_data,
      io_apb_PADDR => system_apbBridge_io_apb_PADDR,
      io_apb_PSEL => system_apbBridge_io_apb_PSEL,
      io_apb_PENABLE => system_apbBridge_io_apb_PENABLE,
      io_apb_PREADY => io_apb_decoder_io_input_PREADY,
      io_apb_PWRITE => system_apbBridge_io_apb_PWRITE,
      io_apb_PWDATA => system_apbBridge_io_apb_PWDATA,
      io_apb_PRDATA => io_apb_decoder_io_input_PRDATA,
      io_apb_PSLVERROR => io_apb_decoder_io_input_PSLVERROR,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  system_gpioACtrl : entity work.Apb3Gpio
    port map ( 
      io_apb_PADDR => system_gpioACtrl_io_apb_PADDR,
      io_apb_PSEL => apb3Router_1_io_outputs_0_PSEL,
      io_apb_PENABLE => apb3Router_1_io_outputs_0_PENABLE,
      io_apb_PREADY => system_gpioACtrl_io_apb_PREADY,
      io_apb_PWRITE => apb3Router_1_io_outputs_0_PWRITE,
      io_apb_PWDATA => apb3Router_1_io_outputs_0_PWDATA,
      io_apb_PRDATA => system_gpioACtrl_io_apb_PRDATA,
      io_apb_PSLVERROR => system_gpioACtrl_io_apb_PSLVERROR,
      io_gpio_read => io_gpioA_read,
      io_gpio_write => system_gpioACtrl_io_gpio_write,
      io_gpio_writeEnable => system_gpioACtrl_io_gpio_writeEnable,
      io_value => system_gpioACtrl_io_value,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  system_uartCtrl : entity work.Apb3UartCtrl
    port map ( 
      io_apb_PADDR => system_uartCtrl_io_apb_PADDR,
      io_apb_PSEL => apb3Router_1_io_outputs_1_PSEL,
      io_apb_PENABLE => apb3Router_1_io_outputs_1_PENABLE,
      io_apb_PREADY => system_uartCtrl_io_apb_PREADY,
      io_apb_PWRITE => apb3Router_1_io_outputs_1_PWRITE,
      io_apb_PWDATA => apb3Router_1_io_outputs_1_PWDATA,
      io_apb_PRDATA => system_uartCtrl_io_apb_PRDATA,
      io_uart_txd => system_uartCtrl_io_uart_txd,
      io_uart_rxd => io_uart_rxd,
      io_interrupt => system_uartCtrl_io_interrupt,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  system_timer : entity work.MuraxApb3Timer
    port map ( 
      io_apb_PADDR => system_timer_io_apb_PADDR,
      io_apb_PSEL => apb3Router_1_io_outputs_2_PSEL,
      io_apb_PENABLE => apb3Router_1_io_outputs_2_PENABLE,
      io_apb_PREADY => system_timer_io_apb_PREADY,
      io_apb_PWRITE => apb3Router_1_io_outputs_2_PWRITE,
      io_apb_PWDATA => apb3Router_1_io_outputs_2_PWDATA,
      io_apb_PRDATA => system_timer_io_apb_PRDATA,
      io_apb_PSLVERROR => system_timer_io_apb_PSLVERROR,
      io_interrupt => system_timer_io_interrupt,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  io_apb_decoder : entity work.Apb3Decoder
    port map ( 
      io_input_PADDR => system_apbBridge_io_apb_PADDR,
      io_input_PSEL => system_apbBridge_io_apb_PSEL,
      io_input_PENABLE => system_apbBridge_io_apb_PENABLE,
      io_input_PREADY => io_apb_decoder_io_input_PREADY,
      io_input_PWRITE => system_apbBridge_io_apb_PWRITE,
      io_input_PWDATA => system_apbBridge_io_apb_PWDATA,
      io_input_PRDATA => io_apb_decoder_io_input_PRDATA,
      io_input_PSLVERROR => io_apb_decoder_io_input_PSLVERROR,
      io_output_PADDR => io_apb_decoder_io_output_PADDR,
      io_output_PSEL => io_apb_decoder_io_output_PSEL,
      io_output_PENABLE => io_apb_decoder_io_output_PENABLE,
      io_output_PREADY => apb3Router_1_io_input_PREADY,
      io_output_PWRITE => io_apb_decoder_io_output_PWRITE,
      io_output_PWDATA => io_apb_decoder_io_output_PWDATA,
      io_output_PRDATA => apb3Router_1_io_input_PRDATA,
      io_output_PSLVERROR => apb3Router_1_io_input_PSLVERROR 
    );
  apb3Router_1 : entity work.Apb3Router
    port map ( 
      io_input_PADDR => io_apb_decoder_io_output_PADDR,
      io_input_PSEL => io_apb_decoder_io_output_PSEL,
      io_input_PENABLE => io_apb_decoder_io_output_PENABLE,
      io_input_PREADY => apb3Router_1_io_input_PREADY,
      io_input_PWRITE => io_apb_decoder_io_output_PWRITE,
      io_input_PWDATA => io_apb_decoder_io_output_PWDATA,
      io_input_PRDATA => apb3Router_1_io_input_PRDATA,
      io_input_PSLVERROR => apb3Router_1_io_input_PSLVERROR,
      io_outputs_0_PADDR => apb3Router_1_io_outputs_0_PADDR,
      io_outputs_0_PSEL => apb3Router_1_io_outputs_0_PSEL,
      io_outputs_0_PENABLE => apb3Router_1_io_outputs_0_PENABLE,
      io_outputs_0_PREADY => system_gpioACtrl_io_apb_PREADY,
      io_outputs_0_PWRITE => apb3Router_1_io_outputs_0_PWRITE,
      io_outputs_0_PWDATA => apb3Router_1_io_outputs_0_PWDATA,
      io_outputs_0_PRDATA => system_gpioACtrl_io_apb_PRDATA,
      io_outputs_0_PSLVERROR => system_gpioACtrl_io_apb_PSLVERROR,
      io_outputs_1_PADDR => apb3Router_1_io_outputs_1_PADDR,
      io_outputs_1_PSEL => apb3Router_1_io_outputs_1_PSEL,
      io_outputs_1_PENABLE => apb3Router_1_io_outputs_1_PENABLE,
      io_outputs_1_PREADY => system_uartCtrl_io_apb_PREADY,
      io_outputs_1_PWRITE => apb3Router_1_io_outputs_1_PWRITE,
      io_outputs_1_PWDATA => apb3Router_1_io_outputs_1_PWDATA,
      io_outputs_1_PRDATA => system_uartCtrl_io_apb_PRDATA,
      io_outputs_1_PSLVERROR => pkg_toStdLogic(false),
      io_outputs_2_PADDR => apb3Router_1_io_outputs_2_PADDR,
      io_outputs_2_PSEL => apb3Router_1_io_outputs_2_PSEL,
      io_outputs_2_PENABLE => apb3Router_1_io_outputs_2_PENABLE,
      io_outputs_2_PREADY => system_timer_io_apb_PREADY,
      io_outputs_2_PWRITE => apb3Router_1_io_outputs_2_PWRITE,
      io_outputs_2_PWDATA => apb3Router_1_io_outputs_2_PWDATA,
      io_outputs_2_PRDATA => system_timer_io_apb_PRDATA,
      io_outputs_2_PSLVERROR => system_timer_io_apb_PSLVERROR,
      io_mainClk => io_mainClk,
      resetCtrl_systemReset => resetCtrl_systemReset 
    );
  process(system_mainBusDecoder_logic_rspSourceId,system_ram_io_bus_rsp_payload_data,system_apbBridge_io_pipelinedMemoryBus_rsp_payload_data)
  begin
    case system_mainBusDecoder_logic_rspSourceId is
      when "0" =>
        zz_system_mainBusDecoder_logic_masterPipelined_rsp_payload_data <= system_ram_io_bus_rsp_payload_data;
      when others =>
        zz_system_mainBusDecoder_logic_masterPipelined_rsp_payload_data <= system_apbBridge_io_pipelinedMemoryBus_rsp_payload_data;
    end case;
  end process;

  process(when_Murax_l188)
  begin
    resetCtrl_mainClkResetUnbuffered <= pkg_toStdLogic(false);
    if when_Murax_l188 = '1' then
      resetCtrl_mainClkResetUnbuffered <= pkg_toStdLogic(true);
    end if;
  end process;

  zz_when_Murax_l188(5 downto 0) <= pkg_unsigned("111111");
  when_Murax_l188 <= pkg_toStdLogic(resetCtrl_systemClkResetCounter /= zz_when_Murax_l188);
  when_Murax_l192 <= io_asyncReset_buffercc_io_dataOut;
  process(system_timer_io_interrupt)
  begin
    system_timerInterrupt <= pkg_toStdLogic(false);
    if system_timer_io_interrupt = '1' then
      system_timerInterrupt <= pkg_toStdLogic(true);
    end if;
  end process;

  process(system_uartCtrl_io_interrupt)
  begin
    system_externalInterrupt <= pkg_toStdLogic(false);
    if system_uartCtrl_io_interrupt = '1' then
      system_externalInterrupt <= pkg_toStdLogic(true);
    end if;
  end process;

  system_cpu_dBus_cmd_halfPipe_fire <= (system_cpu_dBus_cmd_halfPipe_valid and system_cpu_dBus_cmd_halfPipe_ready);
  system_cpu_dBus_cmd_ready <= (not system_cpu_dBus_cmd_rValid);
  system_cpu_dBus_cmd_halfPipe_valid <= system_cpu_dBus_cmd_rValid;
  system_cpu_dBus_cmd_halfPipe_payload_wr <= system_cpu_dBus_cmd_rData_wr;
  system_cpu_dBus_cmd_halfPipe_payload_address <= system_cpu_dBus_cmd_rData_address;
  system_cpu_dBus_cmd_halfPipe_payload_data <= system_cpu_dBus_cmd_rData_data;
  system_cpu_dBus_cmd_halfPipe_payload_size <= system_cpu_dBus_cmd_rData_size;
  system_cpu_dBus_cmd_halfPipe_ready <= system_mainBusArbiter_io_dBus_cmd_ready;
  system_cpu_debug_bus_cmd_payload_address <= pkg_resize(systemDebugger_1_io_mem_cmd_payload_address,8);
  system_cpu_debug_bus_cmd_fire <= (systemDebugger_1_io_mem_cmd_valid and system_cpu_debug_bus_cmd_ready);
  io_jtag_tdo <= jtagBridge_1_io_jtag_tdo;
  io_gpioA_write <= system_gpioACtrl_io_gpio_write;
  io_gpioA_writeEnable <= system_gpioACtrl_io_gpio_writeEnable;
  io_uart_txd <= system_uartCtrl_io_uart_txd;
  system_gpioACtrl_io_apb_PADDR <= pkg_resize(apb3Router_1_io_outputs_0_PADDR,4);
  system_uartCtrl_io_apb_PADDR <= pkg_resize(apb3Router_1_io_outputs_1_PADDR,5);
  system_timer_io_apb_PADDR <= pkg_resize(apb3Router_1_io_outputs_2_PADDR,8);
  system_mainBusDecoder_logic_masterPipelined_cmd_valid <= system_mainBusArbiter_io_masterBus_cmd_valid;
  system_mainBusDecoder_logic_masterPipelined_cmd_payload_write <= system_mainBusArbiter_io_masterBus_cmd_payload_write;
  system_mainBusDecoder_logic_masterPipelined_cmd_payload_address <= system_mainBusArbiter_io_masterBus_cmd_payload_address;
  system_mainBusDecoder_logic_masterPipelined_cmd_payload_data <= system_mainBusArbiter_io_masterBus_cmd_payload_data;
  system_mainBusDecoder_logic_masterPipelined_cmd_payload_mask <= system_mainBusArbiter_io_masterBus_cmd_payload_mask;
  system_mainBusDecoder_logic_hits_0 <= pkg_toStdLogic((system_mainBusDecoder_logic_masterPipelined_cmd_payload_address and pkg_not(pkg_unsigned("00000000000000000000111111111111"))) = pkg_unsigned("10000000000000000000000000000000"));
  process(system_mainBusDecoder_logic_masterPipelined_cmd_valid,system_mainBusDecoder_logic_hits_0,when_MuraxUtiles_l133)
  begin
    system_ram_io_bus_cmd_valid <= (system_mainBusDecoder_logic_masterPipelined_cmd_valid and system_mainBusDecoder_logic_hits_0);
    if when_MuraxUtiles_l133 = '1' then
      system_ram_io_bus_cmd_valid <= pkg_toStdLogic(false);
    end if;
  end process;

  zz_io_bus_cmd_payload_write <= system_mainBusDecoder_logic_masterPipelined_cmd_payload_write;
  system_mainBusDecoder_logic_hits_1 <= pkg_toStdLogic((system_mainBusDecoder_logic_masterPipelined_cmd_payload_address and pkg_not(pkg_unsigned("00000000000011111111111111111111"))) = pkg_unsigned("11110000000000000000000000000000"));
  process(system_mainBusDecoder_logic_masterPipelined_cmd_valid,system_mainBusDecoder_logic_hits_1,when_MuraxUtiles_l133)
  begin
    system_apbBridge_io_pipelinedMemoryBus_cmd_valid <= (system_mainBusDecoder_logic_masterPipelined_cmd_valid and system_mainBusDecoder_logic_hits_1);
    if when_MuraxUtiles_l133 = '1' then
      system_apbBridge_io_pipelinedMemoryBus_cmd_valid <= pkg_toStdLogic(false);
    end if;
  end process;

  zz_io_pipelinedMemoryBus_cmd_payload_write <= system_mainBusDecoder_logic_masterPipelined_cmd_payload_write;
  system_mainBusDecoder_logic_noHit <= (not pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(system_mainBusDecoder_logic_hits_1),pkg_toStdLogicVector(system_mainBusDecoder_logic_hits_0)) /= pkg_stdLogicVector("00")));
  process(system_mainBusDecoder_logic_hits_1,system_apbBridge_io_pipelinedMemoryBus_cmd_ready,system_mainBusDecoder_logic_hits_0,system_ram_io_bus_cmd_ready,system_mainBusDecoder_logic_noHit,when_MuraxUtiles_l133)
  begin
    system_mainBusDecoder_logic_masterPipelined_cmd_ready <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector((system_mainBusDecoder_logic_hits_1 and system_apbBridge_io_pipelinedMemoryBus_cmd_ready)),pkg_toStdLogicVector((system_mainBusDecoder_logic_hits_0 and system_ram_io_bus_cmd_ready))) /= pkg_stdLogicVector("00")) or system_mainBusDecoder_logic_noHit);
    if when_MuraxUtiles_l133 = '1' then
      system_mainBusDecoder_logic_masterPipelined_cmd_ready <= pkg_toStdLogic(false);
    end if;
  end process;

  system_mainBusDecoder_logic_masterPipelined_cmd_fire <= (system_mainBusDecoder_logic_masterPipelined_cmd_valid and system_mainBusDecoder_logic_masterPipelined_cmd_ready);
  when_MuraxUtiles_l127 <= (system_mainBusDecoder_logic_masterPipelined_cmd_fire and (not system_mainBusDecoder_logic_masterPipelined_cmd_payload_write));
  system_mainBusDecoder_logic_masterPipelined_cmd_fire_1 <= (system_mainBusDecoder_logic_masterPipelined_cmd_valid and system_mainBusDecoder_logic_masterPipelined_cmd_ready);
  system_mainBusDecoder_logic_masterPipelined_rsp_valid <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(system_apbBridge_io_pipelinedMemoryBus_rsp_valid),pkg_toStdLogicVector(system_ram_io_bus_rsp_valid)) /= pkg_stdLogicVector("00")) or (system_mainBusDecoder_logic_rspPending and system_mainBusDecoder_logic_rspNoHit));
  system_mainBusDecoder_logic_masterPipelined_rsp_payload_data <= zz_system_mainBusDecoder_logic_masterPipelined_rsp_payload_data;
  when_MuraxUtiles_l133 <= (system_mainBusDecoder_logic_rspPending and (not system_mainBusDecoder_logic_masterPipelined_rsp_valid));
  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if when_Murax_l188 = '1' then
        resetCtrl_systemClkResetCounter <= (resetCtrl_systemClkResetCounter + pkg_unsigned("000001"));
      end if;
      if when_Murax_l192 = '1' then
        resetCtrl_systemClkResetCounter <= pkg_unsigned("000000");
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      resetCtrl_mainClkReset <= resetCtrl_mainClkResetUnbuffered;
      resetCtrl_systemReset <= resetCtrl_mainClkResetUnbuffered;
      if system_cpu_debug_resetOut_regNext = '1' then
        resetCtrl_systemReset <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(io_mainClk, resetCtrl_systemReset)
  begin
    if resetCtrl_systemReset = '1' then
      system_cpu_dBus_cmd_rValid <= pkg_toStdLogic(false);
      system_mainBusDecoder_logic_rspPending <= pkg_toStdLogic(false);
      system_mainBusDecoder_logic_rspNoHit <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      if system_cpu_dBus_cmd_valid = '1' then
        system_cpu_dBus_cmd_rValid <= pkg_toStdLogic(true);
      end if;
      if system_cpu_dBus_cmd_halfPipe_fire = '1' then
        system_cpu_dBus_cmd_rValid <= pkg_toStdLogic(false);
      end if;
      if system_mainBusDecoder_logic_masterPipelined_rsp_valid = '1' then
        system_mainBusDecoder_logic_rspPending <= pkg_toStdLogic(false);
      end if;
      if when_MuraxUtiles_l127 = '1' then
        system_mainBusDecoder_logic_rspPending <= pkg_toStdLogic(true);
      end if;
      system_mainBusDecoder_logic_rspNoHit <= pkg_toStdLogic(false);
      if system_mainBusDecoder_logic_noHit = '1' then
        system_mainBusDecoder_logic_rspNoHit <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      if system_cpu_dBus_cmd_ready = '1' then
        system_cpu_dBus_cmd_rData_wr <= system_cpu_dBus_cmd_payload_wr;
        system_cpu_dBus_cmd_rData_address <= system_cpu_dBus_cmd_payload_address;
        system_cpu_dBus_cmd_rData_data <= system_cpu_dBus_cmd_payload_data;
        system_cpu_dBus_cmd_rData_size <= system_cpu_dBus_cmd_payload_size;
      end if;
      if system_mainBusDecoder_logic_masterPipelined_cmd_fire_1 = '1' then
        system_mainBusDecoder_logic_rspSourceId <= unsigned(pkg_toStdLogicVector(system_mainBusDecoder_logic_hits_1));
      end if;
    end if;
  end process;

  process(io_mainClk)
  begin
    if rising_edge(io_mainClk) then
      system_cpu_debug_resetOut_regNext <= system_cpu_debug_resetOut;
    end if;
  end process;

  process(io_mainClk, resetCtrl_mainClkReset)
  begin
    if resetCtrl_mainClkReset = '1' then
      system_cpu_debug_bus_cmd_fire_regNext <= pkg_toStdLogic(false);
    elsif rising_edge(io_mainClk) then
      system_cpu_debug_bus_cmd_fire_regNext <= system_cpu_debug_bus_cmd_fire;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity de1_murax_franz is
  port(
    jtag_tck : in std_logic;
    jtag_tdi : in std_logic;
    jtag_tdo : out std_logic;
    jtag_tms : in std_logic;
    uart_txd : out std_logic;
    uart_rxd : in std_logic;
    KEY0 : in std_logic;
    CLOCK_50 : in std_logic;
    LEDR : out std_logic_vector(7 downto 0)
  );
end de1_murax_franz;

architecture arch of de1_murax_franz is
  signal murax_1_io_asyncReset : std_logic;
  signal murax_1_io_jtag_tdo : std_logic;
  signal murax_1_io_gpioA_write : std_logic_vector(31 downto 0);
  signal murax_1_io_gpioA_writeEnable : std_logic_vector(31 downto 0);
  signal murax_1_io_uart_txd : std_logic;

begin
  murax_1 : entity work.Murax
    port map ( 
      io_asyncReset => murax_1_io_asyncReset,
      io_mainClk => CLOCK_50,
      io_jtag_tms => jtag_tms,
      io_jtag_tdi => jtag_tdi,
      io_jtag_tdo => murax_1_io_jtag_tdo,
      io_jtag_tck => jtag_tck,
      io_gpioA_read => pkg_stdLogicVector("00000000000000000000000000000000"),
      io_gpioA_write => murax_1_io_gpioA_write,
      io_gpioA_writeEnable => murax_1_io_gpioA_writeEnable,
      io_uart_txd => murax_1_io_uart_txd,
      io_uart_rxd => uart_rxd 
    );
  LEDR <= pkg_extract(murax_1_io_gpioA_write,7,0);
  jtag_tdo <= murax_1_io_jtag_tdo;
  uart_txd <= murax_1_io_uart_txd;
  murax_1_io_asyncReset <= (not KEY0);
end arch;

