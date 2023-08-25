Multiplier algorithms
=====================

The multiplier is implemented in ASAP7 using Perhaps https://github.com/antonblanchard/vlsiffra


multiply-hancarlson.v is generated with:

    vlsi-multiplier --bits=64 --algorithm=hancarlson --tech=asap7 --register-post-ppa --register-post-ppg --output=multiply-hancarlson.v
