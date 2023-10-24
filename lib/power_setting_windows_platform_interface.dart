import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'power_setting_observer.dart';
import 'power_setting_windows_method_channel.dart';

abstract class PowerSettingWindowsPlatform extends PlatformInterface {
  /// Constructs a PowerSettingWindowsPlatform.
  PowerSettingWindowsPlatform() : super(token: _token);

  static final Object _token = Object();

  static PowerSettingWindowsPlatform _instance =
      MethodChannelPowerSettingWindows();

  /// The default instance of [PowerSettingWindowsPlatform] to use.
  ///
  /// Defaults to [EventChannelPowerSettingWindows].
  static PowerSettingWindowsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PowerSettingWindowsPlatform] when
  /// they register themselves.
  static set instance(PowerSettingWindowsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Registers the given object as a power setting observer. Power setting
  /// observers are notified when various power setting events occur.
  ///
  /// See also:
  ///
  ///  * [removeObserver], to release the resources reserved by this method.
  void addObserver(PowerSettingObserver observer) {
    throw UnimplementedError('addObserver() has not been implemented.');
  }

  /// Unregisters the given observer. This should be used sparingly as
  /// it is relatively expensive (O(N) in the number of registered
  /// observers).
  ///
  /// See also:
  ///
  ///  * [addObserver], for the method that adds observers in the first place.
  void removeObserver(PowerSettingObserver observer) {
    throw UnimplementedError('removeObserver() has not been implemented.');
  }
}
