#!/bin/tclsh
#----------------------------------------------
# Dump a file of DRC errors from magic
#----------------------------------------------
namespace path {::tcl::mathop ::tcl::mathfunc}

magic::suspendall
set fout [open "drc.out" w]
set oscale [cif scale out]

select top cell
set origcell [cellname list self]
drc check
set celllist [drc list count]
puts stdout "celllist is $celllist"
puts stdout ""
flush stdout
foreach pair $celllist {
   set cellname [lindex $pair 0]
   set count [lindex $pair 1]
   puts stdout "loading $cellname"
   flush stdout
   
   load $cellname
   select top cell
   puts $fout "$cellname $count"
   puts $fout "----------------------------------------"
   set drcresult [drc listall why]
   foreach {errtype coordlist} $drcresult {
      puts $fout $errtype
      puts $fout "----------------------------------------"
      foreach coord $coordlist {
         set bllx [* $oscale [lindex $coord 0]]
         set blly [* $oscale [lindex $coord 1]]
         set burx [* $oscale [lindex $coord 2]]
         set bury [* $oscale [lindex $coord 3]]
         set coords [format "%.3f %.3f %.3f %.3f" $bllx $blly $burx $bury]
         puts $fout "$coords"
      }
      puts $fout "----------------------------------------"
   }
   puts $fout ""
}
close $fout
load $origcell
magic::resumeall
