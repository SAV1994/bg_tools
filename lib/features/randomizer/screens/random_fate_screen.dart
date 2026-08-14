import 'dart:math';

import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class BlockData {
  final int id;
  final String label;
  final Color? color;
  final bool isRevealed;
  final bool isShaking;

  BlockData({
    required this.id,
    required this.label,
    this.color,
    this.isRevealed = false,
    this.isShaking = false,
  });

  BlockData copyWith({
    int? id,
    String? label,
    Color? color,
    bool? isRevealed,
    bool? isShaking,
  }) {
    return BlockData(
      id: id ?? this.id,
      label: label ?? this.label,
      color: color ?? this.color,
      isRevealed: isRevealed ?? this.isRevealed,
      isShaking: isShaking ?? this.isShaking,
    );
  }
}

class RandomFateScreen extends StatefulWidget {
  const RandomFateScreen({super.key});

  @override
  State<RandomFateScreen> createState() => _RandomFateScreenState();
}

class _RandomFateScreenState extends State<RandomFateScreen> {
  int _totalBlocks = 12;
  final int _columns = 4;

  final Map<TeamsEnum, int> _labelCounts = {
    TeamsEnum.red: 0,
    TeamsEnum.blue: 0,
    TeamsEnum.green: 0,
    TeamsEnum.purple: 0,
  };

  // Состояние блоков
  List<BlockData> _blocks = [];
  bool _isStarted = false;
  bool _isFinished = false;
  bool _isSettingsMode = true;

  // Статистика
  int _revealedLabels = 0;
  final List<String> _revealedHistory = [];

  @override
  void initState() {
    super.initState();
    _generateBlocks();
  }

  void _generateBlocks() {
    final random = Random();
    List<BlockData> newBlocks = [];

    List<TeamsEnum?> allLabels = [];
    for (var entry in _labelCounts.entries) {
      for (int i = 0; i < entry.value; i++) {
        allLabels.add(entry.key);
      }
    }

    while (allLabels.length < _totalBlocks) {
      allLabels.add(null);
    }

    allLabels.shuffle(random);

    for (int i = 0; i < _totalBlocks; i++) {
      final enumObj = allLabels[i];
      final color = enumObj?.color;
      newBlocks.add(
        BlockData(
          id: i,
          label: enumObj?.label ?? '',
          color: color,
          isRevealed: false,
          isShaking: false,
        ),
      );
    }

    setState(() {
      _blocks = newBlocks;
    });
  }

  void _setTotalBlocks(int value) {
    if (_isStarted) return;
    setState(() {
      _totalBlocks = value;
      _validateCounts();
      _generateBlocks();
    });
  }

  void _setLabelCount(TeamsEnum enumObj, int count) {
    if (_isStarted) return;
    setState(() {
      _labelCounts[enumObj] = count;
      _validateCounts();
    });
  }

  // Проверка: сумма меток не превышает общее количество блоков
  void _validateCounts() {
    final total = _labelCounts.values.fold(0, (sum, count) => sum + count);
    if (total > _totalBlocks) {
      for (var key in _labelCounts.keys) {
        if (_labelCounts[key]! > 0) {
          _labelCounts[key] = _labelCounts[key]! - (total - _totalBlocks);
          break;
        }
      }
    }
  }

  void _startDraw() {
    final totalLabels = _labelCounts.values.fold(
      0,
      (sum, count) => sum + count,
    );
    if (totalLabels == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Добавьте хотя бы одну метку'),
          backgroundColor: redColor,
        ),
      );
      return;
    }

    setState(() {
      _isStarted = true;
      _isSettingsMode = false;
      _isFinished = false;
      _revealedLabels = 0;
      _revealedHistory.clear();
      _generateBlocks();
    });
  }

  // Открытие блока
  void _revealBlock(int index) {
    if (!_isStarted || _isFinished) return;

    final block = _blocks[index];
    if (block.isRevealed) return;

    setState(() {
      _blocks[index] = block.copyWith(isRevealed: true);
      if (block.label.isNotEmpty) {
        _revealedLabels++;
        _revealedHistory.add(block.label);
      }

      // Проверяем, все ли блоки открыты
      final allRevealed = _blocks.every((b) => b.isRevealed);
      if (allRevealed) {
        _isFinished = true;
        _showResults();
      }
    });
  }

  // Показать результаты
  void _showResults() {
    final labels = _blocks
        .where((b) => b.label.isNotEmpty)
        .map((b) => b.label)
        .toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(children: [Text('Жеребьёвка завершена')]),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Статистика меток
              ..._labelCounts.keys.map((entry) {
                final count = labels.where((l) => l == entry.label).length;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: entry.color,
                    radius: 12,
                  ),
                  title: Text(entry.label),
                  trailing: Text('$count'),
                  dense: true,
                );
              }),
              Divider(),
              ListTile(
                title: Text('Всего меток'),
                trailing: Text('${labels.length}'),
                dense: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reset();
            },
            child: Text('Повторить'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _reset() {
    setState(() {
      _isStarted = false;
      _isFinished = false;
      _isSettingsMode = true;
      _revealedLabels = 0;
      _revealedHistory.clear();
      _generateBlocks();
    });
  }

  Widget _buildSettingsPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: firstColor,
        border: Border(bottom: BorderSide(color: textColor)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Количество блоков
            Text(
              'Количество блоков: $_totalBlocks',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _totalBlocks.toDouble(),
              min: 4,
              max: 20,
              divisions: 32,
              label: '$_totalBlocks',
              onChanged: (value) => _setTotalBlocks(value.toInt()),
            ),

            SizedBox(height: 16),

            // Настройка меток
            Text(
              'Метки (сумма: ${_labelCounts.values.fold(0, (sum, count) => sum + count)} / $_totalBlocks)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ..._labelCounts.entries.map((entry) {
              return Row(
                children: [
                  CircleAvatar(backgroundColor: entry.key.color, radius: 10),
                  SizedBox(width: 8),
                  Expanded(flex: 2, child: Text(entry.key.label)),
                  Expanded(
                    flex: 3,
                    child: Slider(
                      value: entry.value.toDouble(),
                      min: 0,
                      max: _totalBlocks.toDouble(),
                      divisions: _totalBlocks,
                      label: '${_labelCounts[entry.key]}',
                      onChanged: (value) {
                        final newCount = value.toInt();
                        final otherSum = _labelCounts.entries
                            .where((e) => e.key != entry.key)
                            .fold(0, (sum, e) => sum + e.value);

                        if (otherSum + newCount <= _totalBlocks) {
                          _setLabelCount(entry.key, newCount);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Сумма меток не может превышать $_totalBlocks',
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${_labelCounts[entry.key]}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: textColor)),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBlock(BlockData block, int index) {
    return GestureDetector(
      onTap: () => _revealBlock(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: block.isRevealed
              ? (block.label.isNotEmpty
                    ? block.color!.withValues(alpha: 0.2)
                    : textColor)
              : silverColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: block.isRevealed
                ? (block.label.isNotEmpty ? block.color! : textColor)
                : silverColor,
            width: 2,
          ),
          boxShadow: [
            if (!block.isRevealed)
              BoxShadow(
                color: secondColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: block.isRevealed
              ? _buildRevealedContent(block)
              : Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: secondColor,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRevealedContent(BlockData block) {
    if (block.label.isEmpty) {
      return Center(child: Icon(Icons.close, size: 40, color: textColor));
    }

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            block.color!.withValues(alpha: 0.3),
            block.color!.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: block.color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            block.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: block.color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(randomIcon, color: silverColor),
            Icon(fateIcon),
          ],
        ),
        backgroundColor: secondColor,
        foregroundColor: textColor,
        actions: [
          if (_isStarted && !_isFinished)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Сбросить?'),
                    content: Text('Все блоки будут закрыты.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _reset();
                        },
                        child: Text('Сбросить'),
                      ),
                    ],
                  ),
                );
              },
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Выйти', style: TextStyle(color: redColor)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Статус бар
          if (_isStarted)
            Container(
              padding: EdgeInsets.all(16),
              color: firstColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusItem(
                    'Открыто',
                    '${_blocks.where((b) => b.isRevealed).length}/$_totalBlocks',
                    Icons.check_circle,
                    goldColor,
                  ),
                  _buildStatusItem(
                    'Меток найдено',
                    '$_revealedLabels',
                    Icons.local_offer,
                    bronzeColor,
                  ),
                  _buildStatusItem(
                    'Осталось',
                    '${_blocks.where((b) => !b.isRevealed).length}',
                    Icons.hourglass_empty,
                    blueColor,
                  ),
                ],
              ),
            ),

          // Настройки
          if (_isSettingsMode) _buildSettingsPanel(),

          // Поле с блоками
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _columns,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _blocks.length,
                itemBuilder: (context, index) {
                  final block = _blocks[index];
                  return _buildBlock(block, index);
                },
              ),
            ),
          ),

          // Кнопка начала
          if (_isSettingsMode)
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _startDraw,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  foregroundColor: firstColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Начать жеребьёвку',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
