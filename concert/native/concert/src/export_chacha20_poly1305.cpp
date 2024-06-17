//
// Created by Patrick on 2024/6/1.
//

#include <concert/export_chacha20_poly1305.h>

int ChaCha20Poly1305EncryptFile(const char *source_file,
                                const char *target_file,
                                const char *password) {
  return concert::chacha20_poly1305::Encrypt(source_file, target_file, password);
}

int ChaCha20Poly1305DecryptFile(const char *source_file,
                                const char *target_file,
                                const char *password) {
  return concert::chacha20_poly1305::Decrypt(source_file, target_file, password);
}
