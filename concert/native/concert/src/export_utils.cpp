//
// Created by patrick on 2024/5/6.
//

#include <concert/export_utils.h>

int64_t getFileSize(const char *path) {
  return concert::utils::file::get_file_size(path);
}
const char *getLastWriteTime(const char *path) {
  return concert::utils::file::get_last_write_time(path).c_str();
}
