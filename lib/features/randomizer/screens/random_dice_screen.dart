import 'dart:math';

import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class DiceType {
  final int sides;
  final String label;
  final Color color;

  DiceType({required this.sides, required this.label, required this.color});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiceType &&
          runtimeType == other.runtimeType &&
          sides == other.sides;

  @override
  int get hashCode => sides.hashCode;
}

class DiceResult {
  final DiceType type;
  final int value;
  bool isHighlighted;

  DiceResult({
    required this.type,
    required this.value,
    this.isHighlighted = false,
  });
}

class RandomDiceScreen extends StatefulWidget {
  const RandomDiceScreen({super.key});

  @override
  State<RandomDiceScreen> createState() => _RandomDiceScreenState();
}

class _RandomDiceScreenState extends State<RandomDiceScreen>
    with SingleTickerProviderStateMixin {
  final List<DiceType> _diceTypes = [
    DiceType(sides: 4, label: 'd4', color: Colors.green),
    DiceType(sides: 6, label: 'd6', color: Colors.blue),
    DiceType(sides: 8, label: 'd8', color: Colors.orange),
    DiceType(sides: 10, label: 'd10', color: Colors.purple),
    DiceType(sides: 12, label: 'd12', color: Colors.red),
    DiceType(sides: 20, label: 'd20', color: Colors.amber),
  ];

  final Map<String, int> _diceCounts = {};

  // Результаты броска
  List<DiceResult> _results = [];
  bool _isRolling = false;
  int _totalSum = 0;

  // Анимация
  late AnimationController _animationController;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Инициализируем счетчики
    for (var type in _diceTypes) {
      _diceCounts[type.label] = 0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Изменить количество кубиков
  void _updateDiceCount(String label, int count) {
    setState(() {
      _diceCounts[label] = count.clamp(0, 20);
    });
  }

  // Получить общее количество кубиков
  int get _totalDiceCount {
    return _diceCounts.values.fold(0, (sum, count) => sum + count);
  }

  // Бросить кубики
  void _rollDice() {
    if (_totalDiceCount == 0 || _isRolling) return;

    setState(() {
      _isRolling = true;
      _results.clear();
    });

    _animationController.forward(from: 0);

    // Небольшая задержка для анимации
    Future.delayed(Duration(milliseconds: 500), () {
      final results = <DiceResult>[];

      for (var type in _diceTypes) {
        final count = _diceCounts[type.label] ?? 0;
        for (int i = 0; i < count; i++) {
          final value = _random.nextInt(type.sides) + 1;
          results.add(
            DiceResult(type: type, value: value, isHighlighted: false),
          );
        }
      }

      // Перемешиваем результаты
      results.shuffle(_random);

      setState(() {
        _results = results;
        _totalSum = results.fold(0, (sum, r) => sum + r.value);
        _isRolling = false;
      });
    });
  }

  // Подсветка выигрышных комбинаций
  void _highlightDuplicates() {
    final values = _results.map((r) => r.value).toList();
    final duplicates = values
        .where((v) => values.where((x) => x == v).length > 1)
        .toSet();

    setState(() {
      for (var result in _results) {
        result.isHighlighted = duplicates.contains(result.value);
      }
    });
  }

  // Очистить результаты
  void _clearResults() {
    setState(() {
      _results.clear();
      _totalSum = 0;
    });
  }

  // Сбросить все счетчики
  void _resetAll() {
    setState(() {
      for (var type in _diceTypes) {
        _diceCounts[type.label] = 0;
      }
      _results.clear();
      _totalSum = 0;
    });
  }

  // Быстрый набор (например, для D&D)
  void _quickSet(String preset) {
    setState(() {
      // Сбрасываем все
      for (var type in _diceTypes) {
        _diceCounts[type.label] = 0;
      }

      switch (preset) {
        case 'Все по одному':
          for (var type in _diceTypes) {
            _diceCounts[type.label] = 1;
          }
          break;
      }
    });
  }

  Widget _buildDiceResult(DiceResult result) {
    final isHighlighted = result.isHighlighted;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isHighlighted
            ? result.type.color.withValues(alpha: 0.2)
            : secondColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? result.type.color : textColor,
          width: isHighlighted ? 3 : 1,
        ),
        boxShadow: [
          if (isHighlighted)
            BoxShadow(
              color: result.type.color.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Значение
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: result.type.color.withValues(alpha: 0.2),
              border: Border.all(color: result.type.color, width: 2),
            ),
            child: Center(
              child: Text(
                result.value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: result.type.color,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            result.type.label,
            style: TextStyle(fontSize: 15, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceSelector(DiceType type, int count) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: secondColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: secondColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Иконка кубика
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: type.color.withValues(alpha: 0.2),
              border: Border.all(color: type.color, width: 2),
            ),
            child: Center(
              child: Text(
                type.sides.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: type.color,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            type.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Spacer(),
          // Кнопки управления количеством
          IconButton(
            icon: Icon(Icons.remove_circle_outline),
            color: textColor,
            onPressed: count > 0
                ? () => _updateDiceCount(type.label, count - 1)
                : null,
            iconSize: 28,
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: textColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: textColor,
            onPressed: count < 20
                ? () => _updateDiceCount(type.label, count + 1)
                : null,
            iconSize: 28,
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
            Icon(randomIcon),
          ],
        ),
        backgroundColor: secondColor,
        foregroundColor: textColor,
        actions: [
          if (_results.isNotEmpty)
            IconButton(icon: Icon(Icons.clear), onPressed: _clearResults),
          PopupMenuButton<String>(
            icon: Icon(Icons.settings),
            onSelected: (value) {
              if (value == 'reset') {
                _resetAll();
              } else if (value.startsWith('preset_')) {
                final preset = value.replaceFirst('preset_', '');
                _quickSet(preset);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'preset_Все по одному',
                child: Text(
                  '🎲 Все по одному',
                  style: TextStyle(color: textColor),
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'reset',
                child: Text(
                  '🔄 Сбросить всё',
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
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
          // Выбор кубиков
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsetsGeometry.only(top: 5),
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: firstColor,
                border: BoxBorder.all(color: secondColor, width: 4),
                borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Выберите кубики:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Всего: $_totalDiceCount',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _diceTypes.length,
                      itemBuilder: (context, index) {
                        final type = _diceTypes[index];
                        final count = _diceCounts[type.label] ?? 0;
                        return _buildDiceSelector(type, count);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Кнопка броска
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _totalDiceCount == 0 || _isRolling
                        ? null
                        : _rollDice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldColor,
                      foregroundColor: firstColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_isRolling ? Icons.hourglass_empty : Icons.casino),
                        SizedBox(width: 10),
                        Text(
                          _isRolling
                              ? 'Бросок...'
                              : 'Бросить ($_totalDiceCount)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_results.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: IconButton(
                      icon: Icon(Icons.star, color: bronzeColor, size: 35),
                      onPressed: _highlightDuplicates,
                      tooltip: 'Подсветить совпадения',
                    ),
                  ),
              ],
            ),
          ),

          // Результаты
          if (_results.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: secondColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сумма: $_totalSum',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Кубиков: ${_results.length}',
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),

          // Результаты в виде сетки
          Expanded(
            flex: 3,
            child: _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.casino, size: 64, color: textColor),
                        SizedBox(height: 16),
                        Text(
                          'Выберите кубики и нажмите "Бросить"',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _results.length >= 4
                          ? 4
                          : _results.length,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final result = _results[index];
                      return _buildDiceResult(result);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
