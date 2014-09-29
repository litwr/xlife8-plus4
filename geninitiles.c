//do not form plainbox - add it manually
#include <stdio.h>

#define PLUS4

#ifdef PLUS4
#define TILESIZE 61
#define TILESTART 0x7500
#define XMAX 20
#define YMAX 24
#define VIDEOYINC 0
#define VIDEOXINC 16
#define VIDEOSTART 0x2000
#endif

main() {
   int i, x, y, cur, video = VIDEOSTART;
   unsigned short b[TILESIZE/2] = {0};
   for (y = 0; y < YMAX; y++, video += VIDEOYINC)
       for (x = 0; x < XMAX; x++, video += VIDEOXINC) {
          cur = TILESTART + (y*XMAX + x)*TILESIZE;
          b[4] = cur - TILESIZE;
          b[5] = cur - TILESIZE*(XMAX + 1);
          b[6] = cur - TILESIZE*XMAX;
          b[7] = cur - TILESIZE*(XMAX - 1);
          b[8] = cur + TILESIZE;
          b[9] = cur + TILESIZE*(XMAX + 1);
          b[10] = cur + TILESIZE*XMAX;
          b[11] = cur + TILESIZE*(XMAX - 1);
          if (y == 0) {
             b[5] = cur + TILESIZE*(XMAX*(YMAX - 1) - 1);
             b[6] = cur + TILESIZE*XMAX*(YMAX - 1);
             b[7] = cur + TILESIZE*(XMAX*(YMAX - 1) + 1);
             if (x == 0) {
                b[4] = cur + TILESIZE*(XMAX - 1);
                b[5] = cur + TILESIZE*(YMAX*XMAX - 1);
                b[11] = cur + TILESIZE*(XMAX*2 - 1);
             } 
             else if (x == XMAX - 1) {
                b[7] = cur + TILESIZE*((YMAX - 2)*XMAX + 1);
                b[8] = cur - TILESIZE*(XMAX - 1);
                b[9] = cur + TILESIZE;
             }
          }
          else if (y == YMAX - 1) {
             b[9] = cur - TILESIZE*(XMAX*(YMAX - 1) - 1);
             b[10] = cur - TILESIZE*XMAX*(YMAX - 1);
             b[11] = cur - TILESIZE*(XMAX*(YMAX - 1) + 1);
             if (x == 0) {
                b[4] = cur + TILESIZE*(XMAX - 1);
                b[5] = cur - TILESIZE;
                b[11] = cur - TILESIZE*((YMAX - 2)*XMAX + 1);
             } 
             else if (x == XMAX - 1) {
                b[7] = cur - TILESIZE*(2*XMAX-1);
                b[8] = cur - TILESIZE*(XMAX - 1);
                b[9] = TILESTART;
             }
          }
          else if (x == 0) {
             b[4] = cur + TILESIZE*(XMAX - 1);
             b[5] = cur - TILESIZE;
             b[11] = cur + TILESIZE*(XMAX*2 - 1);
          }
          else if (x == XMAX - 1) {
             b[7] = cur - TILESIZE*(XMAX*2 - 1);
             b[8] = cur - TILESIZE*(XMAX - 1);
             b[9] = cur + TILESIZE;
          }
          b[29] = video;
#ifdef PLUS4
          printf("    .byte ");
          for (i = 0; i < 7; i++) printf("0, ");
          printf("0\n    .word ", b[i]);
          for (i = 4; i < 12; i++) printf("$%x, ", b[i]);
          printf("0\n    .byte ");
          for (i = 0; i < 15; i++) printf("0, ");
          printf("0\n    .byte ", b[i]);
          for (i = 0; i < 15; i++) printf("0, ");
          printf("0\n    .word $%x\n    .byte 0\n", b[29]);
#endif
#if 0
          printf("    .word ");
          for (i = 0; i < 9; i++) printf("%u, ", b[i]);
          printf("%u\n    .word ", b[i]);
          for (i = 10; i < 19; i++) printf("%u, ", b[i]);
          printf("%u\n    .word ", b[i]);
          for (i = 20; i < 29; i++) printf("%u, ", b[i]);
          printf("%u\n    .word ", b[i]);
          for (i = 30; i < 34; i++) printf("%u, ", b[i]);
          printf("%u\n", b[i]);
#endif
      }
}

