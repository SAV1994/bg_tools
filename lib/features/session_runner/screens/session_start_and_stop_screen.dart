import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/widgets/export.dart';

class SessionStartStopScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const SessionStartStopScreen({super.key, required this.data});

  @override
  ConsumerState<SessionStartStopScreen> createState() =>
      _SessionStopScreenState();
}

class _SessionStopScreenState extends ConsumerState<SessionStartStopScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            if (widget.data['finishedAt'] != null)
              DateTimeDisplay(
                dateTime: DateTime.parse(widget.data['startedAt']),
                secondDateTime: DateTime.parse(widget.data['finishedAt']),
              ),

            if (widget.data['startedAt'] != null &&
                widget.data['finishedAt'] == null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Время начала сессии', style: TextStyle(fontSize: 20)),
                ],
              ),
              DateTimeDisplay(
                dateTime: DateTime.parse(widget.data['startedAt']),
              ),
              ElapsedTimeWidget(
                startDateTime: DateTime.parse(widget.data['startedAt']),
              ),
            ],

            Expanded(
              flex: 1,
              child: Center(
                child: (widget.data['startedAt'] != null)
                    ? PulsingButton(
                        title: 'Закончить',
                        icon: Icons.pan_tool,
                        onPressed: () {
                          setState(
                            () => widget.data['finishedAt'] = DateTime.now()
                                .toIso8601String(),
                          );
                        },
                      )
                    : PulsingButton(
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
