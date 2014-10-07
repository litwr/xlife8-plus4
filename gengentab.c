#include <stdio.h>
#include <string.h>
#ifdef CPC6128
#define BFMT "db"
#else
#define BFMT ".byte"
#endif
int main() {
   unsigned i, n, t[256] = {0};
   char born[] = "3", live[] = "23";
   for (i = 0; i < 256; i++) {
      unsigned sl, sr, l, r;
      l = (i & 2) >> 1; //3
      r = i & 1;
      sl = (i >> 5) + r;
      sr = ((i & 0x1c) >> 2) + l;
      if (l && strchr(live, sl + '0') || l == 0 && strchr(born, sl + '0')) t[i] += 2;
      if (r && strchr(live, sr + '0') || r == 0 && strchr(born, sr + '0')) t[i] += 1;
      l = (i & 0x10) >> 4; //2
      r = (i & 8) >> 3;
      sl = (i >> 5) + r;
      sr = (i & 7) + l;
      if (l && strchr(live, sl + '0') || l == 0 && strchr(born, sl + '0')) t[i] += 8;
      if (r && strchr(live, sr + '0') || r == 0 && strchr(born, sr + '0')) t[i] += 4;
      if (l && strchr(live, sl + '0') || l == 0 && strchr(born, sl + '0')) t[i] += 32;
      if (r && strchr(live, sr + '0') || r == 0 && strchr(born, sr + '0')) t[i] += 16;
      l = (i & 0x80) >> 7; //0
      r = (i & 0x40) >> 6;
      sl = ((i & 0x38) >> 3) + r;
      sr = (i & 7) + l;
      if (l && strchr(live, sl + '0') || l == 0 && strchr(born, sl + '0')) t[i] += 128;
      if (r && strchr(live, sr + '0') || r == 0 && strchr(born, sr + '0')) t[i] += 64;
   }
   for (i = 0; i < 16; i++) {
      printf("    %s ", BFMT);
      for (n = 0; n < 15; n++)
         printf("$%02x,", t[i*16 + n]);
      printf("$%02x\n", t[i*16 + n]);
   }
   return 0;
}

