import 'power_setting_observer.dart';
import 'power_setting_windows_platform_interface.dart';

class PowerSettingWindows {
  /// Registers the given object as a power setting observer. Power setting
  /// observers are notified when various power setting events occur.
  ///
  /// See also:
  ///
  ///  * [removeObserver], to release the resources reserved by this method.
  static void addObserver(PowerSettingObserver observer) {
    PowerSettingWindowsPlatform.instance.addObserver(observer);
  }

  /// Unregisters the given observer. This should be used sparingly as
  /// it is relatively expensive (O(N) in the number of registered
  /// observers).
  ///
  /// See also:
  ///
  ///  * [addObserver], for the method that adds observers in the first place.
  static void removeObserver(PowerSettingObserver observer) {
    PowerSettingWindowsPlatform.instance.removeObserver(observer);
  }
}
