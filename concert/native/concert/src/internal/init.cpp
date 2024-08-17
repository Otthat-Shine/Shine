//
// Created by Patrick on 2024/6/1.
//

#define SODIUM_STATIC
#include <sodium.h>

#include <clocale>

#if defined(_WIN32)
#include <windows.h>
#else
#include <stdexcept>
#endif

bool Init() {
  if (sodium_init() != 0) {
    return false;
  }
  setlocale(LC_ALL, "zh_CN.UTF-8");

  return true;
}

#if defined(_WIN32)
BOOL WINAPI DllMain(
    HINSTANCE hinstDLL,
    DWORD fdwReason,
    LPVOID lpvReserved) {
  // Perform actions based on the reason for calling.
  switch (fdwReason) {
    case DLL_PROCESS_ATTACH:
      return Init();
    case DLL_THREAD_ATTACH:
      break;
    case DLL_THREAD_DETACH:
      break;
    case DLL_PROCESS_DETACH:
      break;
  }
  return TRUE;  // Successful DLL_PROCESS_ATTACH.
}
#else
__attribute__((constructor)) void onLoad() {
  if (!Init()) {
    throw std::runtime_error("Initialization failed");
  }
}
#endif


