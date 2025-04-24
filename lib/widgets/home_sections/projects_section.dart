import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/providers/auth_provider/auth_provider.dart';
import 'package:portfolio/providers/projects_provider/projects_provider.dart';
import 'package:portfolio/widgets/dialogs/add_project_dialog.dart';
import 'package:portfolio/widgets/list_items/project_item.dart';

class ProjectsSection extends ConsumerStatefulWidget {
  const ProjectsSection({super.key});

  @override
  ConsumerState<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends ConsumerState<ProjectsSection> {
  final _contoller = AddProjectDialogContoller();

  @override
  void dispose() {
    _contoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const Text(
          'Projects',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        FutureBuilder(
          future: ref.watch(projectsListProvider.future),
          builder: (context, snapshot) {
            final projects = <Project>[];
            if (snapshot.hasData) {
              projects.addAll(snapshot.data!);
            }
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: [
                ...projects.map(
                  (project) => ProjectItem(
                    project: project,
                    onDeletePressed: () {
                      if (project.id != null) {
                        ref
                            .read(projectsListProvider.notifier)
                            .deleteProject(project: project);
                      }
                    },
                    onEditPressed: () => _addProject(project: project),
                  ),
                ),
                if (authState.isLoggedin)
                  GestureDetector(
                    onTap: _addProject,
                    child: Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        color:
                            isDarkTheme
                                ? Colors.grey.shade800
                                : Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(child: Icon(Icons.add, size: 50)),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _addProject({Project? project}) {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Project'),
          content: AddProjectDialog(contoller: _contoller, project: project),
          actions: [
            TextButton(
              onPressed: () {
                final both = _contoller.onSubmit?.call();
                if (both?.first != null) {
                  if (project == null) {
                    ref
                        .read(projectsListProvider.notifier)
                        .addProject(
                          project: both!.first!,
                          imageBytes: both.second,
                        );
                  } else if (project.id != null) {
                    ref
                        .read(projectsListProvider.notifier)
                        .updateProject(
                          id: project.id!,
                          project: both!.first!,
                          bytes: both.second,
                        );
                  }
                }
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
