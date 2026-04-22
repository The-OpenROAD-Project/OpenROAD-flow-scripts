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
