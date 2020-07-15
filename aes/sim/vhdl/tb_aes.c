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


void handleErrors(void)
{
    ERR_print_errors_fp(stderr);
    abort();
}


int encrypt(unsigned char *plaintext, int plaintext_len, unsigned char *key,
            unsigned char *ciphertext)
{
    EVP_CIPHER_CTX *ctx;

    int len;

    int ciphertext_len;

    /* Create and initialise the context */
    if(!(ctx = EVP_CIPHER_CTX_new()))
        handleErrors();

    /*
     * Initialise the encryption operation. IMPORTANT - ensure you use a key
     * and IV size appropriate for your cipher
     * In this example we are using 256 bit AES (i.e. a 256 bit key). The
     * IV size for *most* modes is the same as the block size. For AES this
     * is 128 bits
     */
    if(1 != EVP_EncryptInit_ex(ctx, EVP_aes_128_ecb(), NULL, key, NULL))
        handleErrors();

    if(1 != EVP_CIPHER_CTX_set_padding(ctx, 0))
      handleErrors();

    /*
     * Provide the message to be encrypted, and obtain the encrypted output.
     * EVP_EncryptUpdate can be called multiple times if necessary
     */
    if(1 != EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len))
        handleErrors();
    ciphertext_len = len;

    /*
     * Finalise the encryption. Further ciphertext bytes may be written at
     * this stage.
     */
    if(1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len))
        handleErrors();
    ciphertext_len += len;

    /* Clean up */
    EVP_CIPHER_CTX_free(ctx);

    return ciphertext_len;
}


void cryptData(char* datain, char* key, char mode, char* dataout, int len) {

  unsigned char c_data[len+1];
  unsigned char c_key[len+1];
  unsigned char c_data_e[len+1];
  int ciphertext_len;

  c_data[len] = 0;
  c_key[len] = 0;
  c_data_e[len] = 0;

  slv_to_uchar(datain, c_data, 16);
  slv_to_uchar(key, c_key, 16);

  ciphertext_len = encrypt(c_data, 128/8, c_key, c_data_e);

  uchar_to_slv(c_data_e, dataout, 16);

  return;

}
