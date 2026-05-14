import 'package:flutter/material.dart';

class PulsingButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const PulsingButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.orange.shade400, Colors.red.shade600],
                center: Alignment.center,
                radius: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade300.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                customBorder: const CircleBorder(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, size: 80, color: Colors.white),
                      const SizedBox(height: 20),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
