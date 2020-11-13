# units are fF,kOhm




set_layer_rc -layer li1 -capacitance 0.000006287722 -resistance 0.075294118
set_layer_rc -layer met1 -capacitance 0.0000003608976 -resistance 0.000892857
set_layer_rc -layer met2 -capacitance 0.0000002371922 -resistance 0.000892857
set_layer_rc -layer met3 -capacitance 0.000000371187 -resistance 0.000156667
set_layer_rc -layer met4 -capacitance 0.0000002524611 -resistance 0.000156667
set_layer_rc -layer met5 -capacitance 0.0000010113008 -resistance 0.000018125


# Values based on the Rs values 
set_layer_rc -layer mcon -capacitance 0.000070290 -resistance 0.8941176471
set_layer_rc -layer via -capacitance 0.000153021 -resistance 0.03
set_layer_rc -layer via2 -capacitance 0.000142742 -resistance 0.01705
set_layer_rc -layer via3 -capacitance 0.000074106 -resistance 0.01705
set_layer_rc -layer via4 -capacitance 0.000602843 -resistance 0.000475

# Values based on Cap table
##set_layer_rc -layer mcon -capacitance 0.000070290 -resistance 0.0093
##set_layer_rc -layer via -capacitance 0.000153021 -resistance 0.0045
##set_layer_rc -layer via2 -capacitance 0.000142742 -resistance 0.00341
##set_layer_rc -layer via3 -capacitance 0.000074106 -resistance 0.00341
##set_layer_rc -layer via4 -capacitance 0.000602843 -resistance 0.00038







#set_wire_rc -layer li1
#set_wire_rc -layer met1
#set_wire_rc -layer met2
set_wire_rc -layer met3
#set_wire_rc -layer met4
#set_wire_rc -layer met5
