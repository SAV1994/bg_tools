import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class CountingTemplateListScreen extends ConsumerStatefulWidget {
  const CountingTemplateListScreen({super.key});

  @override
  ConsumerState<CountingTemplateListScreen> createState() =>
      _CountingTemplateListScreenListScreenState();
}

class _CountingTemplateListScreenListScreenState
    extends ConsumerState<CountingTemplateListScreen> {
  Future<void> _openAddForm() async {
    final result = await context.pushNamed('templates-add');

    if (result == true) {
      ref.invalidate(countingTemplatesDataProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Future<void> _openDetailPage(int templateId) async {
    final result = await context.pushNamed(
      'templates-detail',
      pathParameters: {'templateId': templateId.toString()},
    );

    if (result == true) {
      ref.invalidate(countingTemplatesDataProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(countingTemplatesDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Шаблоны партий'),
        actions: [
          IconButton(
            onPressed: () => {_openAddForm()},
            icon: Icon(Icons.add_box),
          ),
        ],
      ),
      body: templatesAsync.when(
        data: (templates) {
          if (templates.isEmpty) {
            return buildEmptyListScreen();
          }

          return ListView.builder(
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final CountingTemplate template = templates[index];

              return Card(
                child: ListTile(
                  leading: Icon(Icons.build),
                  title: Text(template.name),
                  subtitle: Text(template.description ?? emptyVal),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _openDetailPage(template.id);
                  },
                ),
              );
            },
          );
        },
        loading: () => buildLoadingScreen(),
        error: (err, _) => Text('ОШИБКА'),
      ),
    );
  }
}
