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
  final List? counterData;
  final FocusNode? nextFocusNode;

  const PlayerInputCard({
    super.key,
    required this.gamerId,
    required this.controllerData,
    required this.addCalcBtn,
    required this.digitsOnly,
    required this.updateScore,
    this.color,
    this.label,
    this.counterData,
    this.nextFocusNode,
  });

  @override
  State<PlayerInputCard> createState() => _PlayerInputCardState();
}

class _PlayerInputCardState extends State<PlayerInputCard> {
  @override
  Widget build(BuildContext context) {
    int? counter;
    if (widget.counterData != null) {
      final Map<String, dynamic>? countData = widget.counterData!.firstWhere(
        (dataItem) => dataItem['label'] == widget.controllerData['username'],
        orElse: () => null,
      );
      if (countData != null) {
        counter = countData['value'];
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: secondColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: widget.color == null ? borderColor : widget.color!,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 12,
          children: [
            // Имя игрока
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        widget.controllerData['username'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  if (counter != null)
                    Row(
                      spacing: 5,
                      children: [
                        Icon(countersIcon),
                        Text(
                          counter.toString(),
                          style: TextStyle(color: firstColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                ],
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
                    color: secondColor,
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
                    child: TextField(
                      focusNode: widget.controllerData['focusNode'],
                      textInputAction: (widget.nextFocusNode == null)
                          ? null
                          : TextInputAction.next,
                      onSubmitted: (_) {
                        if (widget.nextFocusNode == null) {
                          FocusScope.of(context).unfocus();
                        } else {
                          FocusScope.of(
                            context,
                          ).requestFocus(widget.nextFocusNode);
                        }
                      },
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
