import 'package:bg_tools/core/consts.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/app_data.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/providers/database_providers.dart';
import 'package:bg_tools/core/utils/add_gamer_modal_form.dart';
import 'package:bg_tools/core/utils/gamer_fio_builder.dart';
import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

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
      widget.data['gamers'].add(getGamerData(gamer));
      setState(() {});
    });
  }

  Future<void> _addLastSessionGamers() async {
    final List<dynamic> gamersData =
        await AppDataManager.loadLastSessionGamers();
    if (gamersData.isNotEmpty) {
      widget.data['gamers'].addAll(gamersData);
      if (widget.data['type'] == GameTypeEnum.solo.id) {
        for (final Map<String, dynamic> gamerData in gamersData) {
          gamerData['team'] = TeamsEnum.red.id;
        }
      } else {
        _fillTurnOrder();
      }

      setState(() {});
    }
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Map<String, dynamic> gamer = widget.data['gamers'].removeAt(oldIndex);
    widget.data['gamers'].insert(newIndex, gamer);
    _fillTurnOrder();

    setState(() {});
  }

  void _fillTurnOrder() {
    for (final entry in widget.data['gamers'].asMap().entries) {
      entry.value['turnOrder'] = entry.key + 1;
    }
  }

  Map<String, dynamic> getGamerData(Gamer gamer) {
    return {
      'id': gamer.id,
      'username': gamer.username,
      'fio': getGamerFio(gamer),
      'score': null,
      'place': null,
      'turnOrder': null,
      'team': (widget.data['type'] == GameTypeEnum.solo.id)
          ? TeamsEnum.red.id
          : null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return SingleChildScrollView(
          child: Column(
            spacing: 8,
            children: _isLoading
                ? [buildLoadingScreen()]
                : [
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      header: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Text(
                              'Список игроков',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      onReorder: _reorder,
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
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      widget.data['gamers'].removeAt(index);
                                      setState(() => {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
                    if (widget.data['gamers'].isEmpty)
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
