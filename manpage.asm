       * = $1001
       .BYTE $16,$10,0,0,$9E
       .NULL "6144:litwr-2013"
       .BYTE 0,0
       .REPEAT 2000,32

;D0 - temp, D1 - temp, 3 - screen's rows, DC-DD - # of the first line at screen
;D2-D3 (txt src), D4-D5(txt), D6-D7 (attr), E0-E1 (src attr) - for outstr
;D8-D9 - mul40
;DA - saved AC, DB - saved XR during interrupt calls
;DE-DF - line counter from start to end of list of lines
;4 - screen's line position
;7 - temp for 'page up/down' and 'end'

lineslo=   $DC
lineshi=   $DD
linen  =   3
lineclo=   $DE
linechi=   $DF
linep  =   4

       * = $1800
start  JSR help
       LDA $FF07
       ORA #$98
       STA $FF07
       LDA #0
       STA lineslo
       STA lineshi
       LDX #32
       LDA $FF07
       AND #$40
       BEQ pal

       LDX #25
pal    TXA
l0     STA linen
       SEI
       STA $FF3F
       JSR iniirq
       CLI

l7     LDA lineslo
       STA lineclo
       LDA lineshi
       STA linechi
       LDA #0
       STA linep
l5     JSR outstr
       INC linep
       INC lineclo
       BNE nc2

       INC linechi
nc2    LDA linep
       CMP linen
       BMI l5

       LDY #$80
       JSR delay

l1     LDA $FF1C
       CMP #$FF
       BNE l1

       LDA $FF1D
       CMP #$10
       BCS l1

       LDA $FF1C
       CMP #$FF
       BNE l1

       LDA #$DF
       JSR keysc
       BEQ l38
       JMP cud

l38    LDA #$FB
       JSR keysc
       BEQ l32
       JMP d

l32    LDA #$F7
       JSR keysc
       BEQ l24
       JMP hu

l24    LDA #$BF
       JSR keysc
       BNE l37

       LDA #$FD
       JSR keysc
       BEQ l1
       JMP e

l37    CMP #$FE
       BNE l2

       LDA $FF07
       AND #$40
       BNE l1

       LDA #80
       STA $FF0F
       LDA #0
       STA $FF10
       LDX linen	;cursor left
       INX
       CPX #37
       BPL l1

       TXA
       ADC lineslo
       TAY
       LDA lineshi
       ADC #0
       CMP #>textn+1
       TXA
       BCS l29
l30    JMP l0

l29    CPY #<textn+1
       BCC l30

       LDA lineslo
       BNE l11 

       DEC lineshi
l11    DEC lineslo
       LDA lineshi
       PHP
       TXA
       PLP
       BMI l14
       JMP l0

l2     CMP #$F7
       BNE l21

       LDA $FF07
       AND #$40
       BNE l14

       LDA #160
       STA $FF0F
       LDA #0
       STA $FF10
       LDX linen	;cursor right
       DEX
       TXA
       BMI l14
       JMP l0

cud    CMP #$FD
       BNE l41

       LDA pali        ;PAL's colors inversion
       EOR #1
       STA pali
       BPL l16
      
l41    CMP #$FE
       BNE l3

       LDA #<320
       STA $FF0F
       LDA #>320
       STA $FF10
       LDA lineslo      ;cursor down
       CLC
       ADC linen
       TAY
       LDA lineshi
       ADC #0
       CMP #>textn
       BCC l15
       BEQ l23
l14    JMP l1

l23    CPY #<textn
       BCS l14

l15    INC lineslo
       BNE l16
       
       INC lineshi
l16    JMP l7

l3     CMP #$F7
       BNE l17

       LDA #<641
       STA $FF0F
       LDA #>641
       STA $FF10
       LDA lineslo	;cursor up
       ORA lineshi
       BNE l8
l17    JMP l1

l8     LDA lineslo
       BNE l12

       DEC lineshi 
l12    DEC lineslo
       JMP l7

l21    CMP #$EF
       BNE l22
       
       STA $FF3E        ;esc
l40    LDA #0
       JSR keysc
       BNE l40
       JMP $FFF6

l22    CMP #$7F
       BNE l17

       SEI              ;help
       STA $FF3E
       JSR help
       LDA linen
       DEC $FF09
       JMP l0

hu     CMP #$BF
       BNE l25

       LDA #20
       STA $FF0F
       LDA #0
       STA $FF10
       LDA linen
       STA 7
       LDA lineshi	;page up
       BNE l26

       LDA lineslo
       CMP linen
       BCS l26

       LDA lineslo
       STA 7
l26    LDA lineslo
       SEC
       SBC 7
       STA lineslo
       LDA lineshi
       SBC #0
       STA lineshi
       JMP l7

l25    CMP #$DF
       BNE l17

       LDA #60
       STA $FF0F
       LDA #0
       STA $FF10
       LDA #0
       STA lineshi	;home
       STA lineslo
       JMP l7

d      CMP #$FB
r1     BNE l17

       LDA #100
       STA $FF0F
       LDA #0
       STA $FF10
       LDA linen
       ASL
       STA 7
       ADC lineslo      ;page down
       TAY
       LDA lineshi
       ADC #0
       CMP #>textn
       BCC l33
       BEQ l34
       JMP l35

l34    CPY #<textn
       BCC l33

l35    LDA #<textn
       SEC
       SBC 7
       STA lineslo
       LDA #>textn
       SBC #0
       STA lineshi
l33    LDA lineslo
       CLC
       ADC linen
       STA lineslo
       LDA lineshi
       ADC #0
       STA lineshi
       JMP l7

e      CMP #$BF
       BNE r1
 
       LDA linen       ;end
       ASL
       STA 7
       BCC l35

comm1  LDA #<irqe1
       STA $FFFE
       LDA e1_0b,X
       STA $FF0B
       LDA #$A3		;1 - hi byte
       STA $FF0A
       RTS

comm2  LDA #<irqe4
       STA $FFFE
       LDX $D1
       LDA e4_0b,X
       STA $FF0B
       LDA #$A3		;1 - hi byte
       STA $FF0A
       RTS

keysc  STA $FD30
       STA $FF08
       LDA $FF08
       CMP #$FF
       RTS

mul40  STA $D0		;($D8)=A*40
       LDA #0		;used: $D0, X
       CLC
       ASL $D0
       ROL
       ASL $D0
       ROL
       ASL $D0
       ROL
       LDX $D0
       STX $D8
       STA $D9
       ASL $D0
       ROL
       ASL $D0
       ROL
       TAX
       LDA $D0
       ADC $D8
       STA $D8
       TXA
       ADC $D9
       STA $D9
       RTS		;CY=0

delay  .block		;Y - in
l1     DEX
       BNE l1
       TYA
       LSR
       LSR
       LSR
       LSR
       LSR
       ORA #$20
       STA $FF11
       DEY
       BNE l1
       STY $FF11
       RTS
       .bend

outstr .block		;print 40 chars long string
       LDA lineclo      ;string's start address (txtl01)+40*linec
       JSR mul40
       LDX linechi
       BEQ l20

       LDA #0
loop1  ADC #40
       DEX
       BNE loop1

       ADC $D9          ;linechi < 7
       STA $D9
l20    LDA #<txtl01
       ADC $D8
       STA $D2
       LDA #>txtl01
       ADC $D9
       STA $D3
       LDA #<attl01
       ADC $D8
       STA $E0
       LDA #>attl01
       ADC $D9
       STA $E1
       LDA linep
       CMP #25
       BMI l2
       BEQ l26

       JSR mul40
       LDA $D8
       STA $D4
       STA $D6
       LDA #$10
       ADC $D9
       STA $D5
       LDA #$C
       JMP l3

l2     JSR mul40
       LDA $D8
       STA $D4
       STA $D6
       LDA #$C
       ADC $D9
       STA $D5
       LDA #8
l3     ADC $D9
       STA $D7

       LDY #39
l1     LDA ($D2),Y
       STA ($D4),Y
       JSR comm3
       STA ($D6),Y
       DEY
       BPL l1
       RTS

l26    LDY #23
l1a    LDA ($D2),Y
       STA $17E8,Y
       JSR comm3
       STA $13E8,Y
       DEY
       BPL l1a

       LDY #39
l1b    LDA ($D2),Y
       STA $13E8,Y
       JSR comm3
       STA $FE8,Y
       DEY
       CPY #23
       BNE l1b
       RTS
       .bend

       * = $1b00
irqe4  .block
       STA $DA
       STX $DB
       LDA #$13
       STA $FF1D
       INC $FF09
       LDX $D1
       LDA e4_ws,X
       BEQ l1

       TAX
l2     JSR wt35l
       DEX
       BNE l2

       LDX $D1
l1     LDA e5_0b,X
       STA $FF0B
       LDA #$A2		;0 - hi byte
       STA $FF0A
       LDA #<irqe5
       STA $FFFE
       LDX $DB
       LDA $DA
       RTI 

wt35l  LDA #<iel	;waits 35 lines
       STA $FFFE
       LDA #$36
       STA $FF0B
       CLI
l4     ORA #0
       BNE l4
       RTS

iel    LDA #$13
       STA $FF1D
       INC $FF09
       LDA #$00
       RTI
       .bend

irqe5  STA $DA
       LDA #$CA
       STA $FF1D
       LDA #$FA		;250
       STA $FF0B
       LDA #<irqe6
       STA $FFFE
       INC $FF09
       LDA $DA
       RTI

irqe6  STA $DA
       STX $DB
       LDX $D1
       LDA e6_1d,X
       STA $FF1D
       JSR comm2
       INC $FF09
       LDX $DB
       LDA $DA
       RTI

irqe1  STA $DA
       LDA #$36
       STA $FF1D
       LDA #$CA		;202
       STA $FF0B
       LDA #$A2		;0 - hi byte
       STA $FF0A
       LDA #<irqe2
       STA $FFFE
       LDA $DA
irqe0  INC $FF09
       RTI

irqe2  STA $DA
       STX $DB
       LDX $D1
       LDA e2_1d,X
       STA $FF1D
       LDA #$CD		;205
       STA $FF0B
       LDA #<irqe3
       STA $FFFE
       LDA #$10
       STA $FF14
       INC $FF09
       LDX $DB
       LDA $DA
       RTI

irqe3  STA $DA
       STX $DB
       LDX $D1
       LDA e3_1d,X
       STA $FF1D
       JSR comm1
       INC $FF09
       LDA #8
       STA $FF14
       LDX $DB
       LDA $DA
       RTI

iniirq .block		;A - number of rows
       LDX #$1B
       STX $FF06
       ORA #0
       BEQ irq0

       SEC
       SBC #25
       BEQ irq25
       BPL irq36

       ADC #24
       STA $D1
       LDA #>irqe4
       STA $FFFF
       JMP comm2

irq36  TAX
       DEX
       STX $D1
       LDA #>irqe1
       STA $FFFF
       JMP comm1

irq0   LDA #$0B
       STA $FF06
irq25  LDA #>irqe0
       STA $FFFF
       LDA #<irqe0
       STA $FFFE
       RTS
       .bend

comm3  .block
       LDA ($E0),Y
       LDX pali
       BEQ cont1

       CMP #$35
       BNE cont2

       LDA #$32
       RTS
       
cont2  CMP #$44
       BNE cont3

       LDA #$43
       RTS

cont3  CMP #$32
       BNE cont1

       LDA #$35
cont1  RTS
       .bend

help   .block
       LDA $FF07
       AND #$7F
       STA $FF07
       JSR $FF4F
       .BYTE 147,144
       .TEXT "manpage commands:"
       .BYTE $d,28
       .TEXT "  h "
       .BYTE 30
       .TEXT "- home"
       .BYTE $d,28
       .TEXT "  e "
       .BYTE 30
       .TEXT "- end"
       .BYTE $d,28
       .TEXT "  u "
       .BYTE 30
       .TEXT "- page up"
       .BYTE $d,28
       .TEXT "  d "
       .BYTE 30
       .TEXT "- page down"
       .BYTE $d,28
       .TEXT "  cursor up "
       .BYTE 30
       .TEXT "- line up"
       .BYTE $d,28
       .TEXT "  cursor down "
       .BYTE 30
       .TEXT "- line down"
       .BYTE $d,0
       LDA $FF07
       AND #$40
       BNE ntsc

       JSR $FF4F         
       .BYTE 28
       .TEXT "  cursor right "
       .BYTE 30
       .TEXT "- decrease screen size"
       .BYTE $d,28
       .TEXT "  cursor left "
       .BYTE 30
       .TEXT "- increase screen size"
       .BYTE $d,28
       .BYTE 28
       .TEXT "  p "
       .BYTE 30
       .TEXT "- invert pal colors"
       .BYTE $d,0

ntsc   JSR $FF4F
       .BYTE 28
       .TEXT "  / "
       .BYTE 30
       .TEXT "- show this screen"
       .BYTE $d,28
       .TEXT "  esc "
       .BYTE 30
       .TEXT "- quit"
       .BYTE 144,0
loop1  LDA #0
       JSR keysc
       BEQ loop1
       LDA $FF07
       ORA #$98
       STA $FF07
       RTS
       .bend

pali   .byte 0

e2_1d  .byte $C2,$BA,$B2,$AA,$A2,$9A,$92,$8A,$82,$7A,$72
e3_1d  .byte $D4,$D8,$DC,$E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC
e1_0b  .byte $35,$31,$2D,$29,$25,$21,$1D,$19,$15,$11,$0D

e4_ws  .byte   2,  2,  2,  2,  2,  2,  2,  1,  1,  1,  1,  1,  1
       .byte   1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0
e4_0b  .byte $2D,$29,$25,$21,$1D,$19,$15,$34,$30,$2C,$28,$24,$20
       .byte $1C,$18,$14,$33,$2F,$2B,$27,$23,$1F,$1B,$17
e5_0b  .byte $0A,$12,$1A,$22,$2A,$32,$3A,$42,$4A,$52,$5A,$62,$6A
       .byte $72,$7A,$82,$8A,$92,$9A,$A2,$AA,$B2,$BA,$C2
e6_1d  .byte $9A,$9E,$A2,$A6,$AA,$AE,$B2,$B6,$BA,$BE,$C2,$C6,$CA
       .byte $CE,$D2,$D6,$DA,$DE,$E2,$E6,$EA,$EE,$F2,$F6

       .include "txtl.inc"
       .include "attl.inc"

