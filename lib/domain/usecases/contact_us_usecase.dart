import 'package:url_launcher/url_launcher.dart';

class ContactUsUseCase {
  final String _contactUsUrl;

  ContactUsUseCase(this._contactUsUrl);

  Future<void> execute() async {
    launchUrl(Uri.parse(_contactUsUrl));
  }
}
