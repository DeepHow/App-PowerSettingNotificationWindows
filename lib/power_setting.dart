// ignore_for_file: constant_identifier_names
/// Power setting GUIDs identify power change events. An application should
/// register for each power change event that might impact its behavior.
/// Notification is sent each time a setting changes.
///
/// For more information, see the
/// [Power Setting GUIDs](https://learn.microsoft.com/en-us/windows/win32/power/power-setting-guids)
enum PowerSetting {
  /// The current monitor's display state has changed.
  GUID_CONSOLE_DISPLAY_STATE('{6FE69556-704A-47A0-8F24-C28D936FDA47}'),

  /// The display associated with the application's session has been powered on
  /// or off.
  GUID_SESSION_DISPLAY_STATUS('{2B84C20E-AD23-4DDF-93DB-05FFBD7EFCA5}'),

  /// The user status associated with the application's session has changed.
  GUID_SESSION_USER_PRESENCE('{3C0F4548-C03F-4C4D-B9F2-237EDE686376}');

  /// Power setting GUID
  final String guid;

  const PowerSetting(this.guid);

  /// Converts a GUID string to a PowerSetting.
  static PowerSetting fromGUID(String guid) => PowerSetting.values.firstWhere(
      (element) => element.guid.toUpperCase() == guid.toUpperCase());
}
