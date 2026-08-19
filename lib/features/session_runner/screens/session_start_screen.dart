import 'package:bg_tools/core/widgets/datetime_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/widgets/pulsing_buttom.dart';

class SessionStartScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final List<dynamic> counterData;

  const SessionStartScreen({
    super.key,
    required this.data,
    required this.counterData,
  });

  @override
  ConsumerState<SessionStartScreen> createState() => _SessionStartScreenState();
}

class _SessionStartScreenState extends ConsumerState<SessionStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            if (widget.data['startedAt'] != null)
              DateTimeDisplay(
                dateTime: DateTime.parse(widget.data['startedAt']),
              ),
            Expanded(
              flex: 1,
              child: Center(
                child: PulsingButton(
                  title: 'Начать',
                  icon: Icons.play_arrow,
                  onPressed: () {
                    setState(
                      () => widget.data['startedAt'] = DateTime.now()
                          .toIso8601String(),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
