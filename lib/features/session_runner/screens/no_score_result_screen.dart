import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/utils/loading_screen_builder.dart';

class NoScoreResultScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const NoScoreResultScreen({super.key, required this.data});

  @override
  ConsumerState<NoScoreResultScreen> createState() =>
      _NoScoreResultScreenState();
}

class _NoScoreResultScreenState extends ConsumerState<NoScoreResultScreen> {
  bool isDraw = false;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.data['gamers'][0]['place'] == null) {
      _fillPlace();
    } else {
      isDraw = hasDraw();
    }

    setState(() => _isLoading = false);
  }

  bool hasDraw() {
    for (int i = 0; i < widget.data['gamers'].length - 1; i++) {
      if (widget.data['gamers'][i]['place'] ==
          widget.data['gamers'][i + 1]['place']) {
        return true; // Найдены одинаковые соседние значения
      }
    }
    return false; // Нет одинаковых соседних значений
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
    });

    _fillPlace();

    setState(() {});
  }

  void _fillPlace() {
    for (final entry in widget.data['gamers'].asMap().entries) {
      entry.value['place'] = entry.key + 1;
    }
  }

  Widget _buildPlayerCard(int index, Map<String, dynamic> gamerData) {
    final isTop3 = index < 3;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isTop3 ? Colors.amber.shade300 : Colors.grey.shade200,
          width: isTop3 ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 10,
          children: [
            // Drag handle
            ReorderableDragStartListener(
              index: index,
              child: Icon(Icons.drag_handle, color: Colors.grey),
            ),

            // Позиция
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isTop3
                    ? Colors.amber.withValues(alpha: 0.2)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isTop3
                        ? Colors.amber.shade700
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),

            // Имя игрока
            Expanded(
              child: Text(
                gamerData['username'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
        return _isLoading
            ? buildLoadingScreen()
            : ReorderableListView(
                padding: const EdgeInsets.all(16),
                onReorder: _reorder,
                children: List.generate(widget.data['gamers'].length, (index) {
                  final Map<String, dynamic> gamerData =
                      widget.data['gamers'][index];

                  return Container(
                    key: Key('${gamerData['id']}_$index'),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: _buildPlayerCard(index, gamerData),
                    ),
                  );
                }),
              );
      },
    );
  }
}
