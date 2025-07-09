/// The user status associated with the application's session.
enum WinSessionUserState {
  /// The user is providing input to the session.
  present(0),

  /// The user activity timeout has elapsed with no interaction from the user.
  inactive(2);

  /// User status value
  final int status;

  const WinSessionUserState(this.status);

  /// Converts status value to a WinSessionUserState.
  static fromStatus(int status) => WinSessionUserState.values.firstWhere(
    (element) => element.status == status,
  );
}
