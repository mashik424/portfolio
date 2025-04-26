import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/providers/auth_provider/auth_provider.dart';
import 'package:portfolio/utils/utils.dart' as utils;

class ProjectItem extends ConsumerWidget {
  const ProjectItem({
    required this.project,
    this.onDeletePressed,
    this.onEditPressed,
    super.key,
  });

  final Project project;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authNotifierProvider);
    return Container(
      width: 300,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.grey.shade800 : Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
            child: Builder(
              builder: (context) {
                final placeHolder = Center(
                  child: Text(
                    project.name[0],
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                );
                return project.imageUrl == null
                    ? placeHolder
                    : CachedNetworkImage(
                      imageUrl: project.imageUrl ?? '',
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        );
                      },
                    );
              },
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                project.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
              if (authState.isLoggedin) ...[
                const Spacer(),
                IconButton(
                  onPressed: onEditPressed,
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: onDeletePressed,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: TextStyle(
              color: isDarkTheme ? Colors.grey.shade400 : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (project.githubUrl.isNotEmpty)
                IconButton(
                  onPressed: () => utils.launch(project.githubUrl),
                  icon: const FaIcon(FontAwesomeIcons.github, size: 16),
                ),
              if (project.appstoreUrl.isNotEmpty)
                IconButton(
                  onPressed: () => utils.launch(project.appstoreUrl),
                  icon: const FaIcon(FontAwesomeIcons.apple, size: 16),
                ),
              if (project.playstoreUrl.isNotEmpty)
                IconButton(
                  onPressed: () => utils.launch(project.playstoreUrl),
                  icon: const FaIcon(FontAwesomeIcons.android, size: 16),
                ),
              if (project.url.isNotEmpty)
                IconButton(
                  onPressed: () => utils.launch(project.url),
                  icon: const FaIcon(FontAwesomeIcons.globe, size: 16),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
