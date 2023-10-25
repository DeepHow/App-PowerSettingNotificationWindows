#include "power_setting_windows_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/event_channel.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

using ::flutter::EncodableValue;
using ::flutter::EventSink;
using ::flutter::StreamHandlerError;

namespace power_setting_windows {

// static
void PowerSettingWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "power_setting_windows",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<PowerSettingWindowsPlugin>(registrar);

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  auto eventHandler = std::make_unique<
  flutter::StreamHandlerFunctions<EncodableValue>>(
      [plugin_pointer = plugin.get()](const auto *arguments, auto &&events) {
        return plugin_pointer->OnListen(arguments, std::move(events));
      },
      [plugin_pointer = plugin.get()](const auto *arguments) {
        return plugin_pointer->OnCancel(arguments);
      });

  auto eventChannel = std::make_unique<flutter::EventChannel<EncodableValue>>(
      registrar->messenger(), "power_setting_windows/power_setting_event",
      &flutter::StandardMethodCodec::GetInstance());

  eventChannel->SetStreamHandler(std::move(eventHandler));

  registrar->AddPlugin(std::move(plugin));
}

PowerSettingWindowsPlugin::PowerSettingWindowsPlugin(
    flutter::PluginRegistrarWindows *registrar)
    : registrar(registrar) {
  window_proc_id = registrar->RegisterTopLevelWindowProcDelegate(
      [this](HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam) {
        return HandleWindowProc(hwnd, message, wParam, lParam);
      });
}

PowerSettingWindowsPlugin::~PowerSettingWindowsPlugin() {
  registrar->UnregisterTopLevelWindowProcDelegate(window_proc_id);
}

void PowerSettingWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  result->NotImplemented();
}

std::optional<LRESULT> PowerSettingWindowsPlugin::HandleWindowProc(
    HWND hwnd,
    UINT message,
    WPARAM wParam,
    LPARAM lParam) {
  std::optional<LRESULT> result = std::nullopt;

  if (power_setting_events == nullptr) {
    return result;
  }

  if (message == WM_POWERBROADCAST && wParam == PBT_POWERSETTINGCHANGE) {
    POWERBROADCAST_SETTING *ppbs = (POWERBROADCAST_SETTING*) lParam;

    // Get GUID String
    OLECHAR *guid_char;
    StringFromCLSID(ppbs->PowerSetting, &guid_char);
    std::string guid_str = Utf8FromUtf16(guid_char);
    // Release GUID String
    ::CoTaskMemFree(guid_char);
    
    if (memcmp(&ppbs->PowerSetting, &GUID_CONSOLE_DISPLAY_STATE, sizeof(GUID)) == 0) {
      unsigned int status = *(unsigned int*) ppbs->Data;
      power_setting_events->Success(ParseEvent(guid_str, status));
    } else if (memcmp(&ppbs->PowerSetting, &GUID_SESSION_DISPLAY_STATUS, sizeof(GUID)) == 0) {
      unsigned int status = *(unsigned int*) ppbs->Data;
      power_setting_events->Success(ParseEvent(guid_str, status));
    } else if (memcmp(&ppbs->PowerSetting, &GUID_SESSION_USER_PRESENCE, sizeof(GUID)) == 0) {
      unsigned int status = *(unsigned int*) ppbs->Data;
      power_setting_events->Success(ParseEvent(guid_str, status));
    }
  }

  return result;
}

std::unique_ptr<StreamHandlerError<EncodableValue>>
    PowerSettingWindowsPlugin::OnListen(
        const EncodableValue *arguments,
        std::unique_ptr<EventSink<EncodableValue>> &&events) {
  power_setting_events = std::move(events);
  return nullptr;
}

std::unique_ptr<StreamHandlerError<EncodableValue>>
    PowerSettingWindowsPlugin::OnCancel(const EncodableValue *arguments) {
  power_setting_events = nullptr;
  return nullptr;
}

EncodableValue PowerSettingWindowsPlugin::ParseEvent(
    const std::string &guid,
    const int &status) {
  auto output = flutter::EncodableMap::map();

  output.insert(std::pair<flutter::EncodableValue, flutter::EncodableValue>(
      flutter::EncodableValue("guid"),
      flutter::EncodableValue(guid)));

  output.insert(std::pair<flutter::EncodableValue, flutter::EncodableValue>(
      flutter::EncodableValue("status"),
      flutter::EncodableValue(status)));

  return EncodableValue(output);
}

std::string PowerSettingWindowsPlugin::Utf8FromUtf16(const wchar_t* utf16_string) {
  if (utf16_string == nullptr) {
    return std::string();
  }
  int target_length = ::WideCharToMultiByte(
      CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string,
      -1, nullptr, 0, nullptr, nullptr)
    -1; // remove the trailing null character
  int input_length = (int)wcslen(utf16_string);
  std::string utf8_string;
  if (target_length <= 0 || target_length > utf8_string.max_size()) {
    return utf8_string;
  }
  utf8_string.resize(target_length);
  int converted_length = ::WideCharToMultiByte(
      CP_UTF8, WC_ERR_INVALID_CHARS, utf16_string,
      input_length, utf8_string.data(), target_length, nullptr, nullptr);
  if (converted_length == 0) {
    return std::string();
  }
  return utf8_string;
}

}  // namespace power_setting_windows
