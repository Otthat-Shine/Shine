//
// Created by Patrick on 2024/4/21.
//

#ifndef CONCERT_INCLUDE_CONCERT_EXPORT_AES_H_
#define CONCERT_INCLUDE_CONCERT_EXPORT_AES_H_

#include "export.h"
#include "internal/aes.h"

EXPORT int AesEncrypt(const char *input_file_path,
                      const char *output_file_path,
                      const char *password);

EXPORT int AesDecrypt(const char *input_file_path,
                      const char *output_file_path,
                      const char *password);

#endif //CONCERT_INCLUDE_CONCERT_EXPORT_AES_H_
