/// The user status associated with the application's session.
enum SessionUserState {
  /// The user is providing input to the session.
  present(0),

  /// The user activity timeout has elapsed with no interaction from the user.
  inactive(2);

  /// User status value
  final int status;

  const SessionUserState(this.status);

  /// Converts status value to a SessionUserState.
  static fromStatus(int status) =>
      SessionUserState.values.firstWhere((element) => element.status == status);
}
