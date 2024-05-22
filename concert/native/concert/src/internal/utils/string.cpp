//
// Created by patrick on 2024/5/6.
//

#include <concert/internal/utils/string.h>

namespace concert::utils::string {
void split(const std::string &str, std::vector<std::string> &tokens, const std::string &delimiter) {
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