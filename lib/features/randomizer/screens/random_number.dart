import 'dart:math';

import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class RandomNumberScreen extends StatefulWidget {
  const RandomNumberScreen({super.key});

  @override
  State<RandomNumberScreen> createState() => _RandomNumberScreenState();
}

class _RandomNumberScreenState extends State<RandomNumberScreen>
    with SingleTickerProviderStateMixin {
  int _minValue = 1;
  int _maxValue = 6;

  int? _result;
  bool _isRolling = false;
  final List<int> _history = [];

  // Анимация
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  String _average() {
    if (_history.isEmpty) return '0';
    final sum = _history.fold(0, (a, b) => a + b);
    return (sum / _history.length).toStringAsFixed(1);
  }

  // Генерация случайного числа
  void _generateNumber() {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
      _result = null;
    });

    _animationController.reset();
    _animationController.forward();

    Future.delayed(Duration(milliseconds: 300), () {
      final number = _minValue + _random.nextInt(_maxValue - _minValue + 1);

      setState(() {
        _result = number;
        _isRolling = false;
        _history.add(number);
        if (_history.length > 20) {
          _history.removeAt(0);
        }
      });
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  void _copyResult() {
    if (_result != null) {
      // В реальном приложении - копирование в буфер
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Скопировано: $_result'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Показать диалог истории
  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.history, color: textColor),
            SizedBox(width: 8),
            Text('История (${_history.length})'),
          ],
        ),
        content: Container(
          decoration: BoxDecoration(
            color: firstColor,
            border: BoxBorder.all(color: greenColor, width: 2),
            borderRadius: BorderRadiusGeometry.all(Radius.circular(1)),
          ),
          width: double.maxFinite,
          height: 350,
          child: _history.isEmpty
              ? Center(child: Text('История пуста'))
              : Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final number = _history[_history.length - 1 - index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: secondColor,
                          child: Text(
                            '${_history.length - index}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: firstColor,
                            ),
                          ),
                        ),
                        title: Text(
                          '$number',
                          style: TextStyle(fontSize: 18, color: textColor),
                        ),
                      );
                    },
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearHistory();
              Navigator.pop(context);
            },
            child: Text('Очистить', style: TextStyle(color: redColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Закрыть'),
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
            Icon(randNumIcon),
          ],
        ),
        backgroundColor: secondColor,
        foregroundColor: textColor,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _history.isEmpty ? null : () => _showHistoryDialog(),
            tooltip: 'История',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: _history.isEmpty ? null : _clearHistory,
            tooltip: 'Очистить историю',
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: secondColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: secondColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.compare_arrows, color: secondColor),
                    SizedBox(width: 12),
                    Text(
                      'От $_minValue до $_maxValue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: secondColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: _result != null
                            ? secondColor.withValues(alpha: 0.1)
                            : goldColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _result != null ? secondColor : goldColor,
                          width: 4,
                        ),
                        boxShadow: [
                          if (_result != null)
                            BoxShadow(
                              color: secondColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _result != null ? '$_result' : '?',
                          style: TextStyle(
                            fontSize: _result != null ? 64 : 48,
                            fontWeight: FontWeight.bold,
                            color: _result != null ? secondColor : goldColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 16),

              if (_result != null)
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Chip(
                            label: Text('Всего: ${_history.length}'),
                            avatar: Icon(
                              Icons.history,
                              size: 16,
                              color: textColor,
                            ),
                            backgroundColor: secondColor,
                          ),
                          SizedBox(width: 8),
                          Chip(
                            label: Text('Среднее: ${_average()}'),
                            avatar: Icon(
                              Icons.analytics,
                              size: 16,
                              color: textColor,
                            ),
                            backgroundColor: secondColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isRolling ? null : _generateNumber,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldColor,
                        foregroundColor: firstColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isRolling
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: goldColor,
                              ),
                            )
                          : Icon(Icons.casino),
                      label: Text(
                        _isRolling ? 'Генерация...' : 'Сгенерировать',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),

                  if (_result != null)
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: IconButton(
                        icon: Icon(Icons.copy, color: firstColor),
                        onPressed: _copyResult,
                        tooltip: 'Копировать',
                        style: IconButton.styleFrom(
                          backgroundColor: bronzeColor,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: secondColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Минимум: $_minValue',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Максимум: $_maxValue',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _minValue.toDouble(),
                            min: 0,
                            max: _maxValue.toDouble() - 1,
                            divisions: 100,
                            label: '$_minValue',
                            onChanged: (value) {
                              setState(() {
                                _minValue = value.toInt();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _maxValue.toDouble(),
                            min: _minValue.toDouble() + 1,
                            max: 100,
                            divisions: 100,
                            label: '$_maxValue',
                            onChanged: (value) {
                              setState(() {
                                _maxValue = value.toInt();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
