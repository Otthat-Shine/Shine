//
// Created by Patrick on 2024/4/30.
//

#include <bit7z/bitfileextractor.hpp>

#include <concert/internal/zip/extract.h>
#include <concert/internal/bit7z_loader.h>

namespace concert::zip {
int Extract(const std::string &archive_file, const std::string &output_dir, const std::string &password) {
  using namespace bit7z;

  try {
    if (!std::filesystem::exists(archive_file)) {
      return CONCERT_ZIP_ARCHIVE_FILE_NOT_EXISTS;
    }
    BitFileExtractor extractor{*concert::Bit7zLoader::get_bit7z_lib(), BitFormat::Zip};

    if (!password.empty()) {
      extractor.setPassword(password);
    }
    extractor.setOverwriteMode(OverwriteMode::Overwrite);

    extractor.extract(archive_file, output_dir);
  } catch (const bit7z::BitException &ex) {
    if (std::filesystem::is_directory(output_dir)) {
      std::filesystem::remove(output_dir);
    }

    return ex.code().value();
  }

  return 0;
}
}
