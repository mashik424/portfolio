import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/both.dart';
import 'package:portfolio/models/company.dart';
import 'package:portfolio/providers/file_upload_provider/file_upload_provider.dart';
import 'package:portfolio/providers/pick_image_provider/pick_image_provider.dart';

class AddCompanyDialogContoller {
  Both<Company?, Uint8List?> Function()? onSubmit;

  void dispose() {
    onSubmit = null;
  }
}

class AddCompanyDialog extends ConsumerStatefulWidget {
  const AddCompanyDialog({required this.contoller, super.key, this.company});

  final AddCompanyDialogContoller contoller;
  final Company? company;

  @override
  ConsumerState<AddCompanyDialog> createState() => _AddCompanyDialogState();
}

class _AddCompanyDialogState extends ConsumerState<AddCompanyDialog> {
  final _formKey = GlobalKey<FormState>();

  late List<TextEditingController> _editingControllers;
  Uint8List? _imageBytes;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentCompany = false;

  @override
  void initState() {
    widget.contoller.onSubmit = _onSubmit;
    if (widget.company != null) {
      _isCurrentCompany = widget.company!.endDate == null;
      _startDate = widget.company!.startDate;
      _endDate = widget.company!.endDate;
      _editingControllers = List.generate(
        4,
        (index) => TextEditingController(
          text:
              [
                widget.company!.name,
                widget.company!.description,
                widget.company!.startDate.toLocal().toString().split(' ')[0],
                widget.company!.endDate?.toLocal().toString().split(' ')[0] ??
                    '',
              ][index],
        ),
      );
    } else {
      _editingControllers = List.generate(4, (_) => TextEditingController());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.company?.logoUrl != null) {
        ref
            .read(getFileFromUrlProvider(url: widget.company!.logoUrl!).future)
            .then((value) {
              _imageBytes = value;
              setState(() {});
            });
      }
    });
    super.initState();
  }

  Both<Company?, Uint8List?> _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return Both(null, null);
    }

    final company = Company(
      name: _editingControllers[0].text,
      description: _editingControllers[1].text,
      startDate: _startDate!,
      endDate: _isCurrentCompany ? null : _endDate,
    );

    for (final controller in _editingControllers) {
      controller.clear();
    }

    //
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    return Both(company, _imageBytes);
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
              readOnly: true,
              controller: _editingControllers[2],
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _startDate = date;
                    _editingControllers[2].text =
                        _startDate?.toLocal().toString().split(' ')[0] ?? '';
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Start Date',
                hintText: _startDate?.toLocal().toString().split(' ')[0] ?? '',
              ),
              validator: (value) {
                if (_startDate == null) {
                  return 'Please enter a start date';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _editingControllers[3],
              readOnly: true,
              enabled: !_isCurrentCompany,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate ?? DateTime.now(),
                  firstDate: _startDate ?? DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _endDate = date;
                    _editingControllers[3].text =
                        _endDate?.toLocal().toString().split(' ')[0] ?? '';
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'End Date',
                hintText: _endDate?.toLocal().toString().split(' ')[0] ?? '',
              ),
              validator: (value) {
                if (!_isCurrentCompany && _endDate == null) {
                  return 'Please enter an end date';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Is Current Company'),
              value: _isCurrentCompany,
              onChanged: (value) {
                setState(() {
                  if (value ?? false) {
                    _editingControllers[3].text = '';
                    _endDate = null;
                  }
                  _isCurrentCompany = value!;
                });
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
