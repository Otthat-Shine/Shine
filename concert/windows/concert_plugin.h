#ifndef FLUTTER_PLUGIN_CONCERT_PLUGIN_H_
#define FLUTTER_PLUGIN_CONCERT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace concert {

class ConcertPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ConcertPlugin();

  virtual ~ConcertPlugin();

  // Disallow copy and assign.
  ConcertPlugin(const ConcertPlugin&) = delete;
  ConcertPlugin& operator=(const ConcertPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace concert

#endif  // FLUTTER_PLUGIN_CONCERT_PLUGIN_H_
