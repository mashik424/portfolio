import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/providers/theme_provider.dart';
import 'package:portfolio/widgets/home_sections/about_section.dart';
import 'package:portfolio/widgets/home_sections/companies_section.dart';
import 'package:portfolio/widgets/home_sections/contact_section.dart';
import 'package:portfolio/widgets/home_sections/hero_section.dart';
import 'package:portfolio/widgets/home_sections/projects_section.dart';
import 'package:portfolio/widgets/home_sections/skills_section.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final heroKey = GlobalKey();
  final projectsKey = GlobalKey();
  final aboutKey = GlobalKey();
  final contactKey = GlobalKey();

  void scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(dotenv.env['TITLE'] ?? ''),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          TextButton(
            onPressed: () => scrollTo(heroKey),
            child: const Text('Home'),
          ),
          TextButton(
            onPressed: () => scrollTo(projectsKey),
            child: const Text('Projects'),
          ),
          TextButton(
            onPressed: () => scrollTo(aboutKey),
            child: const Text('About'),
          ),
          TextButton(
            onPressed: () => scrollTo(contactKey),
            child: const Text('Contact'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                Text(dotenv.env.toString()),
                HeroSection(
                  key: heroKey,
                  onContactMe: () => scrollTo(contactKey),
                  onViewWork: () => scrollTo(projectsKey),
                ),
                const SizedBox(height: 50),
                const SkillsSection(),
                const SizedBox(height: 50),
                ProjectsSection(key: projectsKey),
                const SizedBox(height: 50),
                const CompaniesSection(),
                const SizedBox(height: 50),
                AboutSection(key: aboutKey),
                const SizedBox(height: 50),
                ContactSection(key: contactKey),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
