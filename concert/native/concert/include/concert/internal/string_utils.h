//
// Created by Patrick on 2024/4/12.
//

#ifndef CONCERT_INCLUDE_CONCERT_INTERNAL_STRING_UTILS_H_
#define CONCERT_INCLUDE_CONCERT_INTERNAL_STRING_UTILS_H_

#include <string>
#include <vector>

namespace concert {
namespace string_utils {
void split(const std::string &str, std::vector<std::string> &tokens, const std::string &delimiter);
}
}

#endif //CONCERT_INCLUDE_CONCERT_INTERNAL_STRING_UTILS_H_
