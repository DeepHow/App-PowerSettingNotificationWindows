/// The current monitor's display state.
enum WinConsoleDisplayState {
  /// The display is off.
  off(0),

  /// The display is on.
  on(1),

  /// The display is dimmed.
  dimmed(2);

  /// Display status value
  final int status;

  const WinConsoleDisplayState(this.status);

  /// Converts status value to a WinConsoleDisplayState.
  static fromStatus(int status) => WinConsoleDisplayState.values.firstWhere(
    (element) => element.status == status,
  );
}
