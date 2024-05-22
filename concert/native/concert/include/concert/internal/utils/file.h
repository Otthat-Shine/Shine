//
// Created by patrick on 2024/5/6.
//

#ifndef CONCERT_INCLUDE_CONCERT_INTERNAL_UTILS_FILE_H_
#define CONCERT_INCLUDE_CONCERT_INTERNAL_UTILS_FILE_H_

#include <string>

namespace concert::utils::file {
int64_t get_file_size(const std::string &path);
std::string get_last_write_time(const std::string &path);
}

#endif //CONCERT_INCLUDE_CONCERT_INTERNAL_UTILS_FILE_H_
