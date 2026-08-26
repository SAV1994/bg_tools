import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/widgets/export.dart';

class StatisticsMainScreen extends ConsumerStatefulWidget {
  const StatisticsMainScreen({super.key});

  @override
  ConsumerState<StatisticsMainScreen> createState() =>
      _StatisticsMainScreenState();
}

class _StatisticsMainScreenState extends ConsumerState<StatisticsMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Icon(statisticsIcon)),
      body: Center(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10),
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuButton(
                    onPressed: () => context.pushNamed('statistics-session'),
                    label: 'Статистика партий',
                    icon: sessionsStatIcon,
                  ),

                  // MenuButton(
                  //   onPressed: () => context.pushNamed('statistics-win-rate'),
                  //   label: 'Статистика побед',
                  //   icon: winRateIcon,
                  // ),

                  // MenuButton(
                  //   onPressed: () {},
                  //   label: 'Соревновательные',
                  //   icon: competitiveStatIcon,
                  // ),

                  // MenuButton(
                  //   onPressed: () {},
                  //   label: 'Кооперативные',
                  //   icon: coopStatIcon,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
