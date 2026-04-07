import 'package:bg_tools/core/utils/dateformats.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/database_providers.dart';

class GamingSessionListScreen extends ConsumerStatefulWidget {
  const GamingSessionListScreen({super.key});

  @override
  ConsumerState<GamingSessionListScreen> createState() => _GamingSessionListScreenState();
}

class _GamingSessionListScreenState extends ConsumerState<GamingSessionListScreen> {
  Future<void> _openAddForm() async {
    final result = await context.pushNamed('gaming-session-add');
    
    if (result == true) {
      ref.invalidate(gamingSessionDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Future<void> _openDetailPage(int gamingSessionId) async {
    final result = await context.pushNamed('gaming-session-detail', pathParameters: {'gamingSessionId': gamingSessionId.toString()});
    
    if (result == true) {
      ref.invalidate(gamingSessionDaoProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final gamingSessionDao = ref.watch(gamingSessionDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Партии'),
        actions: [
          IconButton(
            onPressed: () => {_openAddForm()},
            icon: Icon(Icons.add_box),
          )
        ],
      ),
      body: FutureBuilder<List<GamingSessionData>> (
        future: gamingSessionDao.getAll(),
        builder: (context, snapshot) {
          // Показываем индикатор загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          // Обрабатываем ошибки
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          
          // Если данных нет
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(emptyListMsg));
          }
          
          // Получаем данные
          final gamingSessions = snapshot.data!;

          return ListView.builder(
            itemCount: gamingSessions.length,
            itemBuilder: (context, index) {
              final GamingSessionData gamingSessionData = gamingSessions[index];
              final GamingSession gamingSession  = gamingSessionData.gamingSession;
              final Game game  = gamingSessionData.game;
              
              String gamingSessionInfo = gamingSession.finishedAt == null ? '🟡' : '🟢';

              gamingSessionInfo += DateFormats.formatDateTime(gamingSession.startedAt);
              if (gamingSession.finishedAt != null) {
                gamingSessionInfo += ' - ${DateFormats.formatDateTime(gamingSession.finishedAt!)}';
              }

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text(game.name),
                  subtitle: Text(gamingSessionInfo),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {_openDetailPage(gamingSession.id);},
                )
              );
            }
          );
        },
      )
    );
  }
}
