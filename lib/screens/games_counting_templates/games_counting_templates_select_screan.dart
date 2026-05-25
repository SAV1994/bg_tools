import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/dataclasses/games_counting_templates_dataclasses.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/features/session_runner/services/session_data_initializer.dart';

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
    final gamesCountingTemplatesDao = ref.read(
      gamesCountingTemplatesDaoProvider,
    );
    GamesCountingTemplatesData? templateData = await gamesCountingTemplatesDao
        .getSingle(gamesCountingTemplatesId);
    await initSessionData(templateData!);

    if (mounted) {
      await context.pushNamed('session-runner');
      ref.invalidate(gameFullDataProvider); // Обновляем провайдер
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
