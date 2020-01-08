%%BeginProlog
%
%  PostScript prolog for output from magic plot
%  Version: 1.0
%  written by Tim Edwards 4/05/00  JHU Applied Physics Laboratory
%
%%BeginResource: procset MAGICproc 1.0 1
% supporting definitions

/MAGICsave save def

/bop { 1 setlinecap 0 setlinejoin 6 setmiterlimit 0 setgray } def
/ninit { /nChars matrix currentmatrix dup 0 get 0 eq {1} {0}
   ifelse get abs 72 8.5 mul mul 64 div ceiling cvi def } def
/minit { 1 1 dtransform abs dup 1 exch div /onePix exch def
   dup /resY exch def 1 exch div /iresY exch def
   abs dup /resX exch def 1 exch div /iresX exch def
   /bX 64 iresX mul def /bY 64 iresY mul def
   /pattFont StipplePattern definefont pop
   /patterns /pattFont findfont [iresX 64 mul 0 0 iresY 64 mul 0 0] makefont def
   /ca nChars 1 add string def
   } def
/StipplePattern 45 dict def
StipplePattern begin
 /FontType 3 def
 /FontMatrix [1 0 0 1 0 0] def
 /FontBBox [0 0 1 1] def
 /Encoding 256 array def
 /PattName (P0) def
 /tmpStr 1 string def
 /NoPatt {<00>} def
 0 1 255 { Encoding exch /NoPatt put } for
 /BuildChar {
   1 0 0 0 1 1 setcachedevice exch begin Encoding exch get load
   64 64 true [64 0 0 64 0 0] 5 -1 roll imagemask end } def
end  
/dp { StipplePattern begin dup 30 tmpStr cvrs PattName exch 1 exch
   putinterval PattName cvn dup Encoding exch 4 -1 roll exch put exch
   store end } def
/sf { findfont exch scalefont setfont } bind def
/sp { patterns setfont 2 setlinewidth } def
/lb { gsave translate 0 0 moveto /just exch def gsave dup true charpath
	flattenpath pathbbox grestore exch 4 -1 roll exch sub 3 1 roll sub
	just 4 and 0 gt {just 8 and 0 eq {0.5 mul} if}{pop 0} ifelse exch
	just 1 and 0 gt {just 2 and 0 eq {0.5 mul} if}{pop 0} ifelse exch
	rmoveto show grestore } def
/sl { 0 1 nChars { exch dup 3 1 roll ca 3 1 roll put } for pop } def
/sc { setcmykcolor } bind def
/l1 { onePix setlinewidth } def
/l2 { onePix 2 mul setlinewidth } def
/l3 { onePix 3 mul setlinewidth } def
/ml { moveto lineto stroke } bind def
/vl { moveto 0 exch rlineto stroke } bind def
/hl { moveto 0 rlineto stroke } bind def
/mr { rectstroke } bind def
/ms { rectfill } bind def
/mx { 4 copy rectstroke 4 -1 roll 4 -1 roll 4 copy moveto rlineto stroke
   3 -1 roll dup neg 4 1 roll add moveto rlineto stroke } bind def
/pl { gsave translate /d exch def 0 d neg moveto 0 d lineto stroke
   d neg 0 moveto d 0 lineto stroke grestore } bind def
/bx { x resX mul cvi 63 not and dup iresX mul exch
   w resX mul sub abs 63 add cvi 64 idiv /w exch def
   y resY mul cvi 63 not and dup iresY mul exch
   h resY mul sub abs 63 add cvi 64 idiv /h exch def
   /ch ca 0 w getinterval def
   moveto h { ch gsave show grestore 0 bY rmoveto } repeat grestore } def
/fb {/h exch def /w exch def /y exch def /x exch def gsave newpath
   x y moveto w y lineto w h lineto x h lineto closepath clip bx } def
/tb {1 sub 3 1 roll gsave newpath moveto {lineto} repeat closepath clip pathbbox
   /h exch def /w exch def /y exch def /x exch def bx } def

