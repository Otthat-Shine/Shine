//
// Created by Patrick on 2024/4/30.
//

#ifndef CONCERT_INCLUDE_CONCERT_INTERNAL_ZIP_CODE_H_
#define CONCERT_INCLUDE_CONCERT_INTERNAL_ZIP_CODE_H_

#define BitCompressionMethodCopy 0
#define BitCompressionMethodDeflate 1
#define BitCompressionMethodDeflate64 2
#define BitCompressionMethodBZip2 3
#define BitCompressionMethodLzma 4
#define BitCompressionMethodLzma2 5
#define BitCompressionMethodPpmd 6

#define BitCompressionLevelNone 0
#define BitCompressionLevelFastest 1
#define BitCompressionLevelFast 3
#define BitCompressionLevelNormal 5
#define BitCompressionLevelMax 7
#define BitCompressionLevelUltra 9

#define CONCERT_ZIP_EMPTY_FILE_LIST (-1)
#define CONCERT_ZIP_EMPTY_OUTPUT_PATH (-2)
#define CONCERT_ZIP_INVALID_DIR_PATH (-3)
#define CONCERT_ZIP_INVALID_COMPRESSION_METHOD (-4)
#define CONCERT_ZIP_INVALID_COMPRESSION_LEVEL (-5)
#define CONCERT_ZIP_ARCHIVE_FILE_NOT_EXISTS (-6)

#endif //CONCERT_INCLUDE_CONCERT_INTERNAL_ZIP_CODE_H_
