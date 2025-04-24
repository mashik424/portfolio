import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/providers/contacts_provider/contacts_provider.dart';
import 'package:portfolio/utils/utils.dart' as utils;

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
    'sendMessage',
  );
  final List<TextEditingController> _editingControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        children: [
          const Text(
            'Let’s Work Together',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Feel free to reach out to me for collaborations, freelance '
            'projects, or just to say hi!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 30),
          Consumer(
            builder:
                (_, ref, __) => FutureBuilder(
                  future: ref.watch(fetchContactsProvider.future),
                  builder: (context, snapshot) {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            if (snapshot.hasData) {
                              final contacts = snapshot.data!;
                              utils.launchEmail(contacts.email);
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
                          label: const Text('Email Me'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (snapshot.hasData) {
                              final contacts = snapshot.data!;
                              utils.launchPhone(contacts.mobile);
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.phone),
                          label: const Text('Call Me'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (snapshot.hasData) {
                              final contacts = snapshot.data!;
                              utils.launch(contacts.linkedin);
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.linkedin),
                          label: const Text('LinkedIn'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (snapshot.hasData) {
                              final contacts = snapshot.data!;
                              utils.launch(contacts.github);
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.github),
                          label: const Text('GitHub'),
                        ),
                      ],
                    );
                  },
                ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Or drop me a message directly:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _editingControllers[0],
                    decoration: InputDecoration(
                      labelText: 'Your Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _editingControllers[1],
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Your Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your message';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      try {
                        await callable.call<dynamic>(<String, dynamic>{
                          'email': _editingControllers[0].text,
                          'message': _editingControllers[1].text,
                        });

                        //
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Message sent successfully!'),
                          ),
                        );
                        _editingControllers[0].clear();
                        _editingControllers[1].clear();
                      } on Exception {
                        //
                      }
                    },
                    child: const Text('Send Message'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
