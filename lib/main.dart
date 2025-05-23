import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/firebase_options.dart';
import 'package:portfolio/home.dart';
import 'package:portfolio/providers/theme_provider.dart';
import 'package:web/web.dart' as web;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: 'env');
  web.document.title = dotenv.env['TITLE'] ?? 'Portfolio';
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: dotenv.env['TITLE'] ?? '',
      theme: ThemeData(
        fontFamily: 'Lora',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        inputDecorationTheme: _inputDecorationTheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Lora',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF014421),
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: _inputDecorationTheme,
        useMaterial3: true,
      ),
      themeMode: ref.watch(themeProvider), // Use system theme by default
      home: HomePage(),
    );
  }
}

InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  alignLabelWithHint: true,
);
