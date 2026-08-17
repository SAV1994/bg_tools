import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';

class SelectionRandomizerScreen extends ConsumerStatefulWidget {
  const SelectionRandomizerScreen({super.key});

  @override
  ConsumerState<SelectionRandomizerScreen> createState() =>
      _SelectionRandomizerScreenState();
}

class _SelectionRandomizerScreenState
    extends ConsumerState<SelectionRandomizerScreen> {
  late final Gamer? owner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Icon(randomIcon)),
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
                  ElevatedButton.icon(
                    onPressed: () => context.pushNamed('randomizer-number'),
                    style: btnStyle,
                    label: Text('Случайное число'),
                    icon: Icon(randNumIcon),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.pushNamed('randomizer-games'),
                    style: btnStyle,
                    label: Text('Случайная игра'),
                    icon: Icon(gamesIcon),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.pushNamed('randomizer-players'),
                    style: btnStyle,
                    label: Text('Случайный игрок'),
                    icon: Icon(gamersIcon),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.pushNamed('randomizer-dice'),
                    style: btnStyle,
                    label: Text('Игральные кости'),
                    icon: Icon(randomIcon),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.pushNamed('randomizer-fate'),
                    style: btnStyle,
                    label: Text('Жребий'),
                    icon: const Icon(fateIcon),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.pushNamed('randomizer-coin'),
                    style: btnStyle,
                    label: Text('Монетка'),
                    icon: const Icon(randCoinIcon),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.pushNamed('randomizer-touch'),
                    style: btnStyle,
                    label: Text('Касания'),
                    icon: Icon(randTouchIcon),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
