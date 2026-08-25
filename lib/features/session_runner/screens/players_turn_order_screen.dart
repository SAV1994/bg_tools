import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:bg_tools/features/session_runner/categories.dart';

class GamersTurnOrderScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final List<dynamic> counterData;

  const GamersTurnOrderScreen({
    super.key,
    required this.data,
    required this.counterData,
  });

  @override
  ConsumerState<GamersTurnOrderScreen> createState() =>
      _GamersTurnOrderScreenState();
}

class _GamersTurnOrderScreenState extends ConsumerState<GamersTurnOrderScreen> {
  // Загрузка
  bool _isLoading = false;

  Future<void> _reorderByCircle() async {
    setState(() => _isLoading = true);

    final List<dynamic> gamers = widget.data['gamers'];
    final int totalGamers = gamers.length;
    final int index = Random().nextInt(totalGamers);
    if (index != 0) {
      final List<dynamic> reorderGamers =
          gamers.sublist(index) + gamers.sublist(0, index);
      widget.data['gamers'] = reorderGamers;
      _fillTurnOrder();
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Порядок хода изменён')));

    setState(() => _isLoading = false);
  }

  void _fillTurnOrder() {
    for (final entry in widget.data['gamers'].asMap().entries) {
      entry.value['turnOrder'] = entry.key + 1;
    }
  }

  Future<void> _reorderRandom() async {
    setState(() => _isLoading = true);

    setState(() {
      widget.data['gamers'].shuffle();
      _fillTurnOrder();
      _isLoading = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Порядок хода изменён')));
  }

  Future<void> _reorderTeamTakeTurns() async {
    setState(() => _isLoading = true);

    final List<Map<String, dynamic>> gamers = [];

    final int totalGamers = widget.data['gamers'].length;

    List<List<Map<String, dynamic>>> teams = _getTeamsList();

    setState(() {
      teams.sort((a, b) => b.length.compareTo(a.length));

      int i = 0;
      while (gamers.length < totalGamers) {
        if (teams[i].isNotEmpty) {
          final Map<String, dynamic> gamerData = teams[i].removeAt(0);
          gamers.add(gamerData);
        }

        if (i == widget.data['numberTeams'] - 1) {
          i = 0;
        } else {
          i++;
        }
      }

      widget.data['gamers'] = gamers;
      _fillTurnOrder();

      _isLoading = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Порядок хода изменён')));
  }

  List<List<Map<String, dynamic>>> _getTeamsList() {
    List<List<Map<String, dynamic>>> teams = [];

    for (int i = 0; i < widget.data['numberTeams']; i++) {
      teams.add([]);
    }
    for (Map<String, dynamic> gamerData in widget.data['gamers']) {
      teams[gamerData['team'] - 1].add(gamerData);
    }
    for (int i = 0; i < widget.data['numberTeams']; i++) {
      teams[i].shuffle();
    }

    return teams;
  }

  Future<void> _reorderOneTeamFirst() async {
    setState(() => _isLoading = true);

    final List<Map<String, dynamic>> gamers = [];

    List<List<Map<String, dynamic>>> teams = _getTeamsList();
    teams.shuffle();

    for (List<Map<String, dynamic>> teamData in teams) {
      gamers.addAll(teamData);
    }

    widget.data['gamers'] = gamers;
    _fillTurnOrder();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Порядок хода изменён')));

    setState(() => _isLoading = false);
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

  void _moveToStart(int index) {
    if (index != 0) {
      setState(() {
        widget.data['gamers'] =
            widget.data['gamers'].sublist(index) +
            widget.data['gamers'].sublist(0, index);
        _fillTurnOrder();
      });
    }
  }

  void _moveToEnd(int index) {
    if (index != widget.data['gamers'].length - 1) {
      setState(() {
        widget.data['gamers'] =
            widget.data['gamers'].sublist(index + 1) +
            widget.data['gamers'].sublist(0, index + 1);
        _fillTurnOrder();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Column(
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
                            child: Dismissible(
                              key: Key(gamerData['id'].toString()),
                              direction: DismissDirection.horizontal,
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  _moveToEnd(index);
                                } else {
                                  _moveToStart(index);
                                }
                              },

                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  return widget.data['gamers'].length - 1 !=
                                      index;
                                } else {
                                  return index != 0;
                                }
                              },

                              // Фон при свайпе вправо
                              background: Container(
                                color: redColor,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    Icon(Icons.last_page, color: textColor),
                                    SizedBox(width: 8),
                                    Text(
                                      'Конец',
                                      style: TextStyle(color: textColor),
                                    ),
                                  ],
                                ),
                              ),

                              // Фон при свайпе влево
                              secondaryBackground: Container(
                                color: greenColor,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Начало',
                                      style: TextStyle(color: textColor),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.first_page, color: textColor),
                                  ],
                                ),
                              ),

                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: (gamerData['team'] != null)
                                        ? TeamsEnum.fromId(
                                            gamerData['team'],
                                          ).color
                                        : Colors.red,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(color: Colors.white),
                                    ),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlinedButton.icon(
                          onPressed: _reorderByCircle,
                          icon: const Icon(Icons.trip_origin),
                          label: const Text('Сохранить последовательность'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlinedButton.icon(
                          onPressed: _reorderRandom,
                          icon: const Icon(Icons.priority_high),
                          label: const Text('Полный рандом'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                          ),
                        ),
                      ),
                      if (widget.data['type'] == GameTypeEnum.team.id)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: OutlinedButton.icon(
                            onPressed: _reorderTeamTakeTurns,
                            icon: const Icon(Icons.priority_high),
                            label: const Text('Чередовать команды'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                            ),
                          ),
                        ),
                      if (widget.data['type'] == GameTypeEnum.team.id)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: OutlinedButton.icon(
                            onPressed: _reorderOneTeamFirst,
                            icon: const Icon(Icons.priority_high),
                            label: const Text('Команды по порядку'),
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
