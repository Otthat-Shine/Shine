//
// Created by Patrick on 2024/4/30.
//

#ifndef CONCERT_INCLUDE_CONCERT_EXPORT_ZIP_H_
#define CONCERT_INCLUDE_CONCERT_EXPORT_ZIP_H_

#include "export.h"
#include "internal/zip/compress.h"
#include "internal/zip/extract.h"
#include "internal/zip/code.h"

EXPORT int ZipCompress(const char *list_of_file,
                       const char *output_path,
                       int compression_method,
                       int compression_level,
                       const char *password);

EXPORT int ZipCompressDirectory(const char *dir_path,
                                const char *output_path,
                                int compression_method,
                                int compression_level,
                                const char *password);

EXPORT int ZipExtract(const char *archive_file, const char *output_dir, const char *password);

#endif //CONCERT_INCLUDE_CONCERT_EXPORT_ZIP_H_
