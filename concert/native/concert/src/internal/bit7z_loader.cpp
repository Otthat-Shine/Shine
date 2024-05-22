//
// Created by Patrick on 2024/4/30.
//

#include <new>

#include <bit7z/bit7zlibrary.hpp>

#include <concert/internal/bit7z_loader.h>

namespace concert {
Bit7zLoader *Bit7zLoader::instance = new(std::nothrow) Bit7zLoader();
Bit7zLibrary *Bit7zLoader::bit7z_lib = nullptr;

Bit7zLoader::Bit7zLoader() {
#if defined(_DEBUG)
  bit7z_lib = new Bit7zLibrary{"libs/windows/x86_64/7z.dll"};
#elif defined(__ANDROID__)
  bit7z_lib = new Bit7zLibrary{"lib7z.so"};
#elif defined(WIN32)
  bit7z_lib = new Bit7zLibrary{"7z.dll"};
#endif
}

Bit7zLoader::~Bit7zLoader() {
  if (bit7z_lib) {
    delete bit7z_lib;
    bit7z_lib = nullptr;
  }
}

Bit7zLibrary *Bit7zLoader::get_bit7z_lib() {
  return bit7z_lib;
}

void Bit7zLoader::delete_bit7z_lib() {
  if (bit7z_lib) {
    delete bit7z_lib;
    bit7z_lib = nullptr;
  }

  if (instance) {
    delete instance;
    instance = nullptr;
  }
}
}
