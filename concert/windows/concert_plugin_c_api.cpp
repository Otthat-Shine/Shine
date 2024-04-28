#include "include/concert/concert_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "concert_plugin.h"

void ConcertPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  concert::ConcertPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
