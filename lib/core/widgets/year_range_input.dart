import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YearRangeField extends StatefulWidget {
  final int? initialStartYear;
  final int? initialEndYear;
  final int minYear;
  final int maxYear;
  final Function(int? start, int? end) onChanged;

  const YearRangeField({
    Key? key,
    this.initialStartYear,
    this.initialEndYear,
    this.minYear = 1000,
    this.maxYear = 2999,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<YearRangeField> createState() => _YearRangeFieldState();
}

class _YearRangeFieldState extends State<YearRangeField> {
  late final TextEditingController _startController;
  late final TextEditingController _endController;

  String? _startError;
  String? _endError;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(
      text: widget.initialStartYear?.toString() ?? '',
    );
    _endController = TextEditingController(
      text: widget.initialEndYear?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  int? _parseYear(String text) {
    if (text.isEmpty) return null;
    final year = int.tryParse(text);
    if (year == null) return null;
    if (year < widget.minYear || year > widget.maxYear) return null;
    return year;
  }

  void _validate() {
    final start = _parseYear(_startController.text);
    final end = _parseYear(_endController.text);

    setState(() {
      // Проверка начала
      if (_startController.text.isNotEmpty) {
        if (start == null) {
          _startError = '${widget.minYear}–${widget.maxYear}';
        } else {
          _startError = null;
        }
      } else {
        _startError = null;
      }

      // Проверка конца
      if (_endController.text.isNotEmpty) {
        if (end == null) {
          _endError = '${widget.minYear}–${widget.maxYear}';
        } else {
          _endError = null;
        }
      } else {
        _endError = null;
      }

      // Проверка порядка
      if (start != null && end != null && start > end) {
        _endError = 'Конец меньше начала';
      }
    });

    widget.onChanged(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Начало периода
        Expanded(
          child: TextField(
            controller: _startController,
            decoration: InputDecoration(
              labelText: 'Начало',
              hintText: '${widget.minYear}',
              errorText: _startError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              suffixText: 'г.',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            onChanged: (_) => _validate(),
          ),
        ),
        const SizedBox(width: 12),
        // Конец периода
        Expanded(
          child: TextField(
            controller: _endController,
            decoration: InputDecoration(
              labelText: 'Конец',
              hintText: '${widget.maxYear}',
              errorText: _endError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              suffixText: 'г.',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            onChanged: (_) => _validate(),
          ),
        ),
      ],
    );
  }
}
