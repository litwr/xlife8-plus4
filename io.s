loadpat  .block
         lda fnlen
         ldx #<fn
         ldy #>fn
         jsr SETNAM
         lda #8
         jsr io2
         jsr OPEN
         ldx #8
         jsr CHKIN
         bcs error

         ldy #0
loop4    jsr READSS
         bne checkst

         jsr BASIN
         cmp #193
         bcs eof

         sta x0,y     ;geometry
         iny
         cpy #2
         bne loop4

         jsr showrect
         bcs eof

         ldy #0
loop2    jsr READSS
         bne checkst

         jsr BASIN
         sta $fe8,y   ;live/born
         iny
         cpy #4
         bne loop2

         lda $fe9
         ora $feb
         cmp #2
         bcs eof

         lda $fea
         and #1
         bne eof

         ldy #3
loop1    lda live,y
         cmp $fe8,y
         bne cont1

         dey
         bpl loop1

loop5    ldy #0
loop6    jsr READSS
         bne checkst

         jsr BASIN
         sta x0,y   ;x,y - data
         iny
         cpy #2
         bne loop6

         jsr putpixel
         jmp loop5

checkst  cmp #$40
         bne error
         beq eof

error    jsr showds
         lda #0
         sta fnlen
eof      jmp endio

cont1    ldy #3
loop3    lda $fe8,y
         sta live,y
         dey
         bpl loop3

         jsr fillrt   ;sets ZF=1
         beq loop5
         .bend

showds   .block
         lda #147
         jsr BSOUT
         lda #0
         jsr SETNAM
         lda #15
         ldx $ae
         tay
         jsr SETLFS
         jsr OPEN
         ldx #15
         jsr CHKIN
loop7    jsr READSS
         bne eof15

         jsr BASIN
         jsr BSOUT
         jmp loop7

eof15    lda #15
         jsr CLOSE
         jmp getkey
         .bend

showdir  .block
         jsr dirop1
         BCS error

         LDY #6
skip6    JSR getbyte    ; get a byte from dir and ignore it
         DEY
         BNE skip6

         lda #$9c
         jsr BSOUT
loop1    jsr getbyte
         beq cont5
         
         jsr BSOUT
         jmp loop1 

cont5    lda #$d
         jsr BSOUT
next     LDY #2         ; skip 2 bytes on all other lines
skip2    JSR getbyte    ; get a byte from dir and ignore it
         DEY
         BNE skip2

         JSR getbyte    ; get low byte of filesize
         sta fileszlo
         JSR getbyte    ; get high byte
         sta fileszhi
         jsr getbyte
         cmp #$42
         beq prfree

         jsr printmi
         beq exit

         lda #2
         sta quotest
         LDA #$20       ;print a space first
char     cmp #$22       ;quote
         bne cont1
 
         dec quotest
         beq cont4

cont1    ldx quotest
         beq cont3

         cpx #2
         beq cont3

cont4    JSR BSOUT
cont3    JSR getbyte
         BNE char       ; continue until end of line

         jsr printsz
         JSR STOP       ; RUN/STOP pressed?
         BNE next       ; no RUN/STOP -> continue
         beq exit

error    jsr showds
exit     jmp endio

getbyte  JSR READSS
         BNE end

         JMP BASIN

end      PLA            ; don't return to dir reading loop
         PLA
         JMP exit

prfree   jsr JPRIMM
         .byte 144,0
         lda fileszhi
         ldx fileszlo
         jsr INT2STR
         lda #$ff
         sta quotest
         jsr JPRIMM
         .byte 32,0
         lda #$42
         bne cont4
         .bend

menucnt  = $ffb
quotest  = $ffe
fileszhi = $ffd  
fileszlo = $ffc

printmi  .block
         lda #28
         jsr BSOUT
         ldx menucnt
         cpx #100
         bcs cont

         cpx #10
         bcs cont2

         lda #32
         jsr BSOUT
cont2    lda #32
         jsr BSOUT

cont     lda #0
         jsr INT2STR
         jsr JPRIMM
         .byte 144,32,0
         inc menucnt
         rts
         .bend

skipln  .block
        JSR READSS
        BNE end

        jsr BASIN
        DEY
        BNE skipln

char    JSR READSS
        BNE end

        jsr BASIN
        BNE char       ; continue until end of line

end     rts
        .bend

printsz .block
        lda quotest
        bmi exit

        jsr JPRIMM
        .byte 32,31,0
        lda fileszhi
        ldx fileszlo
        JSR INT2STR
        lda #144
        jsr BSOUT
exit    lda #$d
        jmp BSOUT
        .bend

dirop1   LDA dirnlen
         LDX #<dirname
         LDY #>dirname
         JSR SETNAM
         LDA #8
         LDY #0         ; secondary address 0 (required for dir reading!)
         sty menucnt
         jsr io1
         jsr OPEN
         bcs error1     ; quit if OPEN failed

         LDX #8         ; filenumber 8
         JSR CHKIN
error1   rts

findfn   .block         ;fn# is at $14-15
         jsr dirop1
         BCS error

         LDY #6
         jsr skipln
         bne error

         lda $14
         beq next

loop0    ldy #4
         jsr skipln
         bne exit

         dec $14
         bne loop0

next     LDY #4
skip2    JSR getbyte    ; get a byte from dir and ignore it
         DEY
         BNE skip2

         lda #2
         sta quotest
char     cmp #$22       ;quote
         bne cont1

         dec quotest
         beq exit
         bne cont3

cont1    ldx quotest
         cpx #2
         beq cont3

cont4    ldy menucnt
         sta fn,y
         inc menucnt
cont3    JSR getbyte
         BNE char       ; continue until end of line
         beq exit

error    jsr showds
exit     lda menucnt
         sta fnlen
         jmp endio

getbyte  JSR READSS
         BNE end

         JMP BASIN

end      PLA            ; don't return to dir reading loop
         PLA
         JMP exit
         .bend

savepat  .block
sizex    = adjcell2
sizey    = adjcell2+1
xmin     = i1
ymin     = i1+1
curx     = adjcell
cury     = adjcell+1
         lda #8
         jsr io2
         ldy svfnlen
         lda #","
         sta svfn,y
         sta svfn+2,y
         lda #"u"
         sta svfn+1,y
         lda #"w"
         sta svfn+3,y
         tya
         clc
         adc #4
         ldx #<svfn
         ldy #>svfn
         jsr SETNAM
         jsr OPEN
         ldx #8
         jsr CHOUT    ;open channel for write
         bcs error

         jsr READSS
         bne error

         lda sizex
         jsr BSOUT
         jsr READSS
         bne error

         lda sizey
         jsr BSOUT
         ldy #0
loop1    jsr READSS
         bne error

         lda live,y
         jsr BSOUT
         iny
         cpy #4
         bne loop1

         lda #0
         sta curx
         sta cury
         lda #<tiles ;=0
         sta currp
         lda #>tiles
         sta currp+1
loop0    ldy #0
loop2    sei
         sta $ff3f
         lda (currp),y
         sta $ff3e
         cli
         bne cont1

loop4    iny
         cpy #8
         bne loop2

         jsr inccurrp
         inc curx
         ldx curx
         cpx #20
         bne loop0

         ldx #0
         stx curx
         inc cury
         ldy cury
         cpy #24
         bne loop0
         beq eof

error    jsr CLRCH
         jsr showds
eof      jmp endio

cont1    ldx #$ff
loop3    inx
         asl
         bcs cont4
         beq loop4
         bcc loop3

cont4    sta i2
         stx t1
         jsr READSS
         bne error

         lda curx
         asl
         asl
         asl
         adc t1
         sec
         sbc xmin
         jsr BSOUT
         jsr READSS
         bne error

         sty t1
         lda cury
         asl
         asl
         asl
         adc t1
         sec
         sbc ymin
         jsr BSOUT
         lda i2
         jmp loop3
         .bend

showcomm .block
         ldx fnlen
         bne cont2

exit1    rts

cont2    lda fn-1,x
         cmp #"*"
         beq exit1

         lda #"#"
         cpx #16
         beq cont1

         inx
cont1    sta fn-1,x
         ;lda #","     ;check file type
         ;inx
         ;sta fn-1,x
         ;lda #"s"
         ;inx
         ;sta fn-1,x
         txa
         ldx #<fn
         ldy #>fn
         .bend

showtxt  .block
         jsr SETNAM
         lda #8
         jsr io2
         jsr OPEN
         ldx #8
         jsr CHKIN
         bcs error

         lda #8
         ora ntscmask
         sta $ff07
loop6    jsr READSS
         bne checkst

         jsr BASIN
         bne cont2

         JSR STOP       ; RUN/STOP pressed?
         beq eof

         lda #$d
cont2    jsr BSOUT
         jmp loop6

checkst  cmp #$40
         beq eof

error    jsr showds
         bne endio

eof      jsr getkey
         lda #$8e
         jsr BSOUT
         .bend

endio    jsr CLRCH      ;must be after showcomm!
         LDA #8         ; filenumber 8
         jmp CLOSE

savecf   .block
         lda #0
         jsr io2
         lda #cfnlen+3
         ldx #<cfn
         ldy #>cfn
         jsr SETNAM
         lda #<borderpc
         sta i1
         lda #>borderpc
         sta i1+1
         ldx #<topology
         ldy #>topology
         lda #<i1
         jsr SAVESP
         bcc noerror

         jsr showds
noerror  rts
         .bend

loadcf   .block
         lda #1
         jsr io2
         lda #cfnlen
         ldx #<cfn+3
         ldy #>cfn+3
         jsr SETNAM
         lda #0
         jmp LOADSP
         .bend

