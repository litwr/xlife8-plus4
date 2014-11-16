#include <stdio.h>

//#define CPC6128
//#define PLUS4
//#define BK0011

#ifdef PLUS4
#define TILESIZE 61
#define TILESTART 0
#define XMAX 20
#define YMAX 24
#define VIDEOYINC 0
#define VIDEOXINC 16
#define VIDEOSTART 0x2000
#elif defined(CPC6128)
#define TILESIZE 61
#define TILESTART 0
#define XMAX 20
#define YMAX 24
#define VIDEOYINC 0
#define VIDEOXINC 4
#define VIDEOSTART 0xc000
#elif defined(BK0011)
#define TILESIZE 62
#define TILESTART 19330
#define XMAX 20
#define YMAX 24
#define VIDEOYINC (64*8-XMAX*2)
#define VIDEOXINC 2
#define VIDEOSTART (0x4000+32-XMAX)
#else
#error The architecture is not defined!
#endif

void printtile(unsigned short *b) {
   int i;
#ifdef PLUS4
   printf("    .byte ");
   for (i = 0; i < 7; i++) printf("0, ");
   printf("0\n    .word ");
   for (i = 4; i < 12; i++) printf("tiles+$%x, ", b[i]);
   printf("$%x\n    .byte ", b[12]);
   for (i = 0; i < 15; i++) printf("0, ");
   printf("0\n    .byte ", b[i]);
   for (i = 0; i < 15; i++) printf("0, ");
   printf("0\n    .word $%x\n    .byte 0\n", b[29]);
#elif defined(CPC6128)
   printf("    db ");
   for (i = 0; i < 7; i++) printf("0, ");
   printf("0\n    dw ");
   for (i = 4; i < 12; i++) printf("tiles+$%x, ", b[i]);
   printf("$%x\n    db ", b[12]);
   for (i = 0; i < 15; i++) printf("0, ");
   printf("0\n    db ", b[i]);
   for (i = 0; i < 15; i++) printf("0, ");
   printf("0\n    dw $%x\n    db 0\n", b[29]);
#elif defined(BK0011)
   printf("    .byte ");
   for (i = 0; i < 7; i++) printf("0, ");
   printf("%d\n    .word ", b[12]);
   for (i = 4; i < 12; i++) printf("%u, ", b[i]);
   printf("0\n    .byte ");
   for (i = 0; i < 15; i++) printf("0, ");
   printf("0\n    .byte ", b[i]);
   for (i = 0; i < 15; i++) printf("0, ");
   printf("0\n    .word %u, 0\n", b[29]);
#endif
}

int main() {
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
          printtile(b);
      }
   cur = TILESTART + YMAX*XMAX*TILESIZE;
   b[12] = b[29] = VIDEOSTART;
   for (i = 4; i <= 11; i++)
      b[i] = cur;
   printtile(b);
   return 0;
}

