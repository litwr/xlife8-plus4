loadram  .block   ;in: AC
         asl
         tax
         lda ramptrs,x
         sta $14
         lda ramptrs+1,x
         sta $15
         ldy #0
         lda ($14),y
         sta x0,y     ;geometry
         iny 
         lda ($14),y
         sta x0,y     ;geometry

         jsr showrect
         bcc cont

         rts

cont     ldy #2
         lda ($14),y
         sta m1+1
         iny
loop     lda ($14),y
         sta x0
         iny
         lda ($14),y
         sta y0
         iny
         tya
         pha 
         jsr putpixel
         pla
         tay
m1       cpy #0
         bne loop

         clc
         rts
         .bend

ramdisk  .block
         jsr JPRIMM
         .byte 147,30
         .text "enter file#"
         .byte $d,28,"0",144
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

