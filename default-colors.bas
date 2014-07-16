

;default-colors.prg ==1001==
    1 dn=peek(174):if dn=0 then dn=8
    3 if dn=8 then scratch"colors-cf",u8:else:scratch"colors-cf",u9
    5 new
