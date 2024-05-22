//
// Created by patrick on 2024/5/6.
//

#include <filesystem>
#include <sys/stat.h>

#include <concert/internal/utils/file.h>

namespace concert::utils::file {
int64_t get_file_size(const std::string &path) {
  try {
    return std::filesystem::file_size(path);
  } catch (std::filesystem::filesystem_error &e) {
    return -1;
  }
}

std::string get_last_write_time(const std::string &path) {
  struct stat file_stat;

  if (stat(path.c_str(), &file_stat)) {
    return "";
  }

  char current_time[20];
  strftime(current_time, 20, "%F %T", localtime(&file_stat.st_mtime));

  return current_time;
}
}
