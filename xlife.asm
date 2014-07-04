;this program doesn't contain code of the original Xlife
;written by litwr, 2013, 2014, v3
;it is under GNU GPL
         .include "plus4.mac"
         .include "xlife.mac"
         * = $1001
        .BYTE $16,$10,0,0,$9E
        .null "15872:litwr-2014"
        .BYTE 0,0

irq210x  pha         ;for zoom in - text mode
         txa
         pha
         tya
         pha
         ldx mode
         lda bgedit,x
         sta $ff15
         sta $ff3e
         jsr KBDREAD
         sta $ff3f
         pla
         tay
         lda #<irq195x
         sta $fffe
         lda #195
         bne irqe1
         ;jmp irqe

irq195x  pha
         lda bgbl
         sta $ff15
         lda #<irq210x
         sta $fffe
         lda #210
         sta $ff0b
         bne irqe2

irq194   pha       ;irq194, irq195x, irqbench, irq210, irq210x must start at the same page
         txa
         pha
         lda #8
         sta $ff14
         lda $ff06
         and #$df
         ldx #7
irql0    dex
         bne irql0

         ldx #$c4
         stx $ff12
         sta $ff06
         lda bgbl
         sta $ff15
         lda #<irq210
         sta $fffe
         lda #210
         bne irqe1

irq210   pha
         txa
         pha
         tya
         pha
         lda #$18
         sta $ff14
         lda $ff06
         ora #$20
         sta $ff06
         lda #$c8
         sta $ff12
         ldx mode
         lda bgedit,x
         sta $ff15
         lda #<irq194
         sta $fffe
         sta $ff3e
         jsr KBDREAD
         sta $ff3f
         pla
         tay
         lda #194
irqe1    sta $ff0b
irqe     pla
         tax
irqe2    pla
         inc $ff09
         rti

irqbench .block       ;timer interrupt
         pha
         txa
         pha
         inc irqcnt+8
         ldx irqcnt+8
         cpx #$3a
         bne irqe

         lda #$30
         sta irqcnt+8
         inc irqcnt+7
         ldx irqcnt+7
         cpx #$3a
         bne irqe

         sta irqcnt+7
         inc irqcnt+5
         ldx irqcnt+5
         cpx #$3a
         bne irqe

         sta irqcnt+5
         inc irqcnt+4
         ldx irqcnt+4
         cpx #$3a
         bne irqe

         sta irqcnt+4
         inc irqcnt+3
         ldx irqcnt+3
         cpx #$3a
         bne irqe

         sta irqcnt+3
         inc irqcnt+2
         ldx irqcnt+2
         cpx #$3a
         bne irqe

         sta irqcnt+2
         inc irqcnt+1
         ldx irqcnt+1
         cpx #$3a
         bne irqe

         sta irqcnt+1
         inc irqcnt
         ldx irqcnt
         cpx #$3a
         bne irqe

         sta irqcnt
         beq irqe
         .bend

crsrbit  .byte $80    ;x bit position
crsrbyte .byte 0      ;y%8
crsrx    .byte 0      ;x/4 -  not at pseudographics
crsry    .byte 0      ;y/8
ttab     .byte 0,1,2,3,3,4,5,6,7,8,8,9,$10,$11,$12,$13,$13,$14
         .byte $15,$16,$17,$18,$18,$19,$20,$21,$22,$23,$23,$24
         .byte $25,$26,$27,$28,$28,$29,$30,$31,$32,$33,$33,$34
         .byte $35,$36,$37,$38,$38,$39,$40,$41,$42,$43,$43,$44
         .byte $45,$46,$47,$48,$48,$49,$50,$51,$52,$53,$53,$54
         .byte $55,$56,$57,$58,$58,$59,$60,$61,$62,$63,$63,$64
         .byte $65,$66,$67,$68,$68,$69,$70,$71,$72,$73,$73,$74
         .byte $75,$76,$77,$78,$78,$79,$80,$81,$82,$83,$83,$84
         .byte $85,$86,$87,$88,$88,$89,$90,$91,$92,$93,$93,$94
         .byte $95,$96,$97,$98,$98,$99
ctab     .byte 0,8,$16,$24,$32,$40,$48,$56,$64,$72,$80,$88,$96
         .byte 4,$12,$20,$28,$36,$44,$52,$60,$68,$76,$84
zoom     .byte 0
fnlen    .byte 0
dirnlen  .byte 0 
dirname  .TEXT "$0:"      ;filename used to access directory
         .repeat 17,0
cfnlen   = live-cfn-3
cfn      .text "@0:colors-cf"
live     .byte 12,0
born     .byte 8,0
density  .byte 4
eval1    .byte $c4,"("              ;str$(ddddddd/dddddd.dd)
bencnt   .byte 0,0,0,0,0,0,0,$ad
irqcnt   .byte 0,0,0,0,0,0,".", 0,0,")",0
vptilecx .byte 0
vptilecy .byte 0
borderpc .byte $28    ;plain
bordertc .byte $25    ;torus
crsrc    .byte $6b
crsrocc  .byte $e3    ;over cell
livcellc .byte $25
newcellc .byte $55
bgedit   .byte $71
bggo     .byte $75
bgbl     .byte $76
topology .byte 0      ;0 - torus
copyleft .text "(c)"

         * = $1200    ;must be page aligned
         .include "gentab.s"
tab3     .byte 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
         .byte 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5
         .byte 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5
         .byte 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6
         .byte 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5
         .byte 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6
         .byte 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6
         .byte 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7
         .byte 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5
         .byte 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6
         .byte 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6
         .byte 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7
         .byte 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6
         .byte 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7
         .byte 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7
         .byte 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8

crsrclr  .block
;removes cursor from graph screen
;in: zoom, crsrtile, crsrbyte, crsrbit, pseudoc
;change: 7, currp:2, i1:2, pctemp1:8, pctemp2:8, t1
         lda zoom
         bne exit

         #assign16 currp,crsrtile
         ldy #video
         lda (currp),y
         sta i1
         iny
         lda (currp),y
         sta i1+1
         ldy crsrbyte
         lda crsrbit
         and #$f0
         beq cont1

         lda pseudoc
         bne cont2

         #vidmac1
exit     rts

cont2    lda #pc
         clc
         adc crsrbyte
         sta t1
         #vidmac1p
         rts

cont1    lda #8
         eor i1
         sta i1
         lda pseudoc
         bne cont3

         #vidmac2
         rts

cont3    lda #pc
         clc
         adc crsrbyte
         sta t1
         lda (currp),y
         sty 7
         sta i2
         ldy t1
         lda (currp),y
         tay
         and i2
         ldx 7
         sta pctemp1,x   ;old
         tya
         ldy crsrbyte
         .bend

xcont7   eor #$ff
         and i2
         sta pctemp2,x   ;new
         #vidmac2p
         rts

inccurrp .block
;increases currp
;change: currp:2
;# of calls: 2 
         lda currp
         clc
         adc #tilesize
         sta currp
         bcc cont10

         inc currp+1
cont10   rts
         .bend

inputhex .block
;gets 2 hex digits and prints them
;out: ZF=1 - empty input 
;in: a - hicur, y - lowcur
;changes: t1
;uses: getkey, curoff
;# of calls: 9
         sty t1
         sta $ff0c
loop3    ldy #0
loop1    tya
         clc
         adc t1
         sta $ff0d
         jsr getkey
         cmp #$d
         beq cont1

         cmp #$14   ;backspace
         beq cont2

         cmp #"0"
         bcc loop1

         cmp #"f"+1
         bcs loop1

         cmp #"a"
         bcs cont7

         cmp #"9"+1
         bcs loop1

cont7    cpy #2    ;hex length limit
         beq loop1

loop8    jsr BSOUT
         iny
         bpl loop1

cont1    cpy #1
         beq loop1

         jsr curoff
         tya
         rts

cont2    dey
         bmi loop3

         dey
         jmp loop8
         .bend

zerocnt  .block
;prepares/zeros benchmark counters
         lda #$30
         ldy #5
loop1    sta irqcnt,y
         sta bencnt,y
         dey
         bpl loop1

         sta irqcnt+7
         sta irqcnt+8
         sta bencnt+6
         rts
         .bend

curoff   lda #$ff
         sta $ff0c
         sta $ff0d
         rts       ;AC =/= 0!

io2      tay
io1      ldx curdev
         jmp SETLFS

tograph0 lda #$18
         ora ntscmask
         sta $ff07
         lda #$3b
         sta $ff06
         lda #$18
         sta $ff14
         lda #$c8
         sta $ff12
         sei
         sta $ff3f
         lda #<irq194
         sta $fffe
         lda #194
         sta $ff0b
         cli
         rts

infoout  .block
         ldy #4
loop2    lda cellcnt,y
         sta $fc9,y
         dey
         bpl loop2

         jmp showtinfo
         .bend

copyr    lda #3
         ldx #<copyleft
         ldy #>copyleft
         jmp showtxt

         * = $1800
         .include "ramdata.s"

         * = $3e00
start    lda $ff07
         and #$40
         sta ntscmask
         jsr loadcf
         jsr copyr
         lda #$88
         ora ntscmask
         sta $ff07
         jsr help
         lda #147
         jsr BSOUT
         #iniram
         sei
         sta $ff3f
         jsr setcolor
         lda #$18
         sta $ff14
         lda #$3b
         sta $ff06
         lda #$18
         ora ntscmask
         sta $ff07
         lda #$c8
         sta $ff12
         lda #<irq194
         sta $fffe
         lda #>irq194
         sta $ffff
         lda #194
         sta $ff0b
         lda #$a2
         sta $ff0a
         lda #"G"-"A"+1
         sta $fc0
         lda #"%"
         sta $fd2
         lda #"X"-"A"+1
         sta $fdf
         lda #"Y"-"A"+1
         sta $fe4
         cli

         #zero16 tilecnt
         sta mode
         sta pseudoc
         #inibcd gencnt,6
         #inibcd xcrsr,2
         #inibcd ycrsr,2

         ;jsr inilinks
         ;jsr torus
         ;jsr plain

         ldy #1
         sty startp
         dey
         sty startp+1
         lda #<tiles
         sta crsrtile
         lda #>tiles
         sta crsrtile+1
         jsr zerocc
         jsr infoout
         jsr showrules
         jsr crsrset       ;unite with the next!
         jsr crsrcalc
mainloop jsr dispatcher
         lda mode
         beq mainloop

         cmp #3
         bne cont3

         sta $ff3e
         lda #$ee
         sta $ff19
         lda #$71
         sta $ff15
         lda #8
         ora ntscmask
         sta $ff07
         jsr JPRIMM
         .byte 147
         .text "welcome to basic!"
         .byte $d,0
         jsr NEW
         jmp WARMRESTART

cont3    lda tilecnt
         bne cont4

         lda tilecnt+1
         bne cont4

         sta mode
         beq mainloop

cont4    lda mode
         cmp #2
         bne cont5

         jsr generate     ;hide
         jsr cleanup
         jmp mainloop

cont5    jsr zerocc
         jsr generate
         jsr showscn
         jsr cleanup
         jmp mainloop

         .include "interface.s"
         .include "tile.s"
         .include "utils.s"
         .include "io.s"
         .include "rules.s"
         .include "ramdisk.s"

generate .block
         #assign16 currp,startp
loop     ldy #sum
         lda (currp),y
         bne cont3

         jmp lnext

cont3    ldy #0		;up
         lda (currp),y
         beq ldown

         tax
         ldy #up
         jsr iniadjc
         clc
         ldy #count+31
         jsr fixcnt1e

         ldy #count+7
         jsr fixcnt1

         ldy #count
         jsr fixcnt2
         jsr chkadd

ldown    ldy #7
         lda (currp),y
         beq lleft

         tax
         ldy #down
         jsr iniadjc
         clc
         ldy #count+3
         jsr fixcnt1e

         ldy #count+27
         jsr fixcnt1

         ldy #count+28
         jsr fixcnt2
         jsr chkadd

lleft    ldy #left
         jsr iniadjc
         ldy #0
         sty t1   ;change indicator
         lda (currp),y
         and #$80
         beq ll1

         sta t1
         ldy #count+3
         #ispyr adjcell
         ldy #count+7
         #ispyr adjcell
         ldy #ul
         jsr iniadjc2
         ldy #count+31
         #ispyr adjcell2
         jsr chkadd2

ll1      ldy #1
         lda (currp),y
         and #$80
         beq ll2

         sta t1
         ldy #count+3
         #ispyr adjcell
         ldy #count+7
         #ispyr adjcell
         ldy #count+11
         #ispyr adjcell
ll2      ldy #2
         lda (currp),y
         and #$80
         beq ll3

         sta t1
         ldy #count+7
         #ispyr adjcell
         ldy #count+11
         #ispyr adjcell
         ldy #count+15
         #ispyr adjcell
ll3      ldy #3
         lda (currp),y
         and #$80
         beq ll4

         sta t1
         ldy #count+11
         #ispyr adjcell
         ldy #count+15
         #ispyr adjcell
         ldy #count+19
         #ispyr adjcell
ll4      ldy #4
         lda (currp),y
         and #$80
         beq ll5

         sta t1
         ldy #count+15
         #ispyr adjcell
         ldy #count+19
         #ispyr adjcell
         ldy #count+23
         #ispyr adjcell
ll5      ldy #5
         lda (currp),y
         and #$80
         beq ll6

         sta t1
         ldy #count+19
         #ispyr adjcell
         ldy #count+23
         #ispyr adjcell
         ldy #count+27
         #ispyr adjcell
ll6      ldy #6
         lda (currp),y
         and #$80
         beq ll7

         sta t1
         ldy #count+23
         #ispyr adjcell
         ldy #count+27
         #ispyr adjcell
         ldy #count+31
         #ispyr adjcell
ll7      ldy #7
         lda (currp),y
         and #$80
         beq lexit

         sta t1
         ldy #count+27
         #ispyr adjcell
         ldy #count+31
         #ispyr adjcell
         ldy #dl
         jsr iniadjc2
         ldy #count+3
         #ispyr adjcell2
         jsr chkadd2
lexit    jsr chkaddt
         ldy #right
         jsr iniadjc
         ldy #0
         sty t1   ;change indicator
         lda (currp),y
         and #1
         beq lr1

         sta t1
         ldy #count
         lda #$10
         clc
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+4
         adc (adjcell),y
         sta (adjcell),y
         ldy #ur
         jsr iniadjc2
         lda #$10
         ldy #count+28
         adc (adjcell2),y
         sta (adjcell2),y
         jsr chkadd2
lr1      ldy #1
         lda (currp),y
         and #1
         beq lr2

         sta t1
         ldy #count
         lda #$10
         clc
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+4
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+8
         adc (adjcell),y
         sta (adjcell),y
lr2      ldy #2
         lda (currp),y
         and #1
         beq lr3

         sta t1
         ldy #count+4
         lda #$10
         clc
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+8
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+12
         adc (adjcell),y
         sta (adjcell),y
lr3      ldy #3
         lda (currp),y
         and #1
         beq lr4

         sta t1
         ldy #count+8
         lda #$10
         clc
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+12
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+16
         adc (adjcell),y
         sta (adjcell),y 
lr4      ldy #4
         lda (currp),y
         and #1
         beq lr5

         sta t1
         ldy #count+12
         lda #$10
         clc
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+16
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+20
         adc (adjcell),y
         sta (adjcell),y
lr5      ldy #5
         lda (currp),y
         and #1
         beq lr6

         sta t1
         ldy #count+16
         lda #$10
         clc
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+20
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+24
         adc (adjcell),y
         sta (adjcell),y
lr6      ldy #6
         lda (currp),y
         and #1
         beq lr7

         sta t1
         ldy #count+20
         lda #$10
         clc
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+24
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+28
         adc (adjcell),y
         sta (adjcell),y
lr7      ldy #7
         lda (currp),y
         and #1
         beq rexit

         sta t1
         ldy #count+24
         lda #$10
         clc
         adc (adjcell),y
         sta (adjcell),y
         lda #$10
         ldy #count+28
         adc (adjcell),y
         sta (adjcell),y
         ldy #dr
         jsr iniadjc2
         lda #$10
         ldy #count
         adc (adjcell2),y
         sta (adjcell2),y
         jsr chkadd2
rexit    jsr chkaddt

         ldy #1
         lda (currp),y
         beq l2

         tax
         clc
         ldy #count+3
         jsr fixcnt1
         ldy #count+4
         jsr fixcnt2
         ldy #count+11
         jsr fixcnt1
l2       ldy #2
         lda (currp),y
         beq l3

         tax
         clc
         ldy #count+7
         jsr fixcnt1
         ldy #count+8
         jsr fixcnt2
         ldy #count+15
         jsr fixcnt1
l3       ldy #3
         lda (currp),y
         beq l4

         tax
         clc
         ldy #count+11
         jsr fixcnt1
         ldy #count+12
         jsr fixcnt2
         ldy #count+19
         jsr fixcnt1
l4       ldy #4
         lda (currp),y
         beq l5

         tax
         clc
         ldy #count+15
         jsr fixcnt1
         ldy #count+16
         jsr fixcnt2
         ldy #count+23
         jsr fixcnt1
l5       ldy #5
         lda (currp),y
         beq l6

         tax
         clc
         ldy #count+19
         jsr fixcnt1
         ldy #count+20
         jsr fixcnt2
         ldy #count+27
         jsr fixcnt1
l6       ldy #6
         lda (currp),y
         beq lnext

         tax
         clc
         ldy #count+23
         jsr fixcnt1
         ldy #count+24
         jsr fixcnt2
         ldy #count+31
         jsr fixcnt1
lnext    ldy #next
         lda (currp),y
         tax
         iny
         lda (currp),y
         bne cont2

         cpx #1
         beq stage2

cont2    sta currp+1
         stx currp
         jmp loop

stage2   #assign16 currp,startp
         .bend

genloop2 ldy #sum
         .block
         lda #0
         sta (currp),y
         lda pseudoc   ;commented = 5% slower
         beq cont4     ;with no pseudocolor

         ldx #8
         lda #0
         sta loop8+1
         lda #pc
         sta mpc+1
loop8    ldy #0
         lda (currp),y
mpc      ldy #pc
         sta (currp),y
         inc loop8+1
         inc mpc+1
         dex
         bne loop8

cont4    #genmac count,0
         #genmac count+4,1
         #genmac count+8,2
         #genmac count+12,3
         #genmac count+16,4
         #genmac count+20,5
         #genmac count+24,6
         #genmac count+28,7
         ldy #count
         lda #0
loop3    sta (currp),y
         iny
         cpy #count+32
         bne loop3

         ldy #next
         lda (currp),y
         tax
         iny
         lda (currp),y
         bne gencont1

         cpx #1
         bne gencont1
         .bend

rts2     rts

gencont1 sta currp+1
         stx currp
         jmp genloop2

incgen   .block
         ldy #$30
         #incbcd gencnt+6
         sty gencnt+6
         #incbcd gencnt+5
         sty gencnt+5
         #incbcd gencnt+4
         sty gencnt+4
         #incbcd gencnt+3
         sty gencnt+3
         #incbcd gencnt+2
         sty gencnt+2
         #incbcd gencnt+1
         sty gencnt+1
         #incbcd gencnt
         sty gencnt
cont2    rts
         .bend

cleanup  .block
         jsr incgen
         inc clncnt
         lda #$f
         and clncnt
         bne rts2
         .bend

cleanup0 .block
         #assign16 currp,startp
         #zero16 adjcell   ;mark 1st
loop     ldy #sum
         lda (currp),y
         beq delel

         ldy #next
         lda (currp),y
         tax
         iny
         lda (currp),y
         bne cont2

         cpx #1
         bne cont2

         rts

cont2    ldy currp    ;save pointer to previous
         sty adjcell
         ldy currp+1
         sty adjcell+1
         sta currp+1
         stx currp
         jmp loop

delel    lda tilecnt
         bne l2

         dec tilecnt+1
l2       dec tilecnt
         ldy #next
         lda (currp),y
         sta i1
         iny
         lda (currp),y
         sta i1+1
         lda #0
         sta (currp),y
         dey
         sta (currp),y
         #assign16 currp,i1
         lda adjcell
         ora adjcell+1
         beq del1st

         lda i1
         sta (adjcell),y
         iny
         lda i1+1
         sta (adjcell),y
         bne loop

         lda #1
         cmp i1
         bne loop

exit     rts

del1st   #assign16 startp,i1
         lda tilecnt
         bne loop

         lda tilecnt+1
         beq exit

         jmp loop
         .bend

curdev   .byte 8
ppmode   .byte 1    ;putpixel mode: 0 - tentative, 1 - active
vistab   .byte 0,1,4,5,$10,$11,$14,$15
         .byte $40,$41,$44,$45,$50,$51,$54,$55
bittab   .byte 1,2,4,8,16,32,64,128
         .include "video.s"

         * = $7300   ;no page alignement required
tiles    .include "initiles.s"
         .include "tab12.s"

