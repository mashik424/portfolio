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
            'I’m a mobile developer with 4+ years of experience building '
            'scalable apps using Flutter for startups and businesses. I focus '
            'on clean code, maintainable architecture, and creating a smooth '
            'user experience.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
