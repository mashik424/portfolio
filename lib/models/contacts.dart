class Contacts {
  Contacts({
    required this.email,
    required this.mobile,
    required this.github,
    required this.linkedin,
  });

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      github: json['github'] as String,
      linkedin: json['linkedin'] as String,
    );
  }

  final String email;
  final String mobile;
  final String github;
  final String linkedin;
}
