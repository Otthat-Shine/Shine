//
// Created by Patrick on 2024/4/30.
//

#ifndef CONCERT_INCLUDE_CONCERT_INTERNAL_ZIP_EXTRACT_H_
#define CONCERT_INCLUDE_CONCERT_INTERNAL_ZIP_EXTRACT_H_

#include <string>

#include "code.h"

namespace concert::zip {
int Extract(const std::string &archive_file, const std::string &output_dir, const std::string &password = "");
}

#endif //CONCERT_INCLUDE_CONCERT_INTERNAL_ZIP_EXTRACT_H_
