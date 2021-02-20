#include <stdio.h>
#include <string.h>
#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>

static const char HDL_LOGIC_CHAR[] = { 'U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-'};

enum HDL_LOGIC_STATES {
HDL_U = 0,
HDL_X = 1,
HDL_0 = 2,
HDL_1 = 3,
HDL_Z = 4,
HDL_W = 5,
HDL_L = 6,
HDL_H = 7,
HDL_D = 8,
};

EVP_CIPHER_CTX *ctx;

void slv_to_uchar(char* datain, unsigned char* dataout, int bytelen) {

  for (int i = 0; i < bytelen; i++) {
    for (int y = 0; y < 8; y++) {
      if (*datain == HDL_1) {
        *dataout |= 1 << y;
      } else if (*datain == HDL_0) {
        *dataout &= ~(1 << y);
      }
      datain++;
    }
    dataout++;
  }

  return;

}


void slv_to_string(char* datain, char* dataout, int bytelen) {

  for (int i = 0; i < bytelen; i++) {
    *dataout = HDL_LOGIC_CHAR[*datain];
    datain++;
    dataout++;
  }

  return;

}


void uchar_to_slv(unsigned char* datain, char* dataout, int bytelen) {

  for (int i = 0; i < bytelen; i++) {
    for (int y = 0; y < 8; y++) {
      if ((*datain >> y) & 1 == 1) {
        *dataout = HDL_1 ;
      } else {
        *dataout = HDL_0;
      }
      dataout++;
    }
    datain++;
  }

  return;

}


void handleErrors(void) {

  ERR_print_errors_fp(stderr);
  abort();

}


// Create and initialize the context and nitialize the
// de/encryption operation with keys and iv.
// No padding is done
void init(unsigned char *key, unsigned char *iv, char mode) {

  if (!(ctx = EVP_CIPHER_CTX_new()))
    handleErrors();

  if (mode) {
    if (1 != EVP_DecryptInit_ex(ctx, EVP_aes_128_cbc(), NULL, key, iv))
      handleErrors();
  } else {
    if (1 != EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), NULL, key, iv))
      handleErrors();
  }

  if(1 != EVP_CIPHER_CTX_set_padding(ctx, 0))
    handleErrors();

}


// Provide the message to be de/encrypted and
// obtain the encrypted output
int crypt(char            mode,
          unsigned char  *input,
          int             input_len,
          unsigned char  *output) {

  int len = 0;

  if (mode) {
    if (1 != EVP_DecryptUpdate(ctx, output, &len, input, input_len))
      handleErrors();
  } else {
    if (1 != EVP_EncryptUpdate(ctx, output, &len, input, input_len))
      handleErrors();
  }

  return len;

}


// Finalize the de/encryption. No further bytes are written
// as padding is switched off
int finalize(char mode) {

  int len = 0;
  unsigned char data[16];

  if (mode) {
    if (1 != EVP_DecryptFinal_ex(ctx, data, &len))
      handleErrors();
  } else {
    if (1 != EVP_EncryptFinal_ex(ctx, data, &len))
      handleErrors();
  }

  // Clean up
  EVP_CIPHER_CTX_free(ctx);

  return len;

}


void cryptData(char* datain, char* key, char* iv, char mode, char start, char final, char* dataout, int bytelen) {

  int crypt_len;
  unsigned char c_din[bytelen];
  unsigned char c_key[bytelen];
  unsigned char c_iv[bytelen];
  unsigned char c_dout[bytelen];

  slv_to_uchar(datain, c_din, bytelen);
  slv_to_uchar(key, c_key, bytelen);
  slv_to_uchar(iv, c_iv, bytelen);

  if (start) {
    init(c_key, c_iv, mode);
  }

  crypt_len = crypt(mode, c_din, bytelen, c_dout);

  if (crypt_len != bytelen) {
    printf("Warning: encrypt() returned with unexpected length %d\n", crypt_len);
  }

  if (final) {
    crypt_len = finalize(mode);
    if (crypt_len != 0) {
      printf("Warning: finalize() returned with unexpected length %d\n", crypt_len);
    }
  }

  uchar_to_slv(c_dout, dataout, bytelen);

  return;

}
