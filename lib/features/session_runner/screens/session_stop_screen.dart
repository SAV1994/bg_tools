import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bg_tools/core/widgets/export.dart';

class SessionStopScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final List<dynamic> counterData;

  const SessionStopScreen({
    super.key,
    required this.data,
    required this.counterData,
  });

  @override
  ConsumerState<SessionStopScreen> createState() => _SessionStopScreenState();
}

class _SessionStopScreenState extends ConsumerState<SessionStopScreen> {
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

            if (widget.data['finishedAt'] == null)
              ElapsedTimeWidget(
                startDateTime: DateTime.parse(widget.data['startedAt']),
              ),

            Expanded(
              flex: 1,
              child: Center(
                child: PulsingButton(
                  title: 'Закончить',
                  icon: Icons.pan_tool,
                  onPressed: () {
                    setState(
                      () => widget.data['finishedAt'] = DateTime.now()
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
