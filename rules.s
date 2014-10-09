;live, born - word
;fillrt
;setrconst
fillrt1  .block
         tay
         php
         lda #1
         plp
         beq l1

l2       asl
         dey
         bne l2

l1       rts
         .bend

fillrtsl .block
         adc i1
         jsr fillrt1
         sta adjcell
         lda #0
         rol
         sta adjcell+1
         txa
         rts
         .bend

fillrtsr .block
         adc #0
         jsr fillrt1
         sta adjcell2
         lda #0
         rol
         sta adjcell2+1
         rts
         .bend

fillrt2  .block
         bcc l1

         lda live
         and adjcell
         bne l2

         lda live+1
         and adjcell+1
         beq l3

l2       asl t1
         lda gentab,x
         ora t1
         sta gentab,x
         lsr t1
         bne l3

l1       lda born
         and adjcell
         bne l2

         lda born+1
         and adjcell+1
         bne l2

l3       .bend

         .block
         lda i1  ;test r
         beq l1

         lda live
         and adjcell2
         bne l2

         lda live+1
         and adjcell2+1
         beq l3

l2       lda gentab,x
         ora t1
         sta gentab,x
         bne l3

l1       lda born
         and adjcell2
         bne l2

         lda born+1
         and adjcell2+1
         bne l2
 
l3       .bend
         rts

fillrt   .block
         ldx #0
l0       lda #1
         sta t1
         lda #0
         sta gentab,x
         txa
         and #1
         sta i1  ;r - see gengentab.c
         txa
         lsr
         lsr
         lsr
         lsr
         lsr
         pha
         clc
         jsr fillrtsl
         and #$1e
         lsr
         lsr
         php
         jsr fillrtsr
         plp
         jsr fillrt2

         lda #4
         sta t1
         txa
         and #8
         lsr
         lsr
         lsr
         sta i1 ;r
         pla
         jsr fillrtsl
         and #$10
         asl
         asl
         asl
         ;sta i1+1
         asl
         php
         txa
         and #7
         jsr fillrtsr
         plp
         php
         jsr fillrt2
         
         lda #16
         sta t1
         plp
         jsr fillrt2

         lda #64
         sta t1
         txa
         and #$40
         asl
         asl
         adc #0
         sta i1
         txa
         and #$38
         lsr
         lsr
         lsr
         jsr fillrtsl
         asl
         php
         txa
         and #7
         jsr fillrtsr
         plp
         jsr fillrt2
         
         inx
         bne l0

         rts       ;ZF=1 required for loadpat

         .bend

setrconst
        .block
        stx t1
        lda #<scrstay  ;live
        cpx #0
        beq cont3

        lda #<scrborn
cont3   sta m1+1
        lda #0
        sta live,x
        sta live+1,x
loop2   dey
        bmi exit

m1      lda scrborn,y
        eor #$30
        cmp #8
        beq cont2

        tax
        lda #1
        cpx #0
        beq cont1

loop1   asl
        dex
        bne loop1

cont1   ldx t1
        ora live,x
        sta live,x
        jmp loop2

exit    rts

cont2   lda #1
        ldx t1
        sta live+1,x
        jmp loop2
        .bend

showrules
        .block
        ldy #8
        lda #32
loop6   sta $fd5,y
        dey
        bne loop6

        lda #1
loop1   bit live
        bne cont1

loop2   asl
        bne loop1

        lda live+1
        beq cont4

        lda #"8"
        jsr showr1
        beq cont3

cont4   lda #"/"
        jsr showr1
        beq cont3

        lda #1
loop4   bit born
        bne cont5

loop5   asl
        bne loop4

        lda born+1
        beq cont3

        lda #"8"
        jmp showr1

cont5   jsr showr0
        bne loop5

cont3   rts

cont1   jsr showr0
        bne loop2

        rts

showr0  sta t1
        ldx #$ff
loop3   inx
        lsr
        bcc loop3

        txa
        eor #$30
showr1  cpy #10
        bne cont2

        lda #"*"
cont2   sta $fd4,y
        iny
        lda t1
        cpy #11
        rts
        .bend

showrules2
        .block
        lda #1
loop1   bit live
        bne cont1

loop2   asl
        bne loop1

        lda live+1
        beq cont4

        lda #"8"
        jsr BSOUT
cont4   lda #"/"
        jsr BSOUT
        lda #1
loop4   bit born
        bne cont5

loop5   asl
        bne loop4

        lda born+1
        beq cont3

        lda #"8"
        jmp BSOUT

cont5   jsr showr0
        jmp loop5

cont1   jsr showr0
        jmp loop2

showr0  pha
        ldx #$ff
loop3   inx
        lsr
        bcc loop3

        txa
        eor #$30
        jsr BSOUT
        pla
cont3   rts
        .bend

