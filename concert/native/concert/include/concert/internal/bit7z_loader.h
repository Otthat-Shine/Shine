//
// Created by Patrick on 2024/4/30.
//

#ifndef CONCERT_INCLUDE_CONCERT_INTERNAL_BIT7Z_LOADER_H_
#define CONCERT_INCLUDE_CONCERT_INTERNAL_BIT7Z_LOADER_H_

#include <bit7z/bit7zlibrary.hpp>

namespace concert {
using namespace bit7z;

class Bit7zLoader {
 public:
  static Bit7zLibrary *get_bit7z_lib();
  static void delete_bit7z_lib();
 private:
  Bit7zLoader();
  ~Bit7zLoader();

  Bit7zLoader(const Bit7zLoader &bit7z_loader);
  const Bit7zLoader &operator=(const Bit7zLoader &bit7z_loader);
 private:
  static Bit7zLoader *instance;
  static Bit7zLibrary *bit7z_lib;
};
}

#endif //CONCERT_INCLUDE_CONCERT_INTERNAL_BIT7Z_LOADER_H_
