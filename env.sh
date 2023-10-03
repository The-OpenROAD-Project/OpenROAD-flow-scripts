if [ -f /opt/rh/rh-python38/enable ]; then
  # required for Centos7 where the newest python available is 3.6
  # eqy requires 3.8+
  source /opt/rh/rh-python38/enable
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/Applications/KLayout/klayout.app/Contents/MacOS:$PATH"
  export PATH="$(brew --prefix bison)/bin:$(brew --prefix flex)/bin:$(brew --prefix tcl-tk)/bin:$PATH"
  export CMAKE_PREFIX_PATH="$(brew --prefix or-tools)"
fi
