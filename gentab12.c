#include <stdio.h>
main() {
   unsigned i, n, k, t20[256] = {0}, t21[256] = {0}, t22[256] = {0}, t23[256] = {0};
   char *s[4] = {"tab20", "tab21", "tab22", "tab23"};
   char *d[4] = {"tab10", "tab11", "tab12", "tab13"};
   unsigned *p[4] = {t20, t21, t22, t23};
   for (i = 0; i < 256; i++) {
      if (i&4) t23[i] += 0x10;
      if (i&2) t22[i]++;
      if (i&16) t22[i] += 16;
      if (i&8) t21[i]++;
      if (i&64) t21[i] += 16;
      if (i&32) t20[i]++;
   }
   for (i = 0; i < 256; i++) {
      unsigned l, h;
      l = t23[i] & 15;
      h = t23[i] & 240;
      t23[i] = h << 1 | l << 2;
      l = t22[i] & 15;
      h = t22[i] & 240;
      t22[i] = h << 1 | l;
      l = t21[i] & 15;
      h = t21[i] & 240;
      t21[i] = h << 1 | l;
      l = t20[i] & 15;
      h = t20[i] & 240;
      t20[i] = h >> 1 | l;
   }
   for (k = 0; k < 4; k++) {
      printf("%s\n", s[k]);
      for (i = 0; i < 16; i++) {
         printf("    .byte ");
         for (n = 0; n < 15; n++)
            printf("$%02x,", p[k][i*16 + n]);
         printf("$%02x\n", p[k][i*16 + n]);
      }
   }
   for (k = 0; k < 4; k++)
      for (i = 0; i < 256; i++)
         p[k][i] = 0;
   for (i = 0; i < 256; i++) {
      if (i&1) t23[i] += 17;
      if (i&2) t22[i]++, t23[i] += 17;
      if (i&4) t23[i] += 16, t22[i] += 17;
      if (i&8) t22[i] += 17, t21[i]++;
      if (i&16) t22[i] += 16, t21[i] += 17;
      if (i&32) t20[i]++, t21[i] += 17;
      if (i&64) t20[i] += 17, t21[i] += 16;
      if (i&128) t20[i] += 17;
   }
   for (i = 0; i < 256; i++) {
      unsigned l, h;
      l = t23[i] & 15;
      h = t23[i] & 240;
      t23[i] = h << 1 | l << 2;
      l = t22[i] & 15;
      h = t22[i] & 240;
      t22[i] = h << 1 | l;
      l = t21[i] & 15;
      h = t21[i] & 240;
      t21[i] = h << 1 | l;
      l = t20[i] & 15;
      h = t20[i] & 240;
      t20[i] = h >> 1 | l;
   }
   for (k = 0; k < 4; k++) {
      printf("%s\n", d[k]);
      for (i = 0; i < 16; i++) {
         printf("    .byte ");
         for (n = 0; n < 15; n++)
            printf("$%02x,", p[k][i*16 + n]);
         printf("$%02x\n", p[k][i*16 + n]);
      }
   }
}

