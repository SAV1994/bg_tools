import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:go_router/go_router.dart';

class GamesCountingTemplateslistScreen<T> extends ConsumerStatefulWidget {
  final int gameId;

  const GamesCountingTemplateslistScreen({required this.gameId, super.key});

  @override
  ConsumerState<GamesCountingTemplateslistScreen> createState() =>
      _GamesCountingTemplateslistScreenState();
}

class _GamesCountingTemplateslistScreenState
    extends ConsumerState<GamesCountingTemplateslistScreen> {
  Future<void> _openAddForm() async {
    final result = await context.pushNamed(
      'counting-templates-add',
      pathParameters: {'gameId': widget.gameId.toString()},
    );

    if (result == true) {
      ref.invalidate(gamesCountingTemplatesDataProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Future<void> _openUpdateForm(int gamesCountingTemplatesId) async {
    final result = await context.pushNamed(
      'counting-templates-update',
      pathParameters: {
        'gameId': widget.gameId.toString(),
        'gamesCountingTemplatesId': gamesCountingTemplatesId.toString(),
      },
    );

    if (result == true) {
      ref.invalidate(gamesCountingTemplatesDataProvider); // Обновляем провайдер
    }
  }

  @override
  Widget build(BuildContext context) {
    final gamesCountingTemplatesAsync = ref.watch(
      gamesCountingTemplatesDataProvider(widget.gameId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Настройка шаблонов'),
        actions: [
          IconButton(
            onPressed: () => _openAddForm(),
            icon: Icon(Icons.add_box),
          ),
        ],
      ),
      body: gamesCountingTemplatesAsync.when(
        data: (gamesCountingTemplates) {
          // Если данных нет
          if (gamesCountingTemplates.isEmpty) {
            return buildEmptyListScreen();
          }
          return ListView.builder(
            itemCount: gamesCountingTemplates.length,
            itemBuilder: (context, index) {
              final gamesCountingTemplatesData = gamesCountingTemplates[index];
              final gamesCountingTemplate =
                  gamesCountingTemplatesData.gamesCountingTemplate;
              String subtitle = gamesCountingTemplatesData.expansions
                  .map((expansion) => expansion.name)
                  .toList()
                  .join(', ');

              return Card(
                child: ListTile(
                  leading: Icon(Icons.build),
                  title: Text(gamesCountingTemplate.name),
                  subtitle: Text(subtitle),
                  trailing: Icon(Icons.edit),
                  onTap: () {
                    _openUpdateForm(gamesCountingTemplate.id);
                  },
                ),
              );
            },
          );
        },
        loading: () => buildLoadingScreen(),
        error: (err, _) => Text('ОШИБКА: ${err.toString()}'),
      ),
    );
  }
}
