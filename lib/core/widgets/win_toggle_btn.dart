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
        height: 180,
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
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Центральный контент
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isVictory
                        ? Icons.emoji_events
                        : Icons.sentiment_very_dissatisfied,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isVictory ? 'ПОБЕДА' : 'ПОРАЖЕНИЕ',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
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
