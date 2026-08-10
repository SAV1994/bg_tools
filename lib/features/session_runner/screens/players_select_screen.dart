import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';
import 'package:bg_tools/features/session_runner/utils/export.dart';

class GamersSelectScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const GamersSelectScreen({super.key, required this.data});

  @override
  ConsumerState<GamersSelectScreen> createState() => _GamersSelectScreenState();
}

class _GamersSelectScreenState extends ConsumerState<GamersSelectScreen> {
  List<Gamer> _allGamers = [];
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

    setState(() => _isLoading = false);
  }

  void _showAddGamerDialog() {
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
      if ([
        GameTypeEnum.solo.id,
        GameTypeEnum.coop.id,
      ].contains(widget.data['type'])) {
        gamerData['team'] = TeamsEnum.red.id;
      }

      setState(() => widget.data['gamers'].add(gamerData));
    });
  }

  Future<void> _addLastSessionGamers() async {
    late final List<dynamic> gamersData;
    if (widget.data['type'] == GameTypeEnum.solo.id) {
      gamersData = await AppDataManager.loadLastSessionGamer();
    } else {
      gamersData = await AppDataManager.loadLastSessionGamers();
    }

    if (gamersData.isNotEmpty) {
      setState(() {
        if (widget.data['gamers'].isNotEmpty &&
            !gamersData.any(
              (element) => element['id'] == widget.data['gamers'][0]['id'],
            )) {
          widget.data['gamers'].addAll(gamersData);
        } else {
          widget.data['gamers'] = gamersData;
        }

        if ([
          GameTypeEnum.solo.id,
          GameTypeEnum.coop.id,
          GameTypeEnum.secretTeams.id,
        ].contains(widget.data['type'])) {
          late final int team;
          if (widget.data['type'] == GameTypeEnum.secretTeams.id) {
            team = int.parse(widget.data['teamsData'].keys.first);
          } else {
            team = TeamsEnum.red.id;
          }

          for (final Map<String, dynamic> gamerData in gamersData) {
            gamerData['team'] = team;
          }
        }

        _fillTurnOrder();
      });
    }
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Map<String, dynamic> gamerData = widget.data['gamers'].removeAt(
        oldIndex,
      );
      widget.data['gamers'].insert(newIndex, gamerData);
      _fillTurnOrder();
    });
  }

  void _fillTurnOrder() {
    if (widget.data['type'] != GameTypeEnum.secretRoles ||
        widget.data['firstPlayerStartType'] ==
            FirstPlayerStartTypeEnum.sameTime.id) {
      return;
    }

    for (final entry in widget.data['gamers'].asMap().entries) {
      entry.value['turnOrder'] = entry.key + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return SingleChildScrollView(
          child: Column(
            spacing: 8,
            children: _isLoading
                ? [LoadingScreen()]
                : [
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: _reorder,
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: child,
                        );
                      },
                      itemCount: widget.data['gamers'].length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> gamerData =
                            widget.data['gamers'][index];
                        return Container(
                          key: Key('${gamerData['id']}_$index'),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(gamerData['username']),
                              subtitle: Text(gamerData['fio']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: Icon(Icons.drag_handle),
                                  ),
                                  if (widget.data['master'] == null ||
                                      widget.data['master'] != gamerData['id'])
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () {
                                        setState(
                                          () => widget.data['gamers'].removeAt(
                                            index,
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (widget.data['type'] != GameTypeEnum.solo.id ||
                        widget.data['gamers'].isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlinedButton.icon(
                          onPressed: _showAddGamerDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Добавить игрока'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                          ),
                        ),
                      ),
                    if (widget.data['gamers'].isEmpty ||
                        (widget.data['master'] != null &&
                            widget.data['gamers'].length == 1))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlinedButton.icon(
                          onPressed: _addLastSessionGamers,
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
        );
      },
    );
  }
}
