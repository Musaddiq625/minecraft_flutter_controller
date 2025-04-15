import 'package:minecraft_controller/src/constants/string_constants.dart';

class ValidatorUtils {
  static final _ipRegex = RegExp(r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'
      r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'
      r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'
      r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');

  static String? validIP(String? val) {
    if ((val ?? '').isEmpty) {
      return StringConstants.pleaseEnterIp;
    }

    if (!_ipRegex.hasMatch(val!)) {
      return StringConstants.pleaseEnterValidIp;
    }
    return null;
  }
}
