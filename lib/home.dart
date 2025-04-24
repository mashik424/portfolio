//
// ignore_for_file: use_build_context_synchronously
import 'dart:js_interop';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/providers/auth_provider/auth_provider.dart';
import 'package:portfolio/providers/theme_provider.dart';
import 'package:portfolio/widgets/home_sections/about_section.dart';
import 'package:portfolio/widgets/home_sections/companies_section.dart';
import 'package:portfolio/widgets/home_sections/contact_section.dart';
import 'package:portfolio/widgets/home_sections/hero_section.dart';
import 'package:portfolio/widgets/home_sections/projects_section.dart';
import 'package:portfolio/widgets/home_sections/skills_section.dart';
import 'package:web/web.dart' as web;

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
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.env['TITLE'] ?? ''),
        actions: [
          if (authState.isLoggedin)
            ElevatedButton.icon(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out')),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red.withValues(alpha: 0.8),
                backgroundColor: Colors.red.withValues(alpha: 0.1),
              ),
              label: const Text('Sign Out'),
              icon: FaIcon(
                FontAwesomeIcons.rightFromBracket,
                color: Colors.red.withValues(alpha: 0.8),
              ),
            ),
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
          ElevatedButton.icon(
            onPressed: () => _downploadResume(context),
            label: const Text('Resume'),
            icon: const FaIcon(FontAwesomeIcons.download),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                HeroSection(
                  key: heroKey,
                  onContactMe: () => scrollTo(contactKey),
                  onViewWork: () => scrollTo(projectsKey),
                ),
                const SizedBox(height: 0),
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

  Future<void> _downploadResume(BuildContext context) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('resume.pdf');
      final bytes = await ref.getData();

      if (bytes == null) {
        throw Exception('Failed to download resume');
      }

      // Convert to JS BlobPart array
      final blobParts = <web.BlobPart>[bytes.toJS].toJS;
      // Create Blob and Object URL
      final blob = web.Blob(blobParts);
      final objectUrl = web.URL.createObjectURL(blob);

      final anchor =
          web.HTMLAnchorElement()
            ..href = objectUrl
            ..download = '${dotenv.env['NAME'] ?? 'resume'}.pdf'
            ..style.display = 'none';

      web.document.body!.append(anchor);
      anchor
        ..click()
        ..remove();
      web.URL.revokeObjectURL(objectUrl);
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
