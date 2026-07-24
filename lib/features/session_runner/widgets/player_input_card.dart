import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/features/session_runner/widgets/export.dart';

class PlayerInputCard extends StatefulWidget {
  final int gamerId;
  final Map<String, dynamic> controllerData;
  final bool addCalcBtn;
  final bool digitsOnly;
  final Function updateScore;
  final Color? color;
  final String? label;

  const PlayerInputCard({
    super.key,
    required this.gamerId,
    required this.controllerData,
    required this.addCalcBtn,
    required this.digitsOnly,
    required this.updateScore,
    this.color,
    this.label,
  });

  @override
  State<PlayerInputCard> createState() => _PlayerInputCardState();
}

class _PlayerInputCardState extends State<PlayerInputCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: (widget.color == null) ? secondColor : widget.color,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 12,
          children: [
            // Имя игрока
            Expanded(
              child: Text(
                widget.controllerData['username'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            // Дополнительная информация
            if (widget.controllerData['extraData'] != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.controllerData['extraData'].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            SizedBox(
              width: 135,
              child: Row(
                spacing: 2,
                children: [
                  // Кнопка вызова калькулятора
                  if (widget.addCalcBtn)
                    IconButton(
                      onPressed: () {
                        final TextEditingController controller =
                            widget.controllerData['controller'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScoreCalcModal(
                              title: widget.controllerData['username'],
                              value: int.tryParse(controller.text) ?? 0,
                              onScoreChanged: (value) {
                                final String score = value.toString();
                                controller.text = score;
                                widget.updateScore(widget.gamerId, score);
                              },
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.iso),
                      color: goldColor,
                    ),
                  // Поле ввода
                  Expanded(
                    child: TextFormField(
                      controller: widget.controllerData['controller'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      inputFormatters: [
                        (widget.digitsOnly)
                            ? FilteringTextInputFormatter.digitsOnly
                            : FilteringTextInputFormatter.allow(
                                RegExp(r'^-?\d*'),
                              ),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: widget.label,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (value) =>
                          widget.updateScore(widget.gamerId, value),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
