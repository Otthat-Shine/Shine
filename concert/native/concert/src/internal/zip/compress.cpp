//
// Created by Patrick on 2024/4/30.
//

#include <bit7z/bitfilecompressor.hpp>

#include <concert/internal/zip/compress.h>
#include <concert/internal/bit7z_loader.h>
#include <concert/internal/string_utils.h>

namespace concert::zip {
int Compress(const std::string &list_of_file,
             const std::string &output_path,
             int compression_method,
             int compression_level,
             const std::string &password) {
  using namespace bit7z;
  try {
    if (list_of_file.empty()) {
      return CONCERT_ZIP_EMPTY_FILE_LIST;
    }

    if (output_path.empty()) {
      return CONCERT_ZIP_EMPTY_OUTPUT_PATH;
    }

    // compression_method: 0, 1, 2, 3, 4, 5, 6
    if (compression_method < 0 || compression_method > 6) {
      return CONCERT_ZIP_INVALID_COMPRESSION_METHOD;
    }

    // compression level: 0, 1, 3, 5, 7, 9
    if (compression_level < 0 || compression_level > 9 || (compression_level % 2 == 0 && compression_level != 0)) {
      return CONCERT_ZIP_INVALID_COMPRESSION_LEVEL;
    }

    BitFileCompressor compressor{*concert::Bit7zLoader::get_bit7z_lib(), BitFormat::Zip};

    std::vector<std::string> files;
    concert::string_utils::split(list_of_file, files, "?");

    if (!password.empty()) {
      compressor.setPassword(password);
    }
    compressor.setCompressionMethod((BitCompressionMethod) compression_method);
    compressor.setCompressionLevel((BitCompressionLevel) compression_level);
    compressor.setOverwriteMode(OverwriteMode::Overwrite);

    compressor.compress(files, output_path);
  } catch (const bit7z::BitException &ex) {
    if (std::filesystem::exists(output_path)) {
      std::filesystem::remove(output_path);
    }

    return ex.code().value();
  }

  return 0;
}

int CompressDirectory(const std::string &dir_path,
                      const std::string &output_path,
                      int compression_method,
                      int compression_level,
                      const std::string &password) {
  using namespace bit7z;
  try {
    if (!std::filesystem::is_directory(dir_path)) {
      return CONCERT_ZIP_INVALID_DIR_PATH;
    }

    if (output_path.empty()) {
      return CONCERT_ZIP_EMPTY_OUTPUT_PATH;
    }

    // compression_method: 0, 1, 2, 3, 4, 5, 6
    if (compression_method < 0 || compression_method > 6) {
      return CONCERT_ZIP_INVALID_COMPRESSION_METHOD;
    }

    // compression level: 0, 1, 3, 5, 7, 9
    if (compression_level < 0 || compression_level > 9 || (compression_level % 2 == 0 && compression_level != 0)) {
      return CONCERT_ZIP_INVALID_COMPRESSION_LEVEL;
    }

    BitFileCompressor compressor{*concert::Bit7zLoader::get_bit7z_lib(), BitFormat::Zip};

    if (!password.empty()) {
      compressor.setPassword(password);
    }
    compressor.setCompressionMethod((BitCompressionMethod) compression_method);
    compressor.setCompressionLevel((BitCompressionLevel) compression_level);
    compressor.setOverwriteMode(OverwriteMode::Overwrite);

    if (std::filesystem::exists(output_path)) {
      std::filesystem::remove(output_path);
    }

    compressor.compressDirectory(dir_path, output_path);
  } catch (const bit7z::BitException &ex) {
    if (std::filesystem::exists(output_path)) {
      std::filesystem::remove(output_path);
    }

    return ex.code().value();
  }

  return 0;
}
}
