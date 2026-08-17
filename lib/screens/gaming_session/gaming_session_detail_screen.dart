import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/dataclasses/gaming_session_dataclasses.dart';
import 'package:bg_tools/core/providers/data_providers.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/providers/paginated_providers/export.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

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
      // Обновляем провайдер
      setState(() => ref.invalidate(gamingSessionFullDataProvider));
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
    final List<GamingSessionGamerData?> players = data.gamers;

    String? totalDuration;
    if (data.sessionParts.isNotEmpty) {
      List<Duration> durationList = data.sessionParts
          .map(
            (session) =>
                getDuration(
                      session!.startedAt,
                      session.finishedAt,
                      convertToStr: false,
                    )
                    as Duration,
          )
          .toList();
      durationList.add(
        getDuration(
              gamingSession.startedAt,
              gamingSession.finishedAt,
              convertToStr: false,
            )
            as Duration,
      );

      totalDuration = getTotaDuration(durationList) as String;
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
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
                      label: 'Тип игры',
                      value: GameTypeEnum.fromId(gamingSession.gameType!).label,
                      addDivider: false,
                    ),

                    InfoRow(
                      label: 'Начало партии',
                      value: DateFormats.formatDateTime(
                        gamingSession.startedAt,
                      ),
                    ),

                    InfoRow(
                      label: 'Конец партии',
                      value: DateFormats.formatDateTime(
                        gamingSession.finishedAt,
                      ),
                    ),

                    InfoRow(
                      label: 'Продолжительность партий',
                      value:
                          getDuration(
                                gamingSession.startedAt,
                                gamingSession.finishedAt,
                              )
                              as String,
                    ),

                    if (totalDuration != null)
                      InfoRow(
                        label: 'Общая продолжительность партии',
                        value: totalDuration,
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

            if (data.expansions.isNotEmpty)
              ListChips(
                title: 'Дополнения',
                items: data.expansions,
                getItemTitle: (expansion) => expansion.name,
              ),

            if (data.rootSession != null)
              ListChips(
                title: 'Корневая сессия',
                items: [data.rootSession],
                getItemTitle: (gamingSession) {
                  final String duration =
                      getDuration(
                            gamingSession.startedAt,
                            gamingSession.finishedAt,
                          )
                          as String;
                  return '${DateFormats.formatDateTime(gamingSession.startedAt)} ($duration)';
                },
                onTap: (gamingSessionId) => context.pushNamed(
                  'gaming-sessions-detail',
                  pathParameters: {
                    'gamingSessionId': gamingSessionId.toString(),
                  },
                ),
              ),

            if (data.sessionParts.isNotEmpty)
              ListChips(
                title: 'Составляющие сессии',
                items: data.sessionParts,
                getItemTitle: (gamingSession) {
                  final String duration =
                      getDuration(
                            gamingSession.startedAt,
                            gamingSession.finishedAt,
                          )
                          as String;
                  return '${DateFormats.formatDateTime(gamingSession.startedAt)} ($duration)';
                },
                onTap: (gamingSessionId) => context.pushNamed(
                  'gaming-sessions-detail',
                  pathParameters: {
                    'gamingSessionId': gamingSessionId.toString(),
                  },
                ),
              ),

            if (data.linkedSessions.isNotEmpty)
              ListChips(
                title: 'Связанные сессии',
                items: data.linkedSessions,
                getItemTitle: (gamingSession) {
                  final String duration =
                      getDuration(
                            gamingSession.startedAt,
                            gamingSession.finishedAt,
                          )
                          as String;
                  return '${DateFormats.formatDateTime(gamingSession.startedAt)} ($duration)';
                },
                onTap: (gamingSessionId) => context.pushNamed(
                  'gaming-sessions-detail',
                  pathParameters: {
                    'gamingSessionId': gamingSessionId.toString(),
                  },
                ),
              ),

            if (players.isNotEmpty)
              _buildPlayersCard(gamingSession, players, gamingSession.data),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersCard(
    GamingSession gamingSession,
    List<GamingSessionGamerData?> playersData,
    String? sessionData,
  ) {
    if ([
          GameTypeEnum.team.id,
          GameTypeEnum.coop.id,
          GameTypeEnum.teamOneWinner.id,
          GameTypeEnum.secretRoles.id,
          GameTypeEnum.secretTeams.id,
        ].contains(gamingSession.gameType) &&
        sessionData != null) {
      final Map<String, dynamic> data = jsonDecode(sessionData);
      if (data['teamsData'] != null && data['teamsData'].length > 0) {
        return _buildTeamsCard(gamingSession, playersData, data);
      }
    }

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
          itemCount: playersData.length,
          itemBuilder: (context, index) {
            final GamingSessionGamerData? playerData = playersData[index];
            final Gamer gamer = playerData!.gamer;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        getPlaceText(
                          playerData.place,
                          isFinished: gamingSession.isFinished,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(gamer.username, style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          getGamerFio(gamer),
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),

                    if (playerData.turnOrder != null)
                      InfoRow(
                        label: 'Порядок хода',
                        value: playerData.turnOrder.toString(),
                      ),

                    if (playerData.score != null)
                      InfoRow(
                        label: 'Количество набранных очков',
                        value: playerData.score.toString(),
                      ),

                    if (playerData.data!['scoreByrounds'].isNotEmpty) ...[
                      InfoRow(
                        label: 'Количество очков по раундам',
                        value: convertScoreListToStr(
                          playerData.data!['scoreByrounds'],
                        ),
                      ),
                      InfoRow(
                        label: 'Побед в раундах',
                        value: playerData.data!['numWinRounds'].toString(),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTeamsCard(
    GamingSession gamingSession,
    List<GamingSessionGamerData?> playersData,
    Map<String, dynamic> sessionData,
  ) {
    for (final teamData in sessionData['teamsData'].entries) {
      teamData.value['players'] = [];
      teamData.value['teamEnum'] = TeamsEnum.fromId(int.parse(teamData.key));
    }

    GamingSessionGamerData? master;
    for (final playerData in playersData) {
      if (playerData!.gamer.id == sessionData['master']) {
        master = playerData;
      } else {
        sessionData['teamsData'][playerData.team.toString()]['players'].add(
          playerData,
        );
      }
    }

    final teamsData = sessionData['teamsData'].values.toList();
    teamsData.sort((a, b) {
      if (a['place'] == null) return 1;
      if (b['place'] == null) return -1;
      return a['place'].compareTo(b['place']) as int;
    });

    return Column(
      spacing: 8,
      children: [
        if (master != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ведущий',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '(${master.gamer.username}) ${getGamerFio(master.gamer)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        Row(
          children: [
            Text(
              'Команды',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teamsData.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> teamData = teamsData[index];
            final String teamName =
                teamData['name'] ?? teamData['teamEnum'].label;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: teamData['teamEnum'].color, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        getPlaceText(
                          teamData['place'],
                          isFinished: gamingSession.isFinished,
                        ),
                      ],
                    ),

                    Row(
                      spacing: 5,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: teamData['teamEnum'].color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              teamName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          teamName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (teamData['score'] != null)
                      InfoRow(
                        label: 'Количество набранных очков',
                        value: teamData['score'].toString(),
                        addDivider: false,
                      ),
                    if (teamData['scoreByrounds'].isNotEmpty) ...[
                      InfoRow(
                        label: 'Побед в раундах',
                        value: teamData['numWinRounds'].toString(),
                      ),
                      InfoRow(
                        label: 'Количество очков по раундам',
                        value: convertScoreListToStr(teamData['scoreByrounds']),
                      ),
                    ],
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: teamData['players'].length,
                      itemBuilder: (context, index) {
                        final GamingSessionGamerData playerData =
                            teamData['players'][index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: secondColor,
                            border: BoxBorder.all(
                              color: teamData['teamEnum'].color,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    playerData.gamer.username,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    getGamerFio(playerData.gamer),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),

                              if (playerData.data!['role']['groupName'] != null)
                                InfoRow(
                                  label: 'Группа',
                                  value: playerData.data!['role']['groupName'],
                                  addDivider: false,
                                ),

                              if (playerData.data!['role']['roleName'] != null)
                                InfoRow(
                                  label: 'Роль',
                                  value: playerData.data!['role']['roleName'],
                                  addDivider: false,
                                ),

                              if (playerData.turnOrder != null)
                                InfoRow(
                                  label: 'Порядок хода',
                                  value: playerData.turnOrder.toString(),
                                  addDivider: false,
                                ),

                              if (playerData.score != null)
                                InfoRow(
                                  label: 'Количество набранных очков',
                                  value: playerData.score.toString(),
                                  addDivider: false,
                                ),

                              if (playerData
                                  .data!['scoreByrounds']
                                  .isNotEmpty) ...[
                                InfoRow(
                                  label: 'Количество очков по раундам',
                                  value: convertScoreListToStr(
                                    playerData.data!['scoreByrounds'],
                                  ),
                                  addDivider: false,
                                ),
                                InfoRow(
                                  label: 'Побед в раундах',
                                  value: playerData.data!['numWinRounds']
                                      .toString(),
                                  addDivider: false,
                                ),
                              ],
                            ],
                          ),
                        );
                      },
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
        title: Icon(sessionsIcon, color: silverColor),
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
            icon: const Icon(delIcon, color: redColor),
            onPressed: () {
              final gamingSession = gamingSessionAsync.value?.gamingSession;
              if (gamingSession != null) {
                buildDelModal(
                  context,
                  ref,
                  gamingSessionDaoProvider,
                  mounted,
                  gamingSession,
                  () {
                    ref
                        .read(gamingSessionsPaginatedProvider.notifier)
                        .refresh();
                    ref.read(gamesPaginatedProvider.notifier).refresh();
                  },
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
