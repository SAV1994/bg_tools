import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class RatingSlider extends StatefulWidget {
  final double initialValue;
  final Function(double) onChanged;

  const RatingSlider({
    super.key,
    this.initialValue = 0.0,
    required this.onChanged,
  });

  @override
  State<RatingSlider> createState() => _RatingSliderState();
}

class _RatingSliderState extends State<RatingSlider> {
  late double _rating;

  static const Map<int, String> _statusMap = {
    1: 'Хуже не бывает',
    2: 'Сломанный процесс',
    3: 'Вызывает отторжение',
    4: 'Не нравится',
    5: 'Скучновата',
    6: 'Можно сыграть',
    7: 'Играю с удовольствием',
    8: 'Крепкая, качественная игра',
    9: 'Всегда готов сыграть',
    10: 'Абсолютный шедевр',
  };

  static const Map<int, IconData> _iconMap = {
    1: Icons.sentiment_very_dissatisfied,
    2: Icons.sentiment_dissatisfied,
    3: Icons.sentiment_dissatisfied,
    4: Icons.sentiment_neutral,
    5: Icons.sentiment_neutral,
    6: Icons.sentiment_satisfied,
    7: Icons.sentiment_satisfied,
    8: Icons.sentiment_very_satisfied,
    9: Icons.sentiment_very_satisfied,
    10: Icons.emoji_events,
  };

  @override
  void initState() {
    super.initState();
    _rating = widget.initialValue.clamp(0.0, 10.0);
  }

  int get ratingMapValue {
    if (_rating > 0.0 && _rating < 0.5) {
      return 1;
    }
    return _rating.round();
  }

  String get _status => _statusMap[ratingMapValue] ?? 'Неизвестно';
  IconData get _icon => _iconMap[ratingMapValue] ?? Icons.help;

  Color _getColor(double value) {
    if (value == 0.0) {
      return textColor;
    }
    final normalized = value / 10.0;
    final red = (1.0 - normalized) * 255;
    final green = normalized * 255;
    final blue = (1.0 - (normalized * 2).abs()) * 50;
    return Color.fromARGB(
      255,
      red.round().clamp(0, 255),
      green.round().clamp(0, 255),
      blue.round().clamp(0, 255),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок
        Text(
          'Рейтинг',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        // Статус с иконкой
        Row(
          children: [
            Icon(_icon, size: 32, color: _getColor(_rating)),
            const SizedBox(width: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _status,
                key: ValueKey(_status),
                style: TextStyle(fontSize: 15, color: _getColor(_rating)),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getColor(_rating).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getColor(_rating).withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                _rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getColor(_rating),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Ползунок
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: _getColor(_rating),
            inactiveTrackColor: textColor,
            thumbColor: _getColor(_rating),
            overlayColor: _getColor(_rating).withValues(alpha: 0.2),
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
            valueIndicatorColor: _getColor(_rating),
            valueIndicatorTextStyle: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            showValueIndicator: ShowValueIndicator.onDrag,
          ),
          child: Slider(
            value: _rating,
            min: 0,
            max: 10,
            divisions: 100,
            label: _rating.toStringAsFixed(1),
            onChanged: (value) {
              final rounded = (value * 10).round() / 10.0;
              setState(() => _rating = rounded);
              widget.onChanged(rounded);
            },
          ),
        ),
      ],
    );
  }
}
