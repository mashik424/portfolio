import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'About Me',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Mobile App Developer with nearly 5 years of experience '
            'specializing in cross-platform solutions using Flutter, Android '
            '(Kotlin, Jetpack Compose), and iOS (Swift, SwiftUI). Skilled in '
            'REST APIs, GraphQL, real-time features (Firebase, Agora), and '
            'payment integration (Razorpay, in-app purchases). Passionate about'
            ' delivering high-performance, user-centric applications and '
            'collaborating on innovative projects.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
