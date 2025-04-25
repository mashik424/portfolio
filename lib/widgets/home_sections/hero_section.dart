import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/providers/auth_provider/auth_provider.dart';
import 'package:portfolio/providers/file_upload_provider/file_upload_provider.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({super.key, this.onViewWork, this.onContactMe});

  final VoidCallback? onViewWork;
  final VoidCallback? onContactMe;

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection> {
  int _tapCount = 0;
  DateTime? _lastTapTime;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop();
    ref.read(authNotifierProvider.notifier).signIn(_passwordController.text);
  }

  void _greetTapped() {
    _tapCount++;
    final currentTime = DateTime.now();
    if (_lastTapTime == null ||
        currentTime.difference(_lastTapTime!) >
            const Duration(milliseconds: 800)) {
      _tapCount = 0; // Reset the counter if delay is more than 800ms
    }

    _lastTapTime = currentTime;

    if (_tapCount == 8) {
      _tapCount = 0; // Reset the counter
      // Perform the desired action here
      showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Admin Login'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                autofocus: true,
                obscureText: true,
                controller: _passwordController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Cancel'),
              ),
              TextButton(onPressed: _login, child: const Text('Submit')),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (_, state) {
      if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } else if (state is SignedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${state.user?.email}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 800
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _greetTapped,
                          child: const Text(
                            "Hey, I'm Ashique 👋",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'A Flutter Developer crafting apps for Android, iOS '
                          '& Web.',
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        _buttonsWrap(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  _profilePicture(),
                ],
              )
              : Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _greetTapped,
                    child: const Text(
                      "Hey, I'm Ashique 👋",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'A Flutter Developer crafting apps for Android, iOS & Web.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  _buttonsWrap(alignment: WrapAlignment.center),
                  const SizedBox(height: 40),
                  _profilePicture(),
                ],
              );
        },
      ),
    );
  }

  Widget _profilePicture() {
    return FutureBuilder(
      future: ref.read(getFileUrlProvider(path: 'profile.png').future),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CircleAvatar(
            radius: 120,
            backgroundImage: CachedNetworkImageProvider(snapshot.data!),
          );
        } else {
          return const CircleAvatar(radius: 120);
        }
      },
    );
  }

  Widget _buttonsWrap({WrapAlignment alignment = WrapAlignment.start}) {
    return Wrap(
      spacing: 15,
      alignment: alignment,
      children: [
        ElevatedButton(
          onPressed: widget.onViewWork,
          child: const Text('View My Work'),
        ),
        OutlinedButton(
          onPressed: widget.onContactMe,
          child: const Text('Contact Me'),
        ),
      ],
    );
  }
}
