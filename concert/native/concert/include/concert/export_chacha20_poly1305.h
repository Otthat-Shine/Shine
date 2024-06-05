//
// Created by Patrick on 2024/6/1.
//

#ifndef CONCERT_INCLUDE_CONCERT_EXPORT_CHACHA20_POLY1305_H_
#define CONCERT_INCLUDE_CONCERT_EXPORT_CHACHA20_POLY1305_H_

#include "export.h"
#include "internal/chacha20_poly1305.h"

EXPORT int ChaCha20Poly1305EncryptFile(const char *source_file,
                                       const char *target_file,
                                       const char *password);

EXPORT int ChaCha20Poly1305DecryptFile(const char *source_file,
                                       const char *target_file,
                                       const char *password);

#endif //CONCERT_INCLUDE_CONCERT_EXPORT_CHACHA20_POLY1305_H_
