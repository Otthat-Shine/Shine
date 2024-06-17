//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <concert/concert_plugin_c_api.h>
#include <dynamic_color/dynamic_color_plugin_c_api.h>
#include <fullscreen_window/fullscreen_window_plugin_c_api.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <video_player_win/video_player_win_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ConcertPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConcertPluginCApi"));
  DynamicColorPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DynamicColorPluginCApi"));
  FullscreenWindowPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FullscreenWindowPluginCApi"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  VideoPlayerWinPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("VideoPlayerWinPluginCApi"));
}
