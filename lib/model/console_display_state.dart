/// The current monitor's display state.
enum ConsoleDisplayState {
  /// The display is off.
  off(0),

  /// The display is on.
  on(1),

  /// The display is dimmed.
  dimmed(2);

  /// Display status value
  final int status;

  const ConsoleDisplayState(this.status);

  /// Converts status value to a ConsoleDisplayState.
  static fromStatus(int status) => ConsoleDisplayState.values
      .firstWhere((element) => element.status == status);
}
