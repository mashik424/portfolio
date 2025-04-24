import 'package:flutter/material.dart';
import 'package:portfolio/models/skill.dart';

class AddSkillDialogContoller {
  Skill? Function()? onSubmit;

  void dispose() {
    onSubmit = null;
  }
}

class AddSkillDialog extends StatefulWidget {
  const AddSkillDialog({required this.contoller, super.key});

  final AddSkillDialogContoller contoller;

  @override
  State<AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends State<AddSkillDialog> {
  final _editingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.contoller.onSubmit = _onSubmit;
    super.initState();
  }

  Skill? _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return null;
    }
    final skill = Skill(name: _editingController.text);
    _editingController.clear();
    Navigator.of(context).pop();
    return skill;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}