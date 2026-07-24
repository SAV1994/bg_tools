import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/widgets/export.dart';

enum _SelectMode { single, multiple }

class OneWinnerSelectScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const OneWinnerSelectScreen({super.key, required this.data});

  @override
  ConsumerState<OneWinnerSelectScreen> createState() =>
      _OneWinnerSelectScreenState();
}

class _OneWinnerSelectScreenState extends ConsumerState<OneWinnerSelectScreen> {
  _SelectMode _mode = _SelectMode.single;
  late int? _singleSelected;
  late Set<int> _multipleSelected;
  // Загрузка
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>> gamersData = widget.data['gamers']
        .cast<Map<String, dynamic>>();
    final List<Map<String, dynamic>> selectedItems = gamersData
        .where((gameData) => gameData['place'] == 1)
        .toList();
    if (selectedItems.isNotEmpty) {
      if (selectedItems.length > 1) {
        _mode = _SelectMode.multiple;
        _singleSelected = null;
        _multipleSelected = selectedItems
            .map((gamerData) => gamerData['id'] as int)
            .toSet();
      } else {
        _singleSelected = selectedItems[0]['id'];
        _multipleSelected = {};
      }
    } else {
      _singleSelected = null;
      _multipleSelected = {};
    }
    setState(() => _isLoading = false);
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == _SelectMode.single
          ? _SelectMode.multiple
          : _SelectMode.single;
      if (_mode == _SelectMode.single && _multipleSelected.isNotEmpty) {
        _singleSelected = _multipleSelected.first;
        _updateData([_singleSelected!]);
        _multipleSelected.clear();
      } else if (_mode == _SelectMode.multiple && _singleSelected != null) {
        _multipleSelected.add(_singleSelected!);
        _updateData(_multipleSelected.toList());
        _singleSelected = null;
      }
    });
  }

  void _updateData(List<int> selectedIds) {
    for (final gamerData in widget.data['gamers']) {
      if (selectedIds.contains(gamerData['id'])) {
        gamerData['place'] = 1;
      } else {
        gamerData['place'] = null;
      }
    }
  }

  void _toggleItem(Map<String, dynamic> gamerData) {
    setState(() {
      if (_mode == _SelectMode.single) {
        _singleSelected = gamerData['id'];
        _updateData([_singleSelected!]);
      } else {
        if (_multipleSelected.contains(gamerData['id'])) {
          _multipleSelected.remove(gamerData['id']);
        } else {
          _multipleSelected.add(gamerData['id']);
        }
        _updateData(_multipleSelected.toList());
      }
    });
  }

  bool _isSelected(Map<String, dynamic> gamerData) {
    return _mode == _SelectMode.single
        ? _singleSelected == gamerData['id']
        : _multipleSelected.contains(gamerData['id']);
  }

  Widget _buildItemTile(Map<String, dynamic> gamerData, bool isSelected) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _toggleItem(gamerData),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Индикатор выбора
              _buildSelectionIndicator(isSelected),
              const SizedBox(width: 16),
              Expanded(
                child: ListTile(
                  title: Text(gamerData['username']),
                  subtitle: Text(gamerData['fio']),
                ),
              ),
              // Дополнительная информация (опционально)
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.blue, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    if (_mode == _SelectMode.single) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      );
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.transparent,
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade400,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _isLoading
            ? LoadingScreen()
            : Column(
                spacing: 12,
                children: [
                  // Кнопка переключения режима
                  SegmentedButton<_SelectMode>(
                    segments: const [
                      ButtonSegment(
                        value: _SelectMode.single,
                        label: Text('Один победитель'),
                        icon: Icon(Icons.radio_button_unchecked),
                      ),
                      ButtonSegment(
                        value: _SelectMode.multiple,
                        label: Text('Ничья'),
                        icon: Icon(Icons.check_box_outline_blank),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (Set<_SelectMode> selection) {
                      _toggleMode();
                    },
                  ),
                  // Информационная панель
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue.shade50,
                    child: Row(
                      children: [
                        Icon(
                          _mode == _SelectMode.single
                              ? Icons.radio_button_checked
                              : Icons.check_box,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _mode == _SelectMode.single
                                ? 'Выберите одного победителя'
                                : 'Выберите несколько победителей (${_multipleSelected.length} выбрано)',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Список элементов
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.data['gamers'].length,
                      itemBuilder: (context, index) {
                        final gamerData = widget.data['gamers'][index];
                        final isSelected = _isSelected(gamerData);

                        return _buildItemTile(gamerData, isSelected);
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }
}
