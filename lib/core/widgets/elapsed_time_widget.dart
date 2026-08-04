import 'dart:async';

import 'package:flutter/material.dart';

class ElapsedTimeWidget extends StatefulWidget {
  final DateTime startDateTime;
  final TextStyle? textStyle;
  final bool showDays;
  final bool showHours;
  final bool showMinutes;
  final bool showSeconds;
  final bool showMilliseconds;

  const ElapsedTimeWidget({
    super.key,
    required this.startDateTime,
    this.textStyle,
    this.showDays = true,
    this.showHours = true,
    this.showMinutes = true,
    this.showSeconds = true,
    this.showMilliseconds = false,
  });

  @override
  State<ElapsedTimeWidget> createState() => _ElapsedTimeWidgetState();
}

class _ElapsedTimeWidgetState extends State<ElapsedTimeWidget> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateElapsed();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateElapsed();
    });
  }

  void _updateElapsed() {
    final now = DateTime.now();
    final elapsed = now.difference(widget.startDateTime);

    if (mounted) setState(() => _elapsed = elapsed);
  }

  String _formatNumber(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _elapsed.inDays;
    final hours = _elapsed.inHours % 24;
    final minutes = _elapsed.inMinutes % 60;
    final seconds = _elapsed.inSeconds % 60;
    final milliseconds = _elapsed.inMilliseconds % 1000;

    final defaultStyle = const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.bold,
      fontFeatures: [FontFeature.tabularFigures()],
    );

    final style = widget.textStyle ?? defaultStyle;

    List<Widget> parts = [];

    if (widget.showDays) {
      parts.add(Text(_formatNumber(days), style: style));
      parts.add(const Text(':', style: TextStyle(fontSize: 24)));
    }

    if (widget.showHours) {
      parts.add(Text(_formatNumber(hours), style: style));
      parts.add(const Text(':', style: TextStyle(fontSize: 24)));
    }

    if (widget.showMinutes) {
      parts.add(Text(_formatNumber(minutes), style: style));
      if (widget.showSeconds || widget.showMilliseconds) {
        parts.add(const Text(':', style: TextStyle(fontSize: 24)));
      }
    }

    if (widget.showSeconds) {
      parts.add(Text(_formatNumber(seconds), style: style));
      if (widget.showMilliseconds) {
        parts.add(const Text('.', style: TextStyle(fontSize: 20)));
      }
    }

    if (widget.showMilliseconds) {
      parts.add(
        Text(
          milliseconds.toString().padLeft(3, '0'),
          style: style.copyWith(fontSize: style.fontSize! * 0.7),
        ),
      );
    }

    if (parts.isNotEmpty &&
        parts.last is Text &&
        (parts.last as Text).data == ':') {
      parts.removeLast();
    }

    return Row(mainAxisSize: MainAxisSize.min, children: parts);
  }
}
