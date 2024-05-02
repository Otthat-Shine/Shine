//
// Created by Patrick on 2024/5/1.
//

#include <concert/export_zip.h>

int ZipCompress(const char *list_of_file,
                const char *output_path,
                int compression_method,
                int compression_level,
                const char *password) {
  return concert::zip::Compress(list_of_file, output_path, compression_method, compression_level, password);
}

int ZipCompressDirectory(const char *dir_path,
                         const char *output_path,
                         int compression_method,
                         int compression_level,
                         const char *password) {
  return concert::zip::CompressDirectory(dir_path, output_path, compression_method, compression_level, password);
}

int ZipExtract(const char *archive_file, const char *output_dir, const char *password) {
  return concert::zip::Extract(archive_file, output_dir, password);
}
