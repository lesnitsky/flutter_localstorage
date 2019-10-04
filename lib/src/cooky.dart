import 'dart:html';

import 'package:intl/intl.dart';

/// From [https://gitlab.com/exitlive/cooky] for now

/// `$` and `%` are placeholders that will be replaced by the name of the
/// weekday and the month respectively.
/// The reason we didn't use the `DateFormat` features to add these names, is
/// because we can't assume that the `en_US` locale is loaded, and want to avoid
/// loading it for this simple use case.
final _dateTimeFormatter = new DateFormat(r'$, d % yyyy HH:mm:ss UTC');

/// Manually sets the weekday and month because the 'en_US' locale might not be
/// initialized.
_formatDate(DateTime date) => _dateTimeFormatter
    .format(date)
    .replaceFirst(r'$',
        ['Mon', 'Tue', 'Wed', 'Thi', 'Fri', 'Sat', 'Sun'][date.weekday - 1])
    .replaceFirst(
        r'%',
        [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ][date.month - 1]);

/// Get the value of the cookie with name [key].
String get(String key) {
  final cookies = document.cookie != null ? document.cookie.split('; ') : [];
  for (var cookie in cookies) {
    var parts = cookie.split('=');
    var name = Uri.decodeComponent(parts[0]);
    if (key == name) {
      return parts[1] != null ? Uri.decodeComponent(parts[1]) : null;
    }
  }
  return null;
}

/// Set a cookie with name [key] and [value].
///
/// If the cookie already exists, it gets overwritten.
///
/// [maxAge] is added as a convenience, but always converted to [expires].
/// If both [maxAge] and [expires] are provided, then [maxAge] will overwrite
/// [expires] (this follows the cookie spec).
void set(String key, String value,
    {DateTime expires,
    Duration maxAge,
    String path,
    String domain,
    bool secure}) {
  if (maxAge != null) expires = new DateTime.now().add(maxAge);

  var cookie = ([
    Uri.encodeComponent(key),
    '=',
    Uri.encodeComponent(value),
    expires != null
        ? '; expires=' + _formatDate(expires.toUtc())
        : '', // use expires attribute, max-age is not supported by IE
    path != null ? '; path=' + path : '',
    domain != null ? '; domain=' + domain : '',
    secure != null && secure == true ? '; secure' : ''
  ].join(''));
  document.cookie = cookie;
}

/// Returns `true` if the key was found and the value removed.
/// Returns `false` if the key was not found.
bool remove(String key, {String path, String domain, bool secure}) {
  if (get(key) != null) {
    set(key, '',
        expires: new DateTime(0), path: path, domain: domain, secure: secure);
    return true;
  }
  return false;
}
