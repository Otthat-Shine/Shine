#ifndef CONCERT_INCLUDE_CONCERT_INTERNAL_CHACHA20_POLY1305_H_
#define CONCERT_INCLUDE_CONCERT_INTERNAL_CHACHA20_POLY1305_H_

#include <string>

#define CONCERT_CHACHA20_POLY1305_ENCRYPT_FAILED (-2)
#define CONCERT_CHACHA20_POLY1305_DECRYPT_FAILED (-3)
#define CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_SOURCE_FILE (-4)
#define CONCERT_CHACHA20_POLY1305_CAN_NOT_OPEN_TARGET_FILE (-5)
#define CONCERT_CHACHA20_POLY1305_NOT_CONCERT_FILE (-6)

namespace concert::chacha20_poly1305 {
int Encrypt(const std::string &source_file,
            const std::string &target_file,
            const std::string &password);

int Decrypt(const std::string &source_file,
            const std::string &target_file,
            const std::string &password);
}

#endif //CONCERT_INCLUDE_CONCERT_INTERNAL_CHACHA20_POLY1305_H_
