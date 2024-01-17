set -ex
# vlsi-multiplier --bits=64 --tech=asap7 --register-post-ppa --register-post-ppg --algorithm=hancarlson --output=mult_hancarlson.v
# vlsi-multiplier --bits=64 --tech=asap7 --register-post-ppa --register-post-ppg --algorithm=brentkung --output=mult_brentkung.v
# vlsi-multiplier --bits=64 --tech=asap7 --register-post-ppa --register-post-ppg --algorithm=inferred --output=mult_inferred.v
# vlsi-multiplier --bits=64 --tech=asap7 --register-post-ppa --register-post-ppg --algorithm=koggestone --output=mult_koggestone.v
# vlsi-multiplier --bits=64 --tech=asap7 --register-post-ppa --register-post-ppg --algorithm=ripple --output=mult_ripple.v
vlsi-adder --bits=64 --tech=asap7 --algorithm=hancarlson --output=add_hancarlson.v
vlsi-adder --bits=64 --tech=asap7 --algorithm=koggestone --output=add_koggestone.v
vlsi-adder --bits=64 --tech=asap7 --algorithm=brentkung --output=add_brentkung.v
vlsi-adder --bits=64 --tech=asap7 --algorithm=inferred --output=add_inferred.v
vlsi-adder --bits=64 --tech=asap7 --algorithm=ripple --output=add_ripple.v
