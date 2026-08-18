import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';
import 'package:flutter/material.dart';

class TopInitScreen extends StatefulWidget {
  const TopInitScreen({super.key});

  @override
  State<TopInitScreen> createState() => _TopInitScreenState();
}

class _TopInitScreenState extends State<TopInitScreen> {
  late int _selectedYear = DateTime.now().year;
  late int _selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Icon(topsIcon, color: bronzeColor)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YearInput(
              onChanged: (year) => _selectedYear = year,
              initialYear: _selectedYear,
            ),

            SizedBox(height: 20),

            MonthsInput(
              onChanged: (month) => _selectedMonth = month,
              initialMonth: _selectedMonth,
            ),

            Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Начать'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
