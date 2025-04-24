import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/providers/auth_provider/auth_provider.dart';
import 'package:portfolio/providers/skills_provider/skills_provider.dart';
import 'package:portfolio/widgets/dialogs/add_skill_dialog.dart';

class SkillsSection extends ConsumerStatefulWidget {
  const SkillsSection({super.key});

  @override
  ConsumerState<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends ConsumerState<SkillsSection> {
  final _contoller = AddSkillDialogContoller();

  @override
  void dispose() {
    _contoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    return Column(
      children: [
        const Text(
          'Skills',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        FutureBuilder(
          future: ref.watch(skillListProvider.future),
          builder: (context, snapshot) {
            final skills = <Skill>[];
            if (snapshot.hasData) {
              skills.addAll(snapshot.data!);
            }
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              runSpacing: 15,
              children: [
                ...skills.map(
                  (skill) => Chip(
                    deleteIcon: const Icon(Icons.close),
                    onDeleted:
                        authState.isLoggedin
                            ? () {
                              if (authState.isLoggedin && skill.id != null) {
                                ref
                                    .read(skillListProvider.notifier)
                                    .deleteSkill(skill.id!);
                              }
                            }
                            : null,
                    label: Text(skill.name),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
                if (authState.isLoggedin)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _addSkill,
                    child: const Chip(
                      label: Text('Add new skill'),
                      avatar: Icon(Icons.add),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _addSkill() {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Skill'),
          content: AddSkillDialog(contoller: _contoller),
          actions: [
            TextButton(
              onPressed: () {
                final skill = _contoller.onSubmit?.call();
                if (skill != null) {
                  ref.read(skillListProvider.notifier).addSkill(skill);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
