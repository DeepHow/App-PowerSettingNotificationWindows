# power_setting_windows

A Flutter plugin for receiving Windows power setting notification.

## Getting Started

Listen for power setting notifications:
```dart
class _MyAppState extends State<MyApp> with PowerSettingObserver {
  @override
  void initState() {
    super.initState();
    PowerSettingWindows.addObserver(this);
  }

  @override
  void dispose() {
    PowerSettingWindows.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeConsoleDisplayState(ConsoleDisplayState state) {
    ...
  }

  @override
  void didChangeSessionDisplayState(SessionDisplayState state) {
    ...
  }

  @override
  void didChangeSessionUserState(SessionUserState state) {
    ...
  }
}
```
