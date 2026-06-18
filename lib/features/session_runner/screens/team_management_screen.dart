import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/add_gamer_modal_form_builder.dart';
import 'package:bg_tools/core/utils/gamer_session_data.dart';
import 'package:bg_tools/core/utils/initial_team_data.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class TeamManagementScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const TeamManagementScreen({super.key, required this.data});

  @override
  ConsumerState<TeamManagementScreen> createState() =>
      _TeamManagementScreenState();
}

class _TeamManagementScreenState extends ConsumerState<TeamManagementScreen> {
  List<Gamer> _allGamers = [];
  Map<TeamsEnum, List<Map<String, dynamic>>> _teams = {};
  TeamsEnum? _dragTargetTeam;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Загружаем всех игроков
    final gamerDao = ref.read(gamerDaoProvider);
    _allGamers = await gamerDao.getEverybody();

    for (int i = 1; i <= widget.data['numberTeams']; i++) {
      final teamEnum = TeamsEnum.fromId(i);
      _teams[teamEnum] = [];
      if (widget.data['teamsData'][teamEnum.id.toString()] == null) {
        setIniialTeamData(widget.data['teamsData'], teamEnum.id);
      }
    }

    for (Map<String, dynamic> gamerData in widget.data['gamers']) {
      _teams[TeamsEnum.fromId(gamerData['team'])]!.add(gamerData);
    }

    setState(() => _isLoading = false);
  }

  void _addPlayer(TeamsEnum team) {
    final notSelectedGamers = _allGamers
        .where((g) => !widget.data['gamers'].any((item) => g.id == item['id']))
        .toList();

    if (notSelectedGamers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Все игроки уже добавлены')));
      return;
    }

    // Показываем диалог игрока
    buildAddGamerModal(context, notSelectedGamers, (gamer) {
      final Map<String, dynamic> gamerData = getGamerData(gamer);
      gamerData['team'] = team.id;

      setState(() {
        widget.data['gamers'].add(gamerData);
        _teams[team]!.add(gamerData);
      });
    });
  }

  Future<void> _addLastSessionTeams() async {
    setState(() => _isLoading = true);

    final List<dynamic> gamersData =
        await AppDataManager.loadLastSessionTeams();

    if (gamersData.isNotEmpty) {
      widget.data['gamers'].addAll(gamersData);

      for (Map<String, dynamic> gamerData in widget.data['gamers']) {
        if (_teams[TeamsEnum.fromId(gamerData['team'])] == null) {
          _teams[TeamsEnum.fromId(1)]!.add(gamerData);
        } else {
          _teams[TeamsEnum.fromId(gamerData['team'])]!.add(gamerData);
        }
      }
    }

    setState(() => _isLoading = false);
  }

  void _removePlayer(Map<String, dynamic> gamerData) {
    setState(() {
      widget.data['gamers'].remove(gamerData);
      _teams[TeamsEnum.fromId(gamerData['team'])]!.remove(gamerData);
    });
  }

  void _movePlayerToTeam(Map<String, dynamic> gamerData, TeamsEnum newTeam) {
    if (gamerData['team'] == newTeam.id) return;
    setState(() {
      _teams[TeamsEnum.fromId(gamerData['team'])]!.remove(gamerData);
      _teams[newTeam]!.add(gamerData);
      gamerData['team'] = newTeam.id;
    });
  }

  void _shuffle(bool saveProportions) {
    final Map<TeamsEnum, List<Map<String, dynamic>>> newTeams = {};
    for (int i = 1; i <= widget.data['numberTeams']; i++) {
      final teamEnum = TeamsEnum.fromId(i);
      newTeams[teamEnum] = [];
    }

    final List<Map<String, dynamic>> gamers = _teams.values
        .expand((list) => list)
        .toList();
    gamers.shuffle();

    if (saveProportions) {
      final List<TeamsEnum> teamsMemberList = [];
      for (final entry in _teams.entries) {
        for (int i = 1; i <= entry.value.length; i++) {
          teamsMemberList.add(entry.key);
        }
      }
      for (int i = 0; i < gamers.length; i++) {
        final TeamsEnum team = teamsMemberList[i];
        final Map<String, dynamic> gamerData = gamers[i];
        newTeams[team]!.add(gamerData);
        gamerData['team'] = team.id;
      }
    } else {
      int teamId = 1;
      for (final Map<String, dynamic> gamerData in gamers) {
        gamerData['team'] = teamId;
        newTeams[TeamsEnum.fromId(teamId)]!.add(gamerData);
        if (teamId == widget.data['numberTeams']) {
          teamId = 1;
        } else {
          teamId++;
        }
      }
    }

    setState(() {
      _teams = newTeams;
    });
  }

  Widget _buildTeamCard(TeamsEnum team) {
    final gamers = _teams[team]!;

    return DragTarget<Map<String, dynamic>>(
      onWillAcceptWithDetails: (details) => details.data['team'] != team.id,
      onAcceptWithDetails: (details) => _movePlayerToTeam(details.data, team),
      builder: (context, candidateData, rejectedData) {
        final isDragTarget = _dragTargetTeam == team;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: team.bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDragTarget ? team.color : Colors.transparent,
              width: 3,
            ),
            boxShadow: isDragTarget
                ? [
                    BoxShadow(
                      color: team.color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),

          child: Column(
            children: [
              // Заголовок команды
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: team.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      team.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${gamers.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: team.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Список игроков
              gamers.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 24,
                            color: Colors.white,
                          ),
                          Text(
                            'Нет игроков',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: gamers.length,
                      itemBuilder: (context, index) {
                        final gamer = gamers[index];
                        return _buildPlayerTile(gamer, team);
                      },
                    ),

              // Кнопка добавления
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _addPlayer(team),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Добавить игрока'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerTile(Map<String, dynamic> gamer, TeamsEnum team) {
    return DragTarget<Map<String, dynamic>>(
      onWillAcceptWithDetails: (details) => details.data['team'] != team.id,
      onAcceptWithDetails: (details) => _movePlayerToTeam(details.data, team),
      builder: (context, candidateData, rejectedData) {
        final isDragTarget = _dragTargetTeam == team;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isDragTarget ? team.color.withValues(alpha: 0.2) : null,
          ),
          child: Draggable<Map<String, dynamic>>(
            data: gamer,
            feedback: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: team.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  gamer['username'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: _buildPlayerCard(gamer, team),
            ),
            onDragStarted: () => setState(() => _dragTargetTeam = team),
            onDragEnd: (_) => setState(() => _dragTargetTeam = null),
            child: _buildPlayerCard(gamer, team),
          ),
        );
      },
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> gamer, TeamsEnum team) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: team.color,
          child: Text(
            gamer['username'][0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(gamer['username']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const Icon(Icons.drag_handle, color: Colors.grey),
            const SizedBox(width: 8),
            // Кнопка удаления
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.red),
              onPressed: () => _removePlayer(gamer),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading
              ? buildLoadingScreen()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ..._teams.keys.map((team) {
                        return _buildTeamCard(team);
                      }),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _shuffle(true);
                          },
                          label: const Text('Сохраняя пропорции'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _shuffle(false);
                          },
                          label: const Text('Распределить равномерно'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                          ),
                        ),
                      ),
                      if (widget.data['gamers'].isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: OutlinedButton.icon(
                            onPressed: _addLastSessionTeams,
                            icon: const Icon(Icons.group),
                            label: const Text(
                              'Добавить игроков из прошлой сессии',
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
