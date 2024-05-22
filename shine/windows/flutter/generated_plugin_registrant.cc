//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <concert/concert_plugin_c_api.h>
#include <dynamic_color/dynamic_color_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ConcertPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConcertPluginCApi"));
  DynamicColorPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DynamicColorPluginCApi"));
}
