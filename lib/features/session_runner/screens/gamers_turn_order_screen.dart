import 'dart:math';

import 'package:bg_tools/core/utils/loading_screen_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamersTurnOrderScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const GamersTurnOrderScreen({super.key, required this.data});

  @override
  ConsumerState<GamersTurnOrderScreen> createState() =>
      _GamersTurnOrderScreenState();
}

class _GamersTurnOrderScreenState extends ConsumerState<GamersTurnOrderScreen> {
  // Загрузка
  bool _isLoading = false;

  Future<void> _reorderByCircle() async {
    setState(() => _isLoading = true);

    final List<dynamic> _gamers = widget.data['gamers'];
    final int totalGamers = _gamers.length;
    final int index = Random().nextInt(totalGamers);
    if (index != 0) {
      final List<dynamic> reorderGamers =
          _gamers.sublist(index) + _gamers.sublist(0, index);
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

    widget.data['gamers'].shuffle();
    _fillTurnOrder();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Порядок хода изменён')));

    setState(() => _isLoading = false);
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Map<String, dynamic> gamerData = widget.data['gamers'].removeAt(
      oldIndex,
    );
    widget.data['gamers'].insert(newIndex, gamerData);
    _fillTurnOrder();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return SingleChildScrollView(
          child: Column(
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
                              'Порядок хода',
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
                        label: const Text(
                          'Полный рандом (нужно будет пересесть)',
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
