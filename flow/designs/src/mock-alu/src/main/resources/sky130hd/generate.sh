set -ex
vlsi-multiplier --bits=64 --tech=sky130hd --register-post-ppa --register-post-ppg --algorithm=hancarlson --output=mult_hancarlson.v
vlsi-multiplier --bits=64 --tech=sky130hd --register-post-ppa --register-post-ppg --algorithm=brentkung --output=mult_brentkung.v
vlsi-multiplier --bits=64 --tech=sky130hd --register-post-ppa --register-post-ppg --algorithm=inferred --output=mult_inferred.v
vlsi-multiplier --bits=64 --tech=sky130hd --register-post-ppa --register-post-ppg --algorithm=koggestone --output=mult_koggestone.v
vlsi-multiplier --bits=64 --tech=sky130hd --register-post-ppa --register-post-ppg --algorithm=ripple --output=mult_ripple.v
