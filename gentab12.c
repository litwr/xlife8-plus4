#include <stdio.h>
#if defined(CPC6128)
#define BFMT "db"
#elif defined(IBMPC)
#define BFMT "dw"
#elif defined(AMIGA)
#define BFMT "dc.w"
#elif defined(PLUS4)
#define BFMT ".byte"
#elif defined(BK0011)
#define BFMT ".word"
#else
#error The architecture is not defined!
#endif
void print(unsigned *tn, unsigned *p[]) {
   unsigned k, i, n;
#ifdef BK0011
   int off;
   for (k = 0; k < 2; k++) {
      off = 128;
      for (i = 0; i < 16; i++) {
         printf("    %s ", BFMT);
         for (n = 0; n < 15; n++)
            printf("%5d,", p[2*k][i*16 + n + off]
                + (p[2*k + 1][i*16 + n + off] << 8));
         printf("%5d\n", p[2*k][i*16 + n + off]  + (p[2*k + 1][i*16 + n + off] << 8));
         if (i*16 + n == 127) {printf("tab%d%d:\n", tn[2*k], tn[2*k + 1]); off = -128;}
      }
      printf("\n");
   }
#elif IBMPC
   for (k = 0; k < 2; k++) {
      for (i = 0; i < 16; i++) {
         n = 0;
         if (i*16 + n == 0) printf("tab%d%d:\n", tn[2*k], tn[2*k + 1]);
         printf("    %s ", BFMT);
         for (; n < 15; n++)
            printf("0%xh,", p[2*k][i*16 + n] + (p[2*k + 1][i*16 + n] << 8));
         printf("0%xh\n", p[2*k][i*16 + n]  + (p[2*k + 1][i*16 + n] << 8));
      }
      printf("\n");
   }
#elif AMIGA
   for (k = 0; k < 2; k++) {
      for (i = 0; i < 16; i++) {
         n = 0;
         if (i*16 + n == 0) printf("tab%d%d:\n", tn[2*k], tn[2*k + 1]);
         printf("    %s ", BFMT);
         for (; n < 15; n++)
            printf("$%x,", (p[2*k][i*16 + n] << 8) + p[2*k + 1][i*16 + n]);
         printf("$%x\n", (p[2*k][i*16 + n] << 8)  + p[2*k + 1][i*16 + n]);
      }
      printf("\n");
   }
#elif defined(PLUS4) || defined(CPC6128)
   for (k = 0; k < 4; k++) {
      printf("tab%d\n", tn[k]);
      for (i = 0; i < 16; i++) {
         printf("    %s ", BFMT);
         for (n = 0; n < 15; n++)
            printf("$%02x,", p[k][i*16 + n]);
         printf("$%02x\n", p[k][i*16 + n]);
      }
   }
#else
#error Not defined architecture
#endif
}
int main() {
   unsigned i, n, k, t0[256] = {0}, t1[256] = {0}, t2[256] = {0}, t3[256] = {0};
   unsigned tn[4] = {20, 21, 22, 23};
   unsigned *p[4] = {t0, t1, t2, t3};
   for (i = 0; i < 256; i++) {
      if (i&4) t3[i] += 0x10;
      if (i&2) t2[i]++;
      if (i&16) t2[i] += 16;
      if (i&8) t1[i]++;
      if (i&64) t1[i] += 16;
      if (i&32) t0[i]++;
   }
   for (i = 0; i < 256; i++) {
      unsigned l, h;
      l = t3[i] & 15;
      h = t3[i] & 240;
      t3[i] = h << 1 | l << 2;
      l = t2[i] & 15;
      h = t2[i] & 240;
      t2[i] = h << 1 | l;
      l = t1[i] & 15;
      h = t1[i] & 240;
      t1[i] = h << 1 | l;
      l = t0[i] & 15;
      h = t0[i] & 240;
      t0[i] = h >> 1 | l;
   }
   print(tn, p);
   for (k = 0; k < 4; k++) {
      tn[k] -= 10;
      for (i = 0; i < 256; i++)
         p[k][i] = 0;
   }
   for (i = 0; i < 256; i++) {
      if (i&1) t3[i] += 17;
      if (i&2) t2[i]++, t3[i] += 17;
      if (i&4) t3[i] += 16, t2[i] += 17;
      if (i&8) t2[i] += 17, t1[i]++;
      if (i&16) t2[i] += 16, t1[i] += 17;
      if (i&32) t0[i]++, t1[i] += 17;
      if (i&64) t0[i] += 17, t1[i] += 16;
      if (i&128) t0[i] += 17;
   }
   for (i = 0; i < 256; i++) {
      unsigned l, h;
      l = t3[i] & 15;
      h = t3[i] & 240;
      t3[i] = h << 1 | l << 2;
      l = t2[i] & 15;
      h = t2[i] & 240;
      t2[i] = h << 1 | l;
      l = t1[i] & 15;
      h = t1[i] & 240;
      t1[i] = h << 1 | l;
      l = t0[i] & 15;
      h = t0[i] & 240;
      t0[i] = h >> 1 | l;
   }
   print(tn, p);
   return 0;
}

