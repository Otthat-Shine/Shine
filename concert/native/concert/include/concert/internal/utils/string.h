//
// Created by patrick on 2024/5/6.
//

#ifndef CONCERT_INCLUDE_CONCERT_INTERNAL_UTILS_STRING_H_
#define CONCERT_INCLUDE_CONCERT_INTERNAL_UTILS_STRING_H_

#include <string>
#include <vector>

namespace concert::utils::string {
void split(const std::string &str, std::vector<std::string> &tokens, const std::string &delimiter);
}

#endif //CONCERT_INCLUDE_CONCERT_INTERNAL_UTILS_STRING_H_
