import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/company.dart';
import 'package:portfolio/providers/auth_provider/auth_provider.dart';
import 'package:portfolio/providers/companies_provider/companies_provider.dart';
import 'package:portfolio/widgets/dialogs/add_company_dialog.dart';
import 'package:portfolio/widgets/list_items/company_item.dart';

class CompaniesSection extends ConsumerStatefulWidget {
  const CompaniesSection({super.key});

  @override
  ConsumerState<CompaniesSection> createState() => _CompaniesSectionState();
}

class _CompaniesSectionState extends ConsumerState<CompaniesSection> {
  final _controller = AddCompanyDialogContoller();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        const Text(
          "Companies I've Worked For",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        FutureBuilder(
          future: ref.watch(companiesListProvider.future),
          builder: (context, snapshot) {
            final companies = <Company>[];
            if (snapshot.hasData) {
              companies.addAll(snapshot.data!);
            }
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 30,
              runSpacing: 20,
              children: [
                ...companies.map(
                  (company) => CompanyItem(
                    company: company,
                    onDeletePressed: () {},
                    onEditPressed: () => _addCompany(company: company),
                  ),
                ),
                if (authState.isLoggedin)
                  GestureDetector(
                    onTap: _addCompany,
                    child: Container(
                      width: 300,
                      height: 150,
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

  void _addCompany({Company? company}) {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Company'),
          content: AddCompanyDialog(contoller: _controller, company: company),
          actions: [
            TextButton(
              onPressed: () {
                final both = _controller.onSubmit?.call();
                if (both?.first != null) {
                  if (company == null) {
                    ref
                        .read(companiesListProvider.notifier)
                        .addCompany(
                          company: both!.first!,
                          imageBytes: both.second,
                        );
                  } else if (company.id != null) {
                    ref
                        .read(companiesListProvider.notifier)
                        .updateCompany(
                          id: company.id!,
                          company: both!.first!,
                          imageBytes: both.second,
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
