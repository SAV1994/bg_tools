import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bg_tools/core/consts/export.dart';
import 'package:bg_tools/core/database/app_database.dart';
import 'package:bg_tools/core/widgets/export.dart';

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
                  MenuButton(
                    onPressed: () => context.pushNamed('randomizer-number'),
                    label: 'Случайное число',
                    icon: randNumIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('randomizer-games'),
                    label: 'Случайная игра',
                    icon: gamesIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('randomizer-players'),
                    label: 'Случайный игрок',
                    icon: gamersIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('randomizer-dice'),
                    label: 'Игральные кости',
                    icon: randomIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('randomizer-fate'),
                    label: 'Жребий',
                    icon: fateIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('randomizer-coin'),
                    label: 'Монетка',
                    icon: randCoinIcon,
                  ),
                  MenuButton(
                    onPressed: () => context.pushNamed('randomizer-touch'),
                    label: 'Касания',
                    icon: randTouchIcon,
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
