import 'model/console_display_state.dart';
import 'model/session_display_state.dart';
import 'model/session_user_state.dart';

abstract mixin class PowerSettingObserver {
  /// The current monitor's display state has changed.
  void didChangeConsoleDisplayState(ConsoleDisplayState state) {}

  /// The display associated with the application's session has been powered on
  /// or off.
  void didChangeSessionDisplayState(SessionDisplayState state) {}

  /// The user status associated with the application's session has changed.
  void didChangeSessionUserState(SessionUserState state) {}
}
