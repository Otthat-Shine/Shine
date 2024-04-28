//
// Created by Patrick on 2024/4/21.
//

#ifndef CONCERT_INCLUDE_CONCERT_INTERNAL_AES_H_
#define CONCERT_INCLUDE_CONCERT_INTERNAL_AES_H_

#include <cryptopp/aes.h>

#define CONCERT_AES_INPUT_FILE_NOT_EXISTS (-1)
#define CONCERT_AES_CAN_NOT_OPEN_OUTPUT_FILE (-2)
#define CONCERT_AES_CAN_NOT_OPEN_INPUT_FILE (-3)
#define CONCERT_AES_INPUT_FILE_LESS_THAN_32BYTES (-4)
#define CONCERT_AES_EMPTY_PASSWORD (-5)

namespace concert::aes {
int Encrypt(const std::string &input_file_path,
            std::string output_file_path,
            const std::string &password);

int Decrypt(const std::string &input_file_path,
            std::string output_file_path,
            const std::string &password);
}

#endif //CONCERT_INCLUDE_CONCERT_INTERNAL_AES_H_
