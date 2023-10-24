/// The display status associated with the application's session.
enum SessionDisplayState {
  /// The display is off.
  off(0),

  /// The display is on.
  on(1),

  /// The display is dimmed.
  dimmed(2);

  /// Display status value
  final int status;

  const SessionDisplayState(this.status);

  /// Converts status value to a SessionDisplayState.
  static fromStatus(int status) => SessionDisplayState.values
      .firstWhere((element) => element.status == status);
}
