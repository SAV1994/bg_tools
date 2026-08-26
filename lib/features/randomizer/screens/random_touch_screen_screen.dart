import 'dart:async';

import 'package:bg_tools/core/consts/export.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TouchPoint {
  final int id;
  final Offset position;
  final (Color, int) colorData;
  final DateTime timestamp;

  TouchPoint({
    required this.id,
    required this.position,
    required this.colorData,
    required this.timestamp,
  });

  TouchPoint copyWith({
    int? id,
    Offset? position,
    (Color, int)? colorData,
    DateTime? timestamp,
  }) {
    return TouchPoint(
      id: id ?? this.id,
      position: position ?? this.position,
      colorData: colorData ?? this.colorData,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class RandomTouchScreen extends StatefulWidget {
  const RandomTouchScreen({super.key});

  @override
  State<RandomTouchScreen> createState() => _RandomTouchScreenState();
}

class _RandomTouchScreenState extends State<RandomTouchScreen>
    with SingleTickerProviderStateMixin {
  final Map<int, TouchPoint> _touches = {};
  Timer? _selectionTimer;
  (Color, int)? _selectedColor;
  bool _isSelecting = false;
  late AnimationController _animationController;
  final Random _random = Random();

  final List<(Color, int)> _allColors = [
    (Colors.red, 1),
    (Colors.blue, 2),
    (Colors.green, 3),
    (Colors.orange, 4),
    (Colors.purple, 5),
    (Colors.pink, 6),
    (Colors.teal, 7),
    (Colors.indigo, 8),
    (Colors.amber, 9),
    (Colors.cyan, 10),
    (Colors.grey, 11),
    (Colors.yellow, 12),
    (Colors.lime, 13),
    (Colors.brown, 14),
    (Colors.teal, 15),
  ];
  List<(Color, int)> _availableColors = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _availableColors = _allColors.toList();
  }

  @override
  void dispose() {
    _selectionTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _addTouch(PointerEvent event) {
    if (_touches.length >= 10 || _isSelecting) return;

    final id = event.pointer;
    final colorData = _availableColors.removeAt(0);

    _touches[id] = TouchPoint(
      id: id,
      position: event.position,
      colorData: colorData,
      timestamp: DateTime.now(),
    );

    setState(() {});
    _resetSelectionTimer();
  }

  void _updateTouch(PointerEvent event) {
    final id = event.pointer;
    if (_touches.containsKey(id)) {
      _touches[id] = _touches[id]!.copyWith(position: event.position);
      setState(() {});
    }
  }

  void _removeTouch(PointerEvent event) {
    final id = event.pointer;
    if (_touches.containsKey(id)) {
      _availableColors.add(_touches[id]!.colorData);
      _touches.remove(id);
      setState(() {});
      _resetSelectionTimer();
    }
  }

  void _resetSelectionTimer() {
    _selectionTimer?.cancel();
    if (_touches.isNotEmpty && !_isSelecting) {
      _selectionTimer = Timer(Duration(seconds: 2), _selectRandomTouch);
    } else if (_touches.isEmpty) {
      setState(() {
        _selectedColor = null;
        _isSelecting = false;
      });
    }
  }

  void _selectRandomTouch() {
    if (_touches.isEmpty || _isSelecting) return;

    setState(() {
      _isSelecting = true;
    });

    final touchList = _touches.values.toList();
    final selected = touchList[_random.nextInt(touchList.length)];

    setState(() {
      _selectedColor = selected.colorData;
    });

    _animationController.forward(from: 0);

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isSelecting = false;
          _selectedColor = null;
          _touches.clear();
          _availableColors = _allColors.toList();
          _animationController.reset();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(randomIcon, color: silverColor),
            Icon(randTouchIcon),
          ],
        ),
        backgroundColor:
            _selectedColor?.$1.withValues(alpha: 0.8) ?? secondColor,
        foregroundColor: textColor,
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_touches.length}/10',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
      body: Listener(
        onPointerDown: _addTouch,
        onPointerMove: _updateTouch,
        onPointerUp: _removeTouch,
        onPointerCancel: _removeTouch,
        behavior: HitTestBehavior.translucent,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          color: _selectedColor?.$1 ?? firstColor,
          child: Stack(
            children: [
              // Точки касания
              for (var touch in _touches.values)
                AnimatedPositioned(
                  duration: Duration(milliseconds: 100),
                  left: touch.position.dx - 30,
                  top: touch.position.dy - 30,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: touch.colorData.$1.withValues(alpha: 0.8),
                      border: Border.all(color: touch.colorData.$1, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: touch.colorData.$1.withValues(alpha: 0.5),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        touch.colorData.$2.toString(),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

              // Визуализация выбора
              if (_isSelecting)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Container(
                            width: 100 + 50 * _animationController.value,
                            height: 100 + 50 * _animationController.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _selectedColor?.$1.withValues(alpha: 0.3) ??
                                  Colors.transparent,
                              border: Border.all(
                                color: _selectedColor?.$1 ?? textColor,
                                width: 4 - 2 * _animationController.value,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Выбрано! #${_selectedColor?.$2}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: blackColor.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Подсказка
              if (_touches.isEmpty && !_isSelecting && _selectedColor == null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app, size: 64, color: textColor),
                      SizedBox(height: 16),
                      Text(
                        'Коснитесь экрана в разных местах',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Максимум 10 касаний',
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),

              // Прогресс-бар таймера
              if (_touches.isNotEmpty && !_isSelecting)
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: LinearProgressIndicator(
                    value: _selectionTimer?.isActive ?? false ? 1.0 : 0.0,
                    backgroundColor: textColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _availableColors[_random.nextInt(_availableColors.length)]
                          .$1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
