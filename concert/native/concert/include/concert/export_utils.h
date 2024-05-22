//
// Created by patrick on 2024/5/6.
//

#ifndef CONCERT_INCLUDE_CONCERT_EXPORT_UTILS_H_
#define CONCERT_INCLUDE_CONCERT_EXPORT_UTILS_H_

#include "export.h"
#include "internal/utils/file.h"

EXPORT int64_t getFileSize(const char *path);
EXPORT const char *getLastWriteTime(const char *path);

#endif //CONCERT_INCLUDE_CONCERT_EXPORT_UTILS_H_
