import 'dart:ffi';
import 'dart:io';

import 'package:concert/gen/concert.dart';
import 'package:ffi/ffi.dart';
import 'package:uuid/uuid.dart';

export 'package:concert/gen/concert.dart';
import 'package:path/path.dart' as p;

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
  late final GenConcert _genConcert;

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

  bool create(List<String> files, String dest, String password) {
    if (files.isEmpty) return false;
    if (dest.isEmpty) return false;
    if (password.isEmpty) return false;

    String fileList = '';

    for (var i = 0; i < files.length; i++) {
      if (i == files.length - 1) {
        fileList += files[i];
        break;
      }
      fileList += '${files[i]}?';
    }

    final tempFile = p.join(p.dirname(dest), const Uuid().v4());

    if (func.ZipCompress(
          fileList.toCStr(),
          tempFile.toCStr(),
          BitCompressionMethodCopy,
          BitCompressionLevelNone,
          password.toCStr(),
        ) !=
        0) {
      return false;
    }

    if (func.ChaCha20Poly1305EncryptFile(
            tempFile.toCStr(), dest.toCStr(), password.toCStr()) !=
        0) {
      return false;
    }

    File(tempFile).deleteSync();

    return true;
  }

  bool extract(String src, String dest, String password) {
    try {
      if (src.isEmpty) return false;
      if (dest.isEmpty) return false;
      if (password.isEmpty) return false;

      if (!FileSystemEntity.isDirectorySync(dest)) return false;

      final tempFile = p.join(dest, const Uuid().v4());

      if (func.ChaCha20Poly1305DecryptFile(
              src.toCStr(), tempFile.toCStr(), password.toCStr()) !=
          0) {
        return false;
      }

      if (func.ZipExtract(
              tempFile.toCStr(), dest.toCStr(), password.toCStr()) !=
          0) {
        return false;
      }

      File(tempFile).deleteSync();

      return true;
    } catch (e) {
      return false;
    }
  }

  GenConcert get func {
    return _genConcert;
  }
}
