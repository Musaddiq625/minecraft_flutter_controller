import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static void launch(String link) async {
    final url = Uri.tryParse(link);
    if (url != null && !await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
