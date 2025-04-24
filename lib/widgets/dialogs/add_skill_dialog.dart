import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/both.dart';
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/providers/file_upload_provider/file_upload_provider.dart';
import 'package:portfolio/providers/pick_image_provider/pick_image_provider.dart';

class AddSkillDialogContoller {
  Both<Skill, Uint8List?>? Function()? onSubmit;

  void dispose() {
    onSubmit = null;
  }
}

class AddSkillDialog extends ConsumerStatefulWidget {
  const AddSkillDialog({required this.contoller, this.skill, super.key});

  final AddSkillDialogContoller contoller;
  final Skill? skill;

  @override
  ConsumerState<AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends ConsumerState<AddSkillDialog> {
  late final TextEditingController _editingController;
  final _formKey = GlobalKey<FormState>();

  Uint8List? _imageBytes;

  @override
  void initState() {
    widget.contoller.onSubmit = _onSubmit;
    _editingController = TextEditingController(text: widget.skill?.name);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.skill?.avatar != null) {
        ref
            .read(getFileFromUrlProvider(url: widget.skill!.avatar!).future)
            .then((value) {
              _imageBytes = value;
              setState(() {});
            });
      }
    });
    super.initState();
  }

  Both<Skill, Uint8List?>? _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return null;
    }
    final skill = Skill(name: _editingController.text);
    _editingController.clear();
    Navigator.of(context).pop();
    return Both(skill, _imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              controller: _editingController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            if (_imageBytes != null)
              Image.memory(_imageBytes!, width: 100, height: 100),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    _imageBytes = await ref.read(pickImageProvider.future);
    setState(() {});
  }
}
