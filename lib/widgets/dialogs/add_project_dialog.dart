import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/both.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/providers/file_upload_provider/file_upload_provider.dart';
import 'package:portfolio/providers/pick_image_provider/pick_image_provider.dart';

class AddProjectDialogContoller {
  Both<Project?, Uint8List?> Function()? onSubmit;

  void dispose() {
    onSubmit = null;
  }
}

class AddProjectDialog extends ConsumerStatefulWidget {
  const AddProjectDialog({required this.contoller, super.key, this.project});

  final AddProjectDialogContoller contoller;
  final Project? project;

  @override
  ConsumerState<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends ConsumerState<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();

  late List<TextEditingController> _editingControllers;
  Uint8List? _imageBytes;

  @override
  void initState() {
    widget.contoller.onSubmit = _onSubmit;
    if (widget.project != null) {
      _editingControllers = List.generate(
        6,
        (index) => TextEditingController(
          text:
              [
                widget.project!.name,
                widget.project!.description,
                widget.project!.githubUrl,
                widget.project!.playstoreUrl,
                widget.project!.appstoreUrl,
                widget.project!.url,
              ][index],
        ),
      );
    } else {
      _editingControllers = List.generate(6, (_) => TextEditingController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.project?.imageUrl != null) {
        ref
            .read(getFileFromUrlProvider(url: widget.project!.imageUrl!).future)
            .then((value) {
              _imageBytes = value;
              setState(() {});
            });
      }
    });
    super.initState();
  }

  Both<Project?, Uint8List?> _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return Both(null, null);
    }

    final project = Project(
      name: _editingControllers[0].text,
      description: _editingControllers[1].text,
      githubUrl: _editingControllers[2].text,
      playstoreUrl: _editingControllers[3].text,
      appstoreUrl: _editingControllers[4].text,
      url: _editingControllers[5].text,
    );
    for (final controller in _editingControllers) {
      controller.clear();
    }
    //
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    return Both(project, _imageBytes);
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
              controller: _editingControllers[0],

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _editingControllers[1],
              minLines: 4,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _editingControllers[2],
              decoration: const InputDecoration(labelText: 'GitHub URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                const urlPattern =
                    r'^(https?:\/\/)?(www\.)?github\.com\/[a-zA-Z0-9_.-]+\/[a-zA-Z0-9_.-]+$';
                final regex = RegExp(urlPattern);
                if (!regex.hasMatch(value)) {
                  return 'Please enter a valid GitHub URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _editingControllers[3],
              decoration: const InputDecoration(labelText: 'PlayStore URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                const urlPattern =
                    r'^(https?:\/\/)?(www\.)?play\.google\.com\/store\/apps\/details\?id=[a-zA-Z0-9_.-]+$';
                final regex = RegExp(urlPattern);
                if (!regex.hasMatch(value)) {
                  return 'Please enter a valid PlayStore URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _editingControllers[4],
              decoration: const InputDecoration(labelText: 'AppStore URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                const urlPattern =
                    r'^(https?:\/\/)?(www\.)?apps\.apple\.com\/[a-zA-Z]{2}\/app\/[a-zA-Z0-9_.-]+\/id[a-zA-Z0-9_.-]+$';
                final regex = RegExp(urlPattern);
                if (!regex.hasMatch(value)) {
                  return 'Please enter a valid AppStore URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _editingControllers[5],
              decoration: const InputDecoration(labelText: 'URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                const urlPattern =
                  r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:[0-9]{1,5})?(\/.*)?$';
                final regex = RegExp(urlPattern);
                if (!regex.hasMatch(value)) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
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
