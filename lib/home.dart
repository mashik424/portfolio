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
      Scaffold.of(context).closeEndDrawer();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(dotenv.env['TITLE'] ?? ''),
            centerTitle: false,
            actions:
                constraints.maxWidth > 670
                    ? _actions(context, ref)
                    : [
                      IconButton(
                        onPressed: () {
                          final context = contactKey.currentContext;
                          if (context == null) return;
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const FaIcon(FontAwesomeIcons.bars),
                      ),
                    ],
          ),

          endDrawer: Drawer(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _drawerButtons(context, ref),
              ),
            ),
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
                    const SizedBox(height: 25),
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
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _actions(BuildContext context, WidgetRef ref) => [
    TextButton(onPressed: () => scrollTo(heroKey), child: const Text('Home')),
    TextButton(
      onPressed: () => scrollTo(projectsKey),
      child: const Text('Projects'),
    ),
    TextButton(onPressed: () => scrollTo(aboutKey), child: const Text('About')),
    TextButton(
      onPressed: () => scrollTo(contactKey),
      child: const Text('Contact'),
    ),
    ElevatedButton.icon(
      onPressed: () => _downloadResume(context),
      label: const Text('Resume'),
      icon: const FaIcon(FontAwesomeIcons.download),
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
  ];

  List<Widget> _drawerButtons(BuildContext context, WidgetRef ref) {
    final style = TextButton.styleFrom(
      alignment: Alignment.centerLeft,
      shape: const RoundedRectangleBorder(),
    );

    return [
      Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          onPressed: () {
            final context = contactKey.currentContext;
            if (context != null) {
              Scaffold.of(context).closeEndDrawer();
            }
          },
          icon: const Icon(Icons.close),
        ),
      ),
      TextButton(
        onPressed: () => scrollTo(heroKey),
        style: style,
        child: const Text('Home'),
      ),
      TextButton(
        onPressed: () => scrollTo(projectsKey),
        style: style,
        child: const Text('Projects'),
      ),
      TextButton(
        onPressed: () => scrollTo(aboutKey),
        style: style,
        child: const Text('About'),
      ),
      TextButton(
        onPressed: () => scrollTo(contactKey),
        style: style,
        child: const Text('Contact'),
      ),
      TextButton.icon(
        onPressed: () {
          final context = contactKey.currentContext;
          if (context != null) {
            _downloadResume(context);
            Scaffold.of(context).closeEndDrawer();
          }
        },
        style: style,
        label: const Text('Download Resume'),
        icon: const FaIcon(FontAwesomeIcons.download),
        iconAlignment: IconAlignment.end,
      ),
      TextButton.icon(
        onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
        style: style,
        label: const Text('Switch Theme'),
        icon: Icon(
          Theme.of(context).brightness == Brightness.dark
              ? Icons.light_mode
              : Icons.dark_mode,
        ),
        iconAlignment: IconAlignment.end,
      ),
    ];
  }

  Future<void> _downloadResume(BuildContext context) async {
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
