;this program doesn't contain code of the original Xlife
;written by litwr, 2013, 2014, v4
;it is under GNU GPL
         .include "plus4.mac"
         .include "xlife.mac"
         * = $1001
        .BYTE $16,$10,0,0,$9E
        .null "16128:litwr-2014"
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
         lda $ff1f
         and #$38
         bne irqi

         jsr crsrseti
irqi     pla
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

iniadjc  lda (currp),y
         sta adjcell
         iny
         lda (currp),y
         sta adjcell+1
         rts

curoff   lda #$ff
         sta $ff0c
         sta $ff0d
         rts       ;AC =/= 0!

copyr    lda #3
         ldx #<copyleft
         ldy #>copyleft
         jmp showtxt

getkey   .block
loop     ldx $ef
         beq loop

         dec $ef
         lda $526,x
         rts
         .bend

crsrseti .block
         lda i1
         pha
         lda i1+1
         pha
         jsr crsrset1
         inc crsrsw
         lda crsrsw
         lsr
         bcc l1

         jsr pixel11  ;do not set CY
         bcc l2

l1       lda vistab,x
         asl
         ora vistab,x
         eor #$ff
         and (i1),y
         sta (i1),y
l2       pla
         sta i1+1
         pla
         sta i1
         rts
         .bend

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

         * = $1200    ;must be page aligned
vistabpc
   .byte 0, 2, 8, $a, $20, $22, $28, $2a, $80, $82, $88, $8a, $a0, $a2, $a8, $aa
   .byte 0, 1, 8, 9, $20, $21, $28, $29, $80, $81, $88, $89, $a0, $a1, $a8, $a9
   .byte 0, 2, 4, 6, $20, $22, $24, $26, $80, $82, $84, $86, $a0, $a2, $a4, $a6
   .byte 0, 1, 4, 5, $20, $21, $24, $25, $80, $81, $84, $85, $a0, $a1, $a4, $a5
   .byte 0, 2, 8, $a, $10, $12, $18, $1a, $80, $82, $88, $8a, $90, $92, $98, $9a
   .byte 0, 1, 8, 9, $10, $11, $18, $19, $80, $81, $88, $89, $90, $91, $98, $99
   .byte 0, 2, 4, 6, $10, $12, $14, $16, $80, $82, $84, $86, $90, $92, $94, $96
   .byte 0, 1, 4, 5, $10, $11, $14, $15, $80, $81, $84, $85, $90, $91, $94, $95
   .byte 0, 2, 8, $a, $20, $22, $28, $2a, $40, $42, $48, $4a, $60, $62, $68, $6a
   .byte 0, 1, 8, 9, $20, $21, $28, $29, $40, $41, $48, $49, $60, $61, $68, $69
   .byte 0, 2, 4, 6, $20, $22, $24, $26, $40, $42, $44, $46, $60, $62, $64, $66
   .byte 0, 1, 4, 5, $20, $21, $24, $25, $40, $41, $44, $45, $60, $61, $64, $65
   .byte 0, 2, 8, $a, $10, $12, $18, $1a, $40, $42, $48, $4a, $50, $52, $58, $5a
   .byte 0, 1, 8, 9, $10, $11, $18, $19, $40, $41, $48, $49, $50, $51, $58, $59
   .byte 0, 2, 4, 6, $10, $12, $14, $16, $40, $42, $44, $46, $50, $52, $54, $56
   .byte 0, 1, 4, 5, $10, $11, $14, $15, $40, $41, $44, $45, $50, $51, $54, $55

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

gentab
         .include "gentab.s"

crsrbit  .byte $80    ;x bit position
crsrbyte .byte 0      ;y%8
crsrx    .byte 0      ;x/4 -  not at pseudographics
crsry    .byte 0      ;y/8
zoom     .byte 0
fnlen    .byte 0
dirnlen  .byte 0
ppmode   .byte 1    ;putpixel mode: 0 - tentative, 1 - active
crsrsw   .byte 0
vistab   .byte 0,1,4,5,$10,$11,$14,$15
         .byte $40,$41,$44,$45,$50,$51,$54,$55
ctab     .byte 0,8,$16,$24,$32,$40,$48,$56,$64,$72,$80,$88,$96
         .byte 4,$12,$20,$28,$36,$44,$52,$60,$68,$76,$84

bittab   .byte 1,2,4,8,16,32,64,128
svfn     .text "@0:"
         .repeat 20,0
dirname  .TEXT "$0:"      ;filename used to access directory
         .repeat 17,0
cfnlen   = live-cfn-3
cfn      .text "@0:colors.cf"
live     .byte 12,0
born     .byte 8,0
density  .byte 3          ;maybe linked to live-born

eval1    .byte $c4,"("              ;str$(ddddddd/dddddd.dd)
bencnt   .byte 0,0,0,0,0,0,0,$ad
irqcnt   .byte 0,0,0,0,0,0,".", 0,0,")",0
vptilecx .byte 0
vptilecy .byte 0
copyleft .text "(c)"
curdev   .byte 8
borderpc .byte $28    ;plain
bordertc .byte $45    ;torus
crsrc    .byte $6b
crsrocc  .byte $e3    ;over cell
livcellc .byte $25
newcellc .byte $1d
bgedit   .byte $71
bggo     .byte $75
bgbl     .byte $76
topology .byte 0      ;0 - torus, linked to previous colors
fn       .repeat 18,0
svfnlen  .byte 0

io2      tay
io1      ldx curdev
         jmp SETLFS

set_ntsc ora ntscmask
         sta $ff07
         rts

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

iniadjc2 lda (currp),y
         sta adjcell2
         iny
         lda (currp),y
         sta adjcell2+1
         rts

zerocc   #inibcd cellcnt,4
         rts

scrnorm  lda #$1b
         bne scrblnk1

scrblnk  lda #$b
scrblnk1 sta $ff06
         rts

tograph0 lda #$18
         sta $ff14
         jsr set_ntsc
         lda #$3b
         sta $ff06
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

totext   sta $ff3e
totext0  lda #$88
         jsr set_ntsc
         lda #8
         sta $ff14
         lda #$1b
         sta $ff06
         lda #$c4
         sta $ff12
         lda #$71
         sta $ff15
         jmp savebl

tograph  lda zoom
         beq tographx

         jsr restbl
         lda livcellc
         ldy #0
s1loop   sta $800,y
         sta $900,y
         sta $a00,y
         sta $ac0,y
         iny
         bne s1loop

         sei
         sta $ff3f
         lda #<irq210x
         sta $fffe
         cli
         bne totext0

tographx jsr tograph0
         jmp restbl

         * = $1800
         .include "ramdata.s"

         * = $3f00   ;maybe lower, to the start of setcolor call ($3ef9?)
start    lda $ff07
         and #$40
         sta ntscmask
         lda $ae     ;current device #
         bne nochg

         lda curdev
nochg    sta curdev
         ldy #1
         sty startp
         dey
         sty startp+1
         lda #<tiles
         sta crsrtile
         lda #>tiles
         sta crsrtile+1
         jsr loadcf
         jsr copyr
         lda #$88
         jsr set_ntsc
         jsr TOCHARSET1   ;to caps & graphs
         #iniram
         jsr setcolor
         jsr help
         lda #147
         jsr BSOUT
         sei
         lda #>irq194
         sta $ffff
         lda #$a2
         sta $ff0a
         jsr tograph0
         lda #"G"-"A"+1
         sta $fc0
         lda #"%"
         sta $fd2
         lda #"X"-"A"+1
         sta $fdf
         lda #"Y"-"A"+1
         sta $fe4
         #zero16 tilecnt
         sta mode
         sta pseudoc
         jsr zerogc
         #inibcd xcrsr,2
         #inibcd ycrsr,2

         ;jsr inilinks
         ;jsr torus
         ;jsr plain

         jsr zerocc
         jsr infoout
         jsr showrules
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
         jsr set_ntsc
         jsr JPRIMM
         .byte 147
         .text "welcome to basic!"
         .byte $d,0
         jsr NEW
         jmp WARMRESTART

cont3    lda startp+1
         bne cont4

         sta mode
         jsr incgen
         jsr zerocc
         jsr scrnorm
         jsr showscn
         jmp mainloop

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
         clc
         #assign16 currp,startp
loop3    #setcount 0,count0
         #setcount 1,count1
         #setcount 2,count2
         #setcount 3,count3
         #setcount 4,count4
         #setcount 5,count5
         #setcount 6,count6
         #setcount 7,count7

         ldy #next+1
         lda (currp),y
         beq cont10

         tax
         dey
         lda (currp),y
         sta currp
         stx currp+1
         jmp loop3

cont10   #assign16 currp,startp
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
         ldy #count7+3
         jsr fixcnt1e

         ldy #count1+3
         jsr fixcnt1

         ldy #count0
         jsr fixcnt2
         jsr chkadd

ldown    ldy #7
         lda (currp),y
         beq lleft

         tax
         ldy #down
         jsr iniadjc
         ldy #count0+3
         jsr fixcnt1e

         ldy #count6+3
         jsr fixcnt1

         ldy #count7
         jsr fixcnt2
         jsr chkadd

lleft    ldy #left
         jsr iniadjc
         ldy #0
         sty t1   ;change indicator
         lda (currp),y
         bpl ll1

         sta t1
         ldy #count0+3
         #ispyr4 adjcell
         ldy #count1+3
         #ispyr4 adjcell
         ldy #ul
         jsr iniadjc2
         ldy #count7+3
         #ispyr4 adjcell2
         jsr chkadd2

ll1      ldy #1
         lda (currp),y
         bpl ll2

         sta t1
         ldy #count0+3
         #ispyr4 adjcell
         ldy #count1+3
         #ispyr4 adjcell
         ldy #count2+3
         #ispyr4 adjcell
ll2      ldy #2
         lda (currp),y
         bpl ll3

         sta t1
         ldy #count1+3
         #ispyr4 adjcell
         ldy #count2+3
         #ispyr4 adjcell
         ldy #count3+3
         #ispyr4 adjcell
ll3      ldy #3
         lda (currp),y
         bpl ll4

         sta t1
         ldy #count2+3
         #ispyr4 adjcell
         ldy #count3+3
         #ispyr4 adjcell
         ldy #count4+3
         #ispyr4 adjcell
ll4      ldy #4
         lda (currp),y
         bpl ll5

         sta t1
         ldy #count3+3
         #ispyr4 adjcell
         ldy #count4+3
         #ispyr4 adjcell
         ldy #count5+3
         #ispyr4 adjcell
ll5      ldy #5
         lda (currp),y
         bpl ll6

         sta t1
         ldy #count4+3
         #ispyr4 adjcell
         ldy #count5+3
         #ispyr4 adjcell
         ldy #count6+3
         #ispyr4 adjcell
ll6      ldy #6
         lda (currp),y
         bpl ll7

         sta t1
         ldy #count5+3
         #ispyr4 adjcell
         ldy #count6+3
         #ispyr4 adjcell
         ldy #count7+3
         #ispyr4 adjcell
ll7      ldy #7
         lda (currp),y
         bpl lexit

         sta t1
         ldy #count6+3
         #ispyr4 adjcell
         ldy #count7+3
         #ispyr4 adjcell
         ldy #dl
         jsr iniadjc2
         ldy #count0+3
         #ispyr4 adjcell2
         jsr chkadd2
lexit    jsr chkaddt
         ldy #right
         jsr iniadjc
         ldy #0
         sty t1   ;change indicator
         lda (currp),y
         and #1  ;no lsr! CY is used by the next ADC
         beq lr1

         sta t1
         ldy #count0
         #ispyr8 adjcell
         ldy #count1
         #ispyr8 adjcell
         ldy #ur
         jsr iniadjc2
         ldy #count7
         #ispyr8 adjcell2
         jsr chkadd2
lr1      ldy #1
         lda (currp),y
         and #1
         beq lr2

         sta t1
         ldy #count0
         #ispyr8 adjcell
         ldy #count1
         #ispyr8 adjcell
         ldy #count2
         #ispyr8 adjcell
lr2      ldy #2
         lda (currp),y
         and #1
         beq lr3

         sta t1
         ldy #count1
         #ispyr8 adjcell
         ldy #count2
         #ispyr8 adjcell
         ldy #count3
         #ispyr8 adjcell
lr3      ldy #3
         lda (currp),y
         and #1
         beq lr4

         sta t1
         ldy #count2
         #ispyr8 adjcell
         ldy #count3
         #ispyr8 adjcell
         ldy #count4
         #ispyr8 adjcell
lr4      ldy #4
         lda (currp),y
         and #1
         beq lr5

         sta t1
         ldy #count3
         #ispyr8 adjcell
         ldy #count4
         #ispyr8 adjcell
         ldy #count5
         #ispyr8 adjcell
lr5      ldy #5
         lda (currp),y
         and #1
         beq lr6

         sta t1
         ldy #count4
         #ispyr8 adjcell
         ldy #count5
         #ispyr8 adjcell
         ldy #count6
         #ispyr8 adjcell
lr6      ldy #6
         lda (currp),y
         and #1
         beq lr7

         sta t1
         ldy #count5
         #ispyr8 adjcell
         ldy #count6
         #ispyr8 adjcell
         ldy #count7
         #ispyr8 adjcell
lr7      ldy #7
         lda (currp),y
         and #1
         beq rexit

         sta t1
         ldy #count6
         #ispyr8 adjcell
         ldy #count7
         #ispyr8 adjcell
         ldy #dr
         jsr iniadjc2
         ldy #count0
         #ispyr8 adjcell2
         jsr chkadd2
rexit    jsr chkaddt

         ldy #1
         lda (currp),y
         beq l2

         tax
         ldy #count0+3
         jsr fixcnt1
         ldy #count1
         jsr fixcnt2
         ldy #count2+3
         jsr fixcnt1
l2       ldy #2
         lda (currp),y
         beq l3

         tax
         ldy #count1+3
         jsr fixcnt1
         ldy #count2
         jsr fixcnt2
         ldy #count3+3
         jsr fixcnt1
l3       ldy #3
         lda (currp),y
         beq l4

         tax
         ldy #count2+3
         jsr fixcnt1
         ldy #count3
         jsr fixcnt2
         ldy #count4+3
         jsr fixcnt1
l4       ldy #4
         lda (currp),y
         beq l5

         tax
         ldy #count3+3
         jsr fixcnt1
         ldy #count4
         jsr fixcnt2
         ldy #count5+3
         jsr fixcnt1
l5       ldy #5
         lda (currp),y
         beq l6

         tax
         ldy #count4+3
         jsr fixcnt1
         ldy #count5
         jsr fixcnt2
         ldy #count6+3
         jsr fixcnt1
l6       ldy #6
         lda (currp),y
         beq lnext

         tax
         ldy #count5+3
         jsr fixcnt1
         ldy #count6
         jsr fixcnt2
         ldy #count7+3
         jsr fixcnt1
lnext    ldy #next+1
         lda (currp),y
         beq stage2

cont2    tax
         dey
         lda (currp),y
         sta currp
         stx currp+1
         jmp loop

stage2   #assign16 currp,startp
         .bend

genloop2 .block
         ldy #sum
         lda #0
         sta (currp),y
         #genmac count0,0
         #genmac count1,1
         #genmac count2,2
         #genmac count3,3
         #genmac count4,4
         #genmac count5,5
         #genmac count6,6
         #genmac count7,7
         ldy #next+1
         lda (currp),y
         beq incgen

         tax
         dey
         lda (currp),y
         stx currp+1
         sta currp
         jmp genloop2
         .bend

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
cont2
         .bend

rts2     rts

cleanup  .block
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

         ldy #next+1
         lda (currp),y
         beq rts2

cont2    ldx currp    ;save pointer to previous
         stx adjcell
         ldx currp+1
         stx adjcell+1
         tax
         dey
         lda (currp),y
         sta currp
         stx currp+1
         jmp loop

delel    lda tilecnt
         bne l2

         dec tilecnt+1
l2       dec tilecnt

         ldy #count0
         lda #0
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y
         iny
         sta (currp),y

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
         beq exit
         jmp loop

exit     rts

del1st   #assign16 startp,i1
         ;lda startp+1
         ;bne loop
         beq exit
         jmp loop
         .bend

         .include "video.s"

         * = $8000
         .include "tab12.s"
         ;$8000+$800=$8800
tiles    .include "initiles.s"

