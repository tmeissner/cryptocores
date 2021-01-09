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


int encrypt(unsigned char *plaintext, int plaintext_len, unsigned char *key,
            unsigned char *ciphertext) {

  EVP_CIPHER_CTX *ctx;

  int len;
  int ciphertext_len;

  // Create and initialise the context
  if(!(ctx = EVP_CIPHER_CTX_new()))
      handleErrors();

  // Initialise the encryption operation, no IV needed in ECB mode
  if(1 != EVP_EncryptInit_ex(ctx, EVP_des_ecb(), NULL, key, NULL))
      handleErrors();

  // We don't want padding
  if(1 != EVP_CIPHER_CTX_set_padding(ctx, 0))
    handleErrors();

  // Provide the message to be encrypted, and obtain the encrypted output
  if(1 != EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len))
      handleErrors();
  ciphertext_len = len;

  //  Finalise the encryption. No further bytes are written as padding is switched off
  if(1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len))
      handleErrors();
  ciphertext_len += len;

  // Clean up
  EVP_CIPHER_CTX_free(ctx);

  return ciphertext_len;

}


int decrypt(unsigned char *ciphertext, int ciphertext_len, unsigned char *key,
            unsigned char *plaintext) {

  EVP_CIPHER_CTX *ctx;

  int len;
  int plaintext_len;

  // Create and initialise the context
  if(!(ctx = EVP_CIPHER_CTX_new()))
      handleErrors();

  // Initialise the decryption operation, no IV needed in ECB mode
  if(1 != EVP_DecryptInit_ex(ctx, EVP_des_ecb(), NULL, key, NULL))
      handleErrors();

  // We don't want padding
  if(1 != EVP_CIPHER_CTX_set_padding(ctx, 0))
    handleErrors();

  // Provide the message to be decrypted, and obtain the decrypted output
  if(1 != EVP_DecryptUpdate(ctx, plaintext, &len, ciphertext, ciphertext_len))
      handleErrors();
  plaintext_len = len;

  //  Finalise the decryption. No further bytes are written as padding is switched off
  if(1 != EVP_DecryptFinal_ex(ctx, plaintext + len, &len))
      handleErrors();
  plaintext_len += len;

  // Clean up
  EVP_CIPHER_CTX_free(ctx);

  return plaintext_len;

}


void cryptData(char* datain, char* key, char mode, char* dataout, int bytelen) {

  int crypt_len;
  unsigned char c_din[bytelen];
  unsigned char c_key[bytelen];
  unsigned char c_dout[bytelen];

  slv_to_uchar(datain, c_din, bytelen);
  slv_to_uchar(key, c_key, bytelen);

  if (mode) {
    crypt_len = encrypt(c_din, bytelen, c_key, c_dout);
  } else {
    crypt_len = decrypt(c_din, bytelen, c_key, c_dout);
  }

  if (crypt_len != 8) {
    printf("Warning: crypt operation returned with unexpected length %d\n", crypt_len);
  }

  uchar_to_slv(c_dout, dataout, bytelen);

  return;

}
