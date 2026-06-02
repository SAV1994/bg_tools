import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/add_gamer_modal_form_builder.dart';
import 'package:bg_tools/core/utils/gamer_session_data_getter.dart';
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
  late final Map<TeamsEnum, List<Map<String, dynamic>>> _teams = {};
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

    if (widget.data['gamers'].isEmpty) {
      for (int i = 1; i <= widget.data['numberTeams']; i++) {
        final teamEnum = TeamsEnum.fromId(i);
        _teams[teamEnum] = [];
      }
    } else {
      for (Map<String, dynamic> gamerData in widget.data['gamers']) {
        if (_teams[gamerData['team']] == null) {
          _teams[gamerData['team']] = [gamerData];
        } else {
          _teams[gamerData['team']]!.add(gamerData);
        }
      }
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
      final Map<String, dynamic> gamerData = getGamerData(gamer, team.id);

      setState(() {
        widget.data['gamers'].add(gamerData);
        _teams[team]!.add(gamerData);
      });
    });
  }

  void _removePlayer(Map<String, dynamic> gamerData) {
    setState(() {
      widget.data['gamers'].remove(gamerData);
      _teams[gamerData['team']]!.remove(gamerData);
    });
  }

  void _movePlayerToTeam(Map<String, dynamic> gamerData, TeamsEnum newTeam) {
    if (gamerData['team'] == newTeam.id) return;

    setState(() {
      _teams[gamerData['team']]!.remove(gamerData);
      _teams[newTeam]!.add(gamerData);
      gamerData['team'] = newTeam.id;
    });
  }

  Widget _buildTeamHeader(TeamsEnum team) {
    return Container(
      padding: const EdgeInsets.all(12),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_teams[team]!.length}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: team.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerList(TeamsEnum team) {
    final gamers = _teams[team]!;

    if (gamers.isEmpty) {
      return Center(
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: team.color.withValues(alpha: 0.5),
            ),
            Text(
              'Нет игроков',
              style: TextStyle(color: team.color.withValues(alpha: 0.7)),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) newIndex--;
          final player = gamers.removeAt(oldIndex);
          gamers.insert(newIndex, player);
        });
      },
      itemCount: gamers.length,
      itemBuilder: (context, index) {
        final gamerData = gamers[index];

        return Container(
          key: Key('${gamerData['id']}_$index'),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Draggable<Map<String, dynamic>>(
            data: gamerData,
            feedback: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: team.color,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(blurRadius: 8, color: Colors.black26),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.drag_handle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      gamerData['username'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: Card(
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: team.color,
                    child: Text(
                      gamerData['username'][0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(gamerData['username']),
                  trailing: const Icon(Icons.drag_handle),
                ),
              ),
            ),
            onDragStarted: () => setState(() => _dragTargetTeam = team),
            onDragEnd: (_) => setState(() => _dragTargetTeam = null),
            child: Card(
              elevation: 0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: team.color,
                  child: Text(
                    gamerData['username'].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(gamerData['username']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      child: Icon(Icons.drag_handle),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.red,
                      ),
                      onPressed: () => _removePlayer(gamerData),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton(TeamsEnum team) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _addPlayer(team),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Добавить'),
          style: OutlinedButton.styleFrom(
            foregroundColor: team.color,
            side: BorderSide(color: team.color),
          ),
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
          child: Column(
            spacing: 8,
            children: _isLoading
                ? [buildLoadingScreen()]
                : [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _teams.keys.map((team) {
                        return Expanded(
                          child: DragTarget<Map<String, dynamic>>(
                            onAcceptWithDetails: (gamerData) =>
                                _movePlayerToTeam(gamerData.data, team),
                            onWillAcceptWithDetails: (gamerData) =>
                                gamerData.data['team'] != team,
                            onLeave: (gamerData) =>
                                setState(() => _dragTargetTeam = null),
                            builder: (context, candidateData, rejectedData) {
                              final isTargeted = _dragTargetTeam == team;

                              return Container(
                                margin: const EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  color: team.bgColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isTargeted
                                        ? team.color
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: isTargeted
                                      ? [
                                          BoxShadow(
                                            color: team.color.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Column(
                                  children: [
                                    _buildTeamHeader(team),
                                    Expanded(child: _buildPlayerList(team)),
                                    _buildAddButton(team),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
          ),
        );
      },
    );
  }
}
