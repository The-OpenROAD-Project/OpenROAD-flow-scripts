#!/bin/sh
# setup_compiler_wrappers.sh
# Creates compiler wrapper scripts for reproducible builds by overriding
# __TIME__, __DATE__, and __TIMESTAMP__ macros with constant values.
# This ensures Docker image builds are deterministic regardless of build time.

set -e

WRAPPER_DIR="/usr/local/bin/wrapped-cc"
mkdir -p "$WRAPPER_DIR"

# GCC wrapper
cat > "$WRAPPER_DIR/gcc" << 'WRAPPER'
#!/bin/sh
exec /usr/bin/gcc -D__TIME__="\"0\"" -D__DATE__="\"0\"" -D__TIMESTAMP__="\"0\"" -Wno-builtin-macro-redefined "$@"
WRAPPER
chmod +x "$WRAPPER_DIR/gcc"

# Symlink cc to gcc wrapper
ln -sf "$WRAPPER_DIR/gcc" "$WRAPPER_DIR/cc"

# G++ wrapper
cat > "$WRAPPER_DIR/g++" << 'WRAPPER'
#!/bin/sh
exec /usr/bin/g++ -D__TIME__="\"0\"" -D__DATE__="\"0\"" -D__TIMESTAMP__="\"0\"" -Wno-builtin-macro-redefined "$@"
WRAPPER
chmod +x "$WRAPPER_DIR/g++"
