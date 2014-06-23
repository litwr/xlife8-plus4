BEGIN {
   for (i = 32; i < 127; i++)
      t[sprintf("%c", i)] = i
   printf "attl01  .byte " > "attr.inc"
   printf "txtl01  .byte "
   c = 0x10
}
{
   n = split($0, a, "\r")
   for(i = 1; i <= n; i++) {
      l = 0
      for(p = 1; p <= length(a[i]); p++) {
         s = substr(a[i], p, 1)
         if (s == "\\") {
            p++
            s = substr(a[i], p, 1)
            if (s == "g")
               c = 0x35  #green
            else if (s == "b")
               c = 0x10  #black
            else if (s == "r")
               c = 0x32  #red
            else if (s == "p")
               c = 0x44  #purple
            else if (s == "x") {
               c = 0x32
               a[i] = substr(a[i], 1, p + 1) "\\g" substr(a[i], p + 2)
            }
         }
         else {
            o = t[s]
            if (o < 0x40);
            else if (o < 0x5c)
               o -= 64
            else
               o += 32
            printf("$%x,", o)
            printf("$%x,", c) >> "attr.inc"
            l++
         }
      }
      while (l++ < 40) {
         printf("$20,")
         printf("$10,") >> "attr.inc"
      }
      printf "\n"
      printf "\n" >> "attr.inc"
      if (i != n) {
         printf "        .byte "
         printf "        .byte " >> "attr.inc"
      }
   }
   print "textn   = ", n
}

