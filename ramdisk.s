maketent .block
         ldy #2
         lda ($14),y
         lsr     ;CY=1
         sbc #1
         sta $b8
         iny
         ldx #0
         stx $b9
loop     lda ($14),y
         sta $800,x
         iny
         lda ($14),y
         sta $c00,x
         iny
         inx
         cpx $b8
         bne loop
         rts
         .bend

loadram  .block   ;in: AC
         asl
         tax
         lda ramptrs,x
         sta $14
         lda ramptrs+1,x
         sta $15
         ldy #0
         lda ($14),y
         sta x0       ;geometry
         iny 
         lda ($14),y
         sta y0       ;geometry
         jsr maketent
         jsr showrect
         bcc puttent

         rts
         .bend

puttent  .block
         lda #0
         sta currp
         lda #8
         sta currp+1
loop     ldy #0
         lda (currp),y
         sta x0
         lda currp+1
         pha
         eor #4
         sta currp+1
         lda (currp),y
         sta y0
         pla
         sta currp+1
         jsr putpixel
         inc currp
         bne l1

         inc currp+1
l1       lda $b9
         eor #8
         cmp currp+1
         bne loop

         lda currp
         cmp $b8
         bne loop

         cmp #<960
         bne l2

         lda $b9
         cmp #>960
         beq l3

l2       clc
l3       rts
         .bend

ramdisk  .block
         jsr JPRIMM
         .byte 147,30
         .text "enter file# or hit "
         .byte 28
         .text "esc"
         .byte $d,"0",144
         .text " glider"
         .byte $d,28,"1",144
         .text " small fish"
         .byte $d,28,"2",144
         .text " heavyweight spaceship"
         .byte $d,28,"3",144
         .text " r-pentomino"
         .byte $d,28,"4",144
         .text " bunnies"
         .byte $d,28,"5",144
         .text " lidka"
         .byte $d,28,"6",144
         .text " toad"
         .byte $d,28,"7",144
         .text " bi-gun"
         .byte $d,28,"8",144
         .text " acorn"
         .byte $d,28,"9",144
         .null " switch engine puffer"

loop     jsr getkey
         cmp #27
         bne cont

         rts

cont     cmp #$30
         bcc loop

         cmp #$3a
         bcs loop

         eor #$30
         jmp loadram
         .bend

