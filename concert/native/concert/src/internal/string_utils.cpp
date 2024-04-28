//
// Created by Patrick on 2024/4/12.
//

#include <string>
#include <vector>

#include <concert/internal/string_utils.h>

namespace concert {
namespace string_utils {

// Adapted from https://zhuanlan.zhihu.com/p/426939341
void split(const std::string &str, std::vector<std::string> &tokens, const std::string &delimiter = " ") {
  std::size_t previous = 0;
  std::size_t current = str.find(delimiter);

  tokens.clear();

  while (current != std::string::npos) {
    if (current > previous) {
      tokens.push_back(str.substr(previous, current - previous));
    }
    previous = current + 1;
    current = str.find(delimiter, previous);
  }

  if (previous != str.size()) {
    tokens.push_back(str.substr(previous));
  }
}
}
}
