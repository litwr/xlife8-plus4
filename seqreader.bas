

;seqreader.prg ==1001==
   10 rem *** sequential files reader
   20 rem *** by litwr, 2005, 2013
   30 print"{clr}* press commodore logo key to slow down text output speed"
   40 print"* press control-s to pause text output"
   50 print"* press control-q to resume text output"
   60 print"* press run/stop to break text output"
   70 trap220
   80 print
   90 geta$:ifa$<>""then90
  100 input"enter filename($=dir)";a$
  110 ifa$="$"then180
  120 open3,8,3,a$+",s,r":s=1
  130 get#3,a$:ifa$=""thena$=chr$(0)
  150 ifst=0thenprinta$;:goto130:else:gosub240
  160 close3:s=0
  170 goto80
  180 u=peek(174):ifu=0thenu=8
  190 ifu=9thendirectory"*=s",u9
  200 ifu=8thendirectory"*=s",u8
  210 goto80
  220 ifsthenclose3:s=0
  230 resume80
  240 ifds>19thenprintds$
  250 return

