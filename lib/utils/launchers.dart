part of 'utils.dart';

Future<void> launchEmail(String email) async {
  final emailUri = Uri(scheme: 'mailto', path: email);
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  }
}

Future<void> launchPhone(String phone) async {
  final phoneUri = Uri(scheme: 'tel', path: phone);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  }
}

Future<void> launchWhatsApp(String phone) async {
  final whatsappUrl = Uri.parse('https://wa.me/$phone');

  if (await canLaunchUrl(whatsappUrl)) {
    await launchUrl(whatsappUrl);
  }
}

Future<void> launch(String url) async {
  final linkedInUrl = Uri.parse(url);

  if (await canLaunchUrl(linkedInUrl)) {
    await launchUrl(linkedInUrl);
  } else {
    throw Exception('Could not launch $url');
  }
}
