import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:go_router/go_router.dart';

class GamesCountingTemplatesSelectScreen<T> extends ConsumerStatefulWidget {
  final int gameId;

  const GamesCountingTemplatesSelectScreen({required this.gameId, super.key});

  @override
  ConsumerState<GamesCountingTemplatesSelectScreen> createState() =>
      _GamesCountingTemplatesSelectScreenState();
}

class _GamesCountingTemplatesSelectScreenState
    extends ConsumerState<GamesCountingTemplatesSelectScreen> {
  Future<void> _runSession(int gamesCountingTemplatesId) async {
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
      appBar: AppBar(title: Text('Выбор шаблона')),
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
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.build),
                  title: Text(gamesCountingTemplate.name),
                  subtitle: Text(subtitle),
                  trailing: Icon(Icons.play_arrow),
                  onTap: () {
                    _runSession(gamesCountingTemplate.id);
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
