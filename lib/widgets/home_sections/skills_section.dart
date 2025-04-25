import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/providers/auth_provider/auth_provider.dart';
import 'package:portfolio/providers/skills_provider/skills_provider.dart';
import 'package:portfolio/widgets/dialogs/add_skill_dialog.dart';
import 'package:reorderables/reorderables.dart';

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
            final children = [
              ...skills.map(
                (skill) => GestureDetector(
                  onTap: () {
                    if (authState.isLoggedin && skill.id != null) {
                      _addSkill(skill: skill);
                    }
                  },
                  child: Chip(
                    deleteIcon: const Icon(Icons.close),
                    labelPadding: EdgeInsets.zero,
                    onDeleted:
                        authState.isLoggedin
                            ? () {
                              if (authState.isLoggedin && skill.id != null) {
                                ref
                                    .read(skillListProvider.notifier)
                                    .deleteSkill(skill);
                              }
                            }
                            : null,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (skill.avatar != null) ...[
                          CachedNetworkImage(
                            imageUrl: skill.avatar!,
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(skill.name),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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
            ];
            if (authState.isLoggedin) {
              return ReorderableWrap(
                onReorder:
                    (oldIndex, newIndex) => ref
                        .read(skillListProvider.notifier)
                        .reorder(oldIndex: oldIndex, newIndex: newIndex),
                alignment: WrapAlignment.center,
                spacing: 15,
                runSpacing: 15,
                children: children,
              );
            }

            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              runSpacing: 15,
              children: children,
            );
          },
        ),
      ],
    );
  }

  void _addSkill({Skill? skill}) {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Skill'),
          content: AddSkillDialog(contoller: _contoller, skill: skill),
          actions: [
            TextButton(
              onPressed: () {
                final both = _contoller.onSubmit?.call();
                if (both?.first != null) {
                  if (skill == null) {
                    ref
                        .read(skillListProvider.notifier)
                        .addSkill(skill: both!.first, imageBytes: both.second);
                  } else if (skill.id != null) {
                    ref
                        .read(skillListProvider.notifier)
                        .updateSkill(
                          id: skill.id!,
                          skill: both!.first,
                          imageBytes: both.second,
                        );
                  }
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
