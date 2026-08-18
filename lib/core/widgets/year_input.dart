import 'package:bg_tools/core/consts/theme_consts.dart';
import 'package:flutter/material.dart';

class YearInput extends StatefulWidget {
  final int? initialYear;
  final Function(int year) onChanged;

  const YearInput({super.key, required this.onChanged, this.initialYear});
  @override
  State<YearInput> createState() => _YearInputState();
}

class _YearInputState extends State<YearInput> {
  late int _selectedYear;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear ?? DateTime.now().year;
    _yearController = TextEditingController(text: _selectedYear.toString());
  }

  void _updateYear(String value) {
    int? year = int.tryParse(value);
    if (year == null || year < 1900 || year > 9999) {
      year = _selectedYear;
    }
    setState(() {
      _selectedYear = year!;
      _yearController.text = year.toString();
      widget.onChanged(_selectedYear);
    });
  }

  Widget _buildQuickYearButton(int delta, String label) {
    return TextButton(
      onPressed: () {
        final newYear = _selectedYear + delta;
        if (newYear >= 1900) {
          _updateYear(newYear.toString());
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12),
        minimumSize: Size(40, 30),
      ),
      child: Text(label, style: TextStyle(fontSize: 18)),
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: secondColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: textColor),
              SizedBox(width: 8),
              Text('Год', style: TextStyle(fontWeight: FontWeight.w500)),
              Spacer(),
              // Кнопки быстрого выбора
              _buildQuickYearButton(-1, '◀'),
              _buildQuickYearButton(1, '▶'),
            ],
          ),
          TextField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              hintText: 'Введите год',
            ),
            onSubmitted: (value) => _updateYear(value),
          ),
        ],
      ),
    );
  }
}
