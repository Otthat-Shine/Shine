#define SODIUM_STATIC

#include <cstdio>
#include <clocale>
#include <filesystem>

#include <sodium.h>

#include <concert/internal/chacha20_poly1305.h>

#define CHUNK_SIZE 4096
#define CONCERT_LENGTH 8

const unsigned char kConcert[CONCERT_LENGTH] = {0x43, 0x4F, 0x4E, 0x43, 0x45, 0x52, 0x54, 0xCC};

namespace concert::chacha20_poly1305 {
int Encrypt(const std::string &source_file,
            const std::string &target_file,
            const std::string &password) {
  setlocale(LC_ALL, "zh_CN.utf8");

  unsigned char buf_in[CHUNK_SIZE];
  unsigned char buf_out[CHUNK_SIZE + crypto_secretstream_xchacha20poly1305_ABYTES];
  unsigned char header[crypto_secretstream_xchacha20poly1305_HEADERBYTES];
  crypto_secretstream_xchacha20poly1305_state st;
  FILE *fp_t, *fp_s;
  unsigned long long out_len;
  size_t rlen;
  int eof;
  int ret = CONCERT_CHACHA20_POLY1305_ENCRYPT_FAILED;
  unsigned char tag;
  unsigned char key[crypto_secretstream_xchacha20poly1305_KEYBYTES];
  unsigned char salt[crypto_pwhash_SALTBYTES];

#if defined(_MSC_VER)
  errno_t error_fp_s = fopen_s(&fp_s, source_file.c_str(), "rb");
  errno_t error_fp_t = fopen_s(&fp_t, target_file.c_str(), "wb");

  if (error_fp_s != 0) {
    ret = CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_SOURCE_FILE;
    goto ret;
  }

  if (error_fp_t != 0) {
    ret = CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_TARGET_FILE;
    goto ret;
  }
#else
  fp_s = fopen(source_file.c_str(), "rb");
  fp_t = fopen(target_file.c_str(), "wb");

  if (fp_s == nullptr) {
    ret = CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_SOURCE_FILE;
    goto ret;
  }

  if (fp_t == nullptr) {
    ret = CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_TARGET_FILE;
    goto ret;
  }
#endif

  randombytes_buf(salt, sizeof salt);
  if (crypto_pwhash(key,
                    crypto_secretstream_xchacha20poly1305_KEYBYTES,
                    password.c_str(),
                    password.size(),
                    salt,
                    crypto_pwhash_OPSLIMIT_INTERACTIVE,
                    crypto_pwhash_MEMLIMIT_INTERACTIVE,
                    crypto_pwhash_ALG_DEFAULT) != 0) {
    ret = CONCERT_CHACHA20_POLY1305_ENCRYPT_FAILED;
    goto ret;
  }

  crypto_secretstream_xchacha20poly1305_init_push(&st, header, key);

  fwrite(kConcert, 1, CONCERT_LENGTH, fp_t);
  fwrite(salt, 1, crypto_pwhash_SALTBYTES, fp_t);
  fwrite(header, 1, crypto_secretstream_xchacha20poly1305_HEADERBYTES, fp_t);

  do {
    rlen = fread(buf_in, 1, sizeof buf_in, fp_s);
    eof = feof(fp_s);
    tag = eof ? crypto_secretstream_xchacha20poly1305_TAG_FINAL : 0;
    crypto_secretstream_xchacha20poly1305_push(&st, buf_out, &out_len, buf_in, rlen,
                                               nullptr, 0, tag);
    fwrite(buf_out, 1, (size_t) out_len, fp_t);
  } while (!eof);

  ret = 0;
  ret:
  if (fp_s != nullptr) fclose(fp_s);
  if (fp_t != nullptr) fclose(fp_t);
  if (ret != 0) {
    if (std::filesystem::exists(target_file)) std::filesystem::remove(target_file);
  }
  return ret;
}

int Decrypt(const std::string &source_file,
            const std::string &target_file,
            const std::string &password) {
  setlocale(LC_ALL, "zh_CN.utf8");

  unsigned char buf_in[CHUNK_SIZE + crypto_secretstream_xchacha20poly1305_ABYTES];
  unsigned char buf_out[CHUNK_SIZE];
  unsigned char header[crypto_secretstream_xchacha20poly1305_HEADERBYTES];
  crypto_secretstream_xchacha20poly1305_state st;
  FILE *fp_t, *fp_s;
  unsigned long long out_len;
  size_t rlen;
  int eof;
  int ret = CONCERT_CHACHA20_POLY1305_DECRYPT_FAILED;
  unsigned char tag;
  unsigned char magic_number[CONCERT_LENGTH];
  unsigned char key[crypto_secretstream_xchacha20poly1305_KEYBYTES];
  unsigned char salt[crypto_pwhash_SALTBYTES];

#if defined(_MSC_VER)
  errno_t error_fp_s = fopen_s(&fp_s, source_file.c_str(), "rb");
  errno_t error_fp_t = fopen_s(&fp_t, target_file.c_str(), "wb");

  if (error_fp_s != 0)
    return CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_SOURCE_FILE;

  if (error_fp_t != 0)
    return CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_TARGET_FILE;
#else
  fp_s = fopen(source_file.c_str(), "rb");
  fp_t = fopen(target_file.c_str(), "wb");

  if (fp_s == nullptr) {
    ret = CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_SOURCE_FILE;
    goto ret;
  }

  if (fp_t == nullptr) {
    ret = CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_TARGET_FILE;
    goto ret;
  }
#endif

  fread(magic_number, 1, CONCERT_LENGTH, fp_s);
  fread(salt, 1, crypto_pwhash_SALTBYTES, fp_s);
  fread(header, 1, crypto_secretstream_xchacha20poly1305_HEADERBYTES, fp_s);

  if (memcmp(kConcert, magic_number, sizeof(char)) != 0) {
    return CONCERT_CHACHA20_POLY1305_NOT_CONCERT_FILE;
  }

  if (crypto_pwhash(key,
                    crypto_secretstream_xchacha20poly1305_KEYBYTES,
                    password.c_str(),
                    password.size(),
                    salt,
                    crypto_pwhash_OPSLIMIT_INTERACTIVE,
                    crypto_pwhash_MEMLIMIT_INTERACTIVE,
                    crypto_pwhash_ALG_DEFAULT) != 0) {
    return CONCERT_CHACHA20_POLY1305_DECRYPT_FAILED;
  }

  if (crypto_secretstream_xchacha20poly1305_init_pull(&st, header, key) != 0) {
    goto ret; /* incomplete header */
  }
  do {
    rlen = fread(buf_in, 1, sizeof buf_in, fp_s);
    eof = feof(fp_s);
    if (crypto_secretstream_xchacha20poly1305_pull(&st, buf_out, &out_len, &tag,
                                                   buf_in, rlen, nullptr, 0) != 0) {
      goto ret; /* corrupted chunk */
    }
    if (tag == crypto_secretstream_xchacha20poly1305_TAG_FINAL) {
      if (!eof) {
        goto ret; /* end of stream reached before the end of the file */
      }
    } else { /* not the final chunk yet */
      if (eof) {
        goto ret; /* end of file reached before the end of the stream */
      }
    }
    fwrite(buf_out, 1, (size_t) out_len, fp_t);
  } while (!eof);

  ret = 0;
  ret:
  if (fp_s != nullptr) fclose(fp_s);
  if (fp_t != nullptr) fclose(fp_t);
  if (ret != 0) {
    if (std::filesystem::exists(target_file)) std::filesystem::remove(target_file);
  }
  return ret;
}
}
