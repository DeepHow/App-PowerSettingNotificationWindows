/// The display status associated with the application's session.
enum WinSessionDisplayState {
  /// The display is off.
  off(0),

  /// The display is on.
  on(1),

  /// The display is dimmed.
  dimmed(2);

  /// Display status value
  final int status;

  const WinSessionDisplayState(this.status);

  /// Converts status value to a WinSessionDisplayState.
  static fromStatus(int status) => WinSessionDisplayState.values.firstWhere(
    (element) => element.status == status,
  );
}
