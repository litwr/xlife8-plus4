;live, born - word
;fillrt
;setrconst

fillrt   .block
         ldy #0
         lda #$f0   ;beq
         jsr fillrta
         ldy #2
         lda #$d0   ;bne
fillrta  sta m1
         sta m2
         sty t1
         lda #<gentab
         sta adjcell
         lda #>gentab
         sta adjcell+1
         lda #0
         sta i1
         sta i1+1
loop0    lda t1
         bne l5

         sta (adjcell),y
l5       lda i1+1
         and #1
m1       beq lnext

         lda i1
         and #$f
         cmp #8
         beq l1

         bcs lnext

         tay
         lda #1
         cpy #0
         beq l2

loop1    asl
         dey
         bne loop1

l2       ldy t1
         and live,y
         beq lnext

l3       ldy #0
         lda (adjcell),y
         ora #1
         sta (adjcell),y
lnext    lda i1+1
         and #2
m2       beq lnext2

         lda i1
         lsr
         lsr
         lsr
         lsr
         cmp #8
         beq l12

         bcs lnext2

         tay
         lda #1
         cpy #0
         beq l22

loop12   asl
         dey
         bne loop12

l22      ldy t1
         and live,y
         beq lnext2

l32      ldy #0
         lda (adjcell),y
         ora #2
         sta (adjcell),y
lnext2   inc i1
         inc adjcell
         bne l4

         inc i1+1
         inc adjcell+1
         bne loop0

l4       lda i1
         cmp #$89
         bne loop0

         lda i1+1
         cmp #3
         bne loop0
 
         rts       ;ZF=1

l1       lda #1
         ldy t1
         and live+1,y
         beq lnext
         bne l3

l12      lda #1
         ldy t1
         and live+1,y
         beq lnext2
         bne l32
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
        jsr $ffd2
cont4   lda #"/"
        jsr $ffd2
        lda #1
loop4   bit born
        bne cont5

loop5   asl
        bne loop4

        lda born+1
        beq cont3

        lda #"8"
        jmp $ffd2

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
        jsr $ffd2
        pla
cont3   rts
        .bend

