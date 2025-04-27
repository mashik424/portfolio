import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/company.dart';
import 'package:portfolio/providers/auth_provider/auth_provider.dart';
import 'package:portfolio/utils/utils.dart';

class CompanyItem extends ConsumerWidget {
  const CompanyItem({
    required this.company,
    this.onDeletePressed,
    this.onEditPressed,
    super.key,
  });

  final Company company;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authNotifierProvider);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 150,
        maxWidth: 300,
        minWidth: 300,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
             color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: company.logoUrl ?? '',
                            color:
                                isDarkTheme
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            errorWidget:
                                (context, url, error) => Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color:
                                        isDarkTheme
                                            ? Colors.grey.shade700
                                            : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      company.name[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              company.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (authState.isLoggedin)
                      Row(
                        children: [
                          IconButton(
                            onPressed: onEditPressed,
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: onDeletePressed,
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${company.startDate.format()} - '
                  '${company.endDate?.format() ?? 'Present'}',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isDarkTheme
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),

            Text(
              company.description,
              style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? Colors.grey.shade300 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
