#include <stdio.h>
#include <stdlib.h>

FILE *fout = NULL;
void fputa(const unsigned char *restrict buffer, const size_t length, FILE *stream) {
    for (unsigned int i = 0; i != length; ++i) {
        fputc(buffer[i], stream);
    }
}

int main(int argc, char *argv[]) {
  fprintf(stderr, "Send direct ESC POS sequences to the printer.\n");
  fout = stdout;

  if (setvbuf(fout, NULL, _IOFBF, 8192)) {
      fprintf(stderr, "Could not set new buffer policy on output stream\n");
  }

  const unsigned char ESC_INIT[2] = {
      // ESC @, Initialize printer, p. 412
      0x1b, 0x40
  };
  // init printer
  fputa(ESC_INIT, sizeof(ESC_INIT), fout);
  fflush(fout);

  fputa("Ozio caffé",10,fout);
  
  // cut the paper
  const unsigned char ESC_CUT[4] = {
      // GS V, Sub-Function B, p. 373
      0x1d, 0x56, 0x41,
      // Feeds paper to (cutting position + n × vertical motion unit)
      // and executes a full cut (cuts the paper completely)
      // The vertical motion unit is specified by GS P.
      0x40
  };
  fputa(ESC_CUT, sizeof(ESC_CUT), fout);
  fflush(fout);

  if (fout && fout != stdout) {
      fclose(fout), fout = NULL;
  }
  
  return(0);
}
