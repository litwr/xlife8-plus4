

;cat.prg ==1001==
    0 rem * cat v1.03(1991) by w.lidovski
   10 fori=1to46:reada$:poke1014+i,dec(a$):nexti
   20 dima$(24,1),c%(24,2,2)
   30 i=0:j=0:trap100
   35 reada$
   40 a$(i,j)=a$
   50 reada$:c%(i,j,0)=dec(a$)
   60 reada$:c%(i,j,1)=dec(a$)
   70 reada$:i=i+1:ifi=25theni=0:j=j+1
   80 ifj>1thenprint"{clr}too many files!!!":end
   90 goto40
  100 printchr$(27)+"n";:color1,1,1:color0,2,7:color4,15,6
  110 x=0:y=0
  115 ifj=1thenh=24:elseh=i
  120 fork=0toh
  130 print" ";a$(k,0);:ifk<24thenprint
  140 nextk
  150 ifj=1thenh=i:elseh=-1
  155 ifh<0then190
  160 fork=0toh
  170 char,20,k,"":print" ";a$(k,1)
  180 nextk
  190 gosub2000
  195 xo=x:yo=y:gosub2100
  200 gosub2010:gosub2000
  210 ifrt=0goto195
  220 ifrt=1thenpoke216,0:poke217,8:sys1043
  222 print"{clr}new{down}{down}{down}dload"+chr$(34)+a$(y,x/20)+"*"+chr$(34)+"{home}";
  225 poke239,5:poke1319,13:poke1320,13:poke1321,82:poke1322,213:poke1323,13
  230 end
 1000 dataa9,00,a2,08,a0,01,20,ba
 1020 dataff,a9,05,a2,25,a0,04,20
 1030 databd,ff,a9,00,85,93,20,d5
 1050 dataff,4c,0,0
 1060 dataa9,00,a8,91,d8,c8,d0,fb
 1070 datae6,d9,a2,fd,e4,d9,d0,f3
 1080 dataf0,d2
 2000 char,x,y,">":return
 2010 char,xo,yo," ":return
 2100 getkeya$
 2110 ifinstr("{up}{rght}{down}{left}"+chr$(13),a$)=0then2100
 2120 ifa$="{left}"thenx=0
 2130 if(a$="{rght}")and(y<=i)and(j=1)thenx=20
 2140 if(a$="{up}")and(y>0)theny=y-1
 2150 if(a$="{down}")and(y<24)thengosub3000
 2155 ifa$=chr$(13)then2170
 2160 rt=0:return
 2170 k=len(a$(y,x/20))
 2175 forh=1tok
 2180 poke1060+h,asc(mid$(a$(y,x/20),h,1))
 2190 nexth:poke1061+k,asc("*")
 2200 pokedec("401"),k+1
 2210 poke1041,c%(y,x,0)
 2220 poke1042,c%(y,x,1)
 2230 rt=1
 2240 ifc%(y,x/20,0)+c%(y,x/20,1)=0thenrt=2
 2250 return
 3000 ifj=1theni1=25:i2=i:goto3020
 3010 i1=i:i2=0
 3020 ifx=0thenit=i1:elseit=i2
 3030 ify<ittheny=y+1
 3040 return
 10000 dataxlife,0,0,manpage,0,0,notepad+4,0,0,default-colors,0,0

