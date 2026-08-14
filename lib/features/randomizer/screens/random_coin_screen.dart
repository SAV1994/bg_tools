import 'package:bg_tools/core/consts/export.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RandomCoinScreen extends StatefulWidget {
  const RandomCoinScreen({super.key});

  @override
  State<RandomCoinScreen> createState() => _RandomCoinScreenState();
}

class _RandomCoinScreenState extends State<RandomCoinScreen>
    with SingleTickerProviderStateMixin {
  bool _isHeads = true;
  bool _isFlipping = false;
  String _resultMessage = 'Нажмите чтобы подбросить';
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  final Random _random = Random();

  // Список результатов для статистики
  final List<String> _history = [];
  int _headsCount = 0;
  int _tailsCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flipCoin() {
    if (_isFlipping) return;

    setState(() {
      _isFlipping = true;
      _resultMessage = 'Подбрасываем...';
    });

    // Генерируем случайный результат
    final isHeads = _random.nextBool();

    // Небольшая задержка перед показом результата
    Future.delayed(Duration(milliseconds: 500), () {
      _animationController.forward(from: 0);
    });

    // Анимация + результат
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _isHeads = isHeads;
        _isFlipping = false;
        _resultMessage = isHeads ? '🪙 Орёл' : '🪙 Решка';

        // Обновляем статистику
        if (isHeads) {
          _headsCount++;
          _history.add('Орёл');
        } else {
          _tailsCount++;
          _history.add('Решка');
        }
      });
    });
  }

  void _resetStats() {
    setState(() {
      _history.clear();
      _headsCount = 0;
      _tailsCount = 0;
      _resultMessage = 'Статистика сброшена';
    });
  }

  Color _getResultColor() {
    if (_isFlipping) return goldColor;
    return _isHeads ? greenColor : redColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(randomIcon, color: silverColor),
            Icon(randCoinIcon),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Выйти', style: TextStyle(color: redColor)),
          ),
        ],
        backgroundColor: secondColor,
        foregroundColor: textColor,
      ),
      body: Container(
        decoration: BoxDecoration(color: firstColor),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Монетка с анимацией
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateY(_rotationAnimation.value),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: goldColor,
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 0.8,
                            colors: [goldColor, bronzeColor],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: goldColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _isFlipping ? '?' : (_isHeads ? '🦅' : '🪙'),
                            style: TextStyle(fontSize: 60),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 30),

                // Результат
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  decoration: BoxDecoration(
                    color: _getResultColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getResultColor(), width: 2),
                  ),
                  child: Text(
                    _resultMessage,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getResultColor(),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Кнопка подбросить
                ElevatedButton(
                  onPressed: _isFlipping ? null : _flipCoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: firstColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.autorenew),
                      SizedBox(width: 10),
                      Text(
                        _isFlipping ? 'Подбрасывание...' : 'Подбросить',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                // Статистика
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: secondColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: textColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('🦅 Орёл', _headsCount),
                          _buildStatItem('🪙 Решка', _tailsCount),
                          _buildStatItem('📊 Всего', _headsCount + _tailsCount),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (_history.isNotEmpty)
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _history.length,
                            itemBuilder: (context, index) {
                              final result = _history[index];
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: result == 'Орёл'
                                      ? greenColor.withValues(alpha: 0.2)
                                      : redColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: result == 'Орёл'
                                        ? greenColor
                                        : redColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    result == 'Орёл' ? '🦅' : '🪙',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (_history.isNotEmpty)
                        TextButton(
                          onPressed: _resetStats,
                          child: Text(
                            'Сбросить статистику',
                            style: TextStyle(color: redColor),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: textColor)),
        SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
