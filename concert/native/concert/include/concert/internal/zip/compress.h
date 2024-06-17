//
// Created by Patrick on 2024/4/30.
//

#ifndef CONCERT_INCLUDE_CONCERT_INTERNAL_ZIP_COMPRESS_H_
#define CONCERT_INCLUDE_CONCERT_INTERNAL_ZIP_COMPRESS_H_

#include <string>

#include "code.h"

namespace concert::zip {
int Compress(const std::string &list_of_file,
             const std::string &output_path,
             int compression_method,
             int compression_level,
             const std::string &password = "");

int CompressDirectory(const std::string &dir_path,
                      const std::string &output_path,
                      int compression_method,
                      int compression_level,
                      const std::string &password = "");
}

#endif //CONCERT_INCLUDE_CONCERT_INTERNAL_ZIP_COMPRESS_H_
