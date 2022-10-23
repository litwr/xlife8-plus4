dispatcher
         ldx $ef
         bne ldisp1

         rts

ldisp1   dec $ef
         lda $526,x

dispat0  .block
         cmp #"G"-"A"+$41
         bne cont3

         lda mode
         beq cont2

         dec mode
         beq l4

l5       jmp scrnorm

cont2    inc mode
l4       rts

cont3    cmp #"Q"-"A"+$c1
         bne cont5

         lda #3
         sta mode
l1       rts

cont5    cmp #"H"-"A"+$41
         bne cont4

         lda #2
         cmp mode
         bne l3

         dec mode
         bne l5

l3       sta mode
         jsr xclrscn
         jmp scrblnk

cont4    cmp #"T"-"A"+$c1
         bne cont6

         #chgtopology

cont6    cmp #"O"-"A"+$41
         bne cont7

         lda mode
         bne l1

         lda startp+1
         bne l8

         jsr incgen
         jmp infoout

l8       jsr zerocc
         jsr generate
         jsr showscn
         jmp cleanup

cont7    cmp #"?"
         bne cont8

         lda mode
         cmp #2
         beq cont8

         jsr totext
         jsr curoff
         jsr help
         jmp finish

cont8    cmp #"C"-"A"+$c1
         bne cont10

         lda startp+1
         beq l51
         jmp clear

l51      jsr zerogc
         jmp infoout

cont10   cmp #"E"-"A"+$c1
         bne cont11

         dec pseudoc
         beq l11

         lda #1
         sta pseudoc
l11      jmp showscn

cont11   cmp #"!"
         bne cont12

         jsr random
         jmp showscn

cont12   cmp #"%"
         bne cont14

         lda mode
         cmp #2
         beq cont14

         jsr totext
         jsr curoff
         jsr indens
         jmp finish

cont14   cmp #"B"-"A"+$c1
         beq bl12
         jmp cont15

bl12     jsr xclrscn
         jsr totext
         jsr zerocnt
         jsr insteps
         beq qbexit

         lda #<decben
         sta m1+1
         sta m2+1
         lda #>decben
         sta m1+2
         sta m2+2
bl4      cpy #7
         beq bl5

         clc
         lda m1+1
         adc #10
         sta m1+1
         sta m2+1
         bcc bl6

         inc m1+2
         inc m2+2
bl6      iny
         bne bl4

bl5      jsr inmode
         lda #$39
m1       jsr decben
         beq qbexit

         jsr setbench
bloop    lda startp+1
         bne bl7

         lda t3
         beq bl8

         jsr incgen
         jmp bl8

bl7      lda t3
         bpl bl9

         jsr generate
bl11     jsr cleanup
bl8      lda #$39
m2       jsr decben
         bne bloop

bexit    jsr exitbench
         jsr showbench
         jsr calcspd
qbexit   jsr tograph
         jsr zerocc
         jsr calccells
         jsr showscn
         jmp cont17u

bl9      beq bl10

         jsr zerocc
         jsr generate
         jsr showscn
         jmp bl11

bl10     jsr showscn
         jmp bl8

cont15   cmp #"R"-"A"+$c1
         bne cont16

         jsr totext
         jsr inborn
         cpx #27
         beq finish

         ldx #2
         jsr setrconst
         jsr instay
         ldx #0
         jsr setrconst
         jsr fillrt
finish   jsr tograph
         jsr showrules
         jsr calccells    ;for load sequence
         jsr showscn
         jmp cont17u      ;showscn also calls crsrset! but crsrset is fast now...

cont16   cmp #$1d   ;cursor right
         bne cont16x

         jsr crsrclr
         ldy #right
         jsr shift
         bcc cright

         lda vptilecx
         adc #7
         jmp qleft

cright   inc vptilecx
         lda crsrbit
         cmp #1
         beq cxright

         lsr crsrbit
         jmp cont17u

cxright  lda #$80
         bne cm6

cont16x  cmp #$9d   ;cursor left
         bne cont16b

         jsr crsrclr
         ldy #left
         jsr shift
         bcc cleft

         lda vptilecx
         sbc #8
qleft    sta vptilecx
         jmp cont17u

cleft    dec vptilecx
         lda crsrbit
         cmp #$80
         beq cxleft

         asl crsrbit
         jmp cont17u

cxleft   lda #1
cm6      ldx #0
cm1      sta t1
         stx i2
         lda (crsrtile),y
         tax
         iny
         lda (crsrtile),y
         cmp #>plainbox
         bne cm4

         cpx #<plainbox
         bne cm4
         jmp cont17u

cm4      sta crsrtile+1
         stx crsrtile
cm5      lda t1
         ldx i2
         sta crsrbit,x
         jmp cont17u

cont16b  cmp #$91   ;cursor up
         bne cont16c

         jsr crsrclr
         ldy #up
         jsr shift
         bcc cup

         lda vptilecy
         sbc #8
qup      sta vptilecy
         jmp cont17u

cup      dec vptilecy
         lda crsrbyte
         beq cxup

         dec crsrbyte
         jmp cont17u

cxup     lda #7
cm3      ldx #1
         bpl cm1

cont16c  cmp #$11   ;cursor down
         bne cont17

         jsr crsrclr
         ldy #down
         jsr shift
         bcc cdown

         lda vptilecy
         adc #7
         bcc qup

cdown    inc vptilecy
         lda crsrbyte
         cmp #7
         beq cxdown

         inc crsrbyte
         bne cont17u

cxdown   lda #0
         beq cm3

cont17   cmp #$20   ;space
         bne cont17c

         #assign16 adjcell,crsrtile
         jsr chkadd
         ldy crsrbyte
         lda (crsrtile),y
         eor crsrbit
         sta (crsrtile),y
         ldy #sum
         and crsrbit
         beq lsp1

         ldx #4
         jsr inctsum
lsp2     sta (crsrtile),y  ;always writes no-zero value, so must be AC != 0
         lda zoom
         beq lsp3

         jsr showscnz
lsp3     jsr infoout
         jmp cont17u

lsp1     jsr dectsum
         bne lsp2

cont17c  cmp #"."
         bne cont17f

         jsr crsrclr
         lda #<tiles+(tilesize*249)
         sta crsrtile
         lda #>tiles+(tilesize*249)
         sta crsrtile+1
         lda #1
         sta crsrbyte
cont17t  sta crsrbit
         jsr cont17u
         lda zoom
         beq exit0

         jsr setviewport
         jsr showscnz
cont17u  jsr crsrset
         jmp crsrcalc

cont17f  cmp #19        ;home
         bne cont17a

         jsr crsrclr
         lda #<tiles
         sta crsrtile
         lda #>tiles
         sta crsrtile+1
         lda #0
         sta crsrbyte
         lda #$80
         bne cont17t

cont17a  cmp #"L"-"A"+$41
         bne cont17b

         lda zoom
         pha
         beq nozoom1

         jsr zoomout
nozoom1  jsr totext
         jsr loadmenu
         beq exitload

cont17w  jsr loadpat
         jsr scrnorm
exitload jsr finish
         pla
         bne zoomin

exit0    rts

cont17b  cmp #"L"-"A"+$c1
         bne cont17d

         lda fnlen
         bne cont17v

exit7    rts

cont17v  lda zoom
         pha
         beq nozoom3

         jsr zoomout
nozoom3  jsr totext
         jsr out147
         jsr curoff
         jmp cont17w

cont17d  cmp #"+"
         bne cont17e

         lda zoom
         bne exit7

zoomin   jsr crsrclr
         jsr savebl     ;sets YR to 255
         sty zoom
         jsr xclrscn
         jsr setviewport
         jmp finish

cont17e  cmp #"-"
         bne cont17g

         lda zoom
         beq exit7

zoomout  lda #0
         sta zoom
         jsr savebl
         jmp finish

cont17g  cmp #"V"-"A"+$c1
         bne cont17h

         jsr totext
         jsr JPRIMM
         .byte 144,147,0

         jsr curoff
         jsr showcomm
         jmp finish

cont17h  cmp #"V"-"A"+$41
         bne cont17i

         jsr totext
         jsr curoff
         jsr infov
         jmp finish

cont17i  cmp #"Z"-"A"+$c1
         bne cont17j

         jsr totext
         jsr chgcolors
l2       jsr setcolor
         jmp finish

cont17j  cmp #"X"-"A"+$c1
         bne cont18

         jsr totext
         jsr out147
         jsr loadcf
         bcc l2

         jsr showds
         bne l2

cont18   cmp #"S"-"A"+$c1
         bne cont20

         jsr boxsz
         beq cont20

         jsr totext
         jsr getsvfn
         beq exitsave

         jsr savepat
exitsave jmp finish

cont20   clc
         rts

shift    lda $543   ;shift st
         beq cont20

         lda (crsrtile),y
         tax
         iny
         lda (crsrtile),y
         dey
         cmp #>plainbox
         bne cm4x

         cpx #<plainbox
         beq cont20

cm4x     sta crsrtile+1
         stx crsrtile
         sec
         rts
         .bend

decben   dec bencnt2+6   ;ac = $39
         ldy bencnt2+6
         cpy #$2f
         bne dbexit

         sta bencnt2+6
         dec bencnt2+5
         ldy bencnt2+5
         cpy #$2f
         bne dbexit

         sta bencnt2+5
         dec bencnt2+4
         ldy bencnt2+4
         cpy #$2f
         bne dbexit

         sta bencnt2+4
         dec bencnt2+3
         ldy bencnt2+3
         cpy #$2f
         bne dbexit

         sta bencnt2+3
         dec bencnt2+2
         ldy bencnt2+2
         cpy #$2f
         bne dbexit

         sta bencnt2+2
         dec bencnt2+1
         ldy bencnt2+1
         cpy #$2f
         bne dbexit

         sta bencnt2+1
         dec bencnt2
         ldy bencnt2
         cpy #$2f
         bne dbexit

         sta bencnt2   ;zf is set at 9999999
dbexit   rts

setbench .block
         sei
         sta $ff3f
         lda t3
         bpl cont3

         jsr restbl
         lda mode
         sta temp+1
         lda #2
         sta mode
         lda #$b
         sta $ff06
         lda #<irqbench
         sta $fffe
         ldy #$a8
         sty $ff0a
         ldx #<8850  ;0.01 sec
         ldy #>8850
         lda ntscmask
         beq cont1

         ldx #<8940
         ldy #>8940
cont1    stx $ff00
         sty $ff01
         bpl cont2

cont3    jsr tograph
cont2    lda #$a6
         sta subrben     ;$a6 = ldx zp
         cli
         rts
         .bend

exitbench .block
         sei
         lda t3
         bpl cont3

         jsr savebl
         lda #$1b
         sta $ff06
         lda temp+1
         sta mode
         lda #$a2
         sta $ff0a
         bne cont2

cont3    jsr totext0
cont2    sta $ff3e
         lda #$60
         sta subrben     ;$60 = rts
         cli
         rts
         .bend

zerocnt  .block
;prepares/zeros benchmark counters
         lda #$30
         ldy #6
loop1    sta irqcnt,y
         sta bencnt,y
         sta bencnt2,y
         dey
         bpl loop1

         sta irqcnt+7
         rts
         .bend

