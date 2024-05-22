import 'dart:ffi';
import 'dart:io';

import 'package:concert/gen/concert.dart';
import 'package:ffi/ffi.dart';

extension FFIString on String {
  Pointer<Char> toCStr() {
    return toNativeUtf8() as Pointer<Char>;
  }
}

extension FFIPointerUtf8 on Pointer<Char> {
  String toDartString() {
    return (this as Pointer<Utf8>).toDartString();
  }
}

class Concert {
  late GenConcert _genConcert;

  Concert() {
    if (Platform.isWindows) {
      DynamicLibrary library = DynamicLibrary.open("concert.dll");
      _genConcert = GenConcert(library);
    } else if (Platform.isAndroid) {
      DynamicLibrary library = DynamicLibrary.open("libconcert.so");
      _genConcert = GenConcert(library);
    } else {
      throw "Unsupported Platform";
    }
  }

  GenConcert get func {
    return _genConcert;
  }
}
