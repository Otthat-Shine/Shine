//
// Created by Patrick on 2024/6/1.
//

#define SODIUM_STATIC
#include <sodium.h>

#if defined(_WIN32)
#include <windows.h>
#else
#include <stdexcept>
#endif

bool init() {
  if (sodium_init() != 0) {
    return false;
  }

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
      return init();
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
  if (!init()) {
    throw std::runtime_error("Initialization failed");
  }
}
#endif


