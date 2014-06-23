#include <stdio.h>
int lookup[0x388], live = 170, born = 170;

void gentab(void) {
    int i;
    for (i = 0; i <= 0x388; i++) {
       lookup[i] = 0;
       if ((i & 0x100) && (live & 1 << (i & 0xf)))
             lookup[i] |= 1;
       if ((i & 0x200) && (live & 1 << ((i & 0xf0) >> 4)))
             lookup[i] |= 2;
       if (((i & 0x100) == 0) && (born & 1 << (i & 0xf)))
             lookup[i] |= 1;
       if (((i & 0x200) == 0) && (born & 1 << ((i & 0xf0) >> 4)))
             lookup[i] |= 2;
    }
}

main() {
   int i;
   gentab();
   printf("gentab");
   for (i = 0; i <= 0x388; i++) {
      if (i%8 == 0) printf("\n          .byte "); else printf(",");
      printf("$%02x", lookup[i]);
   }
   printf("\n");
}


