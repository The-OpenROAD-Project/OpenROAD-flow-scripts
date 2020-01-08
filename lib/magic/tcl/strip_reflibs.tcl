#!/usr/local/bin/tclsh
#
# Strip GDS cell references from magic files.
#
# This is necessary to make sure that no geometry goes into the output
# for files swapped between Cadence and Magic.  To import into Magic
# from Cadence, "Retain Reference Library" should be FALSE, so that
# Magic gets all of the cell contents.  Then run this file on the
# resulting Magic database directory, and read back into Cadence using
# "Retain Reference Library" = TRUE.  This will prevent Cadence from
# generating local copies of every cell, instead retaining the original
# library definition.
#
# 1. delete lines beginning "string GDS_START"
# 2. delete lines beginning "string GDS_END"
# 3. do NOT delete "string GDS_FILE" lines.
#
# Note that if all cells are treated as library references, then the
# GDS file itself does not need to exist.

foreach fname [glob *.mag] { 
   if [catch {open $fname r} fIn] {
      puts stdout "Error: can't open file $fname"
   } else {
      set fOut [open tmp.mag w]
      while {[gets $fIn line] >= 0} {
         if [regexp {^string GDS_} $line] {
	    if [regexp {^string GDS_START} $line ] {
	    } elseif [regexp {^string GDS_END} $line] {
	    } else {
	       puts $fOut $line
	    }
         } else {
	    puts $fOut $line
         }
      }
      close $fIn
      close $fOut
      file rename -force tmp.mag $fname
   }
}
