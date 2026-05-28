import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoreCalcModal extends ConsumerStatefulWidget {
  final String title;
  final int value;
  final Function(int) onScoreChanged;

  const ScoreCalcModal({
    super.key,
    required this.title,
    required this.value,
    required this.onScoreChanged,
  });

  @override
  ConsumerState<ScoreCalcModal> createState() => _ScoreCalcModalState();
}

class _ScoreCalcModalState extends ConsumerState<ScoreCalcModal> {
  final TextEditingController _amountController = TextEditingController();
  int _amount = 0;
  int _tempScore = 0;
  String _history = '';

  @override
  void initState() {
    super.initState();
    _tempScore = widget.value;
  }

  void _updateAmount(String value) {
    final newAmount = int.tryParse(value) ?? 0;
    setState(() {
      _amount = newAmount;
    });
  }

  void _addToTemp() {
    if (_amount != 0) {
      setState(() {
        _tempScore += _amount;
        _history += ' + $_amount';
        _amountController.clear();
      });
    }
  }

  void _subtractFromTemp() {
    if (_amount != 0) {
      setState(() {
        _tempScore -= _amount;
        _history += ' - $_amount';
        _amountController.clear();
      });
    }
  }

  void _confirm() {
    widget.onScoreChanged(_tempScore);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(24),
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Информация об игроке
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    widget.title[0],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Поле ввода
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _amountController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Введите Значение',
                ),
                onChanged: _updateAmount,
              ),
            ),

            // Кнопки действия
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _subtractFromTemp,
                    icon: const Icon(Icons.remove),
                    label: const Text('Вычесть'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addToTemp,
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            // Предпросмотр результата
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          (_history.isNotEmpty)
                              ? '${widget.value}$_history = $_tempScore'
                              : '$_tempScore',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Кнопки подтверждения/отмены
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('ОК'),
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
