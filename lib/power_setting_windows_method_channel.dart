import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:win32/win32.dart';

import 'model/console_display_state.dart';
import 'model/session_display_state.dart';
import 'model/session_user_state.dart';
import 'power_setting.dart';
import 'power_setting_observer.dart';
import 'power_setting_windows_platform_interface.dart';

/// An implementation of [PowerSettingWindowsPlatform] that uses method channels.
class MethodChannelPowerSettingWindows extends PowerSettingWindowsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('power_setting_windows');

  /// The event channel used to interact with the native platform.
  @visibleForTesting
  final eventChannel = const EventChannel(
    'power_setting_windows/power_setting_event',
  );

  /// Rregistered events.
  final Map<PowerSetting, int> _registeredEvents = {};

  /// PowerSettingObservers.
  final List<PowerSettingObserver> _observers = [];

  /// A subscription on events from [EventChannel].
  StreamSubscription? _subscription;

  @override
  void addObserver(PowerSettingObserver observer) {
    _observers.add(observer);
    if (_registeredEvents.isEmpty) {
      _subscription ??= eventChannel.receiveBroadcastStream().listen((event) {
        if (event is Map) {
          String guid = event['guid'] as String;
          int status = event['status'] as int;
          PowerSetting powerSetting = PowerSetting.fromGUID(guid);
          for (var observer in _observers) {
            switch (powerSetting) {
              case PowerSetting.GUID_CONSOLE_DISPLAY_STATE:
                observer.didChangeConsoleDisplayState(
                  WinConsoleDisplayState.fromStatus(status),
                );
                break;
              case PowerSetting.GUID_SESSION_DISPLAY_STATUS:
                observer.didChangeSessionDisplayState(
                  WinSessionDisplayState.fromStatus(status),
                );
                break;
              case PowerSetting.GUID_SESSION_USER_PRESENCE:
                observer.didChangeSessionUserState(
                  WinSessionUserState.fromStatus(status),
                );
                break;
            }
          }
        }
      });
      _register();
    }
  }

  @override
  void removeObserver(PowerSettingObserver observer) {
    _observers.remove(observer);
    if (_observers.isEmpty) {
      _subscription?.cancel();
      _subscription = null;
      _unregister();
    }
  }

  /// Registers the application to receive power setting notifications for the
  /// specific power setting event.
  void _register() {
    final hwnd = GetForegroundWindow();
    for (var setting in PowerSetting.values) {
      _registeredEvents.putIfAbsent(
        setting,
        () => RegisterPowerSettingNotification(
          hwnd,
          GUIDFromString(setting.guid),
          DEVICE_NOTIFY_WINDOW_HANDLE,
        ),
      );
    }
  }

  /// Unregisters the power setting notification.
  void _unregister() {
    _registeredEvents.forEach((key, value) {
      UnregisterPowerSettingNotification(value);
    });
    _registeredEvents.clear();
  }
}
