#include "include/power_setting_windows/power_setting_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "power_setting_windows_plugin.h"

void PowerSettingWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  power_setting_windows::PowerSettingWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
