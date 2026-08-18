import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class MonthsInput extends StatefulWidget {
  final int? initialMonth;
  final Function(int year) onChanged;

  const MonthsInput({super.key, required this.onChanged, this.initialMonth});
  @override
  State<MonthsInput> createState() => _MonthsInputState();
}

class _MonthsInputState extends State<MonthsInput> {
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialMonth ?? DateTime.now().month;
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
              Icon(Icons.calendar_view_month, color: textColor),
              SizedBox(width: 8),
              Text('Месяц', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 5),
          // Сетка месяцев
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: MonthsEnum.values.length,
            itemBuilder: (context, index) {
              final int monthId = index + 1;
              final MonthsEnum monthEnum = MonthsEnum.fromId(monthId);
              final isSelected = _selectedMonth == monthId;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedMonth = monthId;
                  widget.onChanged(monthId);
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? goldColor : firstColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? goldColor : textColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      monthEnum.label.substring(0, 3),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
