import 'package:flutter/material.dart';

class WinToggleBtn extends StatelessWidget {
  final bool isVictory;
  final Function toggleResult;

  const WinToggleBtn({
    super.key,
    required this.isVictory,
    required this.toggleResult,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => toggleResult(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isVictory
                ? [Colors.green.shade400, Colors.green.shade700]
                : [Colors.red.shade400, Colors.red.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: (isVictory ? Colors.green : Colors.red).withValues(
                alpha: 0.3,
              ),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Центральный контент
            Center(
              child: Column(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isVictory
                        ? Icons.emoji_events
                        : Icons.sentiment_very_dissatisfied,
                    size: 30,
                    color: Colors.white,
                  ),
                  Text(
                    isVictory ? 'ПОБЕДА' : 'ПОРАЖЕНИЕ',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    isVictory
                        ? 'Нажмите чтобы изменить'
                        : 'Нажмите чтобы изменить',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
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
