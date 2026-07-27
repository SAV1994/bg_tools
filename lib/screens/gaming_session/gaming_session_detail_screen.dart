import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class GamingSessionDetailScreen extends ConsumerStatefulWidget {
  final int gamingSessionId;

  const GamingSessionDetailScreen({super.key, required this.gamingSessionId});

  @override
  ConsumerState<GamingSessionDetailScreen> createState() =>
      _GamingSessionDetailScreenState();
}

class _GamingSessionDetailScreenState
    extends ConsumerState<GamingSessionDetailScreen> {
  Future<void> _openUpdateForm() async {
    final result = await context.pushNamed(
      'gaming-sessions-update',
      pathParameters: {'gamingSessionId': widget.gamingSessionId.toString()},
    );

    if (result == true) {
      ref.invalidate(gamingSessionFullDataProvider); // Обновляем провайдер
      setState(() {});
    }
  }

  Widget _buildError(BuildContext context, Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Ошибка загрузки',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(
                gamingSessionFullDataProvider(widget.gamingSessionId),
              );
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, GamingSessionFullData data) {
    final GamingSession gamingSession = data.gamingSession;
    final Game game = data.game;
    final List<GamingSessionGamerData?> gamers = data.gamers;
    final List<Game> expansions = data.expansions;

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            // Заголовок с именем
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    ClipRRect(
                      child: game.imagePath != null
                          ? Image.file(
                              File(game.imagePath!),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Основная информация
            const Text(
              'Основная информация',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    InfoRow(
                      label: 'Начало партии',
                      value: DateFormats.formatDateTime(
                        gamingSession.startedAt,
                      ),
                      isFirst: true,
                    ),

                    if (gamingSession.finishedAt != null)
                      InfoRow(
                        label: 'Конец партии',
                        value: DateFormats.formatDateTime(
                          gamingSession.finishedAt!,
                        ),
                      ),

                    InfoRow(
                      label: 'Партия закончена?',
                      value: convertBoolToStr(gamingSession.isFinished),
                    ),

                    if (gamingSession.comment != null &&
                        gamingSession.comment!.isNotEmpty)
                      InfoRow(
                        label: 'Комментарий',
                        value: gamingSession.comment,
                      ),
                  ],
                ),
              ),
            ),
            if (expansions.isNotEmpty) _buildExpansionsCard(expansions),
            if (gamers.isNotEmpty) _buildGamersCard(gamers),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionsCard(List<Game> expansions) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Дополнения',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: expansions.map((item) {
            return Chip(
              label: Text(item.name, style: TextStyle(color: goldColor)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGamersCard(List<GamingSessionGamerData?> gamersData) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Игроки',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gamersData.length,
          itemBuilder: (context, index) {
            final GamingSessionGamerData? gamerData = gamersData[index];
            final Gamer gamer = gamerData!.gamer;

            String gamerName = '(${gamer.username})';
            if (gamer.lastName != null) {
              gamerName += ' ${gamer.lastName}';
            }
            gamerName += ' ${gamer.firstName}';
            if (gamer.middleName != null) {
              gamerName += ' ${gamer.middleName}';
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    InfoRow(label: 'Игрок', value: gamerName, isFirst: true),

                    if (gamerData.team != null)
                      InfoRow(
                        label: 'Команда',
                        value: TeamsEnum.fromId(gamerData.team!).label,
                        valueColor: (gamerData.team != null)
                            ? TeamsEnum.fromId(gamerData.team!).color
                            : null,
                      ),

                    if (gamerData.score != null)
                      InfoRow(
                        label: 'Количество набранных очков',
                        value: gamerData.score.toString(),
                      ),

                    if (gamerData.place != null)
                      InfoRow(
                        label: 'Занятое место',
                        value: gamerData.place.toString(),
                      ),

                    if (gamerData.turnOrder != null)
                      InfoRow(
                        label: 'Порядок хода',
                        value: gamerData.turnOrder.toString(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gamingSessionAsync = ref.watch(
      gamingSessionFullDataProvider(widget.gamingSessionId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Информация об игровой сессии'),
        actions: [
          // Кнопка редактирования
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              _openUpdateForm();
            },
          ),
          // Кнопка удаления
          IconButton(
            icon: const Icon(Icons.delete_outlined, color: redColor),
            onPressed: () {
              final gamingSession = gamingSessionAsync.value?.gamingSession;
              if (gamingSession != null) {
                buildDelModal(
                  context,
                  ref,
                  gamingSessionDaoProvider,
                  mounted,
                  gamingSession,
                );
              }
            },
          ),
        ],
      ),
      body: gamingSessionAsync.when(
        data: (data) {
          return _buildContent(context, data!);
        },
        loading: () => LoadingScreen(),
        error: (error, _) => _buildError(context, error, ref),
      ),
    );
  }
}
