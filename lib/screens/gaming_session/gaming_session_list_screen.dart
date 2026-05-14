import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/dateformats.dart';
import 'package:bg_tools/core/utils/empty_list_screen_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class GamingSessionListScreen extends ConsumerStatefulWidget {
  const GamingSessionListScreen({super.key});

  @override
  ConsumerState<GamingSessionListScreen> createState() =>
      _GamingSessionListScreenState();
}

class _GamingSessionListScreenState
    extends ConsumerState<GamingSessionListScreen> {
  Future<void> _openAddForm() async {
    final result = await context.pushNamed('gaming-sessions-add');

    if (result == true) {
      ref.invalidate(gamingSessionDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Future<void> _openDetailPage(int gamingSessionId) async {
    final result = await context.pushNamed(
      'gaming-sessions-detail',
      pathParameters: {'gamingSessionId': gamingSessionId.toString()},
    );

    if (result == true) {
      ref.invalidate(gamingSessionDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final gamingSessionsAsync = ref.watch(gamingSessionDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Партии'),
        actions: [
          IconButton(
            onPressed: () => {_openAddForm()},
            icon: Icon(Icons.add_box),
          ),
        ],
      ),
      body: gamingSessionsAsync.when(
        data: (gamingSessions) {
          if (gamingSessions.isEmpty) {
            return buildEmptyListScreen();
          }

          return ListView.builder(
            itemCount: gamingSessions.length,
            itemBuilder: (context, index) {
              final GamingSessionData gamingSessionData = gamingSessions[index];
              final GamingSession gamingSession =
                  gamingSessionData.gamingSession;
              final Game game = gamingSessionData.game;

              String gamingSessionInfo = gamingSession.finishedAt == null
                  ? '🟡'
                  : '🟢';

              gamingSessionInfo += DateFormats.formatDateTime(
                gamingSession.startedAt,
              );

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text(game.name),
                  subtitle: Text(gamingSessionInfo),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _openDetailPage(gamingSession.id);
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
