//
// Created by Patrick on 2024/4/23.
//

#include <concert/export_aes.h>

int AesEncrypt(const char *input_file_path,
               const char *output_file_path,
               const char *password) {
  return concert::aes::Encrypt(input_file_path, output_file_path, password);
}

int AesDecrypt(const char *input_file_path,
               const char *output_file_path,
               const char *password) {
  return concert::aes::Decrypt(input_file_path, output_file_path, password);
}
