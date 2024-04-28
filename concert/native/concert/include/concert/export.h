#ifndef CONCERT_INCLUDE_CONCERT_EXPORT_H_
#define CONCERT_INCLUDE_CONCERT_EXPORT_H_

#if defined(__cplusplus)
#if defined(_MSC_VER)
#define EXPORT extern "C" __declspec( dllexport )
#else
#define EXPORT extern "C"
#endif
#else
#define EXPORT
#endif

#endif //CONCERT_INCLUDE_CONCERT_EXPORT_H_
